import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:practice_janpanese/core/database/app_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _kDevSeedVersionKey = 'dev_seed_completed_version';
const int _kCurrentDevSeedVersion = 25;

/// Seeds the database with realistic development data per spec B1.
/// Runs only when the database is empty or new exam datasets were added.
Future<void> seedDevData(AppDatabase db, {SharedPreferences? prefs}) async {
  if (!kDebugMode) return;

  if (prefs != null) {
    final completedVersion = prefs.getInt(_kDevSeedVersionKey) ?? 0;
    if (completedVersion >= _kCurrentDevSeedVersion) {
      return; // Already seeded up to current version!
    }
  }

  final sourceCount = await db.sources.count().getSingle();
  if (sourceCount > 0) {
    await _ensureTangoLevelN3(db);
    await _updateTangoIfCorrupted(db);
    await _ensureSpeedMasterN3Kanji(db, DateTime.now());
    await _ensurePastExam201007(db, DateTime.now());
    await _ensurePastExam201012(db, DateTime.now());
    await _ensurePastExam201107(db, DateTime.now());
    await _ensurePastExam201112(db, DateTime.now());
    await _ensurePastExam201207(db, DateTime.now());
    await _ensurePastExam201212(db, DateTime.now());
    await _ensurePastExam201307(db, DateTime.now());
    await _ensurePastExam201312(db, DateTime.now());
    await _ensurePastExam201407(db, DateTime.now());
    await _ensurePastExam201412(db, DateTime.now());
    await _ensurePastExam201512(db, DateTime.now());
    await _ensurePastExam201607(db, DateTime.now());
    await _ensurePastExam201612(db, DateTime.now());
    await _ensurePastExam201707(db, DateTime.now());
    await _ensurePastExam201712(db, DateTime.now());
    await _ensurePastExam201807(db, DateTime.now());
    await _ensurePastExam201912(db, DateTime.now());
    await _ensurePastExam202012(db, DateTime.now());
    await _ensurePastExam202107(db, DateTime.now());
    await _ensurePastExam202112(db, DateTime.now());
    await _ensurePastExam202207(db, DateTime.now());
    await _ensurePastExam202212(db, DateTime.now());
    await _ensurePastExam202307(db, DateTime.now());
    await _ensurePastExam202312(db, DateTime.now());
    await _ensurePastExam202407(db, DateTime.now());
    if (prefs != null) {
      await prefs.setInt(_kDevSeedVersionKey, _kCurrentDevSeedVersion);
    }
    return;
  }

  final now = DateTime.now();

  await db.transaction(() async {
    // ────────────────────────────────────────────────────────────────────────
    // 1) Kanji Books
    // ────────────────────────────────────────────────────────────────────────

    // Book 1: Speed Master N2 (3 units × 4 kanji)
    final speedMasterN2Id = await db.into(db.sources).insert(
          SourcesCompanion.insert(
            type: SourceType.kanjiBook,
            name: 'Speed Master N2 漢字',
            jlptLevel: const Value('N2'),
            sortOrder: const Value(1),
          ),
        );

    final smN2Unit1 = await db.into(db.units).insert(
          UnitsCompanion.insert(
            sourceId: speedMasterN2Id,
            name: 'Unit 1: 政治・社会',
            orderNo: 1,
          ),
        );
    final smN2Unit2 = await db.into(db.units).insert(
          UnitsCompanion.insert(
            sourceId: speedMasterN2Id,
            name: 'Unit 2: 法律・裁判',
            orderNo: 2,
          ),
        );
    final smN2Unit3 = await db.into(db.units).insert(
          UnitsCompanion.insert(
            sourceId: speedMasterN2Id,
            name: 'Unit 3: 規則・制度',
            orderNo: 3,
          ),
        );

    final smN2Kanjis = [
      // Unit 1
      (char: '議', on: 'ギ', kun: '', my: 'ဆွေးနွေးတိုင်ပင်သည်', unit: smN2Unit1),
      (char: '選', on: 'セン', kun: 'えら・ぶ', my: 'ရွေးချယ်သည်', unit: smN2Unit1),
      (
        char: '挙',
        on: 'キョ',
        kun: 'あ・げる',
        my: 'မြှောက်သည် / ရွေးကောက်ပွဲ',
        unit: smN2Unit1
      ),
      (char: '票', on: 'ヒョウ', kun: '', my: 'မဲပြား / လက်မှတ်', unit: smN2Unit1),
      // Unit 2
      (char: '裁', on: 'サイ', kun: 'さば・く', my: 'တရားစီရင်သည်', unit: smN2Unit2),
      (
        char: '判',
        on: 'ハン',
        kun: '',
        my: 'ဆုံးဖြတ်သည် / စီရင်သည်',
        unit: smN2Unit2
      ),
      (char: '訟', on: 'ショウ', kun: '', my: 'တရားစွဲဆိုသည်', unit: smN2Unit2),
      (char: '訴', on: 'ソ', kun: 'うった・える', my: 'တိုင်ကြားသည်', unit: smN2Unit2),
      // Unit 3
      (char: '権', on: 'ケン', kun: '', my: 'အခွင့်အာဏာ', unit: smN2Unit3),
      (char: '規', on: 'キ', kun: '', my: 'စည်းကမ်း / စံနှုန်း', unit: smN2Unit3),
      (char: '則', on: 'ソク', kun: '', my: 'ဥပဒေသ / စည်းမျဉ်း', unit: smN2Unit3),
      (
        char: '憲',
        on: 'ケン',
        kun: '',
        my: 'ဖွဲ့စည်းပုံအခြေခံဥပဒေ',
        unit: smN2Unit3
      ),
    ];

    for (var i = 0; i < smN2Kanjis.length; i++) {
      final k = smN2Kanjis[i];
      final kanjiId = await db.into(db.kanjis).insert(
            KanjisCompanion.insert(
              character: k.char,
              meaningMy: Value(k.my),
            ),
          );
      if (k.on.isNotEmpty) {
        await db.into(db.kanjiReadings).insert(
              KanjiReadingsCompanion.insert(
                kanjiId: kanjiId,
                type: ReadingType.on,
                reading: k.on,
              ),
            );
      }
      if (k.kun.isNotEmpty) {
        await db.into(db.kanjiReadings).insert(
              KanjiReadingsCompanion.insert(
                kanjiId: kanjiId,
                type: ReadingType.kun,
                reading: k.kun,
              ),
            );
      }
      await db.into(db.kanjiSourceItems).insert(
            KanjiSourceItemsCompanion.insert(
              kanjiId: kanjiId,
              sourceId: speedMasterN2Id,
              unitId: Value(k.unit),
              position: Value(i % 4 + 1),
              jlptLevel: const Value('N2'),
            ),
          );

      // Seed progress: First 2 kanji in Unit 1 are mastered (streak >= 3)
      if (i < 2) {
        await db.into(db.progress).insert(
              ProgressCompanion.insert(
                itemType: ItemType.kanji,
                itemId: kanjiId,
                streak: const Value(4),
                correctCount: const Value(5),
                lastReviewed: Value(now.subtract(const Duration(days: 2))),
                nextReview: Value(now.add(const Duration(days: 5))),
              ),
            );
      }
      // 3rd kanji is due for review
      if (i == 2) {
        await db.into(db.progress).insert(
              ProgressCompanion.insert(
                itemType: ItemType.kanji,
                itemId: kanjiId,
                streak: const Value(1),
                correctCount: const Value(2),
                lastReviewed: Value(now.subtract(const Duration(days: 3))),
                nextReview: Value(now.subtract(const Duration(hours: 1))),
              ),
            );
      }
    }

    // Book 2: Shinkanzen N3 (3 units × 4 kanji, distinct characters)
    final shinkanzenN3Id = await db.into(db.sources).insert(
          SourcesCompanion.insert(
            type: SourceType.kanjiBook,
            name: 'Shinkanzen N3 漢字',
            jlptLevel: const Value('N3'),
            sortOrder: const Value(2),
          ),
        );

    final skN3Unit1 = await db.into(db.units).insert(
          UnitsCompanion.insert(
            sourceId: shinkanzenN3Id,
            name: 'Unit 1: 役所・窓口',
            orderNo: 1,
          ),
        );
    final skN3Unit2 = await db.into(db.units).insert(
          UnitsCompanion.insert(
            sourceId: shinkanzenN3Id,
            name: 'Unit 2: 道具・生活',
            orderNo: 2,
          ),
        );
    final skN3Unit3 = await db.into(db.units).insert(
          UnitsCompanion.insert(
            sourceId: shinkanzenN3Id,
            name: 'Unit 3: 買い物・計算',
            orderNo: 3,
          ),
        );

    final skN3Kanjis = [
      // Unit 1
      (char: '役', on: 'ヤク', kun: '', my: 'တာဝန် / ရုံးဌာန', unit: skN3Unit1),
      (char: '所', on: 'ショ', kun: 'ところ', my: 'နေရာ / ဌာန', unit: skN3Unit1),
      (
        char: '窓',
        on: 'ソウ',
        kun: 'まど',
        my: 'ပြတင်းပေါက် / ကောင်တာ',
        unit: skN3Unit1
      ),
      (char: '口', on: 'コウ', kun: 'くち', my: 'ပါးစပ် / အပေါက်', unit: skN3Unit1),
      // Unit 2
      (
        char: '具',
        on: 'グ',
        kun: '',
        my: 'ကိရိယာ / အသုံးအဆောင်',
        unit: skN3Unit2
      ),
      (
        char: '支',
        on: 'シ',
        kun: 'ささ・える',
        my: 'ထောက်ပံ့သည် / ပေးချေသည်',
        unit: skN3Unit2
      ),
      (char: '払', on: 'フツ', kun: 'はら・う', my: 'ပေးချေသည်', unit: skN3Unit2),
      (
        char: '済',
        on: 'サイ',
        kun: 'す・む',
        my: 'ပြီးဆုံးသည် / ပြီးစီးသည်',
        unit: skN3Unit2
      ),
      // Unit 3
      (
        char: '割',
        on: 'カツ',
        kun: 'わ・る',
        my: 'ခွဲခြမ်းသည် / လျှော့စျေး',
        unit: skN3Unit3
      ),
      (char: '算', on: 'サン', kun: '', my: 'တွက်ချက်သည်', unit: skN3Unit3),
      (
        char: '引',
        on: 'イン',
        kun: 'ひ・く',
        my: 'ဆွဲသည် / လျှော့သည်',
        unit: skN3Unit3
      ),
      (
        char: '混',
        on: 'コン',
        kun: 'ま・ぜる',
        my: 'ရောနှောသည် / ရှုပ်ထွေးသည်',
        unit: skN3Unit3
      ),
    ];

    for (var i = 0; i < skN3Kanjis.length; i++) {
      final k = skN3Kanjis[i];
      final kanjiId = await db.into(db.kanjis).insert(
            KanjisCompanion.insert(
              character: k.char,
              meaningMy: Value(k.my),
            ),
          );
      if (k.on.isNotEmpty) {
        await db.into(db.kanjiReadings).insert(
              KanjiReadingsCompanion.insert(
                kanjiId: kanjiId,
                type: ReadingType.on,
                reading: k.on,
              ),
            );
      }
      if (k.kun.isNotEmpty) {
        await db.into(db.kanjiReadings).insert(
              KanjiReadingsCompanion.insert(
                kanjiId: kanjiId,
                type: ReadingType.kun,
                reading: k.kun,
              ),
            );
      }
      await db.into(db.kanjiSourceItems).insert(
            KanjiSourceItemsCompanion.insert(
              kanjiId: kanjiId,
              sourceId: shinkanzenN3Id,
              unitId: Value(k.unit),
              position: Value(i % 4 + 1),
              jlptLevel: const Value('N3'),
            ),
          );

      // Progress: Unit 1 first 3 kanji mastered
      if (i < 3) {
        await db.into(db.progress).insert(
              ProgressCompanion.insert(
                itemType: ItemType.kanji,
                itemId: kanjiId,
                streak: const Value(3),
                correctCount: const Value(4),
                lastReviewed: Value(now.subtract(const Duration(days: 1))),
                nextReview: Value(now.add(const Duration(days: 3))),
              ),
            );
      }
    }

    // ────────────────────────────────────────────────────────────────────────
    // Kanji Book 3: Speed Master N3 (10 chapters, 174 kanji from JSON asset)
    // ────────────────────────────────────────────────────────────────────────
    await _seedSpeedMasterN3KanjiFromJson(db, now);

    // ────────────────────────────────────────────────────────────────────────
    // 2) Vocab Book: Tango 2000 (all 60 sections, 1393 words from JSON asset)
    // ────────────────────────────────────────────────────────────────────────
    await _seedTangoFromJson(db, now);

    // ────────────────────────────────────────────────────────────────────────
    // 3) Grammar Book: Shinkanzen 文法 N2 (2 units × 3 patterns)
    // ────────────────────────────────────────────────────────────────────────
    final shinkanzenGrammarN2Id = await db.into(db.sources).insert(
          SourcesCompanion.insert(
            type: SourceType.grammarBook,
            name: 'Shinkanzen 文法 N2',
            jlptLevel: const Value('N2'),
            sortOrder: const Value(4),
          ),
        );

    final grammarUnit1 = await db.into(db.units).insert(
          UnitsCompanion.insert(
            sourceId: shinkanzenGrammarN2Id,
            name: 'Unit 1: 時・契機',
            orderNo: 1,
          ),
        );
    final grammarUnit2 = await db.into(db.units).insert(
          UnitsCompanion.insert(
            sourceId: shinkanzenGrammarN2Id,
            name: 'Unit 2: 範囲・限定',
            orderNo: 2,
          ),
        );

    final grammarPatterns = [
      // Unit 1
      (
        title: '〜に際して',
        meaning: '〜လုပ်သည့်အခါ / အချိန်တွင် (တရားဝင်)',
        formation: 'V-ru / N + に際して',
        unit: grammarUnit1,
      ),
      (
        title: '〜を契機に',
        meaning: '〜ကို အကြောင်းပြု၍ / အစပြုကာ',
        formation: 'N + を契機に',
        unit: grammarUnit1,
      ),
      (
        title: '〜につけ',
        meaning: '〜တိုင်း / ဖြစ်တိုင်း',
        formation: 'V-ru + につけ',
        unit: grammarUnit1,
      ),
      // Unit 2
      (
        title: '〜をはじめ',
        meaning: '〜အပါအဝင် / ဦးစွာထား၍',
        formation: 'N + をはじめ',
        unit: grammarUnit2,
      ),
      (
        title: '〜を問わず',
        meaning: '〜ကို မခွဲခြားဘဲ / မသက်ဆိုင်ဘဲ',
        formation: 'N + を問わず',
        unit: grammarUnit2,
      ),
      (
        title: '〜のもとで',
        meaning: '〜၏ လက်အောက်တွင် / လမ်းညွှန်မှုအောက်တွင်',
        formation: 'N + のもとで',
        unit: grammarUnit2,
      ),
    ];

    for (var i = 0; i < grammarPatterns.length; i++) {
      final g = grammarPatterns[i];
      final grammarPointId = await db.into(db.grammarPoints).insert(
            GrammarPointsCompanion.insert(
              pattern: g.title,
              meaningMy: Value(g.meaning),
              connection: Value(g.formation),
            ),
          );
      await db.into(db.grammarSourceItems).insert(
            GrammarSourceItemsCompanion.insert(
              grammarId: grammarPointId,
              sourceId: shinkanzenGrammarN2Id,
              unitId: Value(g.unit),
              position: Value(i % 3 + 1),
              jlptLevel: const Value('N2'),
            ),
          );

      // Progress: Unit 1 first pattern mastered
      if (i == 0) {
        await db.into(db.progress).insert(
              ProgressCompanion.insert(
                itemType: ItemType.grammar,
                itemId: grammarPointId,
                streak: const Value(3),
                correctCount: const Value(4),
                lastReviewed: Value(now.subtract(const Duration(days: 1))),
                nextReview: Value(now.add(const Duration(days: 6))),
              ),
            );
      }
    }

    // ────────────────────────────────────────────────────────────────────────
    // 4) Past Exam: 2010年07月 & 2011年07月 JLPT N3
    // ────────────────────────────────────────────────────────────────────────
    await _seedPastExamFromJson(
      db,
      now,
      'assets/data/jlpt_n3_2010_07.json',
      sortOrder: 1,
    );
    await _seedPastExamFromJson(
      db,
      now,
      'assets/data/jlpt_n3_2010_12.json',
      sortOrder: 2,
    );
    await _seedPastExamFromJson(
      db,
      now,
      'assets/data/jlpt_n3_2011_07.json',
      sortOrder: 2,
    );
    await _seedPastExamFromJson(
      db,
      now,
      'assets/data/jlpt_n3_2011_12.json',
      sortOrder: 3,
    );
    await _seedPastExamFromJson(
      db,
      now,
      'assets/data/jlpt_n3_2012_07.json',
      sortOrder: 3,
    );
    await _seedPastExamFromJson(
      db,
      now,
      'assets/data/jlpt_n3_2012_12.json',
      sortOrder: 4,
    );
    await _seedPastExamFromJson(
      db,
      now,
      'assets/data/jlpt_n3_2013_07.json',
      sortOrder: 4,
    );
    await _seedPastExamFromJson(
      db,
      now,
      'assets/data/jlpt_n3_2013_12.json',
      sortOrder: 5,
    );
    await _seedPastExamFromJson(
      db,
      now,
      'assets/data/jlpt_n3_2014_07.json',
      sortOrder: 5,
    );
    await _seedPastExamFromJson(
      db,
      now,
      'assets/data/jlpt_n3_2014_12.json',
      sortOrder: 6,
    );
    await _seedPastExamFromJson(
      db,
      now,
      'assets/data/jlpt_n3_2015_12.json',
      sortOrder: 6,
    );
    await _seedPastExamFromJson(
      db,
      now,
      'assets/data/jlpt_n3_2016_07.json',
      sortOrder: 6,
    );
    await _seedPastExamFromJson(
      db,
      now,
      'assets/data/jlpt_n3_2016_12.json',
      sortOrder: 7,
    );
    await _seedPastExamFromJson(
      db,
      now,
      'assets/data/jlpt_n3_2017_07.json',
      sortOrder: 7,
    );
    await _seedPastExamFromJson(
      db,
      now,
      'assets/data/jlpt_n3_2017_12.json',
      sortOrder: 7,
    );
    await _seedPastExamFromJson(
      db,
      now,
      'assets/data/jlpt_n3_2018_07.json',
      sortOrder: 8,
    );
    await _seedPastExamFromJson(
      db,
      now,
      'assets/data/jlpt_n3_2019_12.json',
      sortOrder: 8,
    );
    await _seedPastExamFromJson(
      db,
      now,
      'assets/data/jlpt_n3_2020_12.json',
      sortOrder: 8,
    );
    await _seedPastExamFromJson(
      db,
      now,
      'assets/data/jlpt_n3_2021_07.json',
      sortOrder: 9,
    );
    await _seedPastExamFromJson(
      db,
      now,
      'assets/data/jlpt_n3_2021_12.json',
      sortOrder: 9,
    );
    await _seedPastExamFromJson(
      db,
      now,
      'assets/data/jlpt_n3_2022_07.json',
      sortOrder: 10,
    );
    await _seedPastExamFromJson(
      db,
      now,
      'assets/data/jlpt_n3_2022_12.json',
      sortOrder: 10,
    );
    await _seedPastExamFromJson(
      db,
      now,
      'assets/data/jlpt_n3_2023_07.json',
      sortOrder: 11,
    );
    await _seedPastExamFromJson(
      db,
      now,
      'assets/data/jlpt_n3_2023_12.json',
      sortOrder: 11,
    );
    await _seedPastExamFromJson(
      db,
      now,
      'assets/data/jlpt_n3_2024_07.json',
      sortOrder: 12,
    );
  });

  if (prefs != null) {
    await prefs.setInt(_kDevSeedVersionKey, _kCurrentDevSeedVersion);
  }
}

