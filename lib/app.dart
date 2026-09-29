import 'package:flutter/material.dart';
import 'package:practice_janpanese/core/constants/app_strings.dart';
import 'package:practice_janpanese/core/router/app_router.dart';
import 'package:practice_janpanese/core/theme/app_theme.dart';

/// Root widget. Receives a pre-built [ProviderScope] from main.
class JlptApp extends StatelessWidget {
  const JlptApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: AppStrings.appTitle,
        theme: AppTheme.light,
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
      );
}
