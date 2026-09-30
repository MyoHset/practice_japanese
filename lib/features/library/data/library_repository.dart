import 'package:drift/drift.dart';
import 'package:practice_janpanese/core/database/app_database.dart';
import 'package:practice_janpanese/features/library/domain/content_kind.dart';
import 'package:practice_janpanese/features/library/domain/study_item.dart';
import 'package:practice_janpanese/features/library/domain/unit_progress.dart';

/// Repository for browsing books, units, and items in the library.
class LibraryRepository {
  const LibraryRepository(this._db);

  final AppDatabase _db;

  /// Watches sources for the given [kind] and [level].
  Stream<List<Source>> watchSources(ContentKind kind, String level) {
    final query = _db.select(_db.sources)
      ..where(
        (tbl) =>
            tbl.type.equalsValue(kind.sourceType) &
            (tbl.jlptLevel.equals(level) | tbl.jlptLevel.isNull()),
      )
      ..orderBy([
        (tbl) =>
            OrderingTerm(expression: tbl.sortOrder, mode: OrderingMode.asc),
        (tbl) => OrderingTerm(expression: tbl.id, mode: OrderingMode.asc),
      ]);
    return query.watch();
  }

  /// Fetches a single source by [id].
  Future<Source?> getSource(int id) =>
      (_db.select(_db.sources)..where((tbl) => tbl.id.equals(id)))
          .getSingleOrNull();

  /// Fetches a single unit by [id].
  Future<Unit?> getUnit(int id) =>
      (_db.select(_db.units)..where((tbl) => tbl.id.equals(id)))
          .getSingleOrNull();

  /// Watches units for a [sourceId] with aggregated item count and mastered count.
  Stream<List<UnitProgress>> watchUnits(int sourceId, ContentKind kind) {
    TableInfo itemTable;
    switch (kind) {
      case ContentKind.kanji:
        itemTable = _db.kanjiSourceItems;
      case ContentKind.vocab:
        itemTable = _db.vocabSourceItems;
      case ContentKind.grammar:
        itemTable = _db.grammarSourceItems;
    }

    final query = '''
      SELECT 
        u.id AS unit_id,
        u.name AS unit_name,
        u.order_no AS unit_order_no,
        COUNT(DISTINCT item.${kind.itemIdColumn}) AS total_items,
        COUNT(DISTINCT CASE WHEN p.streak >= 3 THEN item.${kind.itemIdColumn} END) AS mastered_items
      FROM units u
      LEFT JOIN ${kind.itemTableName} item 
        ON item.unit_id = u.id AND item.source_id = :sourceId
      LEFT JOIN progress p 
        ON p.item_id = item.${kind.itemIdColumn} 
       AND p.item_type = :itemType
      WHERE u.source_id = :sourceId
      GROUP BY u.id, u.name, u.order_no
      ORDER BY u.order_no ASC, u.id ASC
    ''';

    return _db
        .customSelect(
          query,
          variables: [
            Variable.withInt(sourceId),
            Variable.withInt(kind.itemType.index),
          ],
          readsFrom: {
            _db.units,
            itemTable,
            _db.progress,
          },
        )
        .watch()
        .map((rows) {
          return rows.map((row) {
            return UnitProgress(
              id: row.read<int>('unit_id'),
              name: row.read<String>('unit_name'),
              orderNo: row.read<int>('unit_order_no'),
              total: row.read<int>('total_items'),
              mastered: row.read<int>('mastered_items'),
            );
          }).toList();
        });
  }

