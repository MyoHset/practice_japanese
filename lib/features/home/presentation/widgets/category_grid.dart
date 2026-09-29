import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:practice_janpanese/core/constants/app_spacing.dart';
import 'package:practice_janpanese/core/constants/app_strings.dart';
import 'package:practice_janpanese/core/router/app_routes.dart';
import 'package:practice_janpanese/core/theme/app_colors.dart';
import 'package:practice_janpanese/features/home/presentation/widgets/category_card.dart';
import 'package:practice_janpanese/features/level/presentation/providers/selected_level_provider.dart';
import 'package:practice_janpanese/features/library/domain/content_kind.dart';

/// 2x2 grid containing the main category entry cards on the home screen per B5.
class CategoryGrid extends ConsumerWidget {
  const CategoryGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLevel = ref.watch(selectedLevelProvider);
    final softColor = AppColors.levelSoft(selectedLevel);

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      childAspectRatio: 1.1,
      children: [
        CategoryCard(
          glyph: ContentKind.kanji.glyph,
          title: ContentKind.kanji.label,
          subtitle: AppStrings.categoryKanjiSub,
          glyphBoxColor: softColor,
          onTap: () => context.push(AppRoutes.sourceList(ContentKind.kanji)),
        ),
        CategoryCard(
          glyph: ContentKind.vocab.glyph,
          title: ContentKind.vocab.label,
          subtitle: AppStrings.categoryVocabSub,
          glyphBoxColor: softColor,
          onTap: () => context.push(AppRoutes.sourceList(ContentKind.vocab)),
        ),
        CategoryCard(
          glyph: ContentKind.grammar.glyph,
          title: ContentKind.grammar.label,
          subtitle: AppStrings.categoryGrammarSub,
          glyphBoxColor: softColor,
          onTap: () => context.push(AppRoutes.sourceList(ContentKind.grammar)),
        ),
        CategoryCard(
          glyph: '問',
          title: AppStrings.categoryPastExam,
          subtitle: AppStrings.categoryPastExamSub,
          glyphBoxColor: softColor,
          onTap: () => context.push(AppRoutes.pastExam),
        ),
      ],
    );
  }
}
