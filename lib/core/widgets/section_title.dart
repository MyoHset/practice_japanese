import 'package:flutter/material.dart';
import 'package:practice_janpanese/core/theme/app_colors.dart';

/// Section heading used above groups of items.
class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.text,
            ),
      );
}
