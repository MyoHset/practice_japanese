import 'package:flutter/material.dart';
import 'package:practice_janpanese/core/theme/app_colors.dart';

/// Single source of truth for all text styles.
/// Never write TextStyle(...) outside this file.
class AppTypography {
  /// Returns the [TextTheme] that [AppTheme] plugs into [ThemeData].
  static TextTheme get textTheme => const TextTheme(
        // Screen titles
        displayLarge: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w700,
          color: AppColors.text,
          fontFamilyFallback: ['Noto Sans Myanmar', 'Noto Sans JP'],
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.text,
          fontFamilyFallback: ['Noto Sans Myanmar', 'Noto Sans JP'],
        ),
        // List titles
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.text,
          fontFamilyFallback: ['Noto Sans Myanmar', 'Noto Sans JP'],
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.text,
          fontFamilyFallback: ['Noto Sans Myanmar', 'Noto Sans JP'],
        ),
        // Body
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.text,
          fontFamilyFallback: ['Noto Sans Myanmar', 'Noto Sans JP'],
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.text,
          fontFamilyFallback: ['Noto Sans Myanmar', 'Noto Sans JP'],
        ),
        // Hint / caption
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.textSoft,
          fontFamilyFallback: ['Noto Sans Myanmar', 'Noto Sans JP'],
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.text,
          letterSpacing: 0.1,
          fontFamilyFallback: ['Noto Sans Myanmar', 'Noto Sans JP'],
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.text,
          fontFamilyFallback: ['Noto Sans Myanmar', 'Noto Sans JP'],
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.textSoft,
          fontFamilyFallback: ['Noto Sans Myanmar', 'Noto Sans JP'],
        ),
      );
}
