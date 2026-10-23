import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:practice_janpanese/core/constants/app_radius.dart';
import 'package:practice_janpanese/core/constants/app_spacing.dart';
import 'package:practice_janpanese/core/router/app_routes.dart';
import 'package:practice_janpanese/core/theme/app_colors.dart';
import 'package:practice_janpanese/core/widgets/async_value_view.dart';
import 'package:practice_janpanese/features/library/domain/content_kind.dart';
import 'package:practice_janpanese/features/library/domain/study_item.dart';
import 'package:practice_janpanese/features/library/domain/study_mode.dart';
import 'package:practice_janpanese/features/library/presentation/providers/library_providers.dart';
import 'package:practice_janpanese/features/library/presentation/screens/study_item_detail_screen.dart';
import 'package:practice_janpanese/features/library/presentation/widgets/study_item_card.dart';

/// Modal bottom sheet displaying the list of weak / frequently forgotten items
/// for a chapter or all chapters, with instant Flashcard & Quiz practice actions.
class WeakItemsModal extends ConsumerWidget {
  const WeakItemsModal({
    super.key,
    required this.kind,
    required this.sourceId,
    required this.sourceName,
    this.chapterNumbers,
    this.chapterTitle,
  });

  final ContentKind kind;
  final int sourceId;
  final String sourceName;
  final List<int>? chapterNumbers;
  final String? chapterTitle;

  /// Shows the weak items modal bottom sheet.
  static Future<void> show(
    BuildContext context, {
    required ContentKind kind,
    required int sourceId,
    required String sourceName,
    List<int>? chapterNumbers,
    String? chapterTitle,
  }) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppColors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
        builder: (_) => WeakItemsModal(
          kind: kind,
          sourceId: sourceId,
          sourceName: sourceName,
          chapterNumbers: chapterNumbers,
          chapterTitle: chapterTitle,
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final effectiveChapters = chapterNumbers ?? const [];
    final itemsAsync = ref.watch(
      multiChapterItemsProvider(
        MultiChapterItemsParams(
          sourceId: sourceId,
          chapterNumbers: effectiveChapters,
          kind: kind,
          onlyWeak: true,
        ),
      ),
    );

    final title = chapterTitle ??
        (effectiveChapters.isEmpty
            ? 'အားလုံးမှ မေ့လွယ်သော စကားလုံးများ'
            : (effectiveChapters.length == 1
                ? 'Chapter ${effectiveChapters.first} · မေ့လွယ်သော စကားလုံးများ'
                : 'Chapters ${effectiveChapters.join(", ")} · မေ့လွယ်သော စကားလုံးများ'));

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.xs),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: const Icon(
                          Icons.warning_amber_rounded,
                          color: AppColors.error,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          title,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    sourceName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSoft,
                        ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Item list
            Expanded(
              child: AsyncValueView<List<StudyItem>>(
                value: itemsAsync,
                isEmpty: (items) => items.isEmpty,
                emptyMessage:
                    'မေ့လွယ်သော စကားလုံး မရှိသေးပါ\n(အားလုံး မှတ်မိထားပြီး ဖြစ်ပါသည်)',
                data: (items) => ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: items.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) => StudyItemCard(
                    item: items[index],
                    index: index + 1,
                    kind: kind,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => StudyItemDetailScreen(
                            items: items,
                            initialIndex: index,
                            kind: kind,
                            title: title,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // Bottom Practice Actions
            itemsAsync.maybeWhen(
              data: (items) {
                if (items.isEmpty) return const SizedBox.shrink();
                return Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    border: Border(top: BorderSide(color: AppColors.divider)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadius.md),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            context.push(
                              AppRoutes.practiceStudy(
                                kind,
                                sourceId,
                                StudyMode.flashcard,
                                chapters: effectiveChapters.isEmpty
                                    ? null
                                    : effectiveChapters,
                                onlyWeak: true,
                              ),
                            );
                          },
                          icon: const Icon(Icons.style_rounded, size: 18),
                          label: Text(
                            'Flashcard (${items.length})',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadius.md),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            context.push(
                              AppRoutes.practiceStudy(
                                kind,
                                sourceId,
                                StudyMode.quick,
                                chapters: effectiveChapters.isEmpty
                                    ? null
                                    : effectiveChapters,
                                onlyWeak: true,
                              ),
                            );
                          },
                          icon: const Icon(Icons.quiz_rounded, size: 18),
                          label: Text(
                            'Quiz (${items.length})',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              orElse: () => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
