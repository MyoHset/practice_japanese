import 'package:flutter/material.dart';
import 'package:practice_janpanese/core/constants/app_radius.dart';
import 'package:practice_janpanese/core/constants/app_sizes.dart';
import 'package:practice_janpanese/core/constants/app_spacing.dart';
import 'package:practice_janpanese/core/constants/app_strings.dart';
import 'package:practice_janpanese/core/theme/app_colors.dart';
import 'package:practice_janpanese/core/widgets/app_card.dart';
import 'package:practice_janpanese/features/library/domain/study_item.dart';

/// Card displaying a single study item (Kanji, Vocab, or Grammar) in List mode.
class StudyItemCard extends StatelessWidget {
  const StudyItemCard({
    super.key,
    required this.item,
    required this.index,
  });

  final StudyItem item;
  final int index;

  @override
  Widget build(BuildContext context) => AppCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: AppSizes.unitBadgeSize,
              height: AppSizes.unitBadgeSize,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: item.isMastered
                    ? AppColors.secondary.withAlpha(35)
                    : AppColors.primarySoft,
                borderRadius: BorderRadius.circular(AppRadius.unitBadge),
              ),
              child: Text(
                '$index',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: item.isMastered
                          ? AppColors.secondary
                          : AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item.secondary != null && item.secondary!.isNotEmpty) ...[
                    if (item.secondary!.contains('音読み:') ||
                        item.secondary!.contains('訓読み:')) ...[
                      for (final line in item.secondary!.split('\n'))
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 1.5,
                                ),
                                decoration: BoxDecoration(
                                  color: line.startsWith('音読み:')
                                      ? AppColors.primarySoft
                                      : const Color(0xFFE8F4F8),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  line.startsWith('音読み:') ? '音読み' : '訓読み',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: line.startsWith('音読み:')
                                        ? AppColors.primary
                                        : const Color(0xFF0077B6),
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Flexible(
                                child: Text(
                                  line.substring(line.indexOf(':') + 1).trim(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.text,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ] else
                      Text(
                        item.secondary!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    const SizedBox(height: AppSpacing.xs),
                  ],
                  Text(
                    item.primary,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.text,
                        ),
                  ),
                  if (item.meaning != null && item.meaning!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      item.meaning!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.text,
                          ),
                    ),
                  ],
                  if (item.connection != null &&
                      item.connection!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Text(
                        item.connection!,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.textSoft,
                            ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (item.isMastered)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withAlpha(25),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(color: AppColors.secondary),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.secondary,
                      size: AppSizes.iconSm,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      AppStrings.masteredCount(1).replaceAll('1 ', ''),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
}
