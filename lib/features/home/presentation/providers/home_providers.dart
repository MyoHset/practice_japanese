import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_janpanese/core/constants/app_strings.dart';
import 'package:practice_janpanese/core/router/app_routes.dart';
import 'package:practice_janpanese/features/home/domain/home_category.dart';
import 'package:practice_janpanese/features/library/domain/content_kind.dart';
import 'package:practice_janpanese/features/library/presentation/providers/library_providers.dart';

export 'package:practice_janpanese/features/library/presentation/providers/library_providers.dart'
    show dueReviewCountProvider;

/// Static list of study categories.
final homeCategoriesProvider = Provider<List<HomeCategory>>(
  (ref) => [
    HomeCategory(
      label: AppStrings.categoryKanji,
      route: AppRoutes.sourceList(ContentKind.kanji),
      emoji: ContentKind.kanji.glyph,
    ),
    HomeCategory(
      label: AppStrings.categoryVocab,
      route: AppRoutes.sourceList(ContentKind.vocab),
      emoji: ContentKind.vocab.glyph,
    ),
    HomeCategory(
      label: AppStrings.categoryGrammar,
      route: AppRoutes.sourceList(ContentKind.grammar),
      emoji: ContentKind.grammar.glyph,
    ),
    const HomeCategory(
      label: AppStrings.categoryPastExam,
      route: AppRoutes.pastExam,
      emoji: '問',
    ),
  ],
);

/// Backward-compatible alias for due review count.
final reviewTodayCountProvider = dueReviewCountProvider;
