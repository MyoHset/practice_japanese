import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_janpanese/core/providers/core_providers.dart';
import 'package:practice_janpanese/features/level/domain/jlpt_level.dart';

/// Currently selected JLPT level, persisted across app launches.
final selectedLevelProvider =
    NotifierProvider<SelectedLevelNotifier, String>(SelectedLevelNotifier.new);

class SelectedLevelNotifier extends Notifier<String> {
  @override
  String build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final saved = prefs.getString(kSelectedLevelPrefKey);
    if (saved != null && kJlptLevels.contains(saved)) {
      return saved;
    }
    return kDefaultJlptLevel;
  }

  Future<void> select(String level) async {
    if (!kJlptLevels.contains(level)) return;
    state = level;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(kSelectedLevelPrefKey, level);
  }
}
