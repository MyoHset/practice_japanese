import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('JLPT N3 2014-12 JSON data integrity test', () {
    final file = File('assets/data/jlpt_n3_2014_12.json');
    expect(file.existsSync(), isTrue, reason: 'File should exist');

    final jsonStr = file.readAsStringSync();
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;

    expect(data['id'], equals('jlpt_n3_2014_12'));
    expect(data['name'], contains('2014年12月'));
    expect(data['level'], equals('N3'));
    expect(data['year'], equals(2014));
    expect(data['month'], equals(12));

    final sections = data['sections'] as List;
    expect(sections.length, equals(4), reason: 'Should have 4 sections: vocab, grammar, reading, listening');

    int totalQuestions = 0;
    final Map<String, int> sectionQuestionCounts = {};

    for (final section in sections) {
      final subject = section['subject'] as String;
      int sectionCount = 0;
      final mondaiTypes = section['mondaiTypes'] as List;

      for (final mondai in mondaiTypes) {
        final questions = mondai['questions'] as List;
        for (final q in questions) {
          sectionCount++;
          totalQuestions++;

          // Verify choices
          final choices = q['choices'] as List;
          expect(choices.length, anyOf(equals(3), equals(4)),
              reason: 'Questions should have 3 or 4 choices');

          // Verify correctIndex
          final correctIndex = q['correctIndex'] as int;
          expect(correctIndex, greaterThanOrEqualTo(1));
          expect(correctIndex, lessThanOrEqualTo(choices.length));

          // Verify explanation is present and non-empty
          final explanation = q['explanation'] as String?;
          expect(explanation, isNotNull);
          expect(explanation!.isNotEmpty, isTrue);

          // Star position questions check
          if (q.containsKey('starPosition')) {
            expect(q['starPosition'], isNotNull);
            expect(q['correctOrder'], isNotNull);
            final correctOrder = q['correctOrder'] as List;
            expect(correctOrder.length, equals(4));
          }
        }
      }
      sectionQuestionCounts[subject] = sectionCount;
    }

    expect(sectionQuestionCounts['vocab'], equals(35), reason: 'Vocab should have 35 questions');
    expect(sectionQuestionCounts['grammar'], equals(23), reason: 'Grammar should have 23 questions');
    expect(sectionQuestionCounts['reading'], equals(16), reason: 'Reading should have 16 questions');
    expect(sectionQuestionCounts['listening'], equals(28), reason: 'Listening should have 28 questions');
    expect(totalQuestions, equals(102), reason: 'Total questions should be 102');
  });
}
