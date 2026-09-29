import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_janpanese/core/constants/app_spacing.dart';
import 'package:practice_janpanese/core/constants/app_strings.dart';
import 'package:practice_janpanese/core/widgets/async_value_view.dart';
import 'package:practice_janpanese/features/library/domain/content_kind.dart';
import 'package:practice_janpanese/features/library/domain/study_item.dart';
import 'package:practice_janpanese/features/library/presentation/providers/library_providers.dart';
import 'package:practice_janpanese/features/library/presentation/widgets/study_item_card.dart';

/// Screen displaying the full list of study items for a unit in List mode.
class UnitListModeScreen extends ConsumerWidget {
  const UnitListModeScreen({
    super.key,
    required this.kind,
    required this.sourceId,
    required this.unitId,
  });

  final ContentKind kind;
  final int sourceId;
  final int unitId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unitAsync = ref.watch(unitProvider(unitId));
    final itemsAsync =
        ref.watch(unitItemsProvider((unitId: unitId, kind: kind)));

    final unitTitle = unitAsync.maybeWhen(
      data: (unit) => unit?.name ?? kind.label,
      orElse: () => kind.label,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(unitTitle),
      ),
      body: AsyncValueView<List<StudyItem>>(
        value: itemsAsync,
        isEmpty: (items) => items.isEmpty,
        emptyMessage: AppStrings.itemsCount(0),
        data: (items) => ListView.separated(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenH,
            vertical: AppSpacing.screenV,
          ),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (context, index) => StudyItemCard(
            item: items[index],
            index: index + 1,
          ),
        ),
      ),
    );
  }
}
