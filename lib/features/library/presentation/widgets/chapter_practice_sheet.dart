import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:practice_janpanese/core/constants/app_radius.dart';
import 'package:practice_janpanese/core/constants/app_spacing.dart';
import 'package:practice_janpanese/core/router/app_routes.dart';
import 'package:practice_janpanese/core/theme/app_colors.dart';
import 'package:practice_janpanese/features/library/domain/content_kind.dart';
import 'package:practice_janpanese/features/library/domain/study_mode.dart';
import 'package:practice_janpanese/features/library/presentation/providers/library_providers.dart';

/// Modal bottom sheet allowing users to configure multi-chapter practice,
/// including Study Mode (Quiz/Flashcard), Target Items (All/Weak), and Random Question Limit (10, 20, 50, All).
class ChapterPracticeSheet extends ConsumerStatefulWidget {
  const ChapterPracticeSheet({
    super.key,
    required this.kind,
    required this.sourceId,
    required this.sourceName,
    required this.selectedChapters,
    required this.totalItems,
    this.initialOnlyWeak = false,
  });

  final ContentKind kind;
  final int sourceId;
  final String sourceName;
  final Set<int> selectedChapters;
  final int totalItems;
  final bool initialOnlyWeak;

  /// Shows the practice configuration bottom sheet.
  static Future<void> show(
    BuildContext context, {
    required ContentKind kind,
    required int sourceId,
    required String sourceName,
    required Set<int> selectedChapters,
    required int totalItems,
    bool initialOnlyWeak = false,
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
        builder: (_) => ChapterPracticeSheet(
          kind: kind,
          sourceId: sourceId,
          sourceName: sourceName,
          selectedChapters: selectedChapters,
          totalItems: totalItems,
          initialOnlyWeak: initialOnlyWeak,
        ),
      );

  @override
  ConsumerState<ChapterPracticeSheet> createState() =>
      _ChapterPracticeSheetState();
}

class _ChapterPracticeSheetState extends ConsumerState<ChapterPracticeSheet> {
  StudyMode _selectedMode = StudyMode.quick;
  int? _selectedLimit = 20;
  bool _isRandom = true;
  late bool _onlyWeak;

  @override
  void initState() {
    super.initState();
    _onlyWeak = widget.initialOnlyWeak;
  }

  static const List<({int? limit, String label})> _limitOptions = [
    (limit: 10, label: '၁၀ ပုဒ်'),
    (limit: 20, label: '၂၀ ပုဒ်'),
    (limit: 50, label: '၅၀ ပုဒ်'),
    (limit: null, label: 'အားလုံး'),
  ];

  void _onStart() {
    Navigator.of(context).pop();

    final sortedChapters = widget.selectedChapters.isEmpty
        ? null
        : (widget.selectedChapters.toList()..sort());

    context.push(
      AppRoutes.practiceStudy(
        widget.kind,
        widget.sourceId,
        _selectedMode,
        chapters: sortedChapters,
        limit: _selectedLimit,
        isRandom: _isRandom,
        onlyWeak: _onlyWeak,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sortedChapters = widget.selectedChapters.isEmpty
        ? null
        : (widget.selectedChapters.toList()..sort());

    final weakCountAsync = ref.watch(
      weakItemsCountProvider(
        WeakItemsCountParams(
          sourceId: widget.sourceId,
          kind: widget.kind,
          chapterNumbers: sortedChapters,
        ),
      ),
    );
    final weakCount = weakCountAsync.valueOrNull ?? 0;

    final chapterDescription = widget.selectedChapters.isEmpty
        ? 'အခန်းအားလုံး (All Chapters)'
        : (widget.selectedChapters.length == 1
            ? 'Chapter ${widget.selectedChapters.first}'
            : 'Chapters: ${widget.selectedChapters.toList()..sort()}');

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'လေ့ကျင့်မှု ရွေးချယ်ရန်',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '$chapterDescription · စုစုပေါင်း ${widget.totalItems} ခု',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSoft,
                        ),
                  ),
                ),
              ],
            ),
            if (weakCount > 0 || widget.initialOnlyWeak) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                'လေ့ကျင့်မည့် အပိုင်း',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSoft,
                    ),
              ),
              const SizedBox(height: AppSpacing.xs),
              SegmentedButton<bool>(
                segments: [
                  ButtonSegment<bool>(
                    value: false,
                    label: Text(
                      'အားလုံး (${widget.totalItems})',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    icon: const Icon(Icons.apps_rounded, size: 16),
                  ),
                  ButtonSegment<bool>(
                    value: true,
                    label: Text(
                      'မေ့လွယ်/မှားလေ့ရှိ ($weakCount)',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    icon: const Icon(Icons.warning_amber_rounded, size: 16),
                  ),
                ],
                selected: {_onlyWeak},
                onSelectionChanged: (set) {
                  setState(() => _onlyWeak = set.first);
                },
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            Text(
              'လေ့ကျင့်မည့် ပုံစံ',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSoft,
                  ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: _ModeOptionCard(
                    title: 'Quick Quiz',
                    subtitle: '၄ ခုရွေး အမေးအဖြေ',
                    icon: Icons.quiz_outlined,
                    isSelected: _selectedMode == StudyMode.quick,
                    onTap: () =>
                        setState(() => _selectedMode = StudyMode.quick),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _ModeOptionCard(
                    title: 'Flashcard',
                    subtitle: 'ကတ်လှန်၍ လေ့ကျင့်မည်',
                    icon: Icons.style_outlined,
                    isSelected: _selectedMode == StudyMode.flashcard,
                    onTap: () =>
                        setState(() => _selectedMode = StudyMode.flashcard),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'မေးခွန်း အရေအတွက်',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSoft,
                      ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Random',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _isRandom
                                ? AppColors.primary
                                : AppColors.textSoft,
                            fontWeight:
                                _isRandom ? FontWeight.w700 : FontWeight.w500,
                          ),
                    ),
                    Switch(
                      value: _isRandom,
                      onChanged: (v) => setState(() => _isRandom = v),
                      activeThumbColor: AppColors.primary,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: _limitOptions.map((opt) {
                final isSelected = _selectedLimit == opt.limit;
                return ChoiceChip(
                  label: Text(opt.label),
                  selected: isSelected,
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.text,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                  onSelected: (_) {
                    setState(() => _selectedLimit = opt.limit);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.icon(
                onPressed: _onStart,
                style: FilledButton.styleFrom(
                  backgroundColor:
                      _onlyWeak ? Colors.deepOrange : AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
                icon: Icon(
                  _onlyWeak
                      ? Icons.warning_amber_rounded
                      : Icons.play_arrow_rounded,
                ),
                label: Text(
                  _onlyWeak
                      ? (_selectedLimit != null
                          ? 'မေ့လွယ်သောစာလုံး ${_isRandom ? "Random " : ""}$_selectedLimit ပုဒ်'
                          : 'မေ့လွယ်သောစာလုံးများ စတင်လေ့ကျင့်မည်')
                      : (_selectedLimit != null
                          ? '${_isRandom ? "Random " : "စဉ်တိုင်း "}$_selectedLimit ပုဒ် စတင်ဖြေဆိုမည်'
                          : 'အားလုံး စတင်ဖြေဆိုမည်'),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}

class _ModeOptionCard extends StatelessWidget {
  const _ModeOptionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.08)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textSoft,
              size: 24,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: isSelected ? AppColors.primary : AppColors.text,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                color: AppColors.textSoft,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
