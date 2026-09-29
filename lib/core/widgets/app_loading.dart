import 'package:flutter/material.dart';
import 'package:practice_janpanese/core/theme/app_colors.dart';

/// Full-screen centred loading indicator.
class AppLoading extends StatelessWidget {
  const AppLoading({super.key});

  @override
  Widget build(BuildContext context) => const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      );
}