/// Loads Tango 2000 vocabulary from [assets/data/tango_2000_n3.json]
/// into [Sources], [Units], [Vocabularies], and [VocabSourceItems].
Future<void> _seedTangoFromJson(AppDatabase db, DateTime now) async {
  String? jsonStr;
  try {
    jsonStr = await rootBundle.loadString('assets/data/tango_2000_n3.json');
  } catch (_) {
    if (!kIsWeb) {
      final file = File('assets/data/tango_2000_n3.json');
      if (file.existsSync()) {
        jsonStr = await file.readAsString();
      }
    }
  }

  if (jsonStr == null || jsonStr.isEmpty) return;

  final data = jsonDecode(jsonStr) as Map<String, dynamic>;
  final bookLevel = data['level'] as String? ?? 'N3';
  final sections = data['sections'] as List<dynamic>;

  final tango2000Id = await db.into(db.sources).insert(
        SourcesCompanion.insert(
          type: SourceType.vocabBook,
          name: 'Tango 2000',
          jlptLevel: Value(bookLevel),
          sortOrder: const Value(3),
        ),
      );

  for (var sIdx = 0; sIdx < sections.length; sIdx++) {
    final sec = sections[sIdx] as Map<String, dynamic>;
    final secTitle = sec['title'] as String;
    final words = sec['words'] as List<dynamic>;

    final unitId = await db.into(db.units).insert(
          UnitsCompanion.insert(
            sourceId: tango2000Id,
            name: secTitle,
            orderNo: sIdx + 1,
          ),
        );

    for (var wIdx = 0; wIdx < words.length; wIdx++) {
      final w = words[wIdx] as Map<String, dynamic>;
      final wordStr = w['word'] as String;
      final readingStr = w['reading'] as String;
      final meaningStr = w['meaning'] as String;

      final vocabId = await db.into(db.vocabularies).insert(
            VocabulariesCompanion.insert(
              word: wordStr,
              reading: readingStr,
              meaningMy: Value(meaningStr),
            ),
          );

      await db.into(db.vocabSourceItems).insert(
            VocabSourceItemsCompanion.insert(
              vocabId: vocabId,
              sourceId: tango2000Id,
              unitId: Value(unitId),
              position: Value(wIdx + 1),
              jlptLevel: const Value('N3'),
            ),
          );

      // Seed progress: First 2 vocab in Unit 1 are mastered (streak >= 3)
      if (sIdx == 0 && wIdx < 2) {
        await db.into(db.progress).insert(
              ProgressCompanion.insert(
                itemType: ItemType.vocab,
                itemId: vocabId,
                streak: const Value(3),
                correctCount: const Value(3),
                lastReviewed: Value(now.subtract(const Duration(days: 2))),
                nextReview: Value(now.add(const Duration(days: 4))),
              ),
            );
      }
      // Unit 2 first item is due for review
      if (sIdx == 1 && wIdx == 0) {
        await db.into(db.progress).insert(
              ProgressCompanion.insert(
                itemType: ItemType.vocab,
                itemId: vocabId,
                streak: const Value(1),
                correctCount: const Value(1),
                lastReviewed: Value(now.subtract(const Duration(days: 2))),
                nextReview: Value(now.subtract(const Duration(minutes: 30))),
              ),
            );
      }
    }
  }
}

