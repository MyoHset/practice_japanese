import 'package:flutter_test/flutter_test.dart';
import 'package:practice_janpanese/core/router/app_routes.dart';
import 'package:practice_janpanese/features/library/domain/chapter_group.dart';
import 'package:practice_janpanese/features/library/domain/content_kind.dart';
import 'package:practice_janpanese/features/library/domain/study_mode.dart';
import 'package:practice_janpanese/features/library/domain/unit_progress.dart';

void main() {
  group('ChapterGroup Domain', () {
    final sampleUnits = [
      const UnitProgress(
        id: 1,
        name: 'Ch.1 Sec.1: 家族 (မိသားစု)',
        orderNo: 1,
        total: 20,
        mastered: 5,
      ),
      const UnitProgress(
        id: 2,
        name: 'Ch.1 Sec.2: 友達と知り合い (သူငယ်ချင်း)',
        orderNo: 2,
        total: 25,
        mastered: 10,
      ),
      const UnitProgress(
        id: 3,
        name: 'Ch.2 Sec.1: 時の表現 (အချိန်)',
        orderNo: 3,
        total: 30,
        mastered: 15,
      ),
    ];

    test('groups units by chapter number correctly', () {
      final groups = ChapterGroup.fromUnits(sampleUnits);

      expect(groups.length, equals(2));
      expect(groups[0].chapterNumber, equals(1));
      expect(groups[0].title, equals('Chapter 1'));
      expect(groups[0].sections.length, equals(2));
      expect(groups[0].total, equals(45));
      expect(groups[0].mastered, equals(15));
      expect(groups[0].ratio, closeTo(15 / 45, 0.001));

      expect(groups[1].chapterNumber, equals(2));
      expect(groups[1].title, equals('Chapter 2'));
      expect(groups[1].sections.length, equals(1));
      expect(groups[1].total, equals(30));
      expect(groups[1].mastered, equals(15));
    });

    test('returns empty list for non-chaptered units', () {
      final standardUnits = [
        const UnitProgress(
          id: 10,
          name: 'Unit 1: 政治・社会',
          orderNo: 1,
          total: 10,
          mastered: 2,
        ),
        const UnitProgress(
          id: 11,
          name: 'Unit 2: 経済・産業',
          orderNo: 2,
          total: 10,
          mastered: 4,
        ),
      ];

      final groups = ChapterGroup.fromUnits(standardUnits);
      expect(groups, isEmpty);
    });

    test('formatSectionName strips redundant Ch. prefix cleanly', () {
      expect(
        ChapterGroup.formatSectionName('Ch.1 Sec.1: 家族 (မိသားစု)'),
        equals('Sec.1: 家族 (မိသားစု)'),
      );
      expect(
        ChapterGroup.formatSectionName('Ch.10 Sec.3: 気をつけよう'),
        equals('Sec.3: 気をつけよう'),
      );
      expect(
        ChapterGroup.formatSectionName('Unit 1: 政治'),
        equals('Unit 1: 政治'),
      );
    });
  });

  group('Chapter Study Routing', () {
    test('builds correct chapter study path', () {
      final path = AppRoutes.chapterStudy(
        ContentKind.vocab,
        3,
        1,
        StudyMode.flashcard,
      );
      expect(path, equals('/library/vocab/source/3/chapter/1/flashcard'));
    });

    test('builds correct section study path for flashcard', () {
      final path = AppRoutes.study(
        ContentKind.vocab,
        3,
        5,
        StudyMode.flashcard,
      );
      expect(path, equals('/library/vocab/source/3/unit/5/flashcard'));
    });

    test('builds correct chapter study path for quick quiz', () {
      final path = AppRoutes.chapterStudy(
        ContentKind.vocab,
        3,
        2,
        StudyMode.quick,
      );
      expect(path, equals('/library/vocab/source/3/chapter/2/quick'));
    });

    test('builds correct section study path for quick quiz', () {
      final path = AppRoutes.study(
        ContentKind.vocab,
        3,
        8,
        StudyMode.quick,
      );
      expect(path, equals('/library/vocab/source/3/unit/8/quick'));
    });
  });
}
