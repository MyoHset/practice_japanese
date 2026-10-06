import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:practice_janpanese/core/constants/app_radius.dart';
import 'package:practice_janpanese/core/constants/app_spacing.dart';
import 'package:practice_janpanese/core/constants/app_strings.dart';
import 'package:practice_janpanese/core/database/app_database.dart';
import 'package:practice_janpanese/core/router/app_routes.dart';
import 'package:practice_janpanese/core/theme/app_colors.dart';
import 'package:practice_janpanese/core/widgets/app_card.dart';
import 'package:practice_janpanese/core/widgets/app_pill.dart';
import 'package:practice_janpanese/core/widgets/async_value_view.dart';
import 'package:practice_janpanese/core/widgets/level_chip.dart';
import 'package:practice_janpanese/core/widgets/level_picker_button.dart';
import 'package:practice_janpanese/core/extensions/build_context_x.dart';
import 'package:practice_janpanese/features/level/presentation/providers/selected_level_provider.dart';
import 'package:practice_janpanese/features/past_exam/domain/past_exam_filter.dart';
import 'package:practice_janpanese/features/past_exam/domain/past_exam_question.dart';
import 'package:practice_janpanese/features/past_exam/presentation/providers/past_exam_providers.dart';

/// Screen listing JLPT Past Exams for the active level.
class PastExamListScreen extends ConsumerWidget {
  const PastExamListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeLevel = ref.watch(selectedLevelProvider);
    final examsAsync = ref.watch(filteredPastExamsProvider);
    final filter = ref.watch(pastExamFilterProvider);

