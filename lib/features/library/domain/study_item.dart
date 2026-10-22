import 'package:flutter/foundation.dart';

/// Unified representation of a study item (Kanji, Vocabulary, or Grammar)
/// used across List mode, Flashcard mode, and review sessions.
@immutable
class StudyItem {
  const StudyItem({
    required this.id,
    required this.primary,
    this.secondary,
    this.meaning,
    this.connection,
    this.exampleJp,
    this.exampleMy,
    this.streak = 0,
    this.wrongCount = 0,
    this.isBookmarked = false,
  });

  /// Primary database ID of the item.
  final int id;

  /// Main character/word/pattern (e.g. '父親', '議', '〜に際して').
  final String primary;

  /// Reading or subtitle (e.g. 'ちちおや', 'ギ / えら・ぶ').
  final String? secondary;

  /// Burmese meaning / definition.
  final String? meaning;

  /// Connection / grammatical note if applicable.
  final String? connection;

  /// Japanese example sentence if applicable.
  final String? exampleJp;

  /// Myanmar translation of the example sentence if applicable.
  final String? exampleMy;

  /// Current SRS streak count.
  final int streak;

  /// Number of times this item was answered incorrectly or marked forgotten.
  final int wrongCount;

  /// Whether this item has been manually favorited / bookmarked as weak / forgotten.
  final bool isBookmarked;

  /// Whether the item is considered mastered (streak >= 3).
  bool get isMastered => streak >= 3;

  /// Whether the item is considered weak / forgotten (bookmarked or wrongCount > 0 or 0 streak).
  bool get isWeak =>
      isBookmarked || wrongCount > 0 || (streak == 0 && !isMastered);

  StudyItem copyWith({
    int? id,
    String? primary,
    String? secondary,
    String? meaning,
    String? connection,
    String? exampleJp,
    String? exampleMy,
    int? streak,
    int? wrongCount,
    bool? isBookmarked,
  }) =>
      StudyItem(
        id: id ?? this.id,
        primary: primary ?? this.primary,
        secondary: secondary ?? this.secondary,
        meaning: meaning ?? this.meaning,
        connection: connection ?? this.connection,
        exampleJp: exampleJp ?? this.exampleJp,
        exampleMy: exampleMy ?? this.exampleMy,
        streak: streak ?? this.streak,
        wrongCount: wrongCount ?? this.wrongCount,
        isBookmarked: isBookmarked ?? this.isBookmarked,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudyItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          primary == other.primary &&
          secondary == other.secondary &&
          meaning == other.meaning &&
          connection == other.connection &&
          exampleJp == other.exampleJp &&
          exampleMy == other.exampleMy &&
          streak == other.streak &&
          wrongCount == other.wrongCount &&
          isBookmarked == other.isBookmarked;

  @override
  int get hashCode => Object.hash(
        id,
        primary,
        secondary,
        meaning,
        connection,
        exampleJp,
        exampleMy,
        streak,
        wrongCount,
        isBookmarked,
      );

  @override
  String toString() =>
      'StudyItem(id: $id, primary: $primary, secondary: $secondary, streak: $streak, wrongCount: $wrongCount, isBookmarked: $isBookmarked)';
}
