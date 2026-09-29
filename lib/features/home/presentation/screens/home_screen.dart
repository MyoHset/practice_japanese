import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_janpanese/core/constants/app_spacing.dart';
import 'package:practice_janpanese/core/constants/app_strings.dart';
import 'package:practice_janpanese/core/widgets/level_picker_button.dart';
import 'package:practice_janpanese/core/widgets/section_title.dart';
import 'package:practice_janpanese/features/home/presentation/widgets/category_grid.dart';
import 'package:practice_janpanese/features/home/presentation/widgets/home_header.dart';
import 'package:practice_janpanese/features/home/presentation/widgets/level_selector.dart';
import 'package:practice_janpanese/features/home/presentation/widgets/review_banner.dart';
import 'package:practice_janpanese/features/level/presentation/providers/selected_level_provider.dart';

/// Main home dashboard screen per B5.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLevel = ref.watch(selectedLevelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appTitle),
        actions: const [LevelPickerButton()],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenH,
          vertical: AppSpacing.screenV,
        ),
        children: [
          const HomeHeader(),
          const SizedBox(height: AppSpacing.xl),
          const SectionTitle(title: AppStrings.selectLevel),
          const SizedBox(height: AppSpacing.sm),
          const LevelSelector(),
          const SizedBox(height: AppSpacing.xl),
          const ReviewBanner(),
          const SizedBox(height: AppSpacing.xl),
          SectionTitle(title: AppStrings.levelCategories(selectedLevel)),
          const SizedBox(height: AppSpacing.sm),
          const CategoryGrid(),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
