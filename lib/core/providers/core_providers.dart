import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_janpanese/core/database/app_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

export 'package:practice_janpanese/features/level/presentation/providers/selected_level_provider.dart';

/// Singleton database instance.
/// Must be overridden at startup in main.dart via ProviderScope.overrides.
final appDatabaseProvider = Provider<AppDatabase>(
  (_) => throw UnimplementedError('AppDatabase not yet initialised'),
);

/// Backward-compatible alias.
final databaseProvider = appDatabaseProvider;

/// Singleton shared preferences instance.
/// Must be overridden at startup in main.dart via ProviderScope.overrides.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (_) => throw UnimplementedError('SharedPreferences not yet initialised'),
);
