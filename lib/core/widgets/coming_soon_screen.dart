import 'package:flutter/material.dart';
import 'package:practice_janpanese/core/constants/app_spacing.dart';
import 'package:practice_janpanese/core/constants/app_strings.dart';
import 'package:practice_janpanese/core/theme/app_colors.dart';

/// Placeholder screen for features and modes not yet implemented.
class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({
    super.key,
    this.title,
    this.message,
  });

  final String? title;
  final String? message;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(title ?? AppStrings.comingSoon),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.construction_rounded,
                size: 64,
                color: AppColors.accent,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                title ?? AppStrings.comingSoon,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                message ?? AppStrings.comingSoonSubtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSoft,
                    ),
              ),
            ],
          ),
        ),
      );
}
