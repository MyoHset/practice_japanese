import 'package:flutter/material.dart';
import 'package:practice_janpanese/core/constants/app_sizes.dart';
import 'package:practice_janpanese/core/theme/app_colors.dart';

/// Thin horizontal progress bar using design-system tokens.
class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    super.key,
    required this.value,
    this.color,
  });

  /// 0.0 → 1.0
  final double value;
  final Color? color;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.progressBarHeight / 2),
        child: LinearProgressIndicator(
          value: value.clamp(0.0, 1.0),
          minHeight: AppSizes.progressBarHeight,
          color: color ?? AppColors.secondary,
          backgroundColor: AppColors.divider,
        ),
      );
}
