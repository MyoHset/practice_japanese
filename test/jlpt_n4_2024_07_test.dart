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

  test('JLPT N4 2024-07 JSON data integrity and reading passages test', () {
    final file = File('assets/data/jlpt_n4_2024_07.json');
    expect(file.existsSync(), isTrue, reason: 'File should exist');

    final jsonStr = file.readAsStringSync();
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;

    expect(data['id'], equals('jlpt_n4_2024_07'));
    expect(data['name'], contains('2024年7月'));
    expect(data['level'], equals('N4'));
    expect(data['year'], equals(2024));
    expect(data['month'], equals(7));

    final sections = data['sections'] as List;
    expect(sections.length, equals(2),
        reason: 'Should have 2 sections: vocab and grammar_reading');

    int totalQuestions = 0;

    for (final section in sections) {
      final mondaiTypes = section['mondaiTypes'] as List;

      for (final mondai in mondaiTypes) {
        final type = mondai['type'] as String?;

        if (type == 'textGrammar') {
          expect(mondai['passage'], isNotNull, reason: 'Text grammar mondai must have passage');
          expect((mondai['passage'] as String).isNotEmpty, isTrue);
        }
        if (type == 'readingMedium' || type == 'informationRetrieval') {
          expect(mondai['passage'], isNotNull, reason: '$type mondai must have passage');
          expect((mondai['passage'] as String).isNotEmpty, isTrue);
        }

        final questions = mondai['questions'] as List;
        for (final q in questions) {
          totalQuestions++;

          if (type == 'readingShort') {
            expect(q['passage'], isNotNull, reason: 'Short reading Q${q['questionNo']} must have passage');
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
        reason: 'Total questions in N4 2024-07 should be 57 (28 vocab + 29 grammar/reading)');
  });

  test('JLPT N4 2024-07 database seeding and reading passages query', () async {
    SharedPreferences.setMockInitialValues({
      'dev_seed_completed_version': 0,
    });
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final repo = PastExamRepository(db);

    try {
      await seedDevData(db, prefs: prefs);

      final source = await (db.sources.select()
            ..where(
              (s) =>
                  s.type.equalsValue(SourceType.pastExam) &
                  s.jlptLevel.equals('N4') &
                  s.examYear.equals(2024) &
                  s.examMonth.equals(7),
            ))
          .getSingleOrNull();

      expect(source, isNotNull);

      final readingQuestions = await repo.getQuestions(
        sourceId: source!.id,
        subject: Subject.reading,
      );

      expect(readingQuestions.length, equals(8), reason: 'Mondai 4, 5, 6 total 8 reading questions');

      for (final q in readingQuestions) {
        expect(q.passage, isNotNull, reason: 'Question ${q.questionNo} should have passage');
        expect(q.passage!.trim().isNotEmpty, isTrue);
      }
    } finally {
      await db.close();
    }
  });

  test('JLPT N4 2024-07 self-heals when already at completed version but missing questionGroups', () async {
    SharedPreferences.setMockInitialValues({
      'dev_seed_completed_version': 66,
    });
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final repo = PastExamRepository(db);

    try {
      final sourceId = await db.into(db.sources).insert(
        SourcesCompanion.insert(
          type: SourceType.pastExam,
          name: '2024年7月 JLPT N4 真題',
          jlptLevel: const Value('N4'),
          examYear: const Value(2024),
          examMonth: const Value(7),
        ),
      );

      // Pre-insert dummy questions without groupId
      for (var i = 1; i <= 57; i++) {
        await db.into(db.questions).insert(
          QuestionsCompanion.insert(
            sourceId: sourceId,
            jlptLevel: 'N4',
            subject: i >= 22 && i <= 29 ? Subject.reading : Subject.vocab,
            mondaiTypeId: 1,
            questionNo: Value(i),
            questionText: 'Question $i without passage',
            groupId: const Value(null),
          ),
        );
      }

      final initialReading = await repo.getQuestions(
        sourceId: sourceId,
        subject: Subject.reading,
      );
      expect(initialReading.every((q) => q.passage == null), isTrue);

      // Run seedDevData (which should self-heal N4 2024-07)
      await seedDevData(db, prefs: prefs);

      final repairedReading = await repo.getQuestions(
        sourceId: sourceId,
        subject: Subject.reading,
      );
      expect(repairedReading.length, equals(8));
      for (final q in repairedReading) {
        expect(q.passage, isNotNull, reason: 'Question ${q.questionNo} must have passage after repair');
        expect(q.passage!.trim().isNotEmpty, isTrue);
      }
    } finally {
      await db.close();
    }
  });
}
