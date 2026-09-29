import 'package:flutter/material.dart';
import 'package:practice_janpanese/core/constants/app_spacing.dart';
import 'package:practice_janpanese/core/theme/app_colors.dart';

/// Full-screen empty state with optional message.
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.message,
    this.icon,
  });

  final String message;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon ?? Icons.inbox_outlined,
                size: 56,
                color: AppColors.divider,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                message,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.textSoft),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
}
