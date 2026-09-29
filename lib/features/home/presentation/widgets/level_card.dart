import 'package:flutter/material.dart';
import 'package:practice_janpanese/core/constants/app_durations.dart';
import 'package:practice_janpanese/core/constants/app_radius.dart';
import 'package:practice_janpanese/core/constants/app_sizes.dart';
import 'package:practice_janpanese/core/constants/app_spacing.dart';
import 'package:practice_janpanese/core/theme/app_colors.dart';
import 'package:practice_janpanese/features/level/domain/jlpt_level.dart';

/// Selectable card for a JLPT level with smooth animated state transitions.
class LevelCard extends StatelessWidget {
  const LevelCard({
    super.key,
    required this.level,
    required this.isSelected,
    required this.onTap,
  });

  final String level;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final solidColor = AppColors.level(level);
    final softColor = AppColors.levelSoft(level);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: AnimatedContainer(
        duration: AppDurations.normal,
        width: AppSizes.levelCardWidth,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: isSelected ? solidColor : softColor,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  level,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.text,
                      ),
                ),
                if (isSelected) ...[
                  const SizedBox(width: AppSpacing.xs),
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.primary,
                    size: AppSizes.iconSm,
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              levelJapaneseLabel(level),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textSoft,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
