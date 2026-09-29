import 'package:flutter/material.dart';
import 'package:practice_janpanese/core/constants/app_radius.dart';
import 'package:practice_janpanese/core/constants/app_spacing.dart';
import 'package:practice_janpanese/core/constants/app_strings.dart';
import 'package:practice_janpanese/core/theme/app_colors.dart';

/// JLPT level badge used in app bar and cards.
class LevelChip extends StatelessWidget {
  const LevelChip({super.key, required this.level});

  final String level;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.levelSoft(level),
          border: Border.all(color: AppColors.level(level)),
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Text(
          AppStrings.levelLabel(level),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.level(level),
                fontWeight: FontWeight.w700,
              ),
        ),
      );
}
