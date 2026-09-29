import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_janpanese/core/constants/app_spacing.dart';
import 'package:practice_janpanese/core/constants/app_strings.dart';
import 'package:practice_janpanese/core/widgets/async_value_view.dart';
import 'package:practice_janpanese/features/library/domain/content_kind.dart';
import 'package:practice_janpanese/features/library/domain/unit_progress.dart';
import 'package:practice_janpanese/features/library/presentation/providers/library_providers.dart';
import 'package:practice_janpanese/features/library/presentation/widgets/study_mode_sheet.dart';
import 'package:practice_janpanese/features/library/presentation/widgets/unit_summary_card.dart';
import 'package:practice_janpanese/features/library/presentation/widgets/unit_tile.dart';

/// Screen listing all units for a given source along with total progress.
class UnitListScreen extends ConsumerWidget {
  const UnitListScreen({
    super.key,
    required this.kind,
    required this.sourceId,
  });

  final ContentKind kind;
  final int sourceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sourceAsync = ref.watch(sourceProvider(sourceId));
    final unitsAsync =
        ref.watch(unitListProvider((sourceId: sourceId, kind: kind)));

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
          final totalAcrossUnits =
              units.fold<int>(0, (sum, u) => sum + u.total);
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
                  kind: kind,
                  sourceId: sourceId,
                  unit: unit,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
