import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_janpanese/core/database/app_database.dart';
import 'package:practice_janpanese/core/providers/core_providers.dart';
import 'package:practice_janpanese/features/past_exam/data/past_exam_repository.dart';
import 'package:practice_janpanese/features/past_exam/domain/past_exam_filter.dart';
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

// ── Filter state ────────────────────────────────────────────────────────────

/// Mutable filter state for past exam list screen.
final pastExamFilterProvider =
    StateProvider<PastExamFilter>((ref) => const PastExamFilter());

/// Provides available exam sessions for the current level.
final pastExamAvailableYearsProvider = StreamProvider<List<ExamSession>>((ref) {
  final level = ref.watch(selectedLevelProvider);
  final repo = ref.watch(pastExamRepositoryProvider);
  return repo.watchAvailableSessions(level);
});

/// Provides available mondai types for the current level.
final pastExamAvailableMondaiTypesProvider =
    StreamProvider<List<MondaiType>>((ref) {
  final level = ref.watch(selectedLevelProvider);
  final repo = ref.watch(pastExamRepositoryProvider);
  return repo.watchAvailableMondaiTypes(level);
});

/// Provides filtered past exams based on active filter state.
final filteredPastExamsProvider = StreamProvider<List<Source>>((ref) {
  final level = ref.watch(selectedLevelProvider);
  final filter = ref.watch(pastExamFilterProvider);
  final repo = ref.watch(pastExamRepositoryProvider);
  return repo.watchFilteredPastExams(level, filter);
});

/// Provides past exam summary for a specific [sourceId].
final pastExamSummaryProvider =
    FutureProvider.family<PastExamSummary?, int>((ref, sourceId) {
  final repo = ref.watch(pastExamRepositoryProvider);
  return repo.getSummary(sourceId);
});

/// Provides total question count matching current level & filter.
final filteredQuestionsCountProvider = FutureProvider<int>((ref) {
  final level = ref.watch(selectedLevelProvider);
  final filter = ref.watch(pastExamFilterProvider);
  final repo = ref.watch(pastExamRepositoryProvider);
  return repo.countFilteredQuestions(level: level, filter: filter);
});

/// Typed parameter for querying questions by source and optional subject.
typedef PastExamQuery = ({int sourceId, Subject? subject});

/// Provides questions for a given source, optionally filtered by subject.
final pastExamQuestionsProvider =
    FutureProvider.family<List<PastExamQuestion>, PastExamQuery>(
  (ref, query) {
    final repo = ref.watch(pastExamRepositoryProvider);
    return repo.getQuestions(sourceId: query.sourceId, subject: query.subject);
  },
);

/// Provides questions for practice based on [PastExamPracticeArgs].
final pastExamPracticeQuestionsProvider =
    FutureProvider.family<List<PastExamQuestion>, PastExamPracticeArgs>(
  (ref, args) {
    final repo = ref.watch(pastExamRepositoryProvider);
    return repo.getQuestions(
      sourceId: args.sourceId,
      sourceIds: args.sourceIds,
      level: args.level,
      sessions: args.sessions.isNotEmpty ? args.sessions : null,
      subject: args.subject,
      questionFrom: args.questionFrom,
      questionTo: args.questionTo,
      mondaiTypes: args.mondaiTypes,
    );
  },
);
