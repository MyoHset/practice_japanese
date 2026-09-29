import 'package:flutter/material.dart';
import 'package:practice_janpanese/core/constants/app_spacing.dart';
import 'package:practice_janpanese/core/constants/app_strings.dart';
import 'package:practice_janpanese/core/theme/app_colors.dart';
import 'package:practice_janpanese/core/widgets/app_card.dart';
import 'package:practice_janpanese/core/widgets/app_progress_bar.dart';

/// Summary card displaying aggregate mastery and progress across all units.
class UnitSummaryCard extends StatelessWidget {
  const UnitSummaryCard({
    super.key,
    required this.total,
    required this.mastered,
  });

  final int total;
  final int mastered;

  @override
  Widget build(BuildContext context) {
    final ratio = total == 0 ? 0.0 : (mastered / total).clamp(0.0, 1.0);
    final percentage = (ratio * 100).toInt();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${AppStrings.masteredCount(mastered)} / ${AppStrings.itemsCount(total)}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.text,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                '$percentage%',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          AppProgressBar(
            value: ratio,
            color: AppColors.secondary,
          ),
        ],
      ),
    );
  }
}