  /// Watches all items within a unit formatted as [StudyItem]s for List mode.
  Stream<List<StudyItem>> watchUnitItems(int unitId, ContentKind kind) {
    switch (kind) {
      case ContentKind.vocab:
        const query = '''
          SELECT 
            v.id AS item_id,
            v.word AS item_primary,
            v.reading AS item_secondary,
            v.meaning_my AS item_meaning,
            NULL AS item_connection,
            COALESCE(p.streak, 0) AS item_streak
          FROM vocab_source_items vsi
          JOIN vocabularies v ON v.id = vsi.vocab_id
          LEFT JOIN progress p ON p.item_id = v.id AND p.item_type = 1
          WHERE vsi.unit_id = :unitId
          ORDER BY vsi.position ASC, v.id ASC
        ''';
        return _db
            .customSelect(
              query,
              variables: [Variable.withInt(unitId)],
              readsFrom: {_db.vocabSourceItems, _db.vocabularies, _db.progress},
            )
            .watch()
            .map((rows) => rows.map(_mapStudyItem).toList());

      case ContentKind.kanji:
        const query = '''
          SELECT 
            k.id AS item_id,
            k.character AS item_primary,
            (SELECT GROUP_CONCAT(reading, '、') FROM kanji_readings WHERE kanji_id = k.id) AS item_secondary,
            k.meaning_my AS item_meaning,
            NULL AS item_connection,
            COALESCE(p.streak, 0) AS item_streak
          FROM kanji_source_items ksi
          JOIN kanjis k ON k.id = ksi.kanji_id
          LEFT JOIN progress p ON p.item_id = k.id AND p.item_type = 0
          WHERE ksi.unit_id = :unitId
          ORDER BY ksi.position ASC, k.id ASC
        ''';
        return _db
            .customSelect(
              query,
              variables: [Variable.withInt(unitId)],
              readsFrom: {
                _db.kanjiSourceItems,
                _db.kanjis,
                _db.kanjiReadings,
                _db.progress,
              },
            )
            .watch()
            .map((rows) => rows.map(_mapStudyItem).toList());

      case ContentKind.grammar:
        const query = '''
          SELECT 
            g.id AS item_id,
            g.pattern AS item_primary,
            g.connection AS item_secondary,
            g.meaning_my AS item_meaning,
            g.connection AS item_connection,
            COALESCE(p.streak, 0) AS item_streak
          FROM grammar_source_items gsi
          JOIN grammar_points g ON g.id = gsi.grammar_id
          LEFT JOIN progress p ON p.item_id = g.id AND p.item_type = 2
          WHERE gsi.unit_id = :unitId
          ORDER BY gsi.position ASC, g.id ASC
        ''';
        return _db
            .customSelect(
              query,
              variables: [Variable.withInt(unitId)],
              readsFrom: {
                _db.grammarSourceItems,
                _db.grammarPoints,
                _db.progress,
              },
            )
            .watch()
            .map((rows) => rows.map(_mapStudyItem).toList());
    }
  }

  /// Watches all items across all units in a given chapter for a source.
  Stream<List<StudyItem>> watchChapterItems(
    int sourceId,
    int chapterNumber,
    ContentKind kind,
  ) {
    switch (kind) {
      case ContentKind.vocab:
        const query = '''
          SELECT 
            v.id AS item_id,
            v.word AS item_primary,
            v.reading AS item_secondary,
            v.meaning_my AS item_meaning,
            NULL AS item_connection,
            COALESCE(p.streak, 0) AS item_streak
          FROM vocab_source_items vsi
          JOIN vocabularies v ON v.id = vsi.vocab_id
          JOIN units u ON u.id = vsi.unit_id
          LEFT JOIN progress p ON p.item_id = v.id AND p.item_type = 1
          WHERE u.source_id = :sourceId 
            AND (u.name LIKE 'Ch.' || :chapterNumber || ' %' OR u.name LIKE 'Ch.' || :chapterNumber || ':%')
          ORDER BY u.order_no ASC, vsi.position ASC, v.id ASC
        ''';
        return _db
            .customSelect(
              query,
              variables: [
                Variable.withInt(sourceId),
                Variable.withInt(chapterNumber),
              ],
              readsFrom: {
                _db.vocabSourceItems,
                _db.vocabularies,
                _db.units,
                _db.progress,
              },
            )
            .watch()
            .map((rows) => rows.map(_mapStudyItem).toList());

      case ContentKind.kanji:
        const query = '''
          SELECT 
            k.id AS item_id,
            k.character AS item_primary,
            (SELECT GROUP_CONCAT(reading, '、') FROM kanji_readings WHERE kanji_id = k.id) AS item_secondary,
            k.meaning_my AS item_meaning,
            NULL AS item_connection,
            COALESCE(p.streak, 0) AS item_streak
          FROM kanji_source_items ksi
          JOIN kanjis k ON k.id = ksi.kanji_id
          JOIN units u ON u.id = ksi.unit_id
          LEFT JOIN progress p ON p.item_id = k.id AND p.item_type = 0
          WHERE u.source_id = :sourceId 
            AND (u.name LIKE 'Ch.' || :chapterNumber || ' %' OR u.name LIKE 'Ch.' || :chapterNumber || ':%')
          ORDER BY u.order_no ASC, ksi.position ASC, k.id ASC
        ''';
        return _db
            .customSelect(
              query,
              variables: [
                Variable.withInt(sourceId),
                Variable.withInt(chapterNumber),
              ],
              readsFrom: {
                _db.kanjiSourceItems,
                _db.kanjis,
                _db.kanjiReadings,
                _db.units,
                _db.progress,
              },
            )
            .watch()
            .map((rows) => rows.map(_mapStudyItem).toList());

      case ContentKind.grammar:
        const query = '''
          SELECT 
            g.id AS item_id,
            g.pattern AS item_primary,
            g.connection AS item_secondary,
            g.meaning_my AS item_meaning,
            g.connection AS item_connection,
            COALESCE(p.streak, 0) AS item_streak
          FROM grammar_source_items gsi
          JOIN grammar_points g ON g.id = gsi.grammar_id
          JOIN units u ON u.id = gsi.unit_id
          LEFT JOIN progress p ON p.item_id = g.id AND p.item_type = 2
          WHERE u.source_id = :sourceId 
            AND (u.name LIKE 'Ch.' || :chapterNumber || ' %' OR u.name LIKE 'Ch.' || :chapterNumber || ':%')
          ORDER BY u.order_no ASC, gsi.position ASC, g.id ASC
        ''';
        return _db
            .customSelect(
              query,
              variables: [
                Variable.withInt(sourceId),
                Variable.withInt(chapterNumber),
              ],
              readsFrom: {
                _db.grammarSourceItems,
                _db.grammarPoints,
                _db.units,
                _db.progress,
              },
            )
            .watch()
            .map((rows) => rows.map(_mapStudyItem).toList());
    }
  }

