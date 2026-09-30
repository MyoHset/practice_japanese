import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:practice_janpanese/core/database/app_database.dart';

/// Seeds the database with realistic development data per spec B1.
/// Runs only when the database is empty (sources count == 0).
Future<void> seedDevData(AppDatabase db) async {
  if (!kDebugMode) return;

  final sourceCount = await db.sources.count().getSingle();
  if (sourceCount > 0) {
    await _ensureTangoLevelN3(db);
    await _updateTangoIfCorrupted(db);
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
  });
}

/// Loads Tango 2000 vocabulary from [assets/data/tango_2000_n3.json]
/// into [Sources], [Units], [Vocabularies], and [VocabSourceItems].
Future<void> _seedTangoFromJson(AppDatabase db, DateTime now) async {
  String? jsonStr;
  try {
    jsonStr = await rootBundle.loadString('assets/data/tango_2000_n3.json');
  } catch (_) {
    final file = File('assets/data/tango_2000_n3.json');
    if (file.existsSync()) {
      jsonStr = await file.readAsString();
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
    final file = File('assets/data/tango_2000_n3.json');
    if (file.existsSync()) {
      jsonStr = await file.readAsString();
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

/// Backwards compatibility alias.
Future<void> devSeed(AppDatabase db) => seedDevData(db);