    return Scaffold(
      endDrawer: context.isMobile
          ? null
          : Drawer(
              width: MediaQuery.sizeOf(context).width * 0.4,
              backgroundColor: Theme.of(context).colorScheme.surface,
              child: SafeArea(
                child: Builder(
                  builder: (drawerContext) => _FilterPanel(
                    ref: ref,
                    onClose: () {
                      Navigator.of(drawerContext).pop();
                    },
                  ),
                ),
              ),
            ),
      appBar: AppBar(
        title: const Text('Past Exam (真題)'),
        actions: [
          // Filter button with badge
          Stack(
            alignment: Alignment.center,
            children: [
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.tune_rounded),
                  tooltip: 'Filter',
                  onPressed: () {
                    if (context.isMobile) {
                      _showFilterSheet(context, ref);
                    } else {
                      Scaffold.of(context).openEndDrawer();
                    }
                  },
                ),
              ),
              if (filter.hasAnyFilter)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 16,
                    height: 16,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${filter.totalActiveFilters}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const LevelPickerButton(),
        ],
      ),
      body: AsyncValueView(
        value: examsAsync,
        isEmpty: (exams) => exams.isEmpty,
        emptyMessage: filter.hasAnyFilter
            ? 'ရွေးချယ်ထားသော Filter နှင့် မကိုက်ညီသော စာမေးပွဲ မရှိပါ။'
            : '$activeLevel အတွက် Past Exam မေးခွန်းများ မရှိသေးပါ။',
        data: (exams) => ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenH,
            vertical: AppSpacing.screenV,
          ),
          children: [
            _buildHeaderBanner(context, activeLevel, filter, ref),
            const SizedBox(height: AppSpacing.lg),
            ...exams.map(
              (source) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                child: _PastExamCard(
                  source: source,
                  mondaiTypeFilter: filter.selectedMondaiTypes,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _FilterBottomSheet(ref: ref),
    );
  }

  Widget _buildHeaderBanner(
    BuildContext context,
    String level,
    PastExamFilter filter,
    WidgetRef ref,
  ) {
    final filteredCountAsync = ref.watch(filteredQuestionsCountProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.level(level).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: AppColors.level(level).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.level(level).withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.quiz_outlined,
                  color: AppColors.level(level),
                  size: 28,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$level စာမေးပွဲ မေးခွန်းဟောင်းများ',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      filter.hasAnyFilter
                          ? 'ရွေးချယ်ထားသော Filter ဖြင့် လေ့ကျင့်နိုင်ပါသည်'
                          : 'JLPT အစစ်အမှန် မေးခွန်းများကို ရှင်းလင်းချက် အပြည့်အစုံဖြင့် လေ့ကျင့်ပါ',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSoft,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (filter.hasAnyFilter) ...[
            const SizedBox(height: AppSpacing.md),
            const Divider(height: 1),
            const SizedBox(height: AppSpacing.sm),
            _buildActiveFilterChips(context, filter, ref),
            const SizedBox(height: AppSpacing.md),
            filteredCountAsync.when(
              data: (count) => SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () =>
                      context.push(AppRoutes.pastExamFilteredPractice),
                  icon: const Icon(Icons.play_circle_fill_rounded),
                  label: Text(
                    'ရွေးချယ်ထားသော မေးခွန်းများ စတင်ဖြေဆိုမည် ($count ပုဒ်)',
                  ),
                ),
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActiveFilterChips(
    BuildContext context,
    PastExamFilter filter,
    WidgetRef ref,
  ) {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: [
        ...filter.selectedYears.map(
          (y) => _SmallFilterChip(
            label: '$y ခုနှစ်',
            color: AppColors.primary,
            onRemove: () {
              final cur = ref.read(pastExamFilterProvider);
              ref.read(pastExamFilterProvider.notifier).state = cur.copyWith(
                selectedYears: {...cur.selectedYears}..remove(y),
              );
            },
          ),
        ),
        ...filter.selectedMondaiTypes.map(
          (t) => _SmallFilterChip(
            label: mondaiTypeShortLabel(t),
            color: mondaiTypeColor(t),
            onRemove: () {
              final cur = ref.read(pastExamFilterProvider);
              ref.read(pastExamFilterProvider.notifier).state = cur.copyWith(
                selectedMondaiTypes: {...cur.selectedMondaiTypes}..remove(t),
              );
            },
          ),
        ),
        GestureDetector(
          onTap: () => ref.read(pastExamFilterProvider.notifier).state =
              const PastExamFilter(),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(color: AppColors.error.withValues(alpha: 0.4)),
            ),
            child: const Text(
              'Clear all',
              style: TextStyle(
                color: AppColors.error,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Small removable chip ──────────────────────────────────────────────────────

class _SmallFilterChip extends StatelessWidget {
  const _SmallFilterChip({
    required this.label,
    required this.color,
    required this.onRemove,
  });

  final String label;
  final Color color;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: AppSpacing.sm,
        right: 4,
        top: 2,
        bottom: 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close_rounded, size: 14, color: color),
          ),
        ],
      ),
    );
  }
}

// ── Category specification for Question Types ─────────────────────────────────

class _MondaiSectionSpec {
  const _MondaiSectionSpec({
    required this.titleMy,
    required this.titleJp,
    required this.color,
    required this.types,
  });

  final String titleMy;
  final String titleJp;
  final Color color;
  final List<MondaiType> types;
}

const List<_MondaiSectionSpec> _mondaiSections = [
  _MondaiSectionSpec(
    titleMy: '၁။ ဝေါဟာရ (Language Knowledge: Vocabulary)',
    titleJp: '言語知識（文字・語彙）',
    color: Color(0xFF10B981),
    types: [
      MondaiType.kanjiReading,
      MondaiType.orthography,
      MondaiType.wordFormation,
      MondaiType.context,
      MondaiType.paraphrase,
      MondaiType.usage,
    ],
  ),
  _MondaiSectionSpec(
    titleMy: '၂။ သဒ္ဒါ (Language Knowledge: Grammar)',
    titleJp: '言語知識（文法）',
    color: Color(0xFF3B82F6),
    types: [
      MondaiType.grammarForm,
      MondaiType.sentenceOrder,
      MondaiType.textGrammar,
    ],
  ),
  _MondaiSectionSpec(
    titleMy: '၃။ စာဖတ်စွမ်းရည် (Reading Comprehension)',
    titleJp: '読解 (Reading)',
    color: Color(0xFF8B5CF6),
    types: [
      MondaiType.reading,
    ],
  ),
  _MondaiSectionSpec(
    titleMy: '၄။ နားထောင်စွမ်းရည် (Listening Comprehension)',
    titleJp: '聴解 (Listening)',
    color: Color(0xFFF59E0B),
    types: [
      MondaiType.listening,
    ],
  ),
];

// ── Filter Bottom Sheet ───────────────────────────────────────────────────────

class _FilterBottomSheet extends StatelessWidget {
  const _FilterBottomSheet({required this.ref});
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.45,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return _FilterPanel(
          ref: ref,
          scrollController: scrollController,
          onClose: () => Navigator.of(context).pop(),
        );
      },
    );
  }
}

