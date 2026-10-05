import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:practice_janpanese/core/constants/app_radius.dart';
import 'package:practice_janpanese/core/constants/app_spacing.dart';
import 'package:practice_janpanese/core/constants/app_strings.dart';
import 'package:practice_janpanese/core/database/app_database.dart' show Source;
import 'package:practice_janpanese/core/router/app_routes.dart';
import 'package:practice_janpanese/core/theme/app_colors.dart';
import 'package:practice_janpanese/core/widgets/app_card.dart';
import 'package:practice_janpanese/core/widgets/app_progress_bar.dart';
import 'package:practice_janpanese/core/widgets/async_value_view.dart';
import 'package:practice_janpanese/features/library/domain/chapter_group.dart';
import 'package:practice_janpanese/features/library/domain/content_kind.dart';
import 'package:practice_janpanese/features/library/domain/study_mode.dart';
import 'package:practice_janpanese/features/library/domain/unit_progress.dart';
import 'package:practice_janpanese/features/library/presentation/providers/library_providers.dart';
import 'package:practice_janpanese/features/library/presentation/widgets/chapter_practice_sheet.dart';
import 'package:practice_janpanese/features/library/presentation/widgets/chapter_summary_card.dart';
import 'package:practice_janpanese/features/library/presentation/widgets/study_mode_sheet.dart';
import 'package:practice_janpanese/features/library/presentation/widgets/unit_summary_card.dart';
import 'package:practice_janpanese/features/library/presentation/widgets/unit_tile.dart';

/// Screen listing all units for a given source along with Chapter/Section organization and Flashcard access.
class UnitListScreen extends ConsumerStatefulWidget {
  const UnitListScreen({
    super.key,
    required this.kind,
    required this.sourceId,
  });

  final ContentKind kind;
  final int sourceId;

  @override
  ConsumerState<UnitListScreen> createState() => _UnitListScreenState();
}

class _UnitListScreenState extends ConsumerState<UnitListScreen> {
  /// Currently selected chapter numbers. If empty, displays all chapters/units.
  Set<int> _selectedChapterNumbers = {1};

  /// Whether the user has toggled to compound words mode (語彙) for companion sources.
  bool? _isCompoundMode;

