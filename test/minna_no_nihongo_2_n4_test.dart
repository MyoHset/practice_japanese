import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Minna no Nihongo II N4 vocabulary JSON data integrity test', () {
    final file = File('assets/data/minna_no_nihongo_2_n4.json');
    expect(file.existsSync(), isTrue, reason: 'File should exist');

    final jsonStr = file.readAsStringSync();
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;

    expect(data['book'], contains('Minna no Nihongo'));
    expect(data['level'], equals('N4'));
    expect(data['totalSections'], equals(25));

    final sections = data['sections'] as List;
    expect(sections.length, equals(25),
        reason: 'Should have 25 lessons (Chapter 26 to 50)');

    int totalWords = 0;

    for (var i = 0; i < sections.length; i++) {
      final section = sections[i] as Map<String, dynamic>;
      final chapter = section['chapter'] as int;
      expect(chapter, equals(26 + i),
          reason: 'Chapter numbers should run from 26 to 50');

      final words = section['words'] as List;
      expect(words.isNotEmpty, isTrue,
          reason: 'Chapter $chapter should have words');

      for (final w in words) {
        totalWords++;
        final wordStr = w['word'] as String?;
        final readingStr = w['reading'] as String?;
        final meaningStr = w['meaning'] as String?;

        expect(wordStr, isNotNull);
        expect(wordStr!.trim().isNotEmpty, isTrue);

        expect(readingStr, isNotNull);
        expect(readingStr!.trim().isNotEmpty, isTrue);

        expect(meaningStr, isNotNull);
        expect(meaningStr!.trim().isNotEmpty, isTrue);
      }
    }

    expect(totalWords, greaterThanOrEqualTo(900),
        reason: 'Should have over 900 vocabulary items across 25 chapters');
  });
}
