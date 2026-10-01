import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:practice_janpanese/core/database/app_database.dart';
import 'package:practice_janpanese/features/past_exam/domain/past_exam_filter.dart';
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
        (tbl) => OrderingTerm(expression: tbl.examYear, mode: OrderingMode.asc),
        (tbl) => OrderingTerm(expression: tbl.examMonth, mode: OrderingMode.asc),
        (tbl) =>
            OrderingTerm(expression: tbl.sortOrder, mode: OrderingMode.asc),
        (tbl) => OrderingTerm(expression: tbl.id, mode: OrderingMode.asc),
      ]);
    return query.watch();
  }

  /// Watches distinct exam years available for [level].
  Stream<List<int>> watchAvailableYears(String level) {
    final q = _db.selectOnly(_db.sources, distinct: true)
      ..addColumns([_db.sources.examYear])
      ..where(
        _db.sources.type.equalsValue(SourceType.pastExam) &
            (_db.sources.jlptLevel.equals(level) |
                _db.sources.jlptLevel.isNull()) &
            _db.sources.examYear.isNotNull(),
      )
      ..orderBy([
        OrderingTerm(
          expression: _db.sources.examYear,
          mode: OrderingMode.asc,
        ),
      ]);
    return q.watch().map(
          (rows) => rows
              .map((r) => r.read(_db.sources.examYear))
              .whereType<int>()
              .toList(),
        );
  }

  /// Watches distinct mondai types available for [level].
  Stream<List<MondaiType>> watchAvailableMondaiTypes(String level) {
    final q = _db.selectOnly(_db.mondaiTypes, distinct: true)
      ..addColumns([_db.mondaiTypes.type, _db.mondaiTypes.sortOrder])
      ..where(
        _db.mondaiTypes.jlptLevel.equals(level) |
            _db.mondaiTypes.jlptLevel.isNull(),
      )
      ..orderBy([
        OrderingTerm(
          expression: _db.mondaiTypes.sortOrder,
          mode: OrderingMode.asc,
        ),
      ]);
    return q.watch().map((rows) {
      final types = rows
          .map((r) => r.read(_db.mondaiTypes.type))
          .whereType<MondaiType>()
          .toSet()
          .toList();
      if (types.isNotEmpty) return types;
      return MondaiType.values.toList();
    });
  }

  /// Watches past exams for [level] filtered by [filter].
  Stream<List<Source>> watchFilteredPastExams(
    String level,
    PastExamFilter filter,
  ) {
    if (!filter.hasAnyFilter) return watchPastExams(level);

    final query = _db.select(_db.sources)
      ..where((tbl) {
        Expression<bool> cond = tbl.type.equalsValue(SourceType.pastExam) &
            (tbl.jlptLevel.equals(level) | tbl.jlptLevel.isNull());

        if (filter.selectedYears.isNotEmpty) {
          cond = cond & tbl.examYear.isIn(filter.selectedYears.toList());
        }

        if (filter.selectedMondaiTypes.isNotEmpty) {
          final sub = _db.selectOnly(_db.questions)
            .join([
              innerJoin(
                _db.mondaiTypes,
                _db.mondaiTypes.id.equalsExp(_db.questions.mondaiTypeId),
              ),
            ])
            ..addColumns([_db.questions.sourceId])
            ..where(_db.mondaiTypes.type.isInValues(filter.selectedMondaiTypes));
          cond = cond & tbl.id.isInQuery(sub);
        }

        return cond;
      })
      ..orderBy([
        (tbl) => OrderingTerm(expression: tbl.examYear, mode: OrderingMode.asc),
        (tbl) =>
            OrderingTerm(expression: tbl.examMonth, mode: OrderingMode.asc),
        (tbl) =>
            OrderingTerm(expression: tbl.sortOrder, mode: OrderingMode.asc),
        (tbl) => OrderingTerm(expression: tbl.id, mode: OrderingMode.asc),
      ]);
    return query.watch();
  }

  /// Counts questions matching the given [level] and [filter].
  Future<int> countFilteredQuestions({
    required String level,
    required PastExamFilter filter,
  }) async {
    final query = _db.selectOnly(_db.questions).join([
      innerJoin(
        _db.mondaiTypes,
        _db.mondaiTypes.id.equalsExp(_db.questions.mondaiTypeId),
      ),
      innerJoin(
        _db.sources,
        _db.sources.id.equalsExp(_db.questions.sourceId),
      ),
    ])
      ..addColumns([_db.questions.id.count()])
      ..where(
        _db.sources.type.equalsValue(SourceType.pastExam) &
            (_db.sources.jlptLevel.equals(level) |
                _db.sources.jlptLevel.isNull()),
      );

    if (filter.selectedYears.isNotEmpty) {
      query.where(_db.sources.examYear.isIn(filter.selectedYears.toList()));
    }

    if (filter.selectedMondaiTypes.isNotEmpty) {
      query.where(
        _db.mondaiTypes.type.isInValues(filter.selectedMondaiTypes),
      );
    }

    final row = await query.getSingle();
    return row.read(_db.questions.id.count()) ?? 0;
  }

  /// Fetches a past exam summary with question counts per subject and per mondai type.
  Future<PastExamSummary?> getSummary(int sourceId) async {
    final source = await (_db.select(_db.sources)
          ..where((s) => s.id.equals(sourceId)))
        .getSingleOrNull();

    if (source == null) return null;

    final query = _db.select(_db.questions).join([
      innerJoin(
        _db.mondaiTypes,
        _db.mondaiTypes.id.equalsExp(_db.questions.mondaiTypeId),
      ),
    ])..where(_db.questions.sourceId.equals(sourceId));

    final rows = await query.get();

    final subjectCounts = <Subject, int>{};
    final mondaiTypeCounts = <MondaiType, int>{};
    for (final row in rows) {
      final q = row.readTable(_db.questions);
      final m = row.readTable(_db.mondaiTypes);
      subjectCounts[q.subject] = (subjectCounts[q.subject] ?? 0) + 1;
      mondaiTypeCounts[m.type] = (mondaiTypeCounts[m.type] ?? 0) + 1;
    }

    return PastExamSummary(
      source: source,
      totalQuestions: rows.length,
      subjectCounts: subjectCounts,
      mondaiTypeCounts: mondaiTypeCounts,
    );
  }

  /// Retrieves questions for practice based on flexible criteria.
  Future<List<PastExamQuestion>> getQuestions({
    int? sourceId,
    List<int>? sourceIds,
    String? level,
    Set<int>? years,
    Subject? subject,
    Set<MondaiType>? mondaiTypes,
  }) async {
    final query = _db.select(_db.questions).join([
      innerJoin(
        _db.mondaiTypes,
        _db.mondaiTypes.id.equalsExp(_db.questions.mondaiTypeId),
      ),
      innerJoin(
        _db.sources,
        _db.sources.id.equalsExp(_db.questions.sourceId),
      ),
      leftOuterJoin(
        _db.questionGroups,
        _db.questionGroups.id.equalsExp(_db.questions.groupId),
      ),
    ]);

    if (sourceId != null) {
      query.where(_db.questions.sourceId.equals(sourceId));
    } else if (sourceIds != null && sourceIds.isNotEmpty) {
      query.where(_db.questions.sourceId.isIn(sourceIds));
    }

    if (level != null) {
      query.where(
        _db.sources.type.equalsValue(SourceType.pastExam) &
            (_db.sources.jlptLevel.equals(level) |
                _db.sources.jlptLevel.isNull()),
      );
    }

    if (years != null && years.isNotEmpty) {
      query.where(_db.sources.examYear.isIn(years.toList()));
    }

    if (subject != null) {
      query.where(_db.questions.subject.equalsValue(subject));
    }

    if (mondaiTypes != null && mondaiTypes.isNotEmpty) {
      query.where(_db.mondaiTypes.type.isInValues(mondaiTypes));
    }

    query.orderBy([
      OrderingTerm(expression: _db.sources.examYear, mode: OrderingMode.asc),
      OrderingTerm(expression: _db.sources.examMonth, mode: OrderingMode.asc),
      OrderingTerm(expression: _db.questions.mondaiNo, mode: OrderingMode.asc),
      OrderingTerm(expression: _db.questions.questionNo, mode: OrderingMode.asc),
      OrderingTerm(expression: _db.questions.id, mode: OrderingMode.asc),
    ]);

    final rows = await query.get();
    if (rows.isEmpty) return const [];

    final questionIds = rows.map((r) => r.readTable(_db.questions).id).toList();

    // Fetch all choices for these questions in one query (batched in 500s)
    final choicesByQuestionId = <int, List<PastExamChoice>>{};
    for (var i = 0; i < questionIds.length; i += 500) {
      final chunk = questionIds.sublist(
        i,
        (i + 500 > questionIds.length) ? questionIds.length : i + 500,
      );
      final choicesRows = await (_db.select(_db.questionChoices)
            ..where((c) => c.questionId.isIn(chunk))
            ..orderBy([(c) => OrderingTerm(expression: c.position)]))
          .get();

      for (final c in choicesRows) {
        choicesByQuestionId.putIfAbsent(c.questionId, () => []).add(
              PastExamChoice(
                position: c.position,
                text: c.choiceText,
                isCorrect: c.isCorrect,
              ),
            );
      }
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