/// Automatically updates corrupted/stale Tango 2000 vocabulary meanings and
/// unit titles in an already seeded database to standard Myanmar Unicode.
Future<void> _updateTangoIfCorrupted(AppDatabase db) async {
  final corruptedUnit = await (db.units.select()
        ..where((u) => u.name.contains('ြိသာားစု'))
        ..limit(1))
      .getSingleOrNull();

  final corruptedVocab = await (db.vocabularies.select()
        ..where((v) => v.meaningMy.contains('အကြီးဆြီး'))
        ..limit(1))
      .getSingleOrNull();

  if (corruptedUnit == null && corruptedVocab == null) return;

  String? jsonStr;
  try {
    jsonStr = await rootBundle.loadString('assets/data/tango_2000_n3.json');
  } catch (_) {
    if (!kIsWeb) {
      final file = File('assets/data/tango_2000_n3.json');
      if (file.existsSync()) {
        jsonStr = await file.readAsString();
      }
    }
  }
  if (jsonStr == null || jsonStr.isEmpty) return;

  final data = jsonDecode(jsonStr) as Map<String, dynamic>;
  final sections = data['sections'] as List<dynamic>;

  await db.transaction(() async {
    for (var sIdx = 0; sIdx < sections.length; sIdx++) {
      final sec = sections[sIdx] as Map<String, dynamic>;
      final secTitle = sec['title'] as String;
      final words = sec['words'] as List<dynamic>;

      await (db.update(db.units)..where((u) => u.orderNo.equals(sIdx + 1)))
          .write(UnitsCompanion(name: Value(secTitle)));

      for (final w in words) {
        final wordMap = w as Map<String, dynamic>;
        final wordStr = wordMap['word'] as String;
        final readingStr = wordMap['reading'] as String;
        final meaningStr = wordMap['meaning'] as String;

        await (db.update(db.vocabularies)
              ..where(
                (v) => v.word.equals(wordStr) & v.reading.equals(readingStr),
              ))
            .write(VocabulariesCompanion(meaningMy: Value(meaningStr)));
      }
    }
  });
}