class _FilterPanel extends ConsumerStatefulWidget {
  const _FilterPanel({
    super.key,
    required this.ref,
    this.scrollController,
    this.onClose,
  });

  final WidgetRef ref;
  final ScrollController? scrollController;
  final VoidCallback? onClose;

  @override
  ConsumerState<_FilterPanel> createState() => _FilterPanelState();
}

class _FilterPanelState extends ConsumerState<_FilterPanel> {
  late PastExamFilter _draft;

  @override
  void initState() {
    super.initState();
    _draft = ref.read(pastExamFilterProvider);
  }

  void _toggleYear(int year) {
    setState(() {
      final set = {..._draft.selectedYears};
      if (set.contains(year)) {
        set.remove(year);
      } else {
        set.add(year);
      }
      _draft = _draft.copyWith(selectedYears: set);
    });
  }

  void _toggleAllYears(List<int> availableYears) {
    setState(() {
      final allSelected = availableYears.every(_draft.selectedYears.contains);
      if (allSelected) {
        _draft = _draft.copyWith(
          selectedYears: {..._draft.selectedYears}..removeAll(availableYears),
        );
      } else {
        _draft = _draft.copyWith(
          selectedYears: {..._draft.selectedYears}..addAll(availableYears),
        );
      }
    });
  }

  void _toggleMondaiType(MondaiType type) {
    setState(() {
      final set = {..._draft.selectedMondaiTypes};
      if (set.contains(type)) {
        set.remove(type);
      } else {
        set.add(type);
      }
      _draft = _draft.copyWith(selectedMondaiTypes: set);
    });
  }

  void _toggleSectionTypes(List<MondaiType> sectionTypes) {
    setState(() {
      final allSelected =
          sectionTypes.every(_draft.selectedMondaiTypes.contains);
      if (allSelected) {
        _draft = _draft.copyWith(
          selectedMondaiTypes: {..._draft.selectedMondaiTypes}
            ..removeAll(sectionTypes),
        );
      } else {
        _draft = _draft.copyWith(
          selectedMondaiTypes: {..._draft.selectedMondaiTypes}
            ..addAll(sectionTypes),
        );
      }
    });
  }

  void _apply() {
    ref.read(pastExamFilterProvider.notifier).state = _draft;
    widget.onClose?.call();
  }

  void _startPracticeNow() {
    ref.read(pastExamFilterProvider.notifier).state = _draft;
    final router = GoRouter.of(context);
    widget.onClose?.call();
    router.push(AppRoutes.pastExamFilteredPractice);
  }

  void _clearAll() {
    setState(() => _draft = const PastExamFilter());
  }

