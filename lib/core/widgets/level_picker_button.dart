import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_janpanese/core/constants/app_spacing.dart';
import 'package:practice_janpanese/core/constants/app_strings.dart';
import 'package:practice_janpanese/core/providers/core_providers.dart';
import 'package:practice_janpanese/core/theme/app_colors.dart';

/// App-bar action button to change the global JLPT level.
/// Shows current level, opens a popup menu with all 5 levels.
class LevelPickerButton extends ConsumerWidget {
  const LevelPickerButton({super.key});

  static const List<String> _levels = ['N5', 'N4', 'N3', 'N2', 'N1'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedLevelProvider);
    return PopupMenuButton<String>(
      tooltip: AppStrings.changeLevel,
      onSelected: (level) =>
          ref.read(selectedLevelProvider.notifier).select(level),
      itemBuilder: (_) => _levels
          .map(
            (lvl) => PopupMenuItem<String>(
              value: lvl,
              child: _LevelMenuItem(
                level: lvl,
                isSelected: lvl == selected,
              ),
            ),
          )
          .toList(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.level(selected),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              selected,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const Icon(
              Icons.arrow_drop_down_rounded,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelMenuItem extends StatelessWidget {
  const _LevelMenuItem({
    required this.level,
    required this.isSelected,
  });

  final String level;
  final bool isSelected;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: AppColors.level(level),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            AppStrings.levelLabel(level),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  color: isSelected ? AppColors.primary : AppColors.text,
                ),
          ),
          if (isSelected) ...[
            const Spacer(),
            const Icon(
              Icons.check_rounded,
              size: 16,
              color: AppColors.primary,
            ),
          ],
        ],
      );
}
