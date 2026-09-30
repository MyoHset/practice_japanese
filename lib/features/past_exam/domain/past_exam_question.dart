import 'package:practice_janpanese/core/database/app_database.dart';

/// Single multiple-choice option for a past exam question.
class PastExamChoice {
  const PastExamChoice({
    required this.position,
    required this.text,
    required this.isCorrect,
  });

  final int position;
  final String text;
  final bool isCorrect;
}

/// A JLPT past exam question populated with its choices, passage, and problem type metadata.
class PastExamQuestion {
  const PastExamQuestion({
    required this.id,
    required this.sourceId,
    required this.jlptLevel,
    required this.subject,
    required this.mondaiType,
    required this.mondaiTypeNameJp,
    this.mondaiTypeNameMy,
    this.mondaiInstruction,
    this.mondaiNo,
    this.questionNo,
    required this.questionText,
    this.targetWord,
    this.starPosition,
    this.correctOrder,
    this.explanation,
    this.passage,
    required this.choices,
  });

  final int id;
  final int sourceId;
  final String jlptLevel;
  final Subject subject;
  final MondaiType mondaiType;
  final String mondaiTypeNameJp;
  final String? mondaiTypeNameMy;
  final String? mondaiInstruction;
  final int? mondaiNo;
  final int? questionNo;
  final String questionText;
  final String? targetWord;
  final int? starPosition;
  final List<int>? correctOrder;
  final String? explanation;
  final String? passage;
  final List<PastExamChoice> choices;

  /// Helper to get the 1-based index of the correct choice.
  int get correctPosition {
    for (final c in choices) {
      if (c.isCorrect) return c.position;
    }
    return 1;
  }
}

/// Aggregated summary of a past exam.
class PastExamSummary {
  const PastExamSummary({
    required this.source,
    required this.totalQuestions,
    required this.subjectCounts,
  });

  final Source source;
  final int totalQuestions;
  final Map<Subject, int> subjectCounts;
}
