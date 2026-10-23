import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_janpanese/core/constants/app_radius.dart';
import 'package:practice_janpanese/core/constants/app_spacing.dart';
import 'package:practice_janpanese/core/constants/app_strings.dart';
import 'package:practice_janpanese/core/database/app_database.dart' show Source;
import 'package:practice_janpanese/core/theme/app_colors.dart';
import 'package:practice_janpanese/core/widgets/app_card.dart';
import 'package:practice_janpanese/core/widgets/app_progress_bar.dart';
import 'package:practice_janpanese/core/widgets/async_value_view.dart';
import 'package:practice_janpanese/features/library/domain/chapter_group.dart';
import 'package:practice_janpanese/features/library/domain/content_kind.dart';
import 'package:practice_janpanese/features/library/domain/unit_progress.dart';
import 'package:practice_janpanese/features/library/presentation/providers/library_providers.dart';
import 'package:practice_janpanese/features/library/presentation/widgets/chapter_practice_sheet.dart';
import 'package:practice_janpanese/features/library/presentation/widgets/study_mode_sheet.dart';
import 'package:practice_janpanese/features/library/presentation/widgets/unit_tile.dart';
import 'package:practice_janpanese/features/library/presentation/widgets/weak_items_modal.dart';

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

  /// Builds a chapter and section organized view with a unified compact header and clean list.
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

    final singleChapterWeakCountAsync = singleSelectedChapter == null
        ? null
        : ref.watch(
            weakItemsCountProvider(
              WeakItemsCountParams(
                sourceId: activeSourceId,
                kind: activeKind,
                chapterNumbers: [singleSelectedChapter.chapterNumber],
              ),
            ),
          );
    final singleChapterWeakCount =
        singleChapterWeakCountAsync?.valueOrNull ?? 0;

    final allWeakCountAsync = _selectedChapterNumbers.isEmpty
        ? ref.watch(
            weakItemsCountProvider(
              WeakItemsCountParams(
                sourceId: activeSourceId,
                kind: activeKind,
                chapterNumbers: null,
              ),
            ),
          )
        : null;
    final allWeakCount = allWeakCountAsync?.valueOrNull ?? 0;

    final multiWeakCountAsync = _selectedChapterNumbers.length > 1
        ? ref.watch(
            weakItemsCountProvider(
              WeakItemsCountParams(
                sourceId: activeSourceId,
                kind: activeKind,
                chapterNumbers: _selectedChapterNumbers.toList()..sort(),
              ),
            ),
          )
        : null;
    final multiWeakCount = multiWeakCountAsync?.valueOrNull ?? 0;

    final effectiveWeakCount = _selectedChapterNumbers.isEmpty
        ? allWeakCount
        : (_selectedChapterNumbers.length == 1
            ? singleChapterWeakCount
            : multiWeakCount);

    final List<UnitProgress> displayedSections = _selectedChapterNumbers.isEmpty
        ? allUnits
        : chapterGroups
            .where((c) => _selectedChapterNumbers.contains(c.chapterNumber))
            .expand((c) => c.sections)
            .toList();

    // Determine scope data for the single unified summary card
    final String scopeTitle;
    final String scopeSubtitle;
    final int scopeTotal;
    final int scopeMastered;

    if (_selectedChapterNumbers.isEmpty) {
      scopeTitle = AppStrings.allChapters;
      scopeSubtitle =
          '${chapterGroups.length} Chapters · ${allUnits.length} Sections · စုစုပေါင်း $totalAcrossUnits လုံး';
      scopeTotal = totalAcrossUnits;
      scopeMastered = masteredAcrossUnits;
    } else if (_selectedChapterNumbers.length == 1 &&
        singleSelectedChapter != null) {
      scopeTitle = singleSelectedChapter.title;
      scopeSubtitle =
          '${singleSelectedChapter.sections.length} Sections · စုစုပေါင်း ${singleSelectedChapter.total} လုံး';
      scopeTotal = singleSelectedChapter.total;
      scopeMastered = singleSelectedChapter.mastered;
    } else {
      final sorted = _selectedChapterNumbers.toList()..sort();
      final matchingGroups = chapterGroups
          .where((c) => _selectedChapterNumbers.contains(c.chapterNumber));
      final matchingTotal =
          matchingGroups.fold<int>(0, (sum, c) => sum + c.total);
      final matchingMastered =
          matchingGroups.fold<int>(0, (sum, c) => sum + c.mastered);
      scopeTitle =
          'ရွေးချယ်ထားသော Chapter (${_selectedChapterNumbers.length}) ခု';
      scopeSubtitle =
          'Ch. ${sorted.join(", ")} · ${displayedSections.length} Sections · စုစုပေါင်း $matchingTotal လုံး';
      scopeTotal = matchingTotal;
      scopeMastered = matchingMastered;
    }

    final scopeRatio =
        scopeTotal == 0 ? 0.0 : (scopeMastered / scopeTotal).clamp(0.0, 1.0);
    final scopePercentage = (scopeRatio * 100).toInt();

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

        // Chapter Filter Bar (Top placement, clean pill tabs)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenH,
                  vertical: 2,
                ),
                itemCount: chapterGroups.length + 1,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: AppSpacing.xs),
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
        ),

        // Single Unified Scope Summary Card
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenH,
              AppSpacing.sm,
              AppSpacing.screenH,
              AppSpacing.xs,
            ),
            child: _buildUnifiedSummaryCard(
              context,
              title: scopeTitle,
              subtitle: scopeSubtitle,
              total: scopeTotal,
              mastered: scopeMastered,
              ratio: scopeRatio,
              percentage: scopePercentage,
              weakCount: effectiveWeakCount,
              activeKind: activeKind,
              activeSourceId: activeSourceId,
              sourceTitle: sourceTitle,
              selectedChapters: _selectedChapterNumbers,
            ),
          ),
        ),

        // Section list header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenH,
              AppSpacing.md,
              AppSpacing.screenH,
              AppSpacing.xs,
            ),
            child: Row(
              children: [
                Text(
                  _selectedChapterNumbers.length == 1
                      ? '${singleSelectedChapter?.title} — Sections'
                      : 'Sections (${displayedSections.length} ခု)',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.textSoft,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                ),
              ],
            ),
          ),
        ),

        // Clean & Compact Section List
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenH,
            vertical: AppSpacing.xs,
          ),
          sliver: SliverList.separated(
            itemCount: displayedSections.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: AppSpacing.xs + 2),
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
              );
            },
          ),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(height: 80),
        ),
      ],
    );
  }

  /// Single unified summary card for overall or chapter scope.
  Widget _buildUnifiedSummaryCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required int total,
    required int mastered,
    required double ratio,
    required int percentage,
    required int weakCount,
    required ContentKind activeKind,
    required int activeSourceId,
    required String sourceTitle,
    required Set<int> selectedChapters,
  }) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSoft,
                            fontSize: 11.5,
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  '$mastered / $total  ($percentage%)',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // Progress Bar
          AppProgressBar(
            value: ratio,
            color: AppColors.secondary,
            height: 4.5,
          ),

          // Weak Items Banner (if any)
          if (weakCount > 0) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E7),
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(color: const Color(0xFFFFE082)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Color(0xFFB78103),
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'မေ့လွယ်သော စကားလုံး ($weakCount ခု)',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF7A5400),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      WeakItemsModal.show(
                        context,
                        kind: activeKind,
                        sourceId: activeSourceId,
                        sourceName: sourceTitle,
                        chapterNumbers: selectedChapters.isEmpty
                            ? null
                            : selectedChapters.toList(),
                      );
                    },
                    borderRadius: BorderRadius.circular(4),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      child: Text(
                        'စာရင်း',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFB78103),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () {
                      ChapterPracticeSheet.show(
                        context,
                        kind: activeKind,
                        sourceId: activeSourceId,
                        sourceName: sourceTitle,
                        selectedChapters: selectedChapters,
                        totalItems: total,
                        initialOnlyWeak: true,
                      );
                    },
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB78103),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: const Text(
                        'လေ့ကျင့်မည်',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: AppSpacing.sm),

          // Quick Actions (Flashcard & Quick Quiz) - Sleek & Compact
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 36,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
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
                        totalItems: total,
                      );
                    },
                    icon: const Icon(Icons.style_rounded, size: 16),
                    label: const Text(
                      AppStrings.modeFlashcard,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: SizedBox(
                  height: 36,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.accent,
                      side: const BorderSide(color: AppColors.accent),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
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
                        totalItems: total,
                      );
                    },
                    icon: const Icon(Icons.quiz_rounded, size: 16),
                    label: const Text(
                      AppStrings.modeQuick,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
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
          vertical: 6,
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
                const Icon(Icons.check, size: 13, color: Colors.white),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.text,
                  fontSize: 12.5,
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
    final ratio = totalAcrossUnits == 0
        ? 0.0
        : (masteredAcrossUnits / totalAcrossUnits).clamp(0.0, 1.0);
    final percentage = (ratio * 100).toInt();

    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenH,
        vertical: AppSpacing.screenV,
      ),
      itemCount: units.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs + 2),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _buildUnifiedSummaryCard(
              context,
              title: sourceTitle,
              subtitle: '${units.length} Units · စုစုပေါင်း $totalAcrossUnits ခု',
              total: totalAcrossUnits,
              mastered: masteredAcrossUnits,
              ratio: ratio,
              percentage: percentage,
              weakCount: 0,
              activeKind: activeKind,
              activeSourceId: activeSourceId,
              sourceTitle: sourceTitle,
              selectedChapters: const {},
            ),
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
        );
      },
    );
  }
}