  @override
  Widget build(BuildContext context) {
    final sourceAsync = ref.watch(sourceProvider(widget.sourceId));
    final companionAsync = ref.watch(companionSourceProvider(widget.sourceId));
    final companionSource = companionAsync.valueOrNull;

    final isCompound = _isCompoundMode ?? (widget.kind == ContentKind.vocab);

    final activeKind = companionSource == null
        ? widget.kind
        : (isCompound ? ContentKind.vocab : ContentKind.kanji);

    final activeSourceId = companionSource == null
        ? widget.sourceId
        : (widget.kind == ContentKind.kanji
            ? (isCompound ? companionSource.id : widget.sourceId)
            : (isCompound ? widget.sourceId : companionSource.id));

    final unitsAsync = ref.watch(
      unitListProvider((sourceId: activeSourceId, kind: activeKind)),
    );

    final sourceTitle = sourceAsync.maybeWhen(
      data: (source) => source?.name ?? '',
      orElse: () => '',
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(sourceTitle),
      ),
      floatingActionButton: unitsAsync.maybeWhen(
        data: (units) {
          final chapterGroups = ChapterGroup.fromUnits(units);
          final totalAcrossUnits =
              units.fold<int>(0, (sum, u) => sum + u.total);
          final selectedTotal = _selectedChapterNumbers.isEmpty
              ? totalAcrossUnits
              : chapterGroups
                  .where(
                    (c) => _selectedChapterNumbers.contains(c.chapterNumber),
                  )
                  .fold<int>(0, (sum, c) => sum + c.total);

          if (totalAcrossUnits == 0) return null;

          return FloatingActionButton.extended(
            backgroundColor: AppColors.primary,
            elevation: 3,
            icon: const Icon(
              Icons.play_circle_fill_rounded,
              color: Colors.white,
            ),
            label: Text(
              _selectedChapterNumbers.isEmpty
                  ? 'အားလုံး လေ့ကျင့်မည်'
                  : 'လေ့ကျင့်မည် (${_selectedChapterNumbers.length} Ch.)',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              ChapterPracticeSheet.show(
                context,
                kind: activeKind,
                sourceId: activeSourceId,
                sourceName: sourceTitle,
                selectedChapters: _selectedChapterNumbers,
                totalItems: selectedTotal,
              );
            },
          );
        },
        orElse: () => null,
      ),
      body: AsyncValueView<List<UnitProgress>>(
        value: unitsAsync,
        isEmpty: (units) => units.isEmpty,
        emptyMessage: AppStrings.unitsEmpty,
        data: (units) {
          final chapterGroups = ChapterGroup.fromUnits(units);

          // If source has chapters (e.g. Tango 2000 or Speed Master N3), render Chapter-organized UI
          if (chapterGroups.isNotEmpty) {
            return _buildChapterOrganizedView(
              context,
              units,
              chapterGroups,
              activeKind: activeKind,
              activeSourceId: activeSourceId,
              companionSource: companionSource,
              isCompound: isCompound,
              sourceTitle: sourceTitle,
            );
          }

          // Otherwise fallback to standard flat unit list
          return _buildFlatUnitList(
            context,
            units,
            activeKind: activeKind,
            activeSourceId: activeSourceId,
            sourceTitle: sourceTitle,
          );
        },
      ),
    );
  }

  /// Builds a chapter and section organized view with filter pills and chapter flashcard buttons.
  Widget _buildChapterOrganizedView(
    BuildContext context,
    List<UnitProgress> allUnits,
    List<ChapterGroup> chapterGroups, {
    required ContentKind activeKind,
    required int activeSourceId,
    required Source? companionSource,
    required bool isCompound,
    required String sourceTitle,
  }) {
    final totalAcrossUnits = allUnits.fold<int>(0, (sum, u) => sum + u.total);
    final masteredAcrossUnits =
        allUnits.fold<int>(0, (sum, u) => sum + u.mastered);

    // Selected chapter if exactly 1 chapter is selected
    final ChapterGroup? singleSelectedChapter =
        _selectedChapterNumbers.length == 1
            ? chapterGroups.cast<ChapterGroup?>().firstWhere(
                  (c) => c?.chapterNumber == _selectedChapterNumbers.first,
                  orElse: () => chapterGroups.first,
                )
            : null;

    final List<UnitProgress> displayedSections = _selectedChapterNumbers.isEmpty
        ? allUnits
        : chapterGroups
            .where((c) => _selectedChapterNumbers.contains(c.chapterNumber))
            .expand((c) => c.sections)
            .toList();

    return CustomScrollView(
      slivers: [
        // Companion Mode Switcher (e.g. ပင်မ Kanji vs Kanji တွဲလုံးများ)
        if (companionSource != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenH,
                AppSpacing.sm,
                AppSpacing.screenH,
                AppSpacing.xs,
              ),
              child: SegmentedButton<bool>(
                segments: const [
                  ButtonSegment<bool>(
                    value: false,
                    label: Text(
                      'ပင်မ Kanji (၁၇၄)',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    icon: Icon(Icons.translate_rounded, size: 18),
                  ),
                  ButtonSegment<bool>(
                    value: true,
                    label: Text(
                      'Kanji တွဲလုံးများ (၅၆၃)',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    icon: Icon(Icons.menu_book_rounded, size: 18),
                  ),
                ],
                selected: {isCompound},
                onSelectionChanged: (set) {
                  setState(() => _isCompoundMode = set.first);
                },
              ),
            ),
          ),
        // Source Overview Summary Card
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.screenH,
              right: AppSpacing.screenH,
              top: AppSpacing.screenV,
              bottom: AppSpacing.sm,
            ),
            child: UnitSummaryCard(
              total: totalAcrossUnits,
              mastered: masteredAcrossUnits,
            ),
          ),
        ),

        // Chapter Filter Bar
        SliverToBoxAdapter(
          child: SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenH,
                vertical: AppSpacing.xs,
              ),
              itemCount: chapterGroups.length + 1,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, index) {
                if (index == 0) {
                  final isSelected = _selectedChapterNumbers.isEmpty;
                  return _buildChapterFilterChip(
                    label: AppStrings.allChapters,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() => _selectedChapterNumbers = {});
                    },
                  );
                }

                final ch = chapterGroups[index - 1];
                final isSelected =
                    _selectedChapterNumbers.contains(ch.chapterNumber);
                return _buildChapterFilterChip(
                  label: 'Ch. ${ch.chapterNumber}',
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      if (_selectedChapterNumbers.isEmpty) {
                        _selectedChapterNumbers = {ch.chapterNumber};
                      } else if (_selectedChapterNumbers
                          .contains(ch.chapterNumber)) {
                        _selectedChapterNumbers.remove(ch.chapterNumber);
                      } else {
                        _selectedChapterNumbers.add(ch.chapterNumber);
                      }
                    });
                  },
                );
              },
            ),
          ),
        ),

        // If a single chapter is selected, show ChapterSummaryCard with practice options
        if (singleSelectedChapter != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenH,
                vertical: AppSpacing.sm,
              ),
              child: ChapterSummaryCard(
                chapter: singleSelectedChapter,
                onFlashcardTap: () {
                  ChapterPracticeSheet.show(
                    context,
                    kind: activeKind,
                    sourceId: activeSourceId,
                    sourceName: sourceTitle,
                    selectedChapters: {singleSelectedChapter.chapterNumber},
                    totalItems: singleSelectedChapter.total,
                  );
                },
                onQuickQuizTap: () {
                  ChapterPracticeSheet.show(
                    context,
                    kind: activeKind,
                    sourceId: activeSourceId,
                    sourceName: sourceTitle,
                    selectedChapters: {singleSelectedChapter.chapterNumber},
                    totalItems: singleSelectedChapter.total,
                  );
                },
              ),
            ),
          ),

        // If multiple chapters are selected (> 1), show MultiChapterCard
        if (_selectedChapterNumbers.length > 1)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenH,
                vertical: AppSpacing.sm,
              ),
              child: _buildMultiChapterCard(
                context,
                selectedChapters: _selectedChapterNumbers,
                chapterGroups: chapterGroups,
                activeKind: activeKind,
                activeSourceId: activeSourceId,
                sourceTitle: sourceTitle,
              ),
            ),
          ),

        // Section list header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.screenH,
              right: AppSpacing.screenH,
              top: AppSpacing.sm,
              bottom: AppSpacing.xs,
            ),
            child: Text(
              _selectedChapterNumbers.length == 1
                  ? '${singleSelectedChapter?.title} — ${AppStrings.section}'
                  : (_selectedChapterNumbers.length > 1
                      ? 'Sections (${displayedSections.length} ခု)'
                      : '${AppStrings.chapter} & ${AppStrings.section}'),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textSoft,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ),

        // Sections
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenH,
            vertical: AppSpacing.xs,
          ),
          sliver: SliverList.separated(
            itemCount: displayedSections.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final section = displayedSections[index];
              final sectionTitle = _selectedChapterNumbers.length == 1
                  ? ChapterGroup.formatSectionName(section.name)
                  : section.name;

              return UnitTile(
                unit: section,
                displayName: sectionTitle,
                onTap: () => StudyModeSheet.show(
                  context,
                  kind: activeKind,
                  sourceId: activeSourceId,
                  unit: section,
                ),
                onFlashcardTap: () {
                  context.push(
                    AppRoutes.study(
                      activeKind,
                      activeSourceId,
                      section.id,
                      StudyMode.flashcard,
                    ),
                  );
                },
                onQuickQuizTap: () {
                  context.push(
                    AppRoutes.study(
                      activeKind,
                      activeSourceId,
                      section.id,
                      StudyMode.quick,
                    ),
                  );
                },
              );
            },
          ),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(height: AppSpacing.xxl),
        ),
      ],
    );
  }

  /// Builds summary card when multiple chapters (> 1) are selected.
  Widget _buildMultiChapterCard(
    BuildContext context, {
    required Set<int> selectedChapters,
    required List<ChapterGroup> chapterGroups,
    required ContentKind activeKind,
    required int activeSourceId,
    required String sourceTitle,
  }) {
    final matchingGroups = chapterGroups
        .where((c) => selectedChapters.contains(c.chapterNumber))
        .toList();
    final totalItems = matchingGroups.fold<int>(0, (sum, c) => sum + c.total);
    final masteredItems =
        matchingGroups.fold<int>(0, (sum, c) => sum + c.mastered);
    final ratio =
        totalItems == 0 ? 0.0 : (masteredItems / totalItems).clamp(0.0, 1.0);
    final sortedNums = selectedChapters.toList()..sort();

    return AppCard(
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ရွေးချယ်ထားသော Chapter (${selectedChapters.length}) ခု',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Ch. ${sortedNums.join(", ")} · စုစုပေါင်း $totalItems ခု',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSoft,
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withAlpha(20),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  '$masteredItems / $totalItems',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          AppProgressBar(
            value: ratio,
            color: AppColors.secondary,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                    ),
                    onPressed: () {
                      ChapterPracticeSheet.show(
                        context,
                        kind: activeKind,
                        sourceId: activeSourceId,
                        sourceName: sourceTitle,
                        selectedChapters: selectedChapters,
                        totalItems: totalItems,
                      );
                    },
                    icon: const Icon(Icons.style_rounded, size: 18),
                    label: const Text(
                      AppStrings.modeFlashcard,
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                    ),
                    onPressed: () {
                      ChapterPracticeSheet.show(
                        context,
                        kind: activeKind,
                        sourceId: activeSourceId,
                        sourceName: sourceTitle,
                        selectedChapters: selectedChapters,
                        totalItems: totalItems,
                      );
                    },
                    icon: const Icon(Icons.quiz_rounded, size: 18),
                    label: const Text(
                      AppStrings.modeQuick,
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds a filter pill chip for selecting chapters with checkmark when selected.
  Widget _buildChapterFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
          ),
          boxShadow: isSelected
              ? const [
                  BoxShadow(
                    color: Color(0x183D5A80),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSelected) ...[
                const Icon(Icons.check, size: 14, color: Colors.white),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.text,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Flat unit list for non-chaptered sources.
  Widget _buildFlatUnitList(
    BuildContext context,
    List<UnitProgress> units, {
    required ContentKind activeKind,
    required int activeSourceId,
    required String sourceTitle,
  }) {
    final totalAcrossUnits = units.fold<int>(0, (sum, u) => sum + u.total);
    final masteredAcrossUnits =
        units.fold<int>(0, (sum, u) => sum + u.mastered);

    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenH,
        vertical: AppSpacing.screenV,
      ),
      itemCount: units.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        if (index == 0) {
          return UnitSummaryCard(
            total: totalAcrossUnits,
            mastered: masteredAcrossUnits,
          );
        }
        final unit = units[index - 1];
        return UnitTile(
          unit: unit,
          onTap: () => StudyModeSheet.show(
            context,
            kind: activeKind,
            sourceId: activeSourceId,
            unit: unit,
          ),
          onFlashcardTap: () {
            context.push(
              AppRoutes.study(
                activeKind,
                activeSourceId,
                unit.id,
                StudyMode.flashcard,
              ),
            );
          },
          onQuickQuizTap: () {
            context.push(
              AppRoutes.study(
                activeKind,
                activeSourceId,
                unit.id,
                StudyMode.quick,
              ),
            );
          },
        );
      },
    );
  }
}
