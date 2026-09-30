import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:practice_janpanese/core/constants/app_radius.dart';
import 'package:practice_janpanese/core/constants/app_spacing.dart';
import 'package:practice_janpanese/core/constants/app_strings.dart';
import 'package:practice_janpanese/core/database/app_database.dart' show Source;
import 'package:practice_janpanese/core/router/app_routes.dart';
import 'package:practice_janpanese/core/theme/app_colors.dart';
import 'package:practice_janpanese/core/widgets/async_value_view.dart';
import 'package:practice_janpanese/features/library/domain/chapter_group.dart';
import 'package:practice_janpanese/features/library/domain/content_kind.dart';
import 'package:practice_janpanese/features/library/domain/study_mode.dart';
import 'package:practice_janpanese/features/library/domain/unit_progress.dart';
import 'package:practice_janpanese/features/library/presentation/providers/library_providers.dart';
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
  /// Currently selected chapter number. If null, displays all chapters/units.
  int? _selectedChapterNumber = 1;

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
            );
          }

          // Otherwise fallback to standard flat unit list
          return _buildFlatUnitList(
            context,
            units,
            activeKind: activeKind,
            activeSourceId: activeSourceId,
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
  }) {
    final totalAcrossUnits = allUnits.fold<int>(0, (sum, u) => sum + u.total);
    final masteredAcrossUnits =
        allUnits.fold<int>(0, (sum, u) => sum + u.mastered);

    // Selected chapter if any
    final ChapterGroup? selectedChapter = _selectedChapterNumber == null
        ? null
        : chapterGroups.cast<ChapterGroup?>().firstWhere(
              (c) => c?.chapterNumber == _selectedChapterNumber,
              orElse: () => chapterGroups.first,
            );

    final displayedSections = selectedChapter != null
        ? selectedChapter.sections
        : allUnits;

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
                  final isSelected = _selectedChapterNumber == null;
                  return _buildChapterFilterChip(
                    label: AppStrings.allChapters,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() => _selectedChapterNumber = null);
                    },
                  );
                }

                final ch = chapterGroups[index - 1];
                final isSelected = _selectedChapterNumber == ch.chapterNumber;
                return _buildChapterFilterChip(
                  label: 'Ch. ${ch.chapterNumber}',
                  isSelected: isSelected,
                  onTap: () {
                    setState(() => _selectedChapterNumber = ch.chapterNumber);
                  },
                );
              },
            ),
          ),
        ),

        // If a specific Chapter is selected, show ChapterSummaryCard
        if (selectedChapter != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenH,
                vertical: AppSpacing.sm,
              ),
              child: ChapterSummaryCard(
                chapter: selectedChapter,
                onFlashcardTap: () {
                  context.push(
                    AppRoutes.chapterStudy(
                      activeKind,
                      activeSourceId,
                      selectedChapter.chapterNumber,
                      StudyMode.flashcard,
                    ),
                  );
                },
                onQuickQuizTap: () {
                  context.push(
                    AppRoutes.chapterStudy(
                      activeKind,
                      activeSourceId,
                      selectedChapter.chapterNumber,
                      StudyMode.quick,
                    ),
                  );
                },
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
              selectedChapter != null
                  ? '${selectedChapter.title} — ${AppStrings.section}'
                  : '${AppStrings.chapter} & ${AppStrings.section}',
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
              final sectionTitle = selectedChapter != null
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
          child: SizedBox(height: AppSpacing.xl),
        ),
      ],
    );
  }

  /// Builds a filter pill chip for selecting chapters.
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
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.text,
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
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