  /// Records a flashcard review for an item: increments streak if remembered,
  /// resets streak if forgotten, updates lastReviewed and nextReview.
  Future<void> recordReview({
    required ContentKind kind,
    required int itemId,
    required bool remembered,
  }) async {
    final itemType = kind.itemType;
    final now = DateTime.now();

    final existing = await (_db.select(_db.progress)
          ..where(
            (p) =>
                p.itemType.equalsValue(itemType) &
                p.itemId.equals(itemId),
          ))
        .getSingleOrNull();

    if (existing == null) {
      final newStreak = remembered ? 1 : 0;
      final intervalDays = remembered ? 1 : 0;
      await _db.into(_db.progress).insert(
            ProgressCompanion.insert(
              itemType: itemType,
              itemId: itemId,
              direction: const Value(Direction.none),
              streak: Value(newStreak),
              correctCount: Value(remembered ? 1 : 0),
              wrongCount: Value(remembered ? 0 : 1),
              lastReviewed: Value(now),
              nextReview: Value(now.add(Duration(days: intervalDays))),
            ),
          );
    } else {
      final newStreak = remembered ? existing.streak + 1 : 0;
      final intervalDays = remembered
          ? (newStreak == 1
              ? 1
              : newStreak == 2
                  ? 3
                  : newStreak * 3)
          : 0;
      await (_db.update(_db.progress)
            ..where(
              (p) =>
                  p.itemType.equalsValue(itemType) &
                  p.itemId.equals(itemId),
            ))
          .write(
        ProgressCompanion(
          streak: Value(newStreak),
          correctCount: Value(
            remembered ? existing.correctCount + 1 : existing.correctCount,
          ),
          wrongCount: Value(
            !remembered ? existing.wrongCount + 1 : existing.wrongCount,
          ),
          lastReviewed: Value(now),
          nextReview: Value(now.add(Duration(days: intervalDays))),
        ),
      );
    }
  }

  StudyItem _mapStudyItem(QueryRow row) => StudyItem(
        id: row.read<int>('item_id'),
        primary: row.read<String>('item_primary'),
        secondary: row.readNullable<String>('item_secondary'),
        meaning: row.readNullable<String>('item_meaning'),
        connection: row.readNullable<String>('item_connection'),
        streak: row.read<int>('item_streak'),
      );

  /// Watches the number of due review items (progress with nextReview <= now).
  Stream<int> watchDueReviewCount() {
    final now = DateTime.now();
    final query = _db.selectOnly(_db.progress)
      ..addColumns([countAll()])
      ..where(
        _db.progress.nextReview.isNotNull() &
            _db.progress.nextReview.isSmallerOrEqual(Variable<DateTime>(now)),
      );

    return query.watchSingle().map((row) => row.read(countAll()) ?? 0);
  }
}
