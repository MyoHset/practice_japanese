import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_janpanese/core/database/app_database.dart';
import 'package:practice_janpanese/core/providers/core_providers.dart';
import 'package:practice_janpanese/features/past_exam/data/past_exam_repository.dart';
import 'package:practice_janpanese/features/past_exam/domain/past_exam_question.dart';

/// Provides the singleton [PastExamRepository].
final pastExamRepositoryProvider = Provider<PastExamRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return PastExamRepository(db);
});

/// Provides list of past exams for the currently selected JLPT level.
final currentLevelPastExamsProvider = StreamProvider<List<Source>>((ref) {
  final level = ref.watch(selectedLevelProvider);
  final repo = ref.watch(pastExamRepositoryProvider);
  return repo.watchPastExams(level);
});

/// Provides past exam summary for a specific [sourceId].
final pastExamSummaryProvider =
    FutureProvider.family<PastExamSummary?, int>((ref, sourceId) {
  final repo = ref.watch(pastExamRepositoryProvider);
  return repo.getSummary(sourceId);
});

/// Typed parameter for querying questions by source and optional subject.
typedef PastExamQuery = ({int sourceId, Subject? subject});

/// Provides questions for a given source, optionally filtered by subject.
final pastExamQuestionsProvider =
    FutureProvider.family<List<PastExamQuestion>, PastExamQuery>(
  (ref, query) {
    final repo = ref.watch(pastExamRepositoryProvider);
    return repo.getQuestions(query.sourceId, subject: query.subject);
  },
);