  @override
  Widget build(BuildContext context) {
    final yearsAsync = ref.watch(pastExamAvailableYearsProvider);
    final mondaiAsync = ref.watch(pastExamAvailableMondaiTypesProvider);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xl),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Header row
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenH,
              vertical: AppSpacing.xs,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.tune_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Filter မေးခွန်းများ',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (_draft.hasAnyFilter) ...[
                  const SizedBox(width: AppSpacing.xs),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      '${_draft.totalActiveFilters}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                if (_draft.hasAnyFilter)
                  TextButton(
                    onPressed: _clearAll,
                    child: const Text(
                      'Clear All',
                      style: TextStyle(
                        color: AppColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Scrollable content
          Expanded(
            child: ListView(
              controller: widget.scrollController,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenH,
                vertical: AppSpacing.md,
              ),
              children: [
                // ── 1. Year filter ───────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSectionHeader(
                      context,
                      icon: Icons.calendar_month_rounded,
                      label: 'စာမေးပွဲ နှစ် (Exam Year)',
                      count: _draft.selectedYears.length,
                    ),
                    yearsAsync.when(
                      data: (years) {
                        if (years.isEmpty) return const SizedBox.shrink();
                        final allSelected =
                            years.every(_draft.selectedYears.contains);
                        return TextButton(
                          onPressed: () => _toggleAllYears(years),
                          style: TextButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            allSelected ? 'အားလုံးပယ်' : 'အားလုံးရွေး',
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                yearsAsync.when(
                  data: (years) => years.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(AppSpacing.md),
                          child: Text(
                            'နှစ်အချက်အလက် မရှိသေးပါ',
                            style: TextStyle(color: AppColors.textSoft),
                          ),
                        )
                      : Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children: years.map((year) {
                            final selected =
                                _draft.selectedYears.contains(year);
                            return _buildToggleChip(
                              label: '$year',
                              selected: selected,
                              color: AppColors.primary,
                              onTap: () => _toggleYear(year),
                            );
                          }).toList(),
                        ),
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.md),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                const SizedBox(height: AppSpacing.lg),
                const Divider(height: 1),
                const SizedBox(height: AppSpacing.md),

                // ── 2. Mondai Types (Grouped by Category) ────────────────
                _buildSectionHeader(
                  context,
                  icon: Icons.category_rounded,
                  label: 'မေးခွန်း အမျိုးအစားများ (Question Types)',
                  count: _draft.selectedMondaiTypes.length,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'လိုချင်သော မေးခွန်း အမျိုးအစား (Mondai Type) များကို ရွေးချယ်ပါ:',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSoft,
                      ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Mondai Types (Grouped by Category)
                Builder(
                  builder: (context) {
                    final effectiveTypes =
                        mondaiAsync.valueOrNull?.toSet() ?? {};
                    final availableSet = effectiveTypes.isNotEmpty
                        ? effectiveTypes
                        : MondaiType.values.toSet();

                    return Column(
                      children: _mondaiSections.map((section) {
                        final sectionTypes =
                            section.types.where(availableSet.contains).toList();
                        if (sectionTypes.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        final allSelected = sectionTypes
                            .every(_draft.selectedMondaiTypes.contains);
                        final selectedCount = sectionTypes
                            .where(_draft.selectedMondaiTypes.contains)
                            .length;

                        return Container(
                          margin: const EdgeInsets.only(bottom: AppSpacing.md),
                          decoration: BoxDecoration(
                            color: section.color.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(AppRadius.card),
                            border: Border.all(
                              color: selectedCount > 0
                                  ? section.color.withValues(alpha: 0.4)
                                  : AppColors.divider,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Category title row
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                  vertical: AppSpacing.sm,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: section.color,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.sm),
                                    Expanded(
                                      child: Text(
                                        section.titleMy,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: section.color,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          _toggleSectionTypes(sectionTypes),
                                      style: TextButton.styleFrom(
                                        visualDensity: VisualDensity.compact,
                                        padding: EdgeInsets.zero,
                                      ),
                                      child: Text(
                                        allSelected
                                            ? 'အားလုံးပယ်'
                                            : 'အားလုံးရွေး',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: section.color,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(height: 1),
                              // Types list
                              Padding(
                                padding: const EdgeInsets.all(AppSpacing.sm),
                                child: Column(
                                  children: sectionTypes.map((type) {
                                    final selected = _draft.selectedMondaiTypes
                                        .contains(type);
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: AppSpacing.xs,
                                      ),
                                      child: InkWell(
                                        onTap: () => _toggleMondaiType(type),
                                        borderRadius: BorderRadius.circular(
                                          AppRadius.card,
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: AppSpacing.sm + 2,
                                            vertical: AppSpacing.xs + 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: selected
                                                ? section.color
                                                    .withValues(alpha: 0.12)
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.circular(
                                              AppRadius.card,
                                            ),
                                            border: Border.all(
                                              color: selected
                                                  ? section.color
                                                  : Colors.transparent,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                selected
                                                    ? Icons.check_box_rounded
                                                    : Icons
                                                        .check_box_outline_blank_rounded,
                                                size: 18,
                                                color: selected
                                                    ? section.color
                                                    : AppColors.textSoft,
                                              ),
                                              const SizedBox(
                                                width: AppSpacing.sm,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      mondaiTypeLabel(type),
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight: selected
                                                            ? FontWeight.bold
                                                            : FontWeight.w600,
                                                        color: selected
                                                            ? section.color
                                                            : AppColors.text,
                                                      ),
                                                    ),
                                                    Text(
                                                      mondaiTypeBurmeseDescription(
                                                        type,
                                                      ),
                                                      style: const TextStyle(
                                                        fontSize: 11,
                                                        color:
                                                            AppColors.textSoft,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
          // Footer Action buttons with live question count
          SafeArea(
            child: FutureBuilder<int>(
              future:
                  ref.read(pastExamRepositoryProvider).countFilteredQuestions(
                        level: ref.read(selectedLevelProvider),
                        filter: _draft,
                      ),
              builder: (context, snapshot) {
                final count = snapshot.data;
                final hasCount = count != null;
                final countStr = hasCount ? '$count ပုဒ်' : '...';

                return Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenH,
                    AppSpacing.xs,
                    AppSpacing.screenH,
                    AppSpacing.md,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Total count summary banner
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.xs + 2,
                        ),
                        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(AppRadius.card),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.format_list_numbered_rounded,
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: AppSpacing.xs),
                                Text(
                                  _draft.hasAnyFilter
                                      ? 'ရွေးချယ်ထားသော မေးခွန်း စုစုပေါင်း:'
                                      : 'စာမေးပွဲ မေးခွန်း စုစုပေါင်း:',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              countStr,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _apply,
                              child: const Text('Cancel'),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            flex: 2,
                            child: FilledButton.icon(
                              onPressed: (hasCount && count == 0)
                                  ? null
                                  : _startPracticeNow,
                              icon: const Icon(Icons.play_arrow_rounded),
                              label: Text(
                                _draft.hasAnyFilter
                                    ? 'တိုက်ရိုက်ဖြေဆိုမည်'
                                    : 'အားလုံး ဖြေဆိုမည်',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required IconData icon,
    required String label,
    int count = 0,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        if (count > 0) ...[
          const SizedBox(width: AppSpacing.xs),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildToggleChip({
    required String label,
    required bool selected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs + 2,
        ),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: selected ? color : AppColors.divider,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected) ...[
              Icon(Icons.check_rounded, size: 14, color: color),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                color: selected ? color : AppColors.text,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Past Exam Card
// ═══════════════════════════════════════════════════════════════════════════════

class _PastExamCard extends ConsumerStatefulWidget {
  const _PastExamCard({
    required this.source,
    required this.mondaiTypeFilter,
  });

  final Source source;
  final Set<MondaiType> mondaiTypeFilter;

  @override
  ConsumerState<_PastExamCard> createState() => _PastExamCardState();
}

class _PastExamCardState extends ConsumerState<_PastExamCard> {
  bool _isTypesExpanded = false;

  @override
  Widget build(BuildContext context) {
    final summaryAsync = ref.watch(pastExamSummaryProvider(widget.source.id));
    final stripeColor = AppColors.level(widget.source.jlptLevel);

    return AppCard(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 6, color: stripeColor),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: summaryAsync.when(
                    data: (summary) => _buildCardContent(context, summary),
                    loading: () => const Padding(
                      padding: EdgeInsets.all(AppSpacing.xl),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (_, __) => _buildCardBasic(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardBasic(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.source.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppSpacing.sm),
        LevelChip(level: widget.source.jlptLevel ?? AppStrings.allLevels),
        const SizedBox(height: AppSpacing.md),
        FilledButton.icon(
          onPressed: () =>
              context.push(AppRoutes.pastExamPractice(widget.source.id)),
          icon: const Icon(Icons.play_arrow_rounded),
          label: const Text('စတင်ဖြေဆိုမည်'),
        ),
      ],
    );
  }

  Widget _buildCardContent(BuildContext context, PastExamSummary? summary) {
    final totalQ = summary?.totalQuestions ?? 0;
    final vocabCount = summary?.subjectCounts[Subject.vocab] ?? 0;
    final grammarCount = summary?.subjectCounts[Subject.grammar] ?? 0;
    final readingCount = summary?.subjectCounts[Subject.reading] ?? 0;
    final listeningCount = summary?.subjectCounts[Subject.listening] ?? 0;

    // Filter matching count in this exam
    final hasMondaiFilter = widget.mondaiTypeFilter.isNotEmpty;
    final filteredCount = hasMondaiFilter
        ? widget.mondaiTypeFilter.fold<int>(
            0,
            (sum, t) => sum + (summary?.mondaiTypeCounts[t] ?? 0),
          )
        : totalQ;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.source.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            AppPill(
              label: hasMondaiFilter
                  ? '$filteredCount / $totalQ Qs'
                  : '$totalQ Questions',
              color: AppColors.level(widget.source.jlptLevel),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            LevelChip(level: widget.source.jlptLevel ?? AppStrings.allLevels),
            const SizedBox(width: AppSpacing.sm),
            if (widget.source.examYear != null)
              Text(
                '${widget.source.examYear} ခုနှစ် ${widget.source.examMonth} လပိုင်း စာမေးပွဲ',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSoft,
                    ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        const Divider(height: 1),
        const SizedBox(height: AppSpacing.sm),

        // Section Breakdown Chips
        Text(
          'အပိုင်းအလိုက် ဖြေဆိုရန်:',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            _buildSectionChip(
              context,
              title: '文字・語彙 ($vocabCount)',
              subject: Subject.vocab,
              color: AppColors.secondary,
            ),
            _buildSectionChip(
              context,
              title: '文法 ($grammarCount)',
              subject: Subject.grammar,
              color: AppColors.primaryLight,
            ),
            _buildSectionChip(
              context,
              title: '読解 ($readingCount)',
              subject: Subject.reading,
              color: AppColors.accent,
            ),
            _buildSectionChip(
              context,
              title: '聴解 ($listeningCount)',
              subject: Subject.listening,
              color: AppColors.error,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        // Expandable Mondai Types list
        if (summary != null && summary.mondaiTypeCounts.isNotEmpty) ...[
          InkWell(
            onTap: () => setState(() => _isTypesExpanded = !_isTypesExpanded),
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(
                    _isTypesExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'မေးခွန်း အမျိုးအစားအလိုက် (Mondai Types) ${_isTypesExpanded ? "ပိတ်မည်" : "ရွေးချယ်မည်"}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isTypesExpanded) ...[
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xs + 2,
              runSpacing: AppSpacing.xs + 2,
              children: summary.mondaiTypeCounts.entries.map((entry) {
                final type = entry.key;
                final count = entry.value;
                final isSelectedInFilter =
                    widget.mondaiTypeFilter.contains(type);
                final color = mondaiTypeColor(type);

                return InkWell(
                  onTap: () => context.push(
                    AppRoutes.pastExamPractice(
                      widget.source.id,
                      mondaiType: type,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm + 2,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: isSelectedInFilter
                          ? color.withValues(alpha: 0.2)
                          : color.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      border: Border.all(
                        color: isSelectedInFilter
                            ? color
                            : color.withValues(alpha: 0.3),
                        width: isSelectedInFilter ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isSelectedInFilter) ...[
                          Icon(Icons.check_rounded, size: 12, color: color),
                          const SizedBox(width: 3),
                        ],
                        Text(
                          '${mondaiTypeShortLabel(type)} ($count)',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelectedInFilter
                                ? FontWeight.bold
                                : FontWeight.w600,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],

        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () {
              if (hasMondaiFilter) {
                // If filter is active, practice with the global filter on this source or full session
                context.push(AppRoutes.pastExamPractice(widget.source.id));
              } else {
                context.push(AppRoutes.pastExamPractice(widget.source.id));
              }
            },
            icon: const Icon(Icons.rocket_launch_rounded),
            label: Text(
              hasMondaiFilter
                  ? 'ရွေးချယ်ထားသော မေးခွန်းများ ဖြေဆိုမည် ($filteredCount ပုဒ်)'
                  : 'စာမေးပွဲ မေးခွန်းအားလုံး ဖြေဆိုမည် ($totalQ ပုဒ်)',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionChip(
    BuildContext context, {
    required String title,
    required Subject subject,
    required Color color,
  }) {
    return InkWell(
      onTap: () => context.push(
        AppRoutes.pastExamPractice(
          widget.source.id,
          subject: subject,
        ),
      ),
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs + 2,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: AppSpacing.xs + 2),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
