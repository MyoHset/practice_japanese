import 'package:flutter/material.dart';
import 'package:practice_janpanese/core/theme/app_colors.dart';

/// Extension on [BuildContext] providing typed access to theme tokens.
/// Usage in widgets: context.colors.primary, context.text.titleMedium
extension BuildContextX on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get text => Theme.of(this).textTheme;

  /// The spec's AppColors.background colour — always warm off-white.
  Color get background => AppColors.background;

  bool get isMobile => MediaQuery.sizeOf(this).width < 600;
}