/// Ensures Tango 2000 has its jlptLevel set to N3 in an already seeded database.
Future<void> _ensureTangoLevelN3(AppDatabase db) async {
  await (db.update(db.sources)
        ..where(
          (s) =>
              s.name.contains('Tango 2000') &
              (s.jlptLevel.isNull() | s.jlptLevel.isNotValue('N3')),
        ))
      .write(const SourcesCompanion(jlptLevel: Value('N3')));
}

/// Ensures Speed Master N3 Kanji and its companion Vocab source are seeded in an already populated database.
Future<void> _ensureSpeedMasterN3Kanji(AppDatabase db, DateTime now) async {
  final existingKanjiSource = await (db.sources.select()
        ..where((s) => s.name.equals('Speed Master N3 漢字')))
      .getSingleOrNull();

  final existingVocabSource = await (db.sources.select()
        ..where((s) => s.name.equals('Speed Master N3 語彙 (Kanji တွဲလုံးများ)')))
      .getSingleOrNull();

  if (existingKanjiSource != null && existingVocabSource != null) {
    final unitCount = await (db.units.select()
          ..where((u) => u.sourceId.equals(existingKanjiSource.id)))
        .get()
        .then((l) => l.length);
    if (unitCount >= 25) return;
  }

  await db.transaction(() async {
    await _seedSpeedMasterN3KanjiFromJson(db, now);
  });
}

/// Seeds Speed Master N3 Kanji and its companion Vocab source from assets/data/kanji_speed_master_n3.json.
Future<void> _seedSpeedMasterN3KanjiFromJson(
  AppDatabase db,
  DateTime now,
) async {
  String? jsonStr;
  try {
    jsonStr =
        await rootBundle.loadString('assets/data/kanji_speed_master_n3.json');
  } catch (_) {
    if (!kIsWeb) {
      final file = File('assets/data/kanji_speed_master_n3.json');
      if (file.existsSync()) {
        jsonStr = await file.readAsString();
      }
    }
  }

  if (jsonStr == null || jsonStr.isEmpty) return;

  final data = jsonDecode(jsonStr) as Map<String, dynamic>;
  final bookTitle = data['book'] as String? ??
      data['title'] as String? ??
      'Speed Master N3 漢字';
  final bookLevel = data['level'] as String? ?? 'N3';
  final chapters = data['chapters'] as List<dynamic>;

  // 1) Kanji Source
  final kanjiSource = await (db.sources.select()
        ..where((s) => s.name.equals(bookTitle)))
      .getSingleOrNull();

  int kanjiSourceId;
  if (kanjiSource == null) {
    kanjiSourceId = await db.into(db.sources).insert(
          SourcesCompanion.insert(
            type: SourceType.kanjiBook,
            name: bookTitle,
            jlptLevel: Value(bookLevel),
            sortOrder: const Value(1),
          ),
        );
  } else {
    kanjiSourceId = kanjiSource.id;
  }

  // 2) Companion Vocab Source for compound words (語彙)
  const vocabBookTitle = 'Speed Master N3 語彙 (Kanji တွဲလုံးများ)';
  final vocabSource = await (db.sources.select()
        ..where((s) => s.name.equals(vocabBookTitle)))
      .getSingleOrNull();

  int vocabSourceId;
  if (vocabSource == null) {
    vocabSourceId = await db.into(db.sources).insert(
          SourcesCompanion.insert(
            type: SourceType.vocabBook,
            name: vocabBookTitle,
            jlptLevel: Value(bookLevel),
            sortOrder: const Value(2),
          ),
        );
  } else {
    vocabSourceId = vocabSource.id;
  }

  final seenVocabInSource = <int>{};

  for (final chObj in chapters) {
    final ch = chObj as Map<String, dynamic>;
    final chNum = ch['chapter'] as int;
    final chTitle = ch['title'] as String;
    final kanjiList = ch['kanjis'] as List<dynamic>;

    // Kanji Unit
    final kanjiUnit = await (db.units.select()
          ..where(
            (u) => u.sourceId.equals(kanjiSourceId) & u.orderNo.equals(chNum),
          ))
        .getSingleOrNull();
    int kanjiUnitId;
    if (kanjiUnit == null) {
      kanjiUnitId = await db.into(db.units).insert(
            UnitsCompanion.insert(
              sourceId: kanjiSourceId,
              name: chTitle,
              orderNo: chNum,
            ),
          );
    } else {
      kanjiUnitId = kanjiUnit.id;
    }

    // Vocab Unit
    final vocabUnit = await (db.units.select()
          ..where(
            (u) => u.sourceId.equals(vocabSourceId) & u.orderNo.equals(chNum),
          ))
        .getSingleOrNull();
    int vocabUnitId;
    if (vocabUnit == null) {
      vocabUnitId = await db.into(db.units).insert(
            UnitsCompanion.insert(
              sourceId: vocabSourceId,
              name: chTitle,
              orderNo: chNum,
            ),
          );
    } else {
      vocabUnitId = vocabUnit.id;
    }

    var vocabPositionInChapter = 1;

    for (var kIdx = 0; kIdx < kanjiList.length; kIdx++) {
      final k = kanjiList[kIdx] as Map<String, dynamic>;
      final char = k['character'] as String;
      final on = k['onyomi'] as String? ?? '';
      final kun = k['kunyomi'] as String? ?? '';
      final my = k['meaning'] as String? ?? '';
      final vocabList = (k['vocab'] as List<dynamic>?) ?? [];

      final existingKanji = await (db.kanjis.select()
            ..where((item) => item.character.equals(char)))
          .getSingleOrNull();

      int kanjiId;
      if (existingKanji != null) {
        kanjiId = existingKanji.id;
        if (existingKanji.meaningMy == null ||
            existingKanji.meaningMy!.isEmpty) {
          await (db.update(db.kanjis)..where((item) => item.id.equals(kanjiId)))
              .write(KanjisCompanion(meaningMy: Value(my)));
        }
      } else {
        kanjiId = await db.into(db.kanjis).insert(
              KanjisCompanion.insert(
                character: char,
                meaningMy: Value(my),
              ),
            );
      }

      final existingReadings = await (db.kanjiReadings.select()
            ..where((r) => r.kanjiId.equals(kanjiId)))
          .get();
      final existingKeys =
          existingReadings.map((r) => '${r.type}_${r.reading}').toSet();

      if (on.isNotEmpty && !existingKeys.contains('${ReadingType.on}_$on')) {
        await db.into(db.kanjiReadings).insert(
              KanjiReadingsCompanion.insert(
                kanjiId: kanjiId,
                type: ReadingType.on,
                reading: on,
              ),
            );
      }
      if (kun.isNotEmpty && !existingKeys.contains('${ReadingType.kun}_$kun')) {
        await db.into(db.kanjiReadings).insert(
              KanjiReadingsCompanion.insert(
                kanjiId: kanjiId,
                type: ReadingType.kun,
                reading: kun,
              ),
            );
      }

      final existingKsi = await (db.kanjiSourceItems.select()
            ..where(
              (ksi) =>
                  ksi.kanjiId.equals(kanjiId) &
                  ksi.sourceId.equals(kanjiSourceId),
            ))
          .getSingleOrNull();

      if (existingKsi == null) {
        await db.into(db.kanjiSourceItems).insert(
              KanjiSourceItemsCompanion.insert(
                kanjiId: kanjiId,
                sourceId: kanjiSourceId,
                unitId: Value(kanjiUnitId),
                position: Value(kIdx + 1),
                jlptLevel: Value(bookLevel),
              ),
            );
      }

      // Seed initial progress for Chapter 1
      if (chNum == 1 && kIdx < 3) {
        final existingProg = await (db.progress.select()
              ..where(
                (p) =>
                    p.itemType.equals(ItemType.kanji.index) &
                    p.itemId.equals(kanjiId),
              ))
            .getSingleOrNull();
        if (existingProg == null) {
          await db.into(db.progress).insert(
                ProgressCompanion.insert(
                  itemType: ItemType.kanji,
                  itemId: kanjiId,
                  streak: const Value(3),
                  correctCount: const Value(4),
                  lastReviewed: Value(now.subtract(const Duration(days: 1))),
                  nextReview: Value(now.add(const Duration(days: 3))),
                ),
              );
        }
      }

      // 3) Process compound words (語彙)
      for (var vIdx = 0; vIdx < vocabList.length; vIdx++) {
        final v = vocabList[vIdx] as Map<String, dynamic>;
        final wordStr = (v['word'] as String? ?? '').trim();
        final readingStr = (v['reading'] as String? ?? '').trim();
        final meaningStr = (v['meaning'] as String? ?? '').trim();

        if (wordStr.isEmpty) continue;

        final existingVocab = await (db.vocabularies.select()
              ..where(
                (item) =>
                    item.word.equals(wordStr) & item.reading.equals(readingStr),
              ))
            .getSingleOrNull();

        int vocabId;
        if (existingVocab != null) {
          vocabId = existingVocab.id;
          if ((existingVocab.meaningMy?.isEmpty ?? true) &&
              meaningStr.isNotEmpty) {
            await (db.update(db.vocabularies)
                  ..where((item) => item.id.equals(vocabId)))
                .write(VocabulariesCompanion(meaningMy: Value(meaningStr)));
          }
        } else {
          vocabId = await db.into(db.vocabularies).insert(
                VocabulariesCompanion.insert(
                  word: wordStr,
                  reading: readingStr,
                  meaningMy: Value(meaningStr),
                ),
              );
        }

        // Link into KanjiCompounds
        await db.into(db.kanjiCompounds).insert(
              KanjiCompoundsCompanion.insert(
                kanjiId: kanjiId,
                vocabId: vocabId,
                sourceId: kanjiSourceId,
                position: Value(vIdx + 1),
              ),
              mode: InsertMode.insertOrIgnore,
            );

        // Link into VocabSourceItems for the companion vocab source
        if (!seenVocabInSource.contains(vocabId)) {
          seenVocabInSource.add(vocabId);
          await db.into(db.vocabSourceItems).insert(
                VocabSourceItemsCompanion.insert(
                  vocabId: vocabId,
                  sourceId: vocabSourceId,
                  unitId: Value(vocabUnitId),
                  position: Value(vocabPositionInChapter),
                  jlptLevel: Value(bookLevel),
                ),
                mode: InsertMode.insertOrIgnore,
              );
          vocabPositionInChapter++;
        }
      }
    }
  }
}

