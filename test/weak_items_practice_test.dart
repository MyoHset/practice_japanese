import 'package:flutter_test/flutter_test.dart';
import 'package:practice_janpanese/core/router/app_routes.dart';
import 'package:practice_janpanese/features/library/domain/content_kind.dart';
import 'package:practice_janpanese/features/library/domain/study_item.dart';
import 'package:practice_janpanese/features/library/domain/study_mode.dart';

void main() {
  group('Weak Items & Forgotten Words Feature Tests', () {
    test('AppRoutes builds practice URL with onlyWeak query parameter', () {
      final urlSingle = AppRoutes.chapterStudy(
        ContentKind.vocab,
        1,
        1,
        StudyMode.flashcard,
        onlyWeak: true,
      );
      expect(urlSingle, contains('?onlyWeak=true'));

      final urlMulti = AppRoutes.practiceStudy(
        ContentKind.kanji,
        2,
        StudyMode.quick,
        chapters: [1, 2],
        limit: 20,
        isRandom: true,
        onlyWeak: true,
      );
      expect(urlMulti, contains('onlyWeak=true'));
      expect(urlMulti, contains('chapters=1,2'));
      expect(urlMulti, contains('limit=20'));
    });

    test('StudyItem isWeak getter behaves correctly based on wrongCount', () {
      const itemNormal = StudyItem(
        id: 1,
        primary: '勉強',
        secondary: 'べんきょう',
        meaning: 'စာကျက်ခြင်း',
        streak: 2,
        wrongCount: 0,
      );
      expect(itemNormal.isWeak, isFalse);

      const itemWeak = StudyItem(
        id: 2,
        primary: '約束',
        secondary: 'やくそく',
        meaning: 'ကတိ',
        streak: 0,
        wrongCount: 3,
      );
      expect(itemWeak.isWeak, isTrue);

      const itemBookmarked = StudyItem(
        id: 3,
        primary: '政治',
        secondary: 'せいじ',
        meaning: 'နိုင်ငံရေး',
        streak: 3,
        wrongCount: 0,
        isBookmarked: true,
      );
      expect(itemBookmarked.isWeak, isTrue);
    });
  });
}
