/// Valid JLPT levels ordered from beginner (N5) to advanced (N1).
const List<String> kJlptLevels = ['N5', 'N4', 'N3', 'N2', 'N1'];

/// Key used to persist the selected level in SharedPreferences.
const String kSelectedLevelPrefKey = 'selected_level';

/// Default JLPT level for new users.
const String kDefaultJlptLevel = 'N3';

/// Returns the Japanese description label for a JLPT level.
String levelJapaneseLabel(String level) {
  switch (level) {
    case 'N5':
      return '入門';
    case 'N4':
      return '初級';
    case 'N3':
      return '中級';
    case 'N2':
      return '中上級';
    case 'N1':
      return '上級';
    default:
      return '';
  }
}
