import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:practice_janpanese/core/constants/app_spacing.dart';
import 'package:practice_janpanese/core/constants/app_strings.dart';
import 'package:practice_janpanese/core/router/app_routes.dart';
import 'package:practice_janpanese/core/widgets/async_value_view.dart';
import 'package:practice_janpanese/core/widgets/level_picker_button.dart';
import 'package:practice_janpanese/features/library/domain/content_kind.dart';
import 'package:practice_janpanese/features/library/presentation/providers/library_providers.dart';
import 'package:practice_janpanese/features/library/presentation/widgets/source_tile.dart';

/// Screen listing study sources for a specific [ContentKind],
/// filtered by the active JLPT level.
class SourceListScreen extends ConsumerWidget {
  const SourceListScreen({
    super.key,
    required this.kind,
  });

  final ContentKind kind;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sourcesAsync = ref.watch(sourceListProvider(kind));

    return Scaffold(
      appBar: AppBar(
        title: Text(kind.label),
        actions: const [LevelPickerButton()],
      ),
      body: AsyncValueView(
        value: sourcesAsync,
        isEmpty: (sources) => sources.isEmpty,
        emptyMessage: AppStrings.sourcesEmpty,
        data: (sources) => ListView.separated(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenH,
            vertical: AppSpacing.screenV,
          ),
          itemCount: sources.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (context, index) {
            final source = sources[index];
            return SourceTile(
              source: source,
              onTap: () => context.push(AppRoutes.unitList(kind, source.id)),
            );
          },
        ),
      ),
    );
  }
}
