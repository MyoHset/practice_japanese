import 'package:flutter_test/flutter_test.dart';
import 'package:practice_janpanese/features/level/domain/jlpt_level.dart';
import 'package:practice_janpanese/features/library/domain/content_kind.dart';
import 'package:practice_janpanese/features/library/domain/study_mode.dart';
import 'package:practice_janpanese/features/library/domain/unit_progress.dart';

void main() {
  group('JLPT Level Domain', () {
    test('kJlptLevels contains all 5 levels from N5 to N1', () {
      expect(kJlptLevels, equals(['N5', 'N4', 'N3', 'N2', 'N1']));
      expect(kDefaultJlptLevel, equals('N3'));
    });

    test('levelJapaneseLabel returns correct Japanese descriptor', () {
      expect(levelJapaneseLabel('N5'), equals('入門'));
      expect(levelJapaneseLabel('N4'), equals('初級'));
      expect(levelJapaneseLabel('N3'), equals('中級'));
      expect(levelJapaneseLabel('N2'), equals('中上級'));
      expect(levelJapaneseLabel('N1'), equals('上級'));
    });
  });

  group('ContentKind Domain', () {
    test('parses slugs correctly', () {
      expect(ContentKind.fromSlug('kanji'), equals(ContentKind.kanji));
      expect(ContentKind.fromSlug('vocab'), equals(ContentKind.vocab));
      expect(ContentKind.fromSlug('grammar'), equals(ContentKind.grammar));
    });

    test('tryFromSlug returns null on invalid slug', () {
      expect(ContentKind.tryFromSlug('unknown'), isNull);
    });

    test('has expected glyphs and database mapping metadata', () {
      expect(ContentKind.kanji.glyph, equals('漢'));
      expect(ContentKind.vocab.glyph, equals('語'));
      expect(ContentKind.grammar.glyph, equals('文'));
      expect(ContentKind.kanji.itemIdColumn, equals('kanji_id'));
      expect(ContentKind.vocab.itemIdColumn, equals('vocab_id'));
      expect(ContentKind.grammar.itemIdColumn, equals('grammar_id'));
    });
  });

  group('StudyMode Domain', () {
    test('parses slugs correctly', () {
      expect(StudyMode.fromSlug('list'), equals(StudyMode.list));
      expect(StudyMode.fromSlug('quick'), equals(StudyMode.quick));
      expect(StudyMode.fromSlug('flashcard'), equals(StudyMode.flashcard));
    });

    test('tryFromSlug returns null on invalid slug', () {
      expect(StudyMode.tryFromSlug('invalid'), isNull);
    });
  });

  group('UnitProgress Domain', () {
    test('calculates ratio correctly', () {
      const emptyUnit = UnitProgress(
        id: 1,
        name: 'Unit 1',
        orderNo: 1,
        total: 0,
        mastered: 0,
      );
      expect(emptyUnit.ratio, equals(0.0));

      const partialUnit = UnitProgress(
        id: 2,
        name: 'Unit 2',
        orderNo: 2,
        total: 10,
        mastered: 4,
      );
      expect(partialUnit.ratio, closeTo(0.4, 0.001));

      const completedUnit = UnitProgress(
        id: 3,
        name: 'Unit 3',
        orderNo: 3,
        total: 5,
        mastered: 5,
      );
      expect(completedUnit.ratio, equals(1.0));
    });
  });
}
