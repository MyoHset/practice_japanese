import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_janpanese/app.dart';
import 'package:practice_janpanese/core/database/app_database.dart';
import 'package:practice_janpanese/core/database/dev_seed.dart';
import 'package:practice_janpanese/core/providers/core_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Application entry point: initializes bindings, preferences, database,
/// executes debug seed if needed, and starts the app with overridden providers.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final db = AppDatabase();

  if (kDebugMode) {
    await seedDevData(db);
  }

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        appDatabaseProvider.overrideWithValue(db),
      ],
      child: const JlptApp(),
    ),
  );
}
