import 'package:flutter/material.dart';
import 'package:practice_janpanese/core/constants/app_sizes.dart';
import 'package:practice_janpanese/core/theme/app_colors.dart';

/// Thin horizontal progress bar using design-system tokens.
class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    super.key,
    required this.value,
    this.color,
    this.height,
  });

  /// 0.0 → 1.0
  final double value;
  final Color? color;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = height ?? AppSizes.progressBarHeight;
    return ClipRRect(
      borderRadius: BorderRadius.circular(effectiveHeight / 2),
      child: LinearProgressIndicator(
        value: value.clamp(0.0, 1.0),
        minHeight: effectiveHeight,
        color: color ?? AppColors.secondary,
        backgroundColor: AppColors.divider,
      ),
    );
  }
}
