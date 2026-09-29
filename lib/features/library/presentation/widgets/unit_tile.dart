import 'package:flutter/material.dart';
import 'package:practice_janpanese/core/constants/app_radius.dart';
import 'package:practice_janpanese/core/constants/app_sizes.dart';
import 'package:practice_janpanese/core/constants/app_spacing.dart';
import 'package:practice_janpanese/core/constants/app_strings.dart';
import 'package:practice_janpanese/core/theme/app_colors.dart';
import 'package:practice_janpanese/core/widgets/app_card.dart';
import 'package:practice_janpanese/core/widgets/app_progress_bar.dart';
import 'package:practice_janpanese/features/library/domain/unit_progress.dart';

/// Card tile representing a unit in a source, showing progress and item counts.
class UnitTile extends StatelessWidget {
  const UnitTile({
    super.key,
    required this.unit,
    required this.onTap,
  });

  final UnitProgress unit;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => AppCard(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: AppSizes.unitBadgeSize,
              height: AppSizes.unitBadgeSize,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(AppRadius.unitBadge),
              ),
              child: Text(
                '${unit.orderNo}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    unit.name,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${AppStrings.itemsCount(unit.total)} · ${AppStrings.masteredCount(unit.mastered)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSoft,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  AppProgressBar(
                    value: unit.ratio,
                    color: AppColors.secondary,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSoft,
              size: AppSizes.iconMd,
            ),
          ],
        ),
      );
}
