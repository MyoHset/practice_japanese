import 'package:flutter/material.dart';
import 'package:practice_janpanese/core/constants/app_strings.dart';

/// Available study modes for a library unit.
enum StudyMode {
  list(
    slug: 'list',
    icon: Icons.format_list_bulleted_rounded,
    title: AppStrings.modeList,
    hint: AppStrings.modeListHint,
  ),
  quick(
    slug: 'quick',
    icon: Icons.quiz_rounded,
    title: AppStrings.modeQuick,
    hint: AppStrings.modeQuickHint,
  ),
  flashcard(
    slug: 'flashcard',
    icon: Icons.style_rounded,
    title: AppStrings.modeFlashcard,
    hint: AppStrings.modeFlashcardHint,
  );

  const StudyMode({
    required this.slug,
    required this.icon,
    required this.title,
    required this.hint,
  });

  final String slug;
  final IconData icon;
  final String title;
  final String hint;

  /// Parses a slug into a [StudyMode], returning null if not found.
  static StudyMode? tryFromSlug(String slug) {
    for (final mode in values) {
      if (mode.slug == slug) return mode;
    }
    return null;
  }

  /// Parses a slug into a [StudyMode], throwing on unrecognized slug.
  static StudyMode fromSlug(String slug) {
    final parsed = tryFromSlug(slug);
    if (parsed == null) {
      throw ArgumentError.value(slug, 'slug', 'Unknown StudyMode slug');
    }
    return parsed;
  }
}
