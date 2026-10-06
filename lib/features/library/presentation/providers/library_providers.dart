import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_janpanese/core/database/app_database.dart';
import 'package:practice_janpanese/core/providers/core_providers.dart';
import 'package:practice_janpanese/features/library/data/library_repository.dart';
import 'package:practice_janpanese/features/library/domain/content_kind.dart';
import 'package:practice_janpanese/features/library/domain/study_item.dart';
import 'package:practice_janpanese/features/library/domain/unit_progress.dart';

/// Provides the singleton [LibraryRepository].
final libraryRepositoryProvider = Provider<LibraryRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return LibraryRepository(db);
});

/// Provides sources filtered by [ContentKind] and the globally selected JLPT level.
final sourceListProvider =
    StreamProvider.family<List<Source>, ContentKind>((ref, kind) {
  final repo = ref.watch(libraryRepositoryProvider);
  final level = ref.watch(selectedLevelProvider);
  return repo.watchSources(kind, level);
});

/// Provides a single [Source] by [id].
final sourceProvider = FutureProvider.family<Source?, int>((ref, id) {
  final repo = ref.watch(libraryRepositoryProvider);
  return repo.getSource(id);
});

/// Looks up a companion source for Speed Master N3 (e.g. Kanji <-> Vocab).
final companionSourceProvider =
    FutureProvider.family<Source?, int>((ref, sourceId) async {
  final source = await ref.watch(sourceProvider(sourceId).future);
  if (source == null) return null;
  final repo = ref.watch(libraryRepositoryProvider);
  if (source.name.contains('Speed Master N3 漢字')) {
    return repo.getSourceByName('Speed Master N3 語彙 (Kanji တွဲလုံးများ)');
  } else if (source.name.contains('Speed Master N3 語彙')) {
    return repo.getSourceByName('Speed Master N3 漢字');
  }
  return null;
});

/// Parameter record for unitListProvider.
typedef UnitListParams = ({int sourceId, ContentKind kind});

/// Provides units with aggregated progress for a source.
final unitListProvider =
    StreamProvider.family<List<UnitProgress>, UnitListParams>((ref, params) {
  final repo = ref.watch(libraryRepositoryProvider);
  return repo.watchUnits(params.sourceId, params.kind);
});

/// Provides a single [Unit] by [id].
final unitProvider = FutureProvider.family<Unit?, int>((ref, id) {
  final repo = ref.watch(libraryRepositoryProvider);
  return repo.getUnit(id);
});

/// Parameter record for unitItemsProvider.
typedef UnitItemsParams = ({int unitId, ContentKind kind});

/// Provides study items in a unit for List mode and Flashcard mode.
final unitItemsProvider =
    StreamProvider.family<List<StudyItem>, UnitItemsParams>((ref, params) {
  final repo = ref.watch(libraryRepositoryProvider);
  return repo.watchUnitItems(params.unitId, params.kind);
});

/// Parameter class for multiChapterItemsProvider with proper list equality.
class MultiChapterItemsParams {
  const MultiChapterItemsParams({
    required this.sourceId,
    required this.chapterNumbers,
    required this.kind,
  });

  final int sourceId;
  final List<int> chapterNumbers;
  final ContentKind kind;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MultiChapterItemsParams) return false;
    if (sourceId != other.sourceId || kind != other.kind) return false;
    if (chapterNumbers.length != other.chapterNumbers.length) return false;
    for (var i = 0; i < chapterNumbers.length; i++) {
      if (chapterNumbers[i] != other.chapterNumbers[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode =>
      Object.hash(sourceId, kind, Object.hashAll(chapterNumbers));
}

/// Provides study items across multiple chapters (or all) for Flashcard and Quiz.
final multiChapterItemsProvider =
    StreamProvider.family<List<StudyItem>, MultiChapterItemsParams>(
        (ref, params) {
  final repo = ref.watch(libraryRepositoryProvider);
  return repo.watchMultiChapterItems(
    params.sourceId,
    params.chapterNumbers,
    params.kind,
  );
});

/// Parameter record for chapterItemsProvider.
typedef ChapterItemsParams = ({
  int sourceId,
  int chapterNumber,
  ContentKind kind,
});

/// Provides study items across all units in a chapter for Flashcard mode.
final chapterItemsProvider =
    StreamProvider.family<List<StudyItem>, ChapterItemsParams>((ref, params) {
  final repo = ref.watch(libraryRepositoryProvider);
  return repo.watchChapterItems(
    params.sourceId,
    params.chapterNumber,
    params.kind,
  );
});

/// Provides the count of due review items across the app.
final dueReviewCountProvider = StreamProvider<int>((ref) {
  final repo = ref.watch(libraryRepositoryProvider);
  return repo.watchDueReviewCount();
});
