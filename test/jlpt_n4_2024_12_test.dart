import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practice_janpanese/core/database/app_database.dart';
import 'package:practice_janpanese/core/database/dev_seed.dart';
import 'package:practice_janpanese/features/past_exam/data/past_exam_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqlite3/open.dart';

void main() {
  setUpAll(() {
    if (Platform.isLinux) {
      open.overrideFor(OperatingSystem.linux, () {
        final paths = [
          '/usr/lib/x86_64-linux-gnu/libsqlite3.so.0',
          '/usr/lib/x86_64-linux-gnu/libsqlite3.so',
          'libsqlite3.so',
        ];
        for (final p in paths) {
          try {
            return DynamicLibrary.open(p);
          } catch (_) {}
        }
        return DynamicLibrary.process();
      });
    }
  });

  test('JLPT N4 2024-12 JSON data integrity and reading passages test', () {
    final file = File('assets/data/jlpt_n4_2024_12.json');
    expect(file.existsSync(), isTrue, reason: 'File should exist');

    final jsonStr = file.readAsStringSync();
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;

    expect(data['id'], equals('jlpt_n4_2024_12'));
    expect(data['name'], contains('2024年12月'));
    expect(data['level'], equals('N4'));
    expect(data['year'], equals(2024));
    expect(data['month'], equals(12));

    final sections = data['sections'] as List;
    expect(sections.length, equals(2),
        reason: 'Should have 2 sections: vocab and grammar_reading');

    int totalQuestions = 0;

    for (final section in sections) {
      final mondaiTypes = section['mondaiTypes'] as List;

      for (final mondai in mondaiTypes) {
        final type = mondai['type'] as String?;

        if (type == 'textGrammar') {
          expect(mondai['passage'], isNotNull,
              reason: 'Text grammar mondai must have passage');
          expect((mondai['passage'] as String).isNotEmpty, isTrue);
        }

        if (type == 'readingMedium' || type == 'informationRetrieval') {
          expect(mondai['passage'], isNotNull,
              reason: '$type must have passage');
          expect((mondai['passage'] as String).isNotEmpty, isTrue);
        }

        final questions = mondai['questions'] as List;
        for (final q in questions) {
          totalQuestions++;

          if (type == 'readingShort') {
            expect(q['passage'], isNotNull,
                reason: 'readingShort question ${q['questionNo']} must have passage');
            expect((q['passage'] as String).isNotEmpty, isTrue);
          }

          // Verify choices
          final choices = q['choices'] as List;
          expect(
            choices.length,
            anyOf(equals(3), equals(4)),
            reason: 'Questions should have 3 or 4 choices',
          );

          // Verify correctIndex
          final correctIndex = q['correctIndex'] as int;
          expect(correctIndex, greaterThanOrEqualTo(1));
          expect(correctIndex, lessThanOrEqualTo(choices.length));

          // Verify explanation is present and non-empty
          final explanation = q['explanation'] as String?;
          expect(explanation, isNotNull);
          expect(explanation!.isNotEmpty, isTrue);
          expect(explanation, contains('【正解: $correctIndex】'));

          // Star position questions check
          if (q.containsKey('starPosition') && q['starPosition'] != null) {
            if (q.containsKey('correctOrder') && q['correctOrder'] != null) {
              final correctOrder = q['correctOrder'] as List;
              expect(correctOrder.length, equals(4));
            }
          }
        }
      }
    }

    expect(totalQuestions, equals(57),
        reason: 'Total questions in N4 2024-12 should be 57 (28 vocab + 29 grammar/reading)');
  });

  test('JLPT N4 2024-12 self-healing and database re-seeding with reading passages test', () async {
    SharedPreferences.setMockInitialValues({
      'dev_seed_completed_version': 73, // Version already matched
    });
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase.forTesting(NativeDatabase.memory());

    try {
      // 1. Simulate existing database where N4 2024-12 has questions but NO passages (groupCount == 0)
      final dummySourceId = await db.into(db.sources).insert(
        SourcesCompanion.insert(
          type: SourceType.pastExam,
          name: '2024年12月 JLPT N4 真題',
          jlptLevel: const Value('N4'),
          examYear: const Value(2024),
          examMonth: const Value(12),
        ),
      );

      // Insert 50 dummy questions so count >= 50
      for (int i = 1; i <= 50; i++) {
        await db.into(db.questions).insert(
          QuestionsCompanion.insert(
            sourceId: dummySourceId,
            jlptLevel: 'N4',
            subject: Subject.vocab,
            mondaiTypeId: 1,
            questionText: 'テスト問題 $i',
            explanation: const Value('Old dummy explanation'),
          ),
        );
      }

      // Check initially groupCount is 0
      final initialGroups = await (db.questionGroups.select()
            ..where((g) => g.sourceId.equals(dummySourceId)))
          .get();
      expect(initialGroups.length, equals(0));

      // 2. Run seedDevData: Even though version == 73, self-heal must detect missing groups and re-seed
      await seedDevData(db, prefs: prefs);

      // Verify that the exam was re-seeded and now has question groups / passages
      final source = await (db.sources.select()
            ..where(
              (s) =>
                  s.type.equalsValue(SourceType.pastExam) &
                  s.jlptLevel.equals('N4') &
                  s.examYear.equals(2024) &
                  s.examMonth.equals(12),
            ))
            .getSingle();

      final groups = await (db.questionGroups.select()
            ..where((g) => g.sourceId.equals(source.id)))
          .get();
      expect(groups.length, greaterThanOrEqualTo(3),
          reason: 'Must have question groups for reading sections');

      // Check with PastExamRepository
      final repo = PastExamRepository(db);
      final readingQuestions = await repo.getQuestions(
        sourceId: source.id,
        subject: Subject.reading,
      );
      expect(readingQuestions.length, equals(8)); // Mondai 4 (3) + Mondai 5 (3) + Mondai 6 (2) = 8
      for (final q in readingQuestions) {
        expect(q.passage, isNotNull,
            reason: 'Question ${q.id} in reading should have non-null passage');
        expect(q.passage!.isNotEmpty, isTrue);
      }
    } finally {
      await db.close();
    }
  });
}
