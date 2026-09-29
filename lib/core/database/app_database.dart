import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

// ============================================================
// Enums (intEnum နဲ့ သိမ်းမယ် — နောက်ပိုင်း အစီအစဉ်မပြောင်းပါနဲ့၊ အဆုံးမှာပဲ ထပ်ထည့်ပါ)
// ============================================================

enum SourceType { kanjiBook, vocabBook, grammarBook, pastExam }

enum ReadingType { on, kun }

enum Subject { vocab, grammar, reading, listening }

enum MondaiType {
  kanjiReading, // 漢字読み
  orthography, // 表記
  wordFormation, // 語形成
  context, // 文脈規定
  paraphrase, // 言い換え類義
  usage, // 用法
  grammarForm, // 文法形式の判断
  sentenceOrder, // 文の組み立て (★)
  textGrammar, // 文章の文法
  reading, // 読解
  listening, // 聴解
}

enum ItemType { kanji, vocab, grammar, question }

/// Quiz direction (Kanji/Vocab အတွက်၊ question အတွက် none)
enum Direction { none, kanjiToReading, kanjiToMeaning, meaningToKanji }

enum QuizModeDb { practice, exam, reviewWrong, quick, flashcard }

// ============================================================
// 1) Content: စာအုပ် / စာမေးပွဲ / အခန်း
// ============================================================

/// စာအုပ် (Speed Master, Shinkanzen, Tango 2000 ...) နဲ့ စာမေးပွဲ (2019-12 N2) နှစ်ခုလုံး
@TableIndex(name: 'idx_sources_type_level', columns: {#type, #jlptLevel})
class Sources extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get type => intEnum<SourceType>()();
  TextColumn get name => text()();
  TextColumn get jlptLevel =>
      text().nullable()(); // 'N5'..'N1'၊ Level စုံတဲ့ စာအုပ်ဆို NULL
  IntColumn get examYear => integer().nullable()(); // pastExam အတွက်
  IntColumn get examMonth => integer().nullable()(); // 7 သို့ 12
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

/// အခန်း (Unit / Chapter / Week)
class Units extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sourceId =>
      integer().references(Sources, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()(); // "Unit 1", "第1週"
  IntColumn get orderNo => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {sourceId, orderNo},
      ];
}

// ============================================================
// 2) Kanji
// ============================================================

class Kanjis extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get character => text().unique()(); // 漢
  TextColumn get meaningMy => text().nullable()();
  TextColumn get meaningEn => text().nullable()();
  IntColumn get strokeCount => integer().nullable()();
  TextColumn get radical => text().nullable()();
}

