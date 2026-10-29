import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practice_janpanese/core/database/app_database.dart';
import 'package:practice_janpanese/core/database/dev_seed.dart';
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

  test('JLPT N3 2025-12 JSON data integrity and database re-seeding test', () async {
    final file = File('assets/data/jlpt_n3_2025_12.json');
    expect(file.existsSync(), isTrue);

    final jsonStr = file.readAsStringSync();
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;

    expect(data['id'], equals('jlpt_n3_2025_12'));
    expect(data['level'], equals('N3'));
    expect(data['year'], equals(2025));
    expect(data['month'], equals(12));

    // Test DB reseed with version migration
    SharedPreferences.setMockInitialValues({
      'dev_seed_completed_version': 61,
    });
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase.forTesting(NativeDatabase.memory());

    try {
      // Pre-insert a dummy source to simulate existing database
      final dummySourceId = await db.into(db.sources).insert(
        SourcesCompanion.insert(
          type: SourceType.pastExam,
          name: '2025年12月 JLPT N3 真題',
          jlptLevel: const Value('N3'),
          examYear: const Value(2025),
          examMonth: const Value(12),
        ),
      );
      // Insert a dummy old question with outdated explanation
      await db.into(db.questions).insert(
        QuestionsCompanion.insert(
          sourceId: dummySourceId,
          jlptLevel: 'N3',
          subject: Subject.vocab,
          mondaiTypeId: 1,
          questionText: 'この料理は塩辛すぎます。',
          explanation: const Value('OLD BROKEN EXPLANATION'),
        ),
      );

      // Call seedDevData which should detect version 61 < 62 and force re-seed
      await seedDevData(db, prefs: prefs);

      // Verify SharedPreferences updated to 64
      expect(prefs.getInt('dev_seed_completed_version'), equals(64));

      // Verify question explanations in DB are updated
      final questions = await (db.select(db.questions)
            ..where((q) => q.sourceId.equals(dummySourceId)))
          .get();

      expect(questions.length, equals(53));
      final q9 = questions.firstWhere((q) => q.questionText.contains('塩辛'));
      expect(q9.explanation, contains('ငန်သော'));
      expect(q9.explanation, isNot(contains('OLD BROKEN EXPLANATION')));
      expect(q9.explanation, isNot(contains('ငန်းချဉ်သည့်အခါတွင်')));
    } finally {
      await db.close();
    }
  });
}