/// Ensures the 2010-07 JLPT N3 Past Exam data is loaded into the DB.
Future<void> _ensurePastExam201007(AppDatabase db, DateTime now) async {
  final existingSource = await (db.sources.select()
        ..where(
          (s) =>
              s.type.equalsValue(SourceType.pastExam) &
              s.jlptLevel.equals('N3') &
              s.examYear.equals(2010) &
              s.examMonth.equals(7),
        ))
      .getSingleOrNull();

  if (existingSource != null) {
    final count = await (db.questions.select()
          ..where(
            (q) => q.sourceId.equals(existingSource.id),
          ))
        .get()
        .then((l) => l.length);
    if (count >= 80) {
      return; // Already fully seeded
    }
  }

  await _seedPastExamFromJson(
    db,
    now,
    'assets/data/jlpt_n3_2010_07.json',
    sortOrder: 1,
  );
}

/// Ensures the 2010-12 JLPT N3 Past Exam data is loaded into the DB.
Future<void> _ensurePastExam201012(AppDatabase db, DateTime now) async {
  final existingSource = await (db.sources.select()
        ..where(
          (s) =>
              s.type.equalsValue(SourceType.pastExam) &
              s.jlptLevel.equals('N3') &
              s.examYear.equals(2010) &
              s.examMonth.equals(12),
        ))
      .getSingleOrNull();

  if (existingSource != null) {
    final count = await (db.questions.select()
          ..where((q) => q.sourceId.equals(existingSource.id)))
        .get()
        .then((l) => l.length);
    if (count >= 70) {
      return; // Already fully seeded
    }
  }

  await _seedPastExamFromJson(
    db,
    now,
    'assets/data/jlpt_n3_2010_12.json',
    sortOrder: 2,
  );
}

/// Ensures the 2011-07 JLPT N3 Past Exam data is loaded into the DB.
Future<void> _ensurePastExam201107(AppDatabase db, DateTime now) async {
  final existingSource = await (db.sources.select()
        ..where(
          (s) =>
              s.type.equalsValue(SourceType.pastExam) &
              s.jlptLevel.equals('N3') &
              s.examYear.equals(2011) &
              s.examMonth.equals(7),
        ))
      .getSingleOrNull();

  if (existingSource != null) {
    final count = await (db.questions.select()
          ..where(
            (q) => q.sourceId.equals(existingSource.id),
          ))
        .get()
        .then((l) => l.length);
    if (count >= 80) {
      return; // Already fully seeded
    }
  }

  await _seedPastExamFromJson(
    db,
    now,
    'assets/data/jlpt_n3_2011_07.json',
    sortOrder: 2,
  );
}

/// Ensures the 2011-12 JLPT N3 Past Exam data is loaded into the DB.
Future<void> _ensurePastExam201112(AppDatabase db, DateTime now) async {
  final existingSource = await (db.sources.select()
        ..where(
          (s) =>
              s.type.equalsValue(SourceType.pastExam) &
              s.jlptLevel.equals('N3') &
              s.examYear.equals(2011) &
              s.examMonth.equals(12),
        ))
      .getSingleOrNull();

  if (existingSource != null) {
    final count = await (db.questions.select()
          ..where(
            (q) => q.sourceId.equals(existingSource.id),
          ))
        .get()
        .then((l) => l.length);
    if (count >= 80) {
      return; // Already fully seeded
    }
  }

  await _seedPastExamFromJson(
    db,
    now,
    'assets/data/jlpt_n3_2011_12.json',
    sortOrder: 3,
  );
}

/// Ensures the 2012-07 JLPT N3 Past Exam data is loaded into the DB.
Future<void> _ensurePastExam201207(AppDatabase db, DateTime now) async {
  final existingSource = await (db.sources.select()
        ..where(
          (s) =>
              s.type.equalsValue(SourceType.pastExam) &
              s.jlptLevel.equals('N3') &
              s.examYear.equals(2012) &
              s.examMonth.equals(7),
        ))
      .getSingleOrNull();

  if (existingSource != null) {
    final count = await (db.questions.select()
          ..where(
            (q) => q.sourceId.equals(existingSource.id),
          ))
        .get()
        .then((l) => l.length);
    if (count >= 70) {
      return; // Already fully seeded
    }
  }

  await _seedPastExamFromJson(
    db,
    now,
    'assets/data/jlpt_n3_2012_07.json',
    sortOrder: 3,
  );
}

