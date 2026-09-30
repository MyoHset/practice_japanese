import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('JLPT N3 2011-07 Past Exam JSON asset integrity test', () {
    final file = File('assets/data/jlpt_n3_2011_07.json');
    expect(file.existsSync(), isTrue);

    final content = file.readAsStringSync();
    final data = jsonDecode(content) as Map<String, dynamic>;

    expect(data['id'], 'jlpt_n3_2011_07');
    expect(data['level'], 'N3');
    expect(data['year'], 2011);
    expect(data['month'], 7);

    final sections = data['sections'] as List<dynamic>;
    expect(sections.length, 4);

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
          if (mondaiMap['type'] == 'sentenceOrder') {
            expect(qMap['starPosition'], isNotNull);
            expect(qMap['correctOrder'], isA<List<dynamic>>());
          }
        }
      }
      sectionCounts[subject] = countInSec;
    }

    // Verify exact question counts per JLPT N3 format
    expect(totalQuestions, 80);
    expect(sectionCounts['vocab'], 35);
    expect(sectionCounts['grammar'], 23);
    expect(sectionCounts['reading'], 16);
    expect(sectionCounts['listening'], 6);
  });
}
