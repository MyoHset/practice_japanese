import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('kanji_nihongo_challenge_n4.json has valid structure and contents', () {
    final file = File('assets/data/kanji_nihongo_challenge_n4.json');
    expect(file.existsSync(), isTrue);

    final jsonStr = file.readAsStringSync();
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;

    expect(data['book'], 'Nihongo Challenge N4 漢字');
    expect(data['level'], 'N4');
    expect(data['totalChapters'], 20);
    expect(data['totalKanji'], 199);
    expect(data['totalVocab'], 646);

    final chapters = data['chapters'] as List<dynamic>;
    expect(chapters.length, 20);

    var totalKanjiCount = 0;
    var totalKanjiVocabPairs = 0;
    var totalAllVocabCount = 0;

    for (var i = 0; i < chapters.length; i++) {
      final ch = chapters[i] as Map<String, dynamic>;
      expect(ch['chapter'], i + 1);
      expect(ch['title'], isNotEmpty);

      // Check all_vocabs
      final allVocabs = ch['all_vocabs'] as List<dynamic>;
      expect(allVocabs.isNotEmpty, isTrue);
      totalAllVocabCount += allVocabs.length;

      for (final v in allVocabs) {
        final vocabMap = v as Map<String, dynamic>;
        expect(vocabMap['word'], isNotEmpty);
        expect(vocabMap['reading'], isNotEmpty);
        expect(vocabMap['meaning'], isNotEmpty);
      }

      // Check kanjis
      final kanjis = ch['kanjis'] as List<dynamic>;
      expect(kanjis.isNotEmpty, isTrue);
      totalKanjiCount += kanjis.length;

      for (final k in kanjis) {
        final kanjiMap = k as Map<String, dynamic>;
        expect(kanjiMap['character'], isNotEmpty);
        expect(kanjiMap['meaning'], isNotEmpty);

        final vocabList = (kanjiMap['vocab'] as List<dynamic>?) ?? [];
        totalKanjiVocabPairs += vocabList.length;

        for (final v in vocabList) {
          final vocabMap = v as Map<String, dynamic>;
          expect(vocabMap['word'], isNotEmpty);
          expect(vocabMap['reading'], isNotEmpty);
          expect(vocabMap['meaning'], isNotEmpty);
        }
      }
    }

    expect(totalKanjiCount, 199);
    expect(totalAllVocabCount, 646);
    expect(totalKanjiVocabPairs, 706);
  });
}