/// Ensures the 2012-12 JLPT N3 Past Exam data is loaded into the DB.
Future<void> _ensurePastExam201212(AppDatabase db, DateTime now) async {
  final existingSource = await (db.sources.select()
        ..where(
          (s) =>
              s.type.equalsValue(SourceType.pastExam) &
              s.jlptLevel.equals('N3') &
              s.examYear.equals(2012) &
              s.examMonth.equals(12),
        ))
      .getSingleOrNull();

  if (existingSource != null) {
    final count = await (db.questions.select()
          ..where(
            (q) => q.sourceId.equals(existingSource.id),
          ))
        .get()
        .then((l) => l.length);
    if (count >= 80) {
      return; // Already fully seeded
    }
  }

  await _seedPastExamFromJson(
    db,
    now,
    'assets/data/jlpt_n3_2012_12.json',
    sortOrder: 4,
  );
}

/// Ensures the 2014-07 JLPT N3 Past Exam data is loaded into the DB.
Future<void> _ensurePastExam201407(AppDatabase db, DateTime now) async {
  final existingSource = await (db.sources.select()
        ..where(
          (s) =>
              s.type.equalsValue(SourceType.pastExam) &
              s.jlptLevel.equals('N3') &
              s.examYear.equals(2014) &
              s.examMonth.equals(7),
        ))
      .getSingleOrNull();

  if (existingSource != null) {
    final count = await (db.questions.select()
          ..where((q) => q.sourceId.equals(existingSource.id)))
        .get()
        .then((l) => l.length);
    if (count >= 70) {
      return; // Already fully seeded
    }
  }

  await _seedPastExamFromJson(
    db,
    now,
    'assets/data/jlpt_n3_2014_07.json',
    sortOrder: 5,
  );
}

/// Ensures the 2014-12 JLPT N3 Past Exam data is loaded into the DB.
Future<void> _ensurePastExam201412(AppDatabase db, DateTime now) async {
  final existingSource = await (db.sources.select()
        ..where(
          (s) =>
              s.type.equalsValue(SourceType.pastExam) &
              s.jlptLevel.equals('N3') &
              s.examYear.equals(2014) &
              s.examMonth.equals(12),
        ))
      .getSingleOrNull();

  if (existingSource != null) {
    final count = await (db.questions.select()
          ..where((q) => q.sourceId.equals(existingSource.id)))
        .get()
        .then((l) => l.length);
    if (count >= 80) {
      return; // Already fully seeded
    }
  }

  await _seedPastExamFromJson(
    db,
    now,
    'assets/data/jlpt_n3_2014_12.json',
    sortOrder: 6,
  );
}

/// Ensures the 2013-07 JLPT N3 Past Exam data is loaded into the DB.
Future<void> _ensurePastExam201307(AppDatabase db, DateTime now) async {
  final existingSource = await (db.sources.select()
        ..where(
          (s) =>
              s.type.equalsValue(SourceType.pastExam) &
              s.jlptLevel.equals('N3') &
              s.examYear.equals(2013) &
              s.examMonth.equals(7),
        ))
      .getSingleOrNull();

  if (existingSource != null) {
    final count = await (db.questions.select()
          ..where((q) => q.sourceId.equals(existingSource.id)))
        .get()
        .then((l) => l.length);
    if (count >= 70) {
      return; // Already fully seeded
    }
  }

  await _seedPastExamFromJson(
    db,
    now,
    'assets/data/jlpt_n3_2013_07.json',
    sortOrder: 4,
  );
}

/// Ensures the 2013-12 JLPT N3 Past Exam data is loaded into the DB.
Future<void> _ensurePastExam201312(AppDatabase db, DateTime now) async {
  final existingSource = await (db.sources.select()
        ..where(
          (s) =>
              s.type.equalsValue(SourceType.pastExam) &
              s.jlptLevel.equals('N3') &
              s.examYear.equals(2013) &
              s.examMonth.equals(12),
        ))
      .getSingleOrNull();

  if (existingSource != null) {
    final count = await (db.questions.select()
          ..where((q) => q.sourceId.equals(existingSource.id)))
        .get()
        .then((l) => l.length);
    if (count >= 80) {
      return; // Already fully seeded
    }
  }

  await _seedPastExamFromJson(
    db,
    now,
    'assets/data/jlpt_n3_2013_12.json',
    sortOrder: 5,
  );
}

/// Ensures the 2016-07 JLPT N3 Past Exam data is loaded into the DB.
Future<void> _ensurePastExam201607(AppDatabase db, DateTime now) async {
  final existingSource = await (db.sources.select()
        ..where(
          (s) =>
              s.type.equalsValue(SourceType.pastExam) &
              s.jlptLevel.equals('N3') &
              s.examYear.equals(2016) &
              s.examMonth.equals(7),
        ))
      .getSingleOrNull();

  if (existingSource != null) {
    final count = await (db.questions.select()
          ..where((q) => q.sourceId.equals(existingSource.id)))
        .get()
        .then((l) => l.length);
    if (count >= 70) {
      return; // Already fully seeded
    }
  }

  await _seedPastExamFromJson(
    db,
    now,
    'assets/data/jlpt_n3_2016_07.json',
    sortOrder: 6,
  );
}

/// Ensures the 2017-07 JLPT N3 Past Exam data is loaded into the DB.
Future<void> _ensurePastExam201707(AppDatabase db, DateTime now) async {
  final existingSource = await (db.sources.select()
        ..where(
          (s) =>
              s.type.equalsValue(SourceType.pastExam) &
              s.jlptLevel.equals('N3') &
              s.examYear.equals(2017) &
              s.examMonth.equals(7),
        ))
      .getSingleOrNull();

  if (existingSource != null) {
    final count = await (db.questions.select()
          ..where((q) => q.sourceId.equals(existingSource.id)))
        .get()
        .then((l) => l.length);
    if (count >= 70) {
      return; // Already fully seeded
    }
  }

  await _seedPastExamFromJson(
    db,
    now,
    'assets/data/jlpt_n3_2017_07.json',
    sortOrder: 7,
  );
}

/// Ensures the 2017-12 JLPT N3 Past Exam data is loaded into the DB.
Future<void> _ensurePastExam201712(AppDatabase db, DateTime now) async {
  final existingSource = await (db.sources.select()
        ..where(
          (s) =>
              s.type.equalsValue(SourceType.pastExam) &
              s.jlptLevel.equals('N3') &
              s.examYear.equals(2017) &
              s.examMonth.equals(12),
        ))
      .getSingleOrNull();

  if (existingSource != null) {
    final count = await (db.questions.select()
          ..where((q) => q.sourceId.equals(existingSource.id)))
        .get()
        .then((l) => l.length);
    if (count >= 70) {
      return; // Already fully seeded
    }
  }

  await _seedPastExamFromJson(
    db,
    now,
    'assets/data/jlpt_n3_2017_12.json',
    sortOrder: 7,
  );
}

/// Ensures the 2018-07 JLPT N3 Past Exam data is loaded into the DB.
Future<void> _ensurePastExam201807(AppDatabase db, DateTime now) async {
  final existingSource = await (db.sources.select()
        ..where(
          (s) =>
              s.type.equalsValue(SourceType.pastExam) &
              s.jlptLevel.equals('N3') &
              s.examYear.equals(2018) &
              s.examMonth.equals(7),
        ))
      .getSingleOrNull();

  if (existingSource != null) {
    final count = await (db.questions.select()
          ..where((q) => q.sourceId.equals(existingSource.id)))
        .get()
        .then((l) => l.length);
    if (count >= 70) {
      return; // Already fully seeded
    }
  }

  await _seedPastExamFromJson(
    db,
    now,
    'assets/data/jlpt_n3_2018_07.json',
    sortOrder: 8,
  );
}

