import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_janpanese/core/constants/app_radius.dart';
import 'package:practice_janpanese/core/constants/app_spacing.dart';
import 'package:practice_janpanese/core/constants/app_strings.dart';
import 'package:practice_janpanese/core/theme/app_colors.dart';
import 'package:practice_janpanese/features/home/presentation/providers/home_providers.dart';

/// Card showing count of items due for review today.
class ReviewTodayCard extends ConsumerWidget {
  const ReviewTodayCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCount = ref.watch(reviewTodayCountProvider);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.auto_awesome_rounded,
            color: AppColors.surface,
            size: 32,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: asyncCount.when(
              loading: () => const _ReviewLoading(),
              error: (_, __) => const _ReviewNone(),
              data: (count) => count > 0
                  ? _ReviewHasItems(count: count)
                  : const _ReviewNone(),
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.surface,
          ),
        ],
      ),
    );
  }
}

class _ReviewLoading extends StatelessWidget {
  const _ReviewLoading();

  @override
  Widget build(BuildContext context) => const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          color: AppColors.surface,
          strokeWidth: 2,
        ),
      );
}

class _ReviewNone extends StatelessWidget {
  const _ReviewNone();

  @override
  Widget build(BuildContext context) => Text(
        AppStrings.reviewNone,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: AppColors.surface),
      );
}

class _ReviewHasItems extends StatelessWidget {
  const _ReviewHasItems({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.reviewCount(count),
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: AppColors.surface),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            AppStrings.reviewToday,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.surface.withAlpha(200)),
          ),
        ],
      );
}
