import 'package:practice_janpanese/core/database/app_database.dart';

/// Immutable filter state for Past Exam List screen.
class PastExamFilter {
  const PastExamFilter({
    this.selectedYears = const {},
    this.selectedMondaiTypes = const {},
  });

  /// Selected exam years, e.g. {2019, 2022}. Empty = all years.
  final Set<int> selectedYears;

  /// Selected mondai types, e.g. {MondaiType.kanjiReading}. Empty = all types.
  final Set<MondaiType> selectedMondaiTypes;

  bool get hasAnyFilter =>
      selectedYears.isNotEmpty || selectedMondaiTypes.isNotEmpty;

  int get totalActiveFilters =>
      selectedYears.length + selectedMondaiTypes.length;

  PastExamFilter copyWith({
    Set<int>? selectedYears,
    Set<MondaiType>? selectedMondaiTypes,
  }) {
    return PastExamFilter(
      selectedYears: selectedYears ?? this.selectedYears,
      selectedMondaiTypes: selectedMondaiTypes ?? this.selectedMondaiTypes,
    );
  }

  PastExamFilter clear() => const PastExamFilter();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PastExamFilter &&
          _setEquals(selectedYears, other.selectedYears) &&
          _setEquals(selectedMondaiTypes, other.selectedMondaiTypes);

  @override
  int get hashCode =>
      Object.hash(selectedYears.toString(), selectedMondaiTypes.toString());

  static bool _setEquals<T>(Set<T> a, Set<T> b) =>
      a.length == b.length && a.containsAll(b);
}