@TableIndex(name: 'idx_kanji_readings_kanji', columns: {#kanjiId})
class KanjiReadings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get kanjiId =>
      integer().references(Kanjis, #id, onDelete: KeyAction.cascade)();
  IntColumn get type => intEnum<ReadingType>()();
  TextColumn get reading => text()(); // かん / おとこ
}

/// Kanji ဟာ စာအုပ်/အခန်း ဘယ်နေရာမှာ ပါလဲ (many-to-many)
@TableIndex(name: 'idx_kanji_items_source_unit', columns: {#sourceId, #unitId})
@TableIndex(name: 'idx_kanji_items_level', columns: {#jlptLevel})
class KanjiSourceItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get kanjiId =>
      integer().references(Kanjis, #id, onDelete: KeyAction.cascade)();
  IntColumn get sourceId =>
      integer().references(Sources, #id, onDelete: KeyAction.cascade)();
  IntColumn get unitId => integer()
      .nullable()
      .references(Units, #id, onDelete: KeyAction.setNull)();
  IntColumn get position => integer().withDefault(const Constant(0))();

  /// item အဆင့် level (source.jlptLevel ကို override)။ COALESCE(item, source) နဲ့ ယူ
  TextColumn get jlptLevel => text().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {kanjiId, sourceId},
      ];
}

// ============================================================
// 3) Vocabulary
// ============================================================

@TableIndex(name: 'idx_vocab_word', columns: {#word})
class Vocabularies extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get word => text()(); // 勉強
  TextColumn get reading => text()(); // べんきょう
  TextColumn get meaningMy => text().nullable()();
  TextColumn get meaningEn => text().nullable()();
  TextColumn get partOfSpeech => text().nullable()(); // 名詞, 動詞...
  TextColumn get exampleJp => text().nullable()();
  TextColumn get exampleMy => text().nullable()();
}

@TableIndex(name: 'idx_vocab_items_source_unit', columns: {#sourceId, #unitId})
@TableIndex(name: 'idx_vocab_items_level', columns: {#jlptLevel})
class VocabSourceItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get vocabId =>
      integer().references(Vocabularies, #id, onDelete: KeyAction.cascade)();
  IntColumn get sourceId =>
      integer().references(Sources, #id, onDelete: KeyAction.cascade)();
  IntColumn get unitId => integer()
      .nullable()
      .references(Units, #id, onDelete: KeyAction.setNull)();
  IntColumn get position => integer().withDefault(const Constant(0))();
  TextColumn get jlptLevel => text().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {vocabId, sourceId},
      ];
}

// ============================================================
// 3b) Kanji compounds (熟語)
//     တွဲလုံးကို vocabularies ထဲမှာ တစ်ခါတည်းသိမ်းပြီး kanji နဲ့ ဒီ table ကနေ ချိတ်မယ်။
//     - 維持 ကို 維 အောက်မှာရော 持 အောက်မှာပါ ပြချင်ရင် row ၂ ကြောင်းထည့် (vocab row က ၁ ခုတည်း)
//     - sourceId + position = စာအုပ်တစ်အုပ်ချင်းစီက kanji တစ်လုံးအောက်မှာ ပေးထားတဲ့ စာရင်းနဲ့ အစီအစဉ်
//     - Unit အလိုက် တွဲလုံး List/Quick/Flashcard သုံးဖို့ VocabSourceItems ကိုပါ တွဲထည့်ပါ
//     - တွဲလုံးရဲ့ progress က Progress(itemType: vocab) ကို ပြန်သုံး
// ============================================================

@TableIndex(
    name: 'idx_kanji_compounds_kanji_source', columns: {#kanjiId, #sourceId})
@TableIndex(name: 'idx_kanji_compounds_vocab', columns: {#vocabId})
class KanjiCompounds extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get kanjiId =>
      integer().references(Kanjis, #id, onDelete: KeyAction.cascade)();
  IntColumn get vocabId =>
      integer().references(Vocabularies, #id, onDelete: KeyAction.cascade)();
  IntColumn get sourceId =>
      integer().references(Sources, #id, onDelete: KeyAction.cascade)();

  /// kanji အောက်က စီစဉ်ပုံ (1..6)
  IntColumn get position => integer().withDefault(const Constant(0))();

  @override
  List<Set<Column>> get uniqueKeys => [
        {kanjiId, vocabId, sourceId},
      ];
}

// ============================================================
// 4) Grammar (Shinkanzen 文法 စတဲ့ grammar စာအုပ်အတွက်)
// ============================================================

class GrammarPoints extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get pattern => text()(); // ～ために
  TextColumn get connection => text().nullable()(); // 接続: V辞書形 / Nの
  TextColumn get meaningMy => text().nullable()();
  TextColumn get meaningEn => text().nullable()();
  TextColumn get exampleJp => text().nullable()();
  TextColumn get exampleMy => text().nullable()();
  TextColumn get note => text().nullable()();
}

@TableIndex(
    name: 'idx_grammar_items_source_unit', columns: {#sourceId, #unitId})
class GrammarSourceItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get grammarId =>
      integer().references(GrammarPoints, #id, onDelete: KeyAction.cascade)();
  IntColumn get sourceId =>
      integer().references(Sources, #id, onDelete: KeyAction.cascade)();
  IntColumn get unitId => integer()
      .nullable()
      .references(Units, #id, onDelete: KeyAction.setNull)();
  IntColumn get position => integer().withDefault(const Constant(0))();
  TextColumn get jlptLevel => text().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {grammarId, sourceId},
      ];
}

// ============================================================
// 5) Old Question (JLPT past exam)
// ============================================================

/// 問題 အမျိုးအစား + မူရင်း Instruction စာသား (Level အလိုက် ကွဲနိုင်လို့ level ပါ)
@DataClassName('MondaiTypeData')
class MondaiTypes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get type => intEnum<MondaiType>()();
  TextColumn get jlptLevel => text()();
  IntColumn get subject => intEnum<Subject>()();
  TextColumn get nameJp => text()(); // 漢字読み
  TextColumn get nameMy => text().nullable()();
  TextColumn get instructionJp => text().nullable()(); // 「＿＿の言葉の読み方として…」
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  List<Set<Column>> get uniqueKeys => [
        {type, jlptLevel},
      ];
}

/// စာပိုဒ်/အသံ တစ်ခုကို မေးခွန်းများစွာ မျှဝေသုံးတဲ့အခါ (読解, 文章の文法, 聴解)
class QuestionGroups extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sourceId =>
      integer().references(Sources, #id, onDelete: KeyAction.cascade)();
  IntColumn get mondaiTypeId => integer().references(MondaiTypes, #id)();
  IntColumn get mondaiNo => integer().nullable()();
  TextColumn get passage => text().nullable()();
  TextColumn get audioPath => text().nullable()();
  TextColumn get instructionOverride => text().nullable()();
}

@TableIndex(
    name: 'idx_questions_filter',
    columns: {#jlptLevel, #subject, #mondaiTypeId, #sourceId})
@TableIndex(name: 'idx_questions_source', columns: {#sourceId})
class Questions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sourceId => integer().references(Sources, #id,
      onDelete: KeyAction.cascade)(); // စာမေးပွဲ (နှစ်)
  TextColumn get jlptLevel => text()();
  IntColumn get subject => intEnum<Subject>()();
  IntColumn get mondaiTypeId => integer().references(MondaiTypes, #id)();
  IntColumn get groupId => integer()
      .nullable()
      .references(QuestionGroups, #id, onDelete: KeyAction.setNull)();
  IntColumn get mondaiNo => integer().nullable()(); // 問題1, 問題2 ...
  IntColumn get questionNo => integer().nullable()(); // မူရင်း နံပါတ်
  TextColumn get questionText => text()();
  TextColumn get targetWord => text().nullable()(); // underline စာလုံး
  TextColumn get audioPath => text().nullable()();

  /// 文の組み立て (★) အတွက်
  IntColumn get starPosition =>
      integer().nullable()(); // ★ က ကွက်ဘယ်နှစ်ခုမြောက်
  TextColumn get correctOrder => text().nullable()(); // JSON: [2,4,1,3]

  TextColumn get explanation => text().nullable()();
}

class QuestionChoices extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get questionId =>
      integer().references(Questions, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()(); // 1..4
  TextColumn get choiceText => text().named('text')();
  BoolColumn get isCorrect => boolean().withDefault(const Constant(false))();

  @override
  List<Set<Column>> get uniqueKeys => [
        {questionId, position},
      ];
}

// ============================================================
// 6) User data: Progress / SRS / Session
//    (Content table တွေနဲ့ သီးခြားထား — content update လုပ်လည်း progress မပျက်)
// ============================================================

@TableIndex(name: 'idx_progress_next_review', columns: {#nextReview})
class Progress extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get itemType => intEnum<ItemType>()();
  IntColumn get itemId => integer()();
  IntColumn get direction =>
      intEnum<Direction>().withDefault(const Constant(0))(); // Direction.none

  IntColumn get correctCount => integer().withDefault(const Constant(0))();
  IntColumn get wrongCount => integer().withDefault(const Constant(0))();
  IntColumn get streak => integer().withDefault(const Constant(0))();

  // SM-2 style SRS
  RealColumn get easeFactor => real().withDefault(const Constant(2.5))();
  IntColumn get intervalDays => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastReviewed => dateTime().nullable()();
  DateTimeColumn get nextReview => dateTime().nullable()();

  BoolColumn get isBookmarked => boolean().withDefault(const Constant(false))();

  @override
  List<Set<Column>> get uniqueKeys => [
        {itemType, itemId, direction},
      ];
}

class PracticeSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get mode => intEnum<QuizModeDb>()();
  IntColumn get contentType => intEnum<ItemType>()();
  TextColumn get filterJson =>
      text()(); // QuizFilter ကို JSON နဲ့ သိမ်း (ပြန်လုပ်လို့ရအောင်)
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get finishedAt => dateTime().nullable()();
  IntColumn get total => integer().withDefault(const Constant(0))();
  IntColumn get correct => integer().withDefault(const Constant(0))();
  IntColumn get durationSec => integer().withDefault(const Constant(0))();
}

@TableIndex(name: 'idx_session_answers_session', columns: {#sessionId})
class SessionAnswers extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer()
      .references(PracticeSessions, #id, onDelete: KeyAction.cascade)();
  IntColumn get itemType => intEnum<ItemType>()();
  IntColumn get itemId => integer()();
  IntColumn get direction =>
      intEnum<Direction>().withDefault(const Constant(0))();
  IntColumn get chosenIndex => integer().nullable()(); // မဖြေရင် NULL
  BoolColumn get isCorrect => boolean()();
  IntColumn get timeMs => integer().withDefault(const Constant(0))();
}

// ============================================================
// Database
// ============================================================

@DriftDatabase(tables: [
  Sources,
  Units,
  Kanjis,
  KanjiReadings,
  KanjiSourceItems,
  Vocabularies,
  VocabSourceItems,
  KanjiCompounds,
  GrammarPoints,
  GrammarSourceItems,
  MondaiTypes,
  QuestionGroups,
  Questions,
  QuestionChoices,
  Progress,
  PracticeSessions,
  SessionAnswers,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'jlpt_practice'));

  /// Test အတွက် (in-memory DB ထည့်နိုင်အောင်)
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          // schemaVersion မြှင့်တဲ့အခါ ဒီမှာ step-by-step migration ရေး
          // if (from < 2) { await m.addColumn(...); }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}
