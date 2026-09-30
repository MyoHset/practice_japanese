import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:practice_janpanese/core/database/app_database.dart';
import 'package:practice_janpanese/features/past_exam/domain/past_exam_question.dart';

/// Repository for retrieving JLPT past exam data and questions from Drift.
class PastExamRepository {
  const PastExamRepository(this._db);

  final AppDatabase _db;

  /// Watches all past exams available for [level].
  Stream<List<Source>> watchPastExams(String level) {
    final query = _db.select(_db.sources)
      ..where(
        (tbl) =>
            tbl.type.equalsValue(SourceType.pastExam) &
            (tbl.jlptLevel.equals(level) | tbl.jlptLevel.isNull()),
      )
      ..orderBy([
        (tbl) =>
            OrderingTerm(expression: tbl.sortOrder, mode: OrderingMode.asc),
        (tbl) => OrderingTerm(expression: tbl.id, mode: OrderingMode.asc),
      ]);
    return query.watch();
  }

  /// Fetches a past exam summary with question counts per subject.
  Future<PastExamSummary?> getSummary(int sourceId) async {
    final source = await (_db.select(_db.sources)
          ..where((s) => s.id.equals(sourceId)))
        .getSingleOrNull();

    if (source == null) return null;

    final questions = await (_db.select(_db.questions)
          ..where((q) => q.sourceId.equals(sourceId)))
        .get();

    final counts = <Subject, int>{};
    for (final q in questions) {
      counts[q.subject] = (counts[q.subject] ?? 0) + 1;
    }

    return PastExamSummary(
      source: source,
      totalQuestions: questions.length,
      subjectCounts: counts,
    );
  }

  /// Retrieves questions for [sourceId], optionally filtered by [subject].
  Future<List<PastExamQuestion>> getQuestions(
    int sourceId, {
    Subject? subject,
  }) async {
    final query = _db.select(_db.questions).join([
      innerJoin(
        _db.mondaiTypes,
        _db.mondaiTypes.id.equalsExp(_db.questions.mondaiTypeId),
      ),
      leftOuterJoin(
        _db.questionGroups,
        _db.questionGroups.id.equalsExp(_db.questions.groupId),
      ),
    ])
      ..where(_db.questions.sourceId.equals(sourceId));

    if (subject != null) {
      query.where(_db.questions.subject.equalsValue(subject));
    }

    query.orderBy([
      OrderingTerm(expression: _db.questions.id, mode: OrderingMode.asc),
    ]);

    final rows = await query.get();
    if (rows.isEmpty) return const [];

    final questionIds = rows.map((r) => r.readTable(_db.questions).id).toList();

    // Fetch all choices for these questions in one query
    final choicesRows = await (_db.select(_db.questionChoices)
          ..where((c) => c.questionId.isIn(questionIds))
          ..orderBy([(c) => OrderingTerm(expression: c.position)]))
        .get();

    final choicesByQuestionId = <int, List<PastExamChoice>>{};
    for (final c in choicesRows) {
      choicesByQuestionId.putIfAbsent(c.questionId, () => []).add(
            PastExamChoice(
              position: c.position,
              text: c.choiceText,
              isCorrect: c.isCorrect,
            ),
          );
    }

    return rows.map((row) {
      final q = row.readTable(_db.questions);
      final m = row.readTable(_db.mondaiTypes);
      final g = row.readTableOrNull(_db.questionGroups);

      List<int>? parsedOrder;
      if (q.correctOrder != null && q.correctOrder!.isNotEmpty) {
        try {
          final list = jsonDecode(q.correctOrder!) as List<dynamic>;
          parsedOrder = list.map((e) => e as int).toList();
        } catch (_) {}
      }

      return PastExamQuestion(
        id: q.id,
        sourceId: q.sourceId,
        jlptLevel: q.jlptLevel,
        subject: q.subject,
        mondaiType: m.type,
        mondaiTypeNameJp: m.nameJp,
        mondaiTypeNameMy: m.nameMy,
        mondaiInstruction: m.instructionJp,
        mondaiNo: q.mondaiNo,
        questionNo: q.questionNo,
        questionText: q.questionText,
        targetWord: q.targetWord,
        starPosition: q.starPosition,
        correctOrder: parsedOrder,
        explanation: q.explanation,
        passage: g?.passage,
        choices: choicesByQuestionId[q.id] ?? const [],
      );
    }).toList();
  }
}
