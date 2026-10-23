import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_janpanese/core/constants/app_radius.dart';
import 'package:practice_janpanese/core/constants/app_sizes.dart';
import 'package:practice_janpanese/core/constants/app_spacing.dart';
import 'package:practice_janpanese/core/theme/app_colors.dart';
import 'package:practice_janpanese/core/widgets/app_card.dart';
import 'package:practice_janpanese/features/library/domain/content_kind.dart';
import 'package:practice_janpanese/features/library/domain/study_item.dart';
import 'package:practice_janpanese/features/library/presentation/providers/library_providers.dart';

/// Card displaying a single study item (Kanji, Vocab, or Grammar) in List mode.
class StudyItemCard extends ConsumerWidget {
  const StudyItemCard({
    super.key,
    required this.item,
    required this.index,
    this.kind,
    this.onBookmarkTap,
    this.onTap,
  });

  final StudyItem item;
  final int index;
  final ContentKind? kind;
  final VoidCallback? onBookmarkTap;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) => AppCard(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                '$index',
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
                  if (item.exampleJp != null && item.exampleJp!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 1.5,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primarySoft,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  '例文',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Expanded(
                                child: Text(
                                  item.exampleJp!,
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
                          if (item.exampleMy != null &&
                              item.exampleMy!.isNotEmpty) ...[
                            const SizedBox(height: 3),
                            Padding(
                              padding: const EdgeInsets.only(left: 32),
                              child: Text(
                                item.exampleMy!,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: AppColors.textSoft,
                                    ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (onBookmarkTap != null || kind != null)
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: item.isBookmarked
                        ? 'မေ့လွယ်သောစာရင်းမှ ဖယ်ထုတ်မည်'
                        : 'မေ့လွယ်သောစာရင်းထဲ ထည့်မည်',
                    icon: Icon(
                      item.isBookmarked
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      color: item.isBookmarked
                          ? Colors.amber.shade700
                          : AppColors.textSoft.withValues(alpha: 0.5),
                      size: 22,
                    ),
                    onPressed: () async {
                      if (onBookmarkTap != null) {
                        onBookmarkTap!();
                      } else if (kind != null) {
                        final isNow = await ref
                            .read(libraryRepositoryProvider)
                            .toggleBookmark(
                              kind: kind!,
                              itemId: item.id,
                            );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isNow
                                    ? '"${item.primary}" ကို မေ့လွယ်သောစာရင်းထဲ ထည့်လိုက်ပါပြီ'
                                    : '"${item.primary}" ကို မေ့လွယ်သောစာရင်းမှ ဖယ်ထုတ်လိုက်ပါပြီ',
                              ),
                              duration: const Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      }
                    },
                  ),
                if (item.isBookmarked) ...[
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      border: Border.all(color: Colors.amber.shade300),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: Colors.amber.shade800,
                          size: 11,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          'မေ့လွယ်',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: Colors.amber.shade900,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 9,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      );
}
