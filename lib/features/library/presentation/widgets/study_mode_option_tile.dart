import 'package:flutter/material.dart';
import 'package:practice_janpanese/core/constants/app_radius.dart';
import 'package:practice_janpanese/core/constants/app_sizes.dart';
import 'package:practice_janpanese/core/constants/app_spacing.dart';
import 'package:practice_janpanese/core/theme/app_colors.dart';
import 'package:practice_janpanese/core/widgets/app_card.dart';
import 'package:practice_janpanese/features/library/domain/study_mode.dart';

/// Single option row inside the [StudyModeSheet].
class StudyModeOptionTile extends StatelessWidget {
  const StudyModeOptionTile({
    super.key,
    required this.mode,
    required this.onTap,
  });

  final StudyMode mode;
  final VoidCallback onTap;

  Color get _iconColor {
    switch (mode) {
      case StudyMode.list:
        return AppColors.primary;
      case StudyMode.quick:
        return AppColors.accent;
      case StudyMode.flashcard:
        return AppColors.secondary;
    }
  }

  Color get _boxColor {
    switch (mode) {
      case StudyMode.list:
        return AppColors.primarySoft;
      case StudyMode.quick:
        return AppColors.accent.withAlpha(40);
      case StudyMode.flashcard:
        return AppColors.secondary.withAlpha(40);
    }
  }

  @override
  Widget build(BuildContext context) => AppCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Container(
              width: AppSizes.unitBadgeSize,
              height: AppSizes.unitBadgeSize,
              decoration: BoxDecoration(
                color: _boxColor,
                borderRadius: BorderRadius.circular(AppRadius.unitBadge),
              ),
              child: Icon(
                mode.icon,
                color: _iconColor,
                size: AppSizes.iconMd,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mode.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    mode.hint,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSoft,
                        ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSoft,
              size: AppSizes.iconMd,
            ),
          ],
        ),
      );
}
