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
class StudyModeSheet extends StatelessWidget {
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

  void _onSelectMode(BuildContext context, StudyMode mode) {
    Navigator.of(context).pop();
    context.push(AppRoutes.study(kind, sourceId, unit.id, mode));
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
                unit.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                AppStrings.itemsCount(unit.total),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSoft,
                    ),
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
