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

  test('JLPT N4 2025-12 reading passages are correctly loaded and queried on fresh seed', () async {
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
                  s.examYear.equals(2025) &
                  s.examMonth.equals(12),
            ))
          .getSingleOrNull();

      expect(source, isNotNull, reason: 'Source for N4 2025-12 must exist');

      final readingQuestions = await repo.getQuestions(
        sourceId: source!.id,
        subject: Subject.reading,
      );

      expect(readingQuestions.length, equals(8), reason: 'Mondai 4 (3) + Mondai 5 (3) + Mondai 6 (2) = 8 questions');

      for (final q in readingQuestions) {
        expect(q.passage, isNotNull, reason: 'Question ${q.questionNo} should have a passage');
        expect(q.passage!.trim().isNotEmpty, isTrue, reason: 'Question ${q.questionNo} passage should not be empty');
      }
    } finally {
      await db.close();
    }
  });

  test('JLPT N4 2025-12 self-heals when already at completed version but missing questionGroups', () async {
    // Simulate an existing database already at version 64 where source and 54 questions exist
    // but questionGroups was 0 (the exact bug the user experienced)
    SharedPreferences.setMockInitialValues({
      'dev_seed_completed_version': 64,
    });
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final repo = PastExamRepository(db);

    try {
      final sourceId = await db.into(db.sources).insert(
        SourcesCompanion.insert(
          type: SourceType.pastExam,
          name: '2025年12月 JLPT N4 真題',
          jlptLevel: const Value('N4'),
          examYear: const Value(2025),
          examMonth: const Value(12),
        ),
      );

      // Pre-insert 54 dummy questions with NO passage/groupId to simulate old unpatched data
      for (var i = 1; i <= 54; i++) {
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

      // Verify that initially reading questions have NO passage
      final initialReading = await repo.getQuestions(
        sourceId: sourceId,
        subject: Subject.reading,
      );
      expect(initialReading.every((q) => q.passage == null), isTrue);

      // Now call seedDevData (which should self-heal N4 2025 12 even though version is 64!)
      await seedDevData(db, prefs: prefs);

      // Verify reading questions now have passages!
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
