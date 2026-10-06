import 'package:practice_janpanese/core/database/app_database.dart';

class ExamSession {
  const ExamSession(this.year, this.month);
  final int year;
  final int month;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExamSession && year == other.year && month == other.month;

  @override
  int get hashCode => Object.hash(year, month);

  @override
  String toString() => '$year ${month}လပိုင်း';
}

/// Immutable filter state for Past Exam List screen.
class PastExamFilter {
  const PastExamFilter({
    this.selectedSessions = const {},
    this.selectedMondaiTypes = const {},
    this.questionFrom,
    this.questionTo,
  });

  /// Selected exam sessions. Empty = all sessions.
  final Set<ExamSession> selectedSessions;

  /// Selected mondai types. Empty = all types.
  final Set<MondaiType> selectedMondaiTypes;

  /// Start question index (1-based)
  final int? questionFrom;

  /// End question index (1-based)
  final int? questionTo;

  bool get hasAnyFilter =>
      selectedSessions.isNotEmpty ||
      selectedMondaiTypes.isNotEmpty ||
      questionFrom != null ||
      questionTo != null;

  int get totalActiveFilters =>
      selectedSessions.length +
      selectedMondaiTypes.length +
      (questionFrom != null || questionTo != null ? 1 : 0);

  PastExamFilter copyWith({
    Set<ExamSession>? selectedSessions,
    Set<MondaiType>? selectedMondaiTypes,
    int? questionFrom,
    int? questionTo,
    bool clearFromTo = false,
  }) {
    return PastExamFilter(
      selectedSessions: selectedSessions ?? this.selectedSessions,
      selectedMondaiTypes: selectedMondaiTypes ?? this.selectedMondaiTypes,
      questionFrom: clearFromTo ? null : (questionFrom ?? this.questionFrom),
      questionTo: clearFromTo ? null : (questionTo ?? this.questionTo),
    );
  }

  PastExamFilter clear() => const PastExamFilter();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PastExamFilter &&
          _setEquals(selectedSessions, other.selectedSessions) &&
          _setEquals(selectedMondaiTypes, other.selectedMondaiTypes) &&
          questionFrom == other.questionFrom &&
          questionTo == other.questionTo;

  @override
  int get hashCode => Object.hash(
        selectedSessions.toString(),
        selectedMondaiTypes.toString(),
        questionFrom,
        questionTo,
      );

  static bool _setEquals<T>(Set<T> a, Set<T> b) =>
      a.length == b.length && a.containsAll(b);
}
