import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practice_janpanese/core/database/app_database.dart';
import 'package:practice_janpanese/core/database/dev_seed.dart';
import 'package:sqlite3/open.dart';

void main() {
  setUpAll(() {
    if (Platform.isLinux) {
      open.overrideFor(OperatingSystem.linux, () {
        final paths = [
          '/usr/lib/x86_64-linux-gnu/libsqlite3.so.0',
          '/usr/lib/x86_64-linux-gnu/libsqlite3.so',
          'libsqlite3.so',
        ];
        for (final p in paths) {
          try {
            return DynamicLibrary.open(p);
          } catch (_) {}
        }
        return DynamicLibrary.process();
      });
    }
  });
  test('Speed Master N3 Kanji JSON asset integrity test', () {
    final file = File('assets/data/kanji_speed_master_n3.json');
    expect(file.existsSync(), isTrue, reason: 'kanji_speed_master_n3.json must exist');

    final jsonStr = file.readAsStringSync();
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;

    expect(data['book'] ?? data['title'], equals('Speed Master N3 漢字'));
    expect(data['level'], equals('N3'));

    final chapters = data['chapters'] as List<dynamic>;
    expect(chapters.length, equals(25), reason: 'Must have 25 chapters');

    var totalKanjis = 0;
    var totalVocabWords = 0;
    final allVocabSet = <String>{};

    for (var i = 0; i < chapters.length; i++) {
      final ch = chapters[i] as Map<String, dynamic>;
      expect(ch['chapter'], equals(i + 1));
      expect(ch['title'], isNotEmpty);

      final kanjis = ch['kanjis'] as List<dynamic>;
      expect(kanjis, isNotEmpty);
      totalKanjis += kanjis.length;

      for (final k in kanjis) {
        final kanjiMap = k as Map<String, dynamic>;
        expect(kanjiMap['character'], isNotEmpty);
        expect(kanjiMap['meaning'], isNotEmpty);
        expect(
          kanjiMap.containsKey('onyomi'),
          isTrue,
        );
        expect(
          kanjiMap.containsKey('kunyomi'),
          isTrue,
        );

        final vocabList = (kanjiMap['vocab'] as List<dynamic>?) ?? [];
        totalVocabWords += vocabList.length;
        for (final v in vocabList) {
          final vMap = v as Map<String, dynamic>;
          expect(vMap['word'], isNotEmpty);
          expect(vMap['reading'], isNotEmpty);
          expect(vMap['meaning'], isNotEmpty);
          allVocabSet.add('${vMap['word']}_${vMap['reading']}');
        }
      }
    }

    expect(totalKanjis, equals(482), reason: 'Total kanji count across 25 chapters should be 482');
    expect(totalVocabWords, equals(1517), reason: 'Total compound words across 25 chapters should be 1517');
    expect(allVocabSet.length, equals(1349), reason: 'Total unique compound words across 25 chapters should be 1349');
  });

  test('Speed Master N3 Kanji Chapter 16 seeds into database with correct title and kanjis', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    await seedDevData(db);

    final kanjiSource = await (db.select(db.sources)
          ..where((s) => s.name.equals('Speed Master N3 漢字')))
        .getSingle();

    final ch16Unit = await (db.select(db.units)
          ..where((u) => u.sourceId.equals(kanjiSource.id) & u.orderNo.equals(16)))
        .getSingle();

    expect(ch16Unit.name, equals('Ch.16: 仕事 (အလုပ်)'));

    final items = await (db.select(db.kanjiSourceItems)
          ..where((i) => i.sourceId.equals(kanjiSource.id) & i.unitId.equals(ch16Unit.id)))
        .get();

    expect(items.length, equals(20));

    final kanjiList = <String>[];
    for (final item in items) {
      final k = await (db.select(db.kanjis)..where((k) => k.id.equals(item.kanjiId))).getSingle();
      kanjiList.add(k.character);
    }

    expect(kanjiList, equals([
      '仕', '職', '求', '常', '識', '失', '礼', '労', '員',
      '官', '局', '辞', '退', '積', '給', '収', '支', '厚',
      '薄', '申',
    ]));
  });

  test('Speed Master N3 Kanji Chapter 18 seeds into database with correct title and kanjis', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    await seedDevData(db);

    final kanjiSource = await (db.select(db.sources)
          ..where((s) => s.name.equals('Speed Master N3 漢字')))
        .getSingle();

    final ch18Unit = await (db.select(db.units)
          ..where((u) => u.sourceId.equals(kanjiSource.id) & u.orderNo.equals(18)))
        .getSingle();

    expect(ch18Unit.name, equals('Ch.18: 会議 (အစည်းအဝေး)'));

    final items = await (db.select(db.kanjiSourceItems)
          ..where((i) => i.sourceId.equals(kanjiSource.id) & i.unitId.equals(ch18Unit.id)))
        .get();

    expect(items.length, equals(20));

    final kanjiList = <String>[];
    for (final item in items) {
      final k = await (db.select(db.kanjis)..where((k) => k.id.equals(item.kanjiId))).getSingle();
      kanjiList.add(k.character);
    }

    expect(kanjiList, equals([
      '議', '賛', '反', '対', '肯', '否', '保', '留', '判', '断',
      '確', '認', '報', '告', '連', '絡', '相', '談', '指', '示',
    ]));
  });

  test('Speed Master N3 Kanji Chapter 19 seeds into database with correct title and kanjis', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    await seedDevData(db);

    final kanjiSource = await (db.select(db.sources)
          ..where((s) => s.name.equals('Speed Master N3 漢字')))
        .getSingle();

    final ch19Unit = await (db.select(db.units)
          ..where((u) => u.sourceId.equals(kanjiSource.id) & u.orderNo.equals(19)))
        .getSingle();

    expect(ch19Unit.name, equals('Ch.19: 産業・貿易 (စက်မှုလုပ်ငန်းနှင့် ကုန်သွယ်မှု)'));

    final items = await (db.select(db.kanjiSourceItems)
          ..where((i) => i.sourceId.equals(kanjiSource.id) & i.unitId.equals(ch19Unit.id)))
        .get();

    expect(items.length, equals(20));

    final kanjiList = <String>[];
    for (final item in items) {
      final k = await (db.select(db.kanjis)..where((k) => k.id.equals(item.kanjiId))).getSingle();
      kanjiList.add(k.character);
    }

    expect(kanjiList, equals([
      '産', '製', '造', '費', '貿', '輸', '販', '商', '営', '払',
      '値', '価', '額', '税', '財', '預', '貯', '納', '農', '豊',
    ]));
  });

  test('Speed Master N3 Kanji Chapter 20 seeds into database with correct title and kanjis', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    await seedDevData(db);

    final kanjiSource = await (db.select(db.sources)
          ..where((s) => s.name.equals('Speed Master N3 漢字')))
        .getSingle();

    final ch20Unit = await (db.select(db.units)
          ..where((u) => u.sourceId.equals(kanjiSource.id) & u.orderNo.equals(20)))
        .getSingle();

    expect(ch20Unit.name, equals('Ch.20: 仕事 (စည်းကမ်း၊ ပြစ်မှု၊ ယှဉ်ပြိုင်ခြင်းနှင့် နိုင်ငံရေး)'));

    final items = await (db.select(db.kanjiSourceItems)
          ..where((i) => i.sourceId.equals(kanjiSource.id) & i.unitId.equals(ch20Unit.id)))
        .get();

    expect(items.length, equals(16));

    final kanjiList = <String>[];
    for (final item in items) {
      final k = await (db.select(db.kanjis)..where((k) => k.id.equals(item.kanjiId))).getSingle();
      kanjiList.add(k.character);
    }

    expect(kanjiList, equals([
      '法', '律', '規', '則', '禁', '許', '件',
      '犯', '罪', '容', '疑',
      '争', '兵', '軍',
      '役', '臣',
    ]));
  });
}
