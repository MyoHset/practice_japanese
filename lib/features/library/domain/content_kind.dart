import 'package:practice_janpanese/core/constants/app_strings.dart';
import 'package:practice_janpanese/core/database/app_database.dart';

/// The kind of study content in the library.
enum ContentKind {
  kanji(
    slug: 'kanji',
    glyph: '漢',
    label: AppStrings.categoryKanji,
    sourceType: SourceType.kanjiBook,
    itemType: ItemType.kanji,
    itemTableName: 'kanji_source_items',
    itemIdColumn: 'kanji_id',
  ),
  vocab(
    slug: 'vocab',
    glyph: '語',
    label: AppStrings.categoryVocab,
    sourceType: SourceType.vocabBook,
    itemType: ItemType.vocab,
    itemTableName: 'vocab_source_items',
    itemIdColumn: 'vocab_id',
  ),
  grammar(
    slug: 'grammar',
    glyph: '文',
    label: AppStrings.categoryGrammar,
    sourceType: SourceType.grammarBook,
    itemType: ItemType.grammar,
    itemTableName: 'grammar_source_items',
    itemIdColumn: 'grammar_id',
  );

  const ContentKind({
    required this.slug,
    required this.glyph,
    required this.label,
    required this.sourceType,
    required this.itemType,
    required this.itemTableName,
    required this.itemIdColumn,
  });

  final String slug;
  final String glyph;
  final String label;
  final SourceType sourceType;
  final ItemType itemType;
  final String itemTableName;
  final String itemIdColumn;

  /// Parses a slug into a [ContentKind], returning null if not found.
  static ContentKind? tryFromSlug(String slug) {
    for (final kind in values) {
      if (kind.slug == slug) return kind;
    }
    return null;
  }

  /// Parses a slug into a [ContentKind], defaulting to [kanji] or throwing.
  static ContentKind fromSlug(String slug) {
    final parsed = tryFromSlug(slug);
    if (parsed == null) {
      throw ArgumentError.value(slug, 'slug', 'Unknown ContentKind slug');
    }
    return parsed;
  }
}
