import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Speed Master N3 Kanji JSON asset integrity test', () {
    final file = File('assets/data/kanji_speed_master_n3.json');
    expect(file.existsSync(), isTrue, reason: 'kanji_speed_master_n3.json must exist');

    final jsonStr = file.readAsStringSync();
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;

    expect(data['book'] ?? data['title'], equals('Speed Master N3 漢字'));
    expect(data['level'], equals('N3'));

    final chapters = data['chapters'] as List<dynamic>;
    expect(chapters.length, equals(25), reason: 'Must have 25 chapters');

    var totalKanjis = 0;
    var totalVocabWords = 0;
    final allVocabSet = <String>{};

    for (var i = 0; i < chapters.length; i++) {
      final ch = chapters[i] as Map<String, dynamic>;
      expect(ch['chapter'], equals(i + 1));
      expect(ch['title'], isNotEmpty);

      final kanjis = ch['kanjis'] as List<dynamic>;
      expect(kanjis, isNotEmpty);
      totalKanjis += kanjis.length;

      for (final k in kanjis) {
        final kanjiMap = k as Map<String, dynamic>;
        expect(kanjiMap['character'], isNotEmpty);
        expect(kanjiMap['meaning'], isNotEmpty);
        expect(
          kanjiMap.containsKey('onyomi'),
          isTrue,
        );
        expect(
          kanjiMap.containsKey('kunyomi'),
          isTrue,
        );

        final vocabList = (kanjiMap['vocab'] as List<dynamic>?) ?? [];
        totalVocabWords += vocabList.length;
        for (final v in vocabList) {
          final vMap = v as Map<String, dynamic>;
          expect(vMap['word'], isNotEmpty);
          expect(vMap['reading'], isNotEmpty);
          expect(vMap['meaning'], isNotEmpty);
          allVocabSet.add('${vMap['word']}_${vMap['reading']}');
        }
      }
    }

    expect(totalKanjis, equals(474), reason: 'Total kanji count across 25 chapters should be 474');
    expect(totalVocabWords, equals(1345), reason: 'Total compound words across 25 chapters should be 1345');
    expect(allVocabSet.length, equals(1219), reason: 'Total unique compound words across 25 chapters should be 1219');
  });
}
