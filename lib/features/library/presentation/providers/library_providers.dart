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

/// Provides study items in a unit for List mode.
final unitItemsProvider =
    StreamProvider.family<List<StudyItem>, UnitItemsParams>((ref, params) {
  final repo = ref.watch(libraryRepositoryProvider);
  return repo.watchUnitItems(params.unitId, params.kind);
});

/// Provides the count of due review items across the app.
final dueReviewCountProvider = StreamProvider<int>((ref) {
  final repo = ref.watch(libraryRepositoryProvider);
  return repo.watchDueReviewCount();
});
