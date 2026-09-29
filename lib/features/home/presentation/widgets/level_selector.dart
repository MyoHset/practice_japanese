import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_janpanese/core/constants/app_spacing.dart';
import 'package:practice_janpanese/features/home/presentation/widgets/level_card.dart';
import 'package:practice_janpanese/features/level/domain/jlpt_level.dart';
import 'package:practice_janpanese/features/level/presentation/providers/selected_level_provider.dart';

/// Horizontal scrolling row of [LevelCard] widgets for selecting the active JLPT level.
class LevelSelector extends ConsumerWidget {
  const LevelSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedLevelProvider);

    return SizedBox(
      height: 76,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: kJlptLevels.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final level = kJlptLevels[index];
          final isSelected = level == selected;

          return LevelCard(
            level: level,
            isSelected: isSelected,
            onTap: () => ref.read(selectedLevelProvider.notifier).select(level),
          );
        },
      ),
    );
  }
}
