import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practice_janpanese/core/database/app_database.dart';
import 'package:practice_janpanese/core/database/dev_seed.dart';
import 'package:practice_janpanese/features/past_exam/data/past_exam_repository.dart';
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

  test('JLPT N3 2015-07 Past Exam JSON asset integrity test', () {
    final file = File('assets/data/jlpt_n3_2015_07.json');
    expect(file.existsSync(), isTrue, reason: 'JSON file must exist');

    final content = file.readAsStringSync();
    final data = jsonDecode(content) as Map<String, dynamic>;

    expect(data['id'], 'jlpt_n3_2015_07');
    expect(data['level'], 'N3');
    expect(data['year'], 2015);
    expect(data['month'], 7);

    final sections = data['sections'] as List<dynamic>;
    expect(sections.length, 3, reason: 'vocab, grammar, reading');

    final sectionCounts = <String, int>{};
    var totalQuestions = 0;

    for (final sec in sections) {
      final s = sec as Map<String, dynamic>;
      final subject = s['subject'] as String;
      final mondais = s['mondaiTypes'] as List<dynamic>;

      var countInSec = 0;
      for (final m in mondais) {
        final mondaiMap = m as Map<String, dynamic>;
        expect(mondaiMap['mondaiNo'], isA<int>());
        expect(mondaiMap['type'], isNotEmpty);
        expect(mondaiMap['nameJp'], isNotEmpty);

        final questions = mondaiMap['questions'] as List<dynamic>;
        for (final q in questions) {
          final qMap = q as Map<String, dynamic>;
          totalQuestions++;
          countInSec++;

          expect(qMap['questionNo'], isA<int>());
          expect(qMap['questionText'], isNotEmpty);
          expect(qMap['explanation'], isNotEmpty);

          final choices = qMap['choices'] as List<dynamic>;
          expect(choices.length, 4);
          for (final choice in choices) {
            expect(choice.toString().trim(), isNotEmpty);
          }

          final correctIndex = qMap['correctIndex'] as int;
          expect(correctIndex >= 1 && correctIndex <= 4, isTrue);

          // Sentence order questions should have starPosition and correctOrder
          if (mondaiMap['type'] == 'sentenceOrder' ||
              mondaiMap['type'] == 'sentenceComposition') {
            expect(qMap['starPosition'], isNotNull);
            expect(qMap['correctOrder'], isA<List<dynamic>>());
            final correctOrder = qMap['correctOrder'] as List<dynamic>;
            expect(correctOrder.length, 4);
            expect(correctOrder[qMap['starPosition'] - 1], equals(correctIndex));
          }
        }
      }
      sectionCounts[subject] = countInSec;
    }

    expect(totalQuestions, 74, reason: 'Total questions in 2015-07 exam');
    expect(sectionCounts['vocab'], 35, reason: 'Vocab should have 35 questions');
    expect(sectionCounts['grammar'], 23, reason: 'Grammar should have 23 questions');
    expect(sectionCounts['reading'], 16, reason: 'Reading should have 16 questions');
  });

  test('JLPT N3 2015-07 seeds correctly into Drift DB and loads questions', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    await seedDevData(db);

    final source = await (db.sources.select()
          ..where(
            (s) =>
                s.type.equalsValue(SourceType.pastExam) &
                s.jlptLevel.equals('N3') &
                s.examYear.equals(2015) &
                s.examMonth.equals(7),
          ))
        .getSingle();

    final repo = PastExamRepository(db);
    final allQuestions = await repo.getQuestions(sourceId: source.id);
    expect(allQuestions.length, equals(74));

    final vocabQs = await repo.getQuestions(sourceId: source.id, subject: Subject.vocab);
    final grammarQs = await repo.getQuestions(sourceId: source.id, subject: Subject.grammar);
    final readingQs = await repo.getQuestions(sourceId: source.id, subject: Subject.reading);

    expect(vocabQs.length, equals(35));
    expect(grammarQs.length, equals(23));
    expect(readingQs.length, equals(16));

    // Check sentence order questions have correctOrder and starPosition
    final starQs = grammarQs.where((q) => q.mondaiType == MondaiType.sentenceOrder).toList();
    expect(starQs.length, equals(5));
    for (final sq in starQs) {
      expect(sq.starPosition, equals(3));
      expect(sq.correctOrder, isNotNull);
      expect(sq.correctOrder!.length, equals(4));
    }

    // Check reading questions have passages loaded via questionGroups
    for (final rq in readingQs) {
      expect(rq.passage, isNotNull,
          reason: 'Reading question ${rq.questionNo} should have passage');
      expect(rq.passage!.trim().isNotEmpty, isTrue);
    }
  });
}
