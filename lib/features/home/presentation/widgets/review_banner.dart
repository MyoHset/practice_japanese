import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_janpanese/core/constants/app_radius.dart';
import 'package:practice_janpanese/core/constants/app_sizes.dart';
import 'package:practice_janpanese/core/constants/app_spacing.dart';
import 'package:practice_janpanese/core/constants/app_strings.dart';
import 'package:practice_janpanese/core/theme/app_colors.dart';
import 'package:practice_janpanese/features/library/presentation/providers/library_providers.dart';

/// Banner on the home screen showing due review items per B5.
class ReviewBanner extends ConsumerWidget {
  const ReviewBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countAsync = ref.watch(dueReviewCountProvider);
    final count = countAsync.valueOrNull ?? 0;

    final message =
        count > 0 ? AppStrings.reviewCount(count) : AppStrings.reviewNone;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppStrings.reviewToday,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.surface.withAlpha(200),
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  message,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.surface,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Container(
            width: AppSizes.unitBadgeSize,
            height: AppSizes.unitBadgeSize,
            decoration: const BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.schedule_rounded,
              color: AppColors.surface,
              size: AppSizes.iconMd,
            ),
          ),
        ],
      ),
    );
  }
}

/// Backwards compatibility alias.
typedef ReviewTodayCard = ReviewBanner;
