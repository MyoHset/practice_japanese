import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('JLPT N4 2024-12 JSON data integrity test', () {
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
        final questions = mondai['questions'] as List;
        for (final q in questions) {
          totalQuestions++;

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
        reason: 'Total questions in N4 2024-12 should be 57 (28 vocab + 29 grammar/reading)');
  });
}
