import 'package:flutter/material.dart';
import 'package:practice_janpanese/core/constants/app_radius.dart';
import 'package:practice_janpanese/core/constants/app_spacing.dart';
import 'package:practice_janpanese/core/constants/app_strings.dart';
import 'package:practice_janpanese/core/theme/app_colors.dart';
import 'package:practice_janpanese/core/widgets/app_card.dart';
import 'package:practice_janpanese/core/widgets/app_progress_bar.dart';
import 'package:practice_janpanese/features/library/domain/unit_progress.dart';

/// Clean and compact card tile representing a unit in a source.
class UnitTile extends StatelessWidget {
  const UnitTile({
    super.key,
    required this.unit,
    required this.onTap,
    this.displayName,
    this.onFlashcardTap,
    this.onQuickQuizTap,
  });

  final UnitProgress unit;
  final VoidCallback onTap;
  final String? displayName;
  final VoidCallback? onFlashcardTap;
  final VoidCallback? onQuickQuizTap;

  @override
  Widget build(BuildContext context) {
    final isMastered = unit.total > 0 && unit.mastered >= unit.total;
    final hasProgress = unit.mastered > 0;
    final percentage = (unit.ratio * 100).toInt();

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 10,
      ),
      child: Row(
        children: [
          // Order / Status Badge
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isMastered
                  ? AppColors.secondary.withValues(alpha: 0.15)
                  : AppColors.primarySoft,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: isMastered
                ? const Icon(
                    Icons.check_rounded,
                    size: 18,
                    color: AppColors.secondary,
                  )
                : Text(
                    '${unit.orderNo}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                  ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Title & Progress Information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  displayName ?? unit.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        height: 1.25,
                      ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      AppStrings.itemsCount(unit.total),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSoft,
                            fontSize: 11,
                          ),
                    ),
                    if (hasProgress) ...[
                      const Text(
                        ' · ',
                        style: TextStyle(
                          color: AppColors.textSoft,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        AppStrings.masteredCount(unit.mastered),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isMastered
                                  ? AppColors.secondary
                                  : AppColors.textSoft,
                              fontWeight: isMastered
                                  ? FontWeight.w700
                                  : FontWeight.normal,
                              fontSize: 11,
                            ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 5),
                AppProgressBar(
                  value: unit.ratio,
                  color: isMastered ? AppColors.secondary : AppColors.primary,
                  height: 3.5,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),

          // Trailing status & arrow
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasProgress)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text(
                    '$percentage%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isMastered
                          ? AppColors.secondary
                          : AppColors.textSoft,
                    ),
                  ),
                ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSoft,
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
