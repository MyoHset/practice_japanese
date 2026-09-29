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
    this.streak = 0,
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

  /// Current SRS streak count.
  final int streak;

  /// Whether the item is considered mastered (streak >= 3).
  bool get isMastered => streak >= 3;

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
          streak == other.streak;

  @override
  int get hashCode =>
      Object.hash(id, primary, secondary, meaning, connection, streak);

  @override
  String toString() =>
      'StudyItem(id: $id, primary: $primary, secondary: $secondary, streak: $streak)';
}