/// Ensures the 2019-12 JLPT N3 Past Exam data is loaded into the DB.
Future<void> _ensurePastExam201912(AppDatabase db, DateTime now) async {
  final existingSource = await (db.sources.select()
        ..where(
          (s) =>
              s.type.equalsValue(SourceType.pastExam) &
              s.jlptLevel.equals('N3') &
              s.examYear.equals(2019) &
              s.examMonth.equals(12),
        ))
      .getSingleOrNull();

  if (existingSource != null) {
    final count = await (db.questions.select()
          ..where((q) => q.sourceId.equals(existingSource.id)))
        .get()
        .then((l) => l.length);
    if (count >= 70) {
      return; // Already fully seeded
    }
  }

  await _seedPastExamFromJson(
    db,
    now,
    'assets/data/jlpt_n3_2019_12.json',
    sortOrder: 8,
  );
}

/// Ensures the 2020-12 JLPT N3 Past Exam data is loaded into the DB.
Future<void> _ensurePastExam202012(AppDatabase db, DateTime now) async {
  final existingSource = await (db.sources.select()
        ..where(
          (s) =>
              s.type.equalsValue(SourceType.pastExam) &
              s.jlptLevel.equals('N3') &
              s.examYear.equals(2020) &
              s.examMonth.equals(12),
        ))
      .getSingleOrNull();

  if (existingSource != null) {
    final count = await (db.questions.select()
          ..where((q) => q.sourceId.equals(existingSource.id)))
        .get()
        .then((l) => l.length);
    if (count >= 70) {
      return; // Already fully seeded
    }
  }

  await _seedPastExamFromJson(
    db,
    now,
    'assets/data/jlpt_n3_2020_12.json',
    sortOrder: 8,
  );
}

/// Ensures the 2021-07 JLPT N3 Past Exam data is loaded into the DB.
Future<void> _ensurePastExam202107(AppDatabase db, DateTime now) async {
  final existingSource = await (db.sources.select()
        ..where(
          (s) =>
              s.type.equalsValue(SourceType.pastExam) &
              s.jlptLevel.equals('N3') &
              s.examYear.equals(2021) &
              s.examMonth.equals(7),
        ))
      .getSingleOrNull();

  if (existingSource != null) {
    final count = await (db.questions.select()
          ..where((q) => q.sourceId.equals(existingSource.id)))
        .get()
        .then((l) => l.length);
    if (count >= 70) {
      return; // Already fully seeded
    }
  }

  await _seedPastExamFromJson(
    db,
    now,
    'assets/data/jlpt_n3_2021_07.json',
    sortOrder: 9,
  );
}

/// Ensures the 2021-12 JLPT N3 Past Exam data is loaded into the DB.
Future<void> _ensurePastExam202112(AppDatabase db, DateTime now) async {
  final existingSource = await (db.sources.select()
        ..where(
          (s) =>
              s.type.equalsValue(SourceType.pastExam) &
              s.jlptLevel.equals('N3') &
              s.examYear.equals(2021) &
              s.examMonth.equals(12),
        ))
      .getSingleOrNull();

  if (existingSource != null) {
    final count = await (db.questions.select()
          ..where((q) => q.sourceId.equals(existingSource.id)))
        .get()
        .then((l) => l.length);
    if (count >= 70) {
      return; // Already fully seeded
    }
  }

  await _seedPastExamFromJson(
    db,
    now,
    'assets/data/jlpt_n3_2021_12.json',
    sortOrder: 9,
  );
}

/// Ensures the 2022-07 JLPT N3 Past Exam data is loaded into the DB.
Future<void> _ensurePastExam202207(AppDatabase db, DateTime now) async {
  final existingSource = await (db.sources.select()
        ..where(
          (s) =>
              s.type.equalsValue(SourceType.pastExam) &
              s.jlptLevel.equals('N3') &
              s.examYear.equals(2022) &
              s.examMonth.equals(7),
        ))
      .getSingleOrNull();

  if (existingSource != null) {
    final count = await (db.questions.select()
          ..where((q) => q.sourceId.equals(existingSource.id)))
        .get()
        .then((l) => l.length);
    if (count >= 70) {
      return; // Already fully seeded
    }
  }

  await _seedPastExamFromJson(
    db,
    now,
    'assets/data/jlpt_n3_2022_07.json',
    sortOrder: 10,
  );
}

/// Ensures the 2022-12 JLPT N3 Past Exam data is loaded into the DB.
Future<void> _ensurePastExam202212(AppDatabase db, DateTime now) async {
  final existingSource = await (db.sources.select()
        ..where(
          (s) =>
              s.type.equalsValue(SourceType.pastExam) &
              s.jlptLevel.equals('N3') &
              s.examYear.equals(2022) &
              s.examMonth.equals(12),
        ))
      .getSingleOrNull();

  if (existingSource != null) {
    final count = await (db.questions.select()
          ..where((q) => q.sourceId.equals(existingSource.id)))
        .get()
        .then((l) => l.length);
    if (count >= 70) {
      return; // Already fully seeded
    }
  }

  await _seedPastExamFromJson(
    db,
    now,
    'assets/data/jlpt_n3_2022_12.json',
    sortOrder: 10,
  );
}

/// Ensures the 2023-07 JLPT N3 Past Exam data is loaded into the DB.
Future<void> _ensurePastExam202307(AppDatabase db, DateTime now) async {
  final existingSource = await (db.sources.select()
        ..where(
          (s) =>
              s.type.equalsValue(SourceType.pastExam) &
              s.jlptLevel.equals('N3') &
              s.examYear.equals(2023) &
              s.examMonth.equals(7),
        ))
      .getSingleOrNull();

  if (existingSource != null) {
    final count = await (db.questions.select()
          ..where((q) => q.sourceId.equals(existingSource.id)))
        .get()
        .then((l) => l.length);
    if (count >= 70) {
      return; // Already fully seeded
    }
  }

  await _seedPastExamFromJson(
    db,
    now,
    'assets/data/jlpt_n3_2023_07.json',
    sortOrder: 11,
  );
}

/// Ensures the 2023-12 JLPT N3 Past Exam data is loaded into the DB.
Future<void> _ensurePastExam202312(AppDatabase db, DateTime now) async {
  final existingSource = await (db.sources.select()
        ..where(
          (s) =>
              s.type.equalsValue(SourceType.pastExam) &
              s.jlptLevel.equals('N3') &
              s.examYear.equals(2023) &
              s.examMonth.equals(12),
        ))
      .getSingleOrNull();

  if (existingSource != null) {
    final count = await (db.questions.select()
          ..where((q) => q.sourceId.equals(existingSource.id)))
        .get()
        .then((l) => l.length);
    if (count >= 70) {
      return; // Already fully seeded
    }
  }

  await _seedPastExamFromJson(
    db,
    now,
    'assets/data/jlpt_n3_2023_12.json',
    sortOrder: 11,
  );
}

/// Ensures the 2024-07 JLPT N3 Past Exam data is loaded into the DB.
Future<void> _ensurePastExam202407(AppDatabase db, DateTime now) async {
  final existingSource = await (db.sources.select()
        ..where(
          (s) =>
              s.type.equalsValue(SourceType.pastExam) &
              s.jlptLevel.equals('N3') &
              s.examYear.equals(2024) &
              s.examMonth.equals(7),
        ))
      .getSingleOrNull();

  if (existingSource != null) {
    final count = await (db.questions.select()
          ..where((q) => q.sourceId.equals(existingSource.id)))
        .get()
        .then((l) => l.length);
    if (count >= 70) {
      return; // Already fully seeded
    }
  }

  await _seedPastExamFromJson(
    db,
    now,
    'assets/data/jlpt_n3_2024_07.json',
    sortOrder: 12,
  );
}

/// Ensures the 2015-12 JLPT N3 Past Exam data is loaded into the DB.
Future<void> _ensurePastExam201512(AppDatabase db, DateTime now) async {
  final existingSource = await (db.sources.select()
        ..where(
          (s) =>
              s.type.equalsValue(SourceType.pastExam) &
              s.jlptLevel.equals('N3') &
              s.examYear.equals(2015) &
              s.examMonth.equals(12),
        ))
      .getSingleOrNull();

  if (existingSource != null) {
    final count = await (db.questions.select()
          ..where((q) => q.sourceId.equals(existingSource.id)))
        .get()
        .then((l) => l.length);
    if (count >= 80) {
      return; // Already fully seeded
    }
  }

  await _seedPastExamFromJson(
    db,
    now,
    'assets/data/jlpt_n3_2015_12.json',
    sortOrder: 6,
  );
}

