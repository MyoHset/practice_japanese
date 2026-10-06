import 'package:flutter/foundation.dart';
import 'package:practice_janpanese/features/library/domain/unit_progress.dart';

/// Represents a grouped Chapter consisting of multiple sections (Units),
/// primarily used for books organized by Chapters and Sections (such as Tango 2000).
@immutable
class ChapterGroup {
  const ChapterGroup({
    required this.chapterNumber,
    required this.title,
    required this.sections,
  });

  final int chapterNumber;
  final String title;
  final List<UnitProgress> sections;

  int get total => sections.fold(0, (sum, s) => sum + s.total);
  int get mastered => sections.fold(0, (sum, s) => sum + s.mastered);
  double get ratio => total == 0 ? 0 : (mastered / total).clamp(0.0, 1.0);

  /// Groups a list of [UnitProgress] into [ChapterGroup]s if their names follow
  /// the 'Ch.X Sec.Y' naming pattern. Returns empty list if no units match.
  static List<ChapterGroup> fromUnits(List<UnitProgress> units) {
    final regExp = RegExp(
      r'^Ch\.?\s*(\d+)',
      caseSensitive: false,
    );

    final map = <int, List<UnitProgress>>{};
    for (final u in units) {
      final match = regExp.firstMatch(u.name.trim());
      if (match != null) {
        final chNum = int.tryParse(match.group(1) ?? '') ?? 0;
        if (chNum > 0) {
          map.putIfAbsent(chNum, () => []).add(u);
        }
      }
    }

    if (map.isEmpty) return const [];

    final sortedKeys = map.keys.toList()..sort();
    return sortedKeys.map((k) {
      return ChapterGroup(
        chapterNumber: k,
        title: 'Chapter $k',
        sections: map[k]!,
      );
    }).toList();
  }

  /// Formats a unit name cleanly for display within a Chapter view.
  /// E.g. "Ch.1 Sec.1: 家族 (မိသားစု)" -> "Sec.1: 家族 (မိသားစု)"
  static String formatSectionName(String rawName) {
    final secRegExp = RegExp(
      r'^Ch\.?\s*\d+\s+(Sec\.?\s*\d+:\s*.*)',
      caseSensitive: false,
    );
    final match = secRegExp.firstMatch(rawName.trim());
    if (match != null) {
      return match.group(1)!;
    }
    return rawName;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChapterGroup &&
          runtimeType == other.runtimeType &&
          chapterNumber == other.chapterNumber &&
          title == other.title &&
          listEquals(sections, other.sections);

  @override
  int get hashCode =>
      Object.hash(chapterNumber, title, Object.hashAll(sections));
}
