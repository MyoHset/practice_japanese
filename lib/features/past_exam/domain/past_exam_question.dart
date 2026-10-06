import 'package:flutter/material.dart';
import 'package:practice_janpanese/core/database/app_database.dart';
import 'package:practice_janpanese/features/past_exam/domain/past_exam_filter.dart';

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
    this.mondaiTypeCounts = const {},
  });

  final Source source;
  final int totalQuestions;
  final Map<Subject, int> subjectCounts;
  final Map<MondaiType, int> mondaiTypeCounts;
}

/// Arguments for querying questions to practice.
class PastExamPracticeArgs {
  const PastExamPracticeArgs({
    this.sourceId,
    this.sourceIds = const [],
    this.level,
    this.sessions = const {},
    this.subject,
    this.mondaiTypes = const {},
    this.title,
    this.questionFrom,
    this.questionTo,
  });

  final int? sourceId;
  final List<int> sourceIds;
  final String? level;
  final Set<ExamSession> sessions;
  final Subject? subject;
  final Set<MondaiType> mondaiTypes;
  final String? title;
  final int? questionFrom;
  final int? questionTo;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PastExamPracticeArgs &&
          sourceId == other.sourceId &&
          level == other.level &&
          subject == other.subject &&
          title == other.title &&
          questionFrom == other.questionFrom &&
          questionTo == other.questionTo &&
          _listEquals(sourceIds, other.sourceIds) &&
          _setEquals(sessions, other.sessions) &&
          _setEquals(mondaiTypes, other.mondaiTypes);

  @override
  int get hashCode => Object.hash(
        sourceId,
        level,
        subject,
        title,
        questionFrom,
        questionTo,
        Object.hashAll(sourceIds),
        Object.hashAll(sessions),
        Object.hashAll(mondaiTypes),
      );

  static bool _setEquals<T>(Set<T> a, Set<T> b) =>
      a.length == b.length && a.containsAll(b);

  static bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

// ── Mondai Type UI Helpers ──────────────────────────────────────────────────

String mondaiTypeLabel(MondaiType t) {
  switch (t) {
    case MondaiType.kanjiReading:
      return 'Kanji Reading (漢字読み)';
    case MondaiType.orthography:
      return 'Orthography (表記)';
    case MondaiType.wordFormation:
      return 'Word Formation (語形成)';
    case MondaiType.context:
      return 'Context (文脈規定)';
    case MondaiType.paraphrase:
      return 'Paraphrase (言い換え)';
    case MondaiType.usage:
      return 'Usage (用法)';
    case MondaiType.grammarForm:
      return 'Grammar Form (文法形式)';
    case MondaiType.sentenceOrder:
      return 'Sentence Order (文の組み立て ★)';
    case MondaiType.textGrammar:
      return 'Text Grammar (文章の文法)';
    case MondaiType.reading:
      return 'Reading (読解)';
    case MondaiType.listening:
      return 'Listening (聴解)';
  }
}

String mondaiTypeShortLabel(MondaiType t) {
  switch (t) {
    case MondaiType.kanjiReading:
      return '漢字読み';
    case MondaiType.orthography:
      return '表記';
    case MondaiType.wordFormation:
      return '語形成';
    case MondaiType.context:
      return '文脈規定';
    case MondaiType.paraphrase:
      return '言い換え';
    case MondaiType.usage:
      return '用法';
    case MondaiType.grammarForm:
      return '文法形式';
    case MondaiType.sentenceOrder:
      return '文の組み立て ★';
    case MondaiType.textGrammar:
      return '文章の文法';
    case MondaiType.reading:
      return '読解';
    case MondaiType.listening:
      return '聴解';
  }
}

String mondaiTypeBurmeseDescription(MondaiType t) {
  switch (t) {
    case MondaiType.kanjiReading:
      return 'Kanji အသံထွက် မှန်ကန်စွာ ဖတ်နည်း';
    case MondaiType.orthography:
      return 'စာလုံးပေါင်း/Kanji ရေးထုံး မှန်ကန်မှု';
    case MondaiType.wordFormation:
      return 'စကားလုံး တွဲစပ်ဖွဲ့စည်းမှု';
    case MondaiType.context:
      return 'ဝါကျ အဓိပ္ပာယ်/စကားစပ် လိုက်ဖက်မှု';
    case MondaiType.paraphrase:
      return 'အဓိပ္ပာယ်တူ စကားလုံး ရွေးချယ်ခြင်း';
    case MondaiType.usage:
      return 'စကားလုံး အသုံးအနှုန်း မှန်ကန်မှု';
    case MondaiType.grammarForm:
      return 'ဝါကျ သဒ္ဒါပုံစံ ရွေးချယ်မှု';
    case MondaiType.sentenceOrder:
      return 'ဝါကျ စီစဉ်ဖွဲ့စည်းမှု (★ နေရာရှာခြင်း)';
    case MondaiType.textGrammar:
      return 'စာပိုဒ်တွင်း သဒ္ဒါ ရွေးချယ်မှု';
    case MondaiType.reading:
      return 'စာဖတ်စွမ်းရည် (စာပိုဒ်တို/အလတ်/သတင်းအချက်အလက်)';
    case MondaiType.listening:
      return 'နားထောင်စွမ်းရည် (အမေးအဖြေ/အချက်အလက်)';
  }
}

Color mondaiTypeColor(MondaiType t) {
  switch (t) {
    case MondaiType.kanjiReading:
    case MondaiType.orthography:
    case MondaiType.wordFormation:
    case MondaiType.context:
    case MondaiType.paraphrase:
    case MondaiType.usage:
      return const Color(0xFF10B981); // Emerald / vocab
    case MondaiType.grammarForm:
    case MondaiType.sentenceOrder:
    case MondaiType.textGrammar:
      return const Color(0xFF3B82F6); // Blue / grammar
    case MondaiType.reading:
      return const Color(0xFF8B5CF6); // Purple / reading
    case MondaiType.listening:
      return const Color(0xFFF59E0B); // Amber / listening
  }
}

Subject mondaiTypeSubject(MondaiType t) {
  switch (t) {
    case MondaiType.kanjiReading:
    case MondaiType.orthography:
    case MondaiType.wordFormation:
    case MondaiType.context:
    case MondaiType.paraphrase:
    case MondaiType.usage:
      return Subject.vocab;
    case MondaiType.grammarForm:
    case MondaiType.sentenceOrder:
    case MondaiType.textGrammar:
      return Subject.grammar;
    case MondaiType.reading:
      return Subject.reading;
    case MondaiType.listening:
      return Subject.listening;
  }
}
