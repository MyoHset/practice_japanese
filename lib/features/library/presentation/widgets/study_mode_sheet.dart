import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:practice_janpanese/core/constants/app_radius.dart';
import 'package:practice_janpanese/core/constants/app_sizes.dart';
import 'package:practice_janpanese/core/constants/app_spacing.dart';
import 'package:practice_janpanese/core/constants/app_strings.dart';
import 'package:practice_janpanese/core/router/app_routes.dart';
import 'package:practice_janpanese/core/theme/app_colors.dart';
import 'package:practice_janpanese/features/library/domain/content_kind.dart';
import 'package:practice_janpanese/features/library/domain/study_mode.dart';
import 'package:practice_janpanese/features/library/domain/unit_progress.dart';
import 'package:practice_janpanese/features/library/presentation/widgets/study_mode_option_tile.dart';

/// Modal bottom sheet allowing the user to pick a study mode for a unit.
/// Must only be opened via [StudyModeSheet.show] per rule A4.1.
class StudyModeSheet extends StatefulWidget {
  const StudyModeSheet({
    super.key,
    required this.kind,
    required this.sourceId,
    required this.unit,
  });

  final ContentKind kind;
  final int sourceId;
  final UnitProgress unit;

  /// Shows the study mode bottom sheet.
  static Future<void> show(
    BuildContext context, {
    required ContentKind kind,
    required int sourceId,
    required UnitProgress unit,
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
        builder: (_) => StudyModeSheet(
          kind: kind,
          sourceId: sourceId,
          unit: unit,
        ),
      );

  @override
  State<StudyModeSheet> createState() => _StudyModeSheetState();
}

class _StudyModeSheetState extends State<StudyModeSheet> {
  int? _selectedLimit = 20;
  bool _isRandom = true;

  static const List<({int? limit, String label})> _limitOptions = [
    (limit: 10, label: '၁၀ ပုဒ်'),
    (limit: 20, label: '၂၀ ပုဒ်'),
    (limit: 50, label: '၅၀ ပုဒ်'),
    (limit: null, label: 'အားလုံး'),
  ];

  void _onSelectMode(BuildContext context, StudyMode mode) {
    Navigator.of(context).pop();
    final int? passedLimit = (mode == StudyMode.list) ? null : _selectedLimit;
    context.push(AppRoutes.study(
      widget.kind,
      widget.sourceId,
      widget.unit.id,
      mode,
      limit: passedLimit,
      isRandom: _isRandom,
    ));
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: AppSizes.dragHandleWidth,
                  height: AppSizes.dragHandleHeight,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                widget.unit.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                AppStrings.itemsCount(widget.unit.total),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSoft,
                    ),
              ),
              const SizedBox(height: AppSpacing.lg),
              
              // Limit Options
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
                              color: _isRandom ? AppColors.primary : AppColors.textSoft,
                              fontWeight: _isRandom ? FontWeight.w700 : FontWeight.w500,
                            ),
                      ),
                      Switch(
                        value: _isRandom,
                        onChanged: (v) => setState(() => _isRandom = v),
                        activeColor: AppColors.primary,
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
              const SizedBox(height: AppSpacing.lg),

              StudyModeOptionTile(
                mode: StudyMode.list,
                onTap: () => _onSelectMode(context, StudyMode.list),
              ),
              const SizedBox(height: AppSpacing.sm),
              StudyModeOptionTile(
                mode: StudyMode.quick,
                onTap: () => _onSelectMode(context, StudyMode.quick),
              ),
              const SizedBox(height: AppSpacing.sm),
              StudyModeOptionTile(
                mode: StudyMode.flashcard,
                onTap: () => _onSelectMode(context, StudyMode.flashcard),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      );
}