/// Ensures the 2016-12 JLPT N3 Past Exam data is loaded into the DB.
Future<void> _ensurePastExam201612(AppDatabase db, DateTime now) async {
  final existingSource = await (db.sources.select()
        ..where(
          (s) =>
              s.type.equalsValue(SourceType.pastExam) &
              s.jlptLevel.equals('N3') &
              s.examYear.equals(2016) &
              s.examMonth.equals(12),
        ))
      .getSingleOrNull();

  if (existingSource != null) {
    final count = await (db.questions.select()
          ..where((q) => q.sourceId.equals(existingSource.id)))
        .get()
        .then((l) => l.length);
    if (count >= 80) {
      return; // Already fully seeded
    }
  }

  await _seedPastExamFromJson(
    db,
    now,
    'assets/data/jlpt_n3_2016_12.json',
    sortOrder: 7,
  );
}

Future<int> _getOrCreateMondaiType(
  AppDatabase db,
  MondaiType type,
  String level,
  Subject subject,
  String nameJp,
  String? nameMy,
  String? instruction,
  int sortOrder,
) async {
  final existing = await (db.mondaiTypes.select()
        ..where(
          (m) => m.type.equalsValue(type) & m.jlptLevel.equals(level),
        ))
      .getSingleOrNull();

  if (existing != null) {
    return existing.id;
  }

  return db.into(db.mondaiTypes).insert(
        MondaiTypesCompanion.insert(
          type: type,
          jlptLevel: level,
          subject: subject,
          nameJp: nameJp,
          nameMy: Value(nameMy),
          instructionJp: Value(instruction),
          sortOrder: Value(sortOrder),
        ),
      );
}

/// Seeds JLPT past exam from JSON asset.
Future<void> _seedPastExamFromJson(
  AppDatabase db,
  DateTime now,
  String assetPath, {
  int sortOrder = 1,
}) async {
  String? jsonStr;
  try {
    jsonStr = await rootBundle.loadString(assetPath);
  } catch (_) {
    if (!kIsWeb) {
      final file = File(assetPath);
      if (file.existsSync()) {
        jsonStr = await file.readAsString();
      }
    }
  }

  if (jsonStr == null || jsonStr.isEmpty) return;

  final data = jsonDecode(jsonStr) as Map<String, dynamic>;
  final examName = data['name'] as String? ?? 'JLPT N3 Past Exam';
  final examLevel = data['level'] as String? ?? 'N3';
  final examYear = data['year'] as int? ?? 2010;
  final examMonth = data['month'] as int? ?? 7;
  final sections = data['sections'] as List<dynamic>;

  final source = await (db.sources.select()
        ..where(
          (s) =>
              s.type.equalsValue(SourceType.pastExam) &
              s.jlptLevel.equals(examLevel) &
              s.examYear.equals(examYear) &
              s.examMonth.equals(examMonth),
        ))
      .getSingleOrNull();

  int sourceId;
  if (source == null) {
    sourceId = await db.into(db.sources).insert(
          SourcesCompanion.insert(
            type: SourceType.pastExam,
            name: examName,
            jlptLevel: Value(examLevel),
            examYear: Value(examYear),
            examMonth: Value(examMonth),
            sortOrder: Value(sortOrder),
          ),
        );
  } else {
    sourceId = source.id;
    // Clear old questions/choices/groups if re-seeding
    final oldQuestions = await (db.questions.select()
          ..where((q) => q.sourceId.equals(sourceId)))
        .get();
    for (final q in oldQuestions) {
      await (db.questionChoices.delete()
            ..where((c) => c.questionId.equals(q.id)))
          .go();
    }
    await (db.questions.delete()..where((q) => q.sourceId.equals(sourceId)))
        .go();
    await (db.questionGroups.delete()
          ..where((g) => g.sourceId.equals(sourceId)))
        .go();
  }

  for (final sectionData in sections) {
    final section = sectionData as Map<String, dynamic>;
    final subjectStr = section['subject'] as String;
    final subject = Subject.values.byName(subjectStr);
    final mondaiTypesList = section['mondaiTypes'] as List<dynamic>;

    for (final mData in mondaiTypesList) {
      final m = mData as Map<String, dynamic>;
      final mondaiNo = m['mondaiNo'] as int?;
      final typeStr = m['type'] as String;
      final MondaiType mondaiType;
      switch (typeStr) {
        case 'shortReading':
        case 'midReading':
        case 'longReading':
        case 'infoSearch':
          mondaiType = MondaiType.reading;
          break;
        case 'taskUnderstanding':
        case 'pointUnderstanding':
        case 'summaryUnderstanding':
        case 'utterance':
        case 'quickResponse':
          mondaiType = MondaiType.listening;
          break;
        default:
          mondaiType = MondaiType.values.byName(typeStr);
      }
      final nameJp = m['nameJp'] as String? ?? '';
      final nameMy = m['nameMy'] as String?;
      final instruction = m['instruction'] as String?;
      final groupPassage = m['passage'] as String?;

      final mondaiTypeId = await _getOrCreateMondaiType(
        db,
        mondaiType,
        examLevel,
        subject,
        nameJp,
        nameMy,
        instruction,
        mondaiNo ?? 0,
      );

      int? currentGroupId;
      if (groupPassage != null && groupPassage.isNotEmpty) {
        currentGroupId = await db.into(db.questionGroups).insert(
              QuestionGroupsCompanion.insert(
                sourceId: sourceId,
                mondaiTypeId: mondaiTypeId,
                mondaiNo: Value(mondaiNo),
                passage: Value(groupPassage),
              ),
            );
      }

      final questionsList = m['questions'] as List<dynamic>;
      for (final qData in questionsList) {
        final q = qData as Map<String, dynamic>;
        final questionNo = q['questionNo'] as int?;
        final questionText = q['questionText'] as String;
        final targetWord = q['targetWord'] as String?;
        final starPosition = q['starPosition'] as int?;
        final correctOrderList = q['correctOrder'] as List<dynamic>?;
        final correctOrder =
            correctOrderList != null ? jsonEncode(correctOrderList) : null;
        final explanation = q['explanation'] as String?;
        final questionPassage = q['passage'] as String?;

        int? qGroupId = currentGroupId;
        if (questionPassage != null && questionPassage.isNotEmpty) {
          qGroupId = await db.into(db.questionGroups).insert(
                QuestionGroupsCompanion.insert(
                  sourceId: sourceId,
                  mondaiTypeId: mondaiTypeId,
                  mondaiNo: Value(mondaiNo),
                  passage: Value(questionPassage),
                ),
              );
          currentGroupId = qGroupId;
        }

        final questionId = await db.into(db.questions).insert(
              QuestionsCompanion.insert(
                sourceId: sourceId,
                jlptLevel: examLevel,
                subject: subject,
                mondaiTypeId: mondaiTypeId,
                groupId: Value(qGroupId),
                mondaiNo: Value(mondaiNo),
                questionNo: Value(questionNo),
                questionText: questionText,
                targetWord: Value(targetWord),
                starPosition: Value(starPosition),
                correctOrder: Value(correctOrder),
                explanation: Value(explanation),
              ),
            );

        final choices = q['choices'] as List<dynamic>;
        final correctIndex = q['correctIndex'] as int;

        for (var cIdx = 0; cIdx < choices.length; cIdx++) {
          final choiceText = choices[cIdx].toString();
          final pos = cIdx + 1;
          await db.into(db.questionChoices).insert(
                QuestionChoicesCompanion.insert(
                  questionId: questionId,
                  position: pos,
                  choiceText: choiceText,
                  isCorrect: Value(pos == correctIndex),
                ),
              );
        }
      }
    }
  }
}

/// Backwards compatibility alias.
Future<void> devSeed(AppDatabase db) => seedDevData(db);
