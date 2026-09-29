import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Tango 2000 N3 JSON has valid structure and clean Burmese translations',
      () {
    final file = File('assets/data/tango_2000_n3.json');
    expect(file.existsSync(), isTrue);

    final content = file.readAsStringSync();
    final data = jsonDecode(content) as Map<String, dynamic>;

    expect(data['book'], 'Tango 2000');
    expect(data['level'], 'N3');
    expect(data['totalSections'], 60);
    expect(data['totalWords'], 1393);

    final sections = data['sections'] as List<dynamic>;
    expect(sections.length, 60);

    var wordCount = 0;
    for (final sec in sections) {
      final s = sec as Map<String, dynamic>;
      expect(s['title'], isNotEmpty);
      // Ensure section title does not have corrupted Zawgyi fragments
      expect(s['title'].toString().contains('ြိသာားစု'), isFalse);

      final words = s['words'] as List<dynamic>;
      for (final w in words) {
        final wordMap = w as Map<String, dynamic>;
        wordCount++;
        expect(wordMap['no'], isA<int>());
        expect(wordMap['word'], isNotEmpty);
        expect(wordMap['reading'], isNotEmpty);
        expect(wordMap['meaning'], isNotEmpty);

        // Meaning must not have previous corrupted font mappings
        final meaning = wordMap['meaning'] as String;
        expect(meaning.contains('အကြီးဆြီး'), isFalse);
        expect(meaning.contains('ဆြီး'), isFalse);
      }
    }

    expect(wordCount, 1393);
  });
}
