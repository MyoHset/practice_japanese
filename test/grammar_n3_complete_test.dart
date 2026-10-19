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

  group('JLPT N3 Grammar Complete Dataset Test', () {
    test('JSON data integrity and structure', () {
      final file = File('assets/data/grammar_n3_complete.json');
      expect(file.existsSync(), isTrue, reason: 'File should exist');

      final jsonStr = file.readAsStringSync();
      final data = jsonDecode(jsonStr) as Map<String, dynamic>;

      expect(data['book'], equals('Shinkanzen Master N3 文法'));
      expect(data['level'], equals('N3'));
      expect(data['totalChapters'], equals(12));
      expect(data['totalPatterns'], equals(100));

      final chapters = data['chapters'] as List<dynamic>;
      expect(chapters.length, equals(12));

      int totalPatterns = 0;
      for (final ch in chapters) {
        final chapterMap = ch as Map<String, dynamic>;
        expect(chapterMap['chapter'], isNotNull);
        expect(chapterMap['title'], isNotEmpty);

        final patterns = chapterMap['patterns'] as List<dynamic>;
        expect(patterns.isNotEmpty, isTrue);

        for (final p in patterns) {
          totalPatterns++;
          final patternMap = p as Map<String, dynamic>;
          expect((patternMap['pattern'] as String).isNotEmpty, isTrue);
          expect((patternMap['connection'] as String).isNotEmpty, isTrue);
          expect((patternMap['meaning'] as String).isNotEmpty, isTrue);
          expect((patternMap['exampleJp'] as String).isNotEmpty, isTrue);
          expect((patternMap['exampleMy'] as String).isNotEmpty, isTrue);
        }
      }

      expect(totalPatterns, equals(100));
    });

    test('Seeding N3 grammar into AppDatabase', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);

      await seedDevData(db);

      // Verify source
      final grammarSources = await (db.select(db.sources)
            ..where((s) => s.jlptLevel.equals('N3') & s.type.equalsValue(SourceType.grammarBook)))
          .get();

      expect(grammarSources.length, equals(1));
      final source = grammarSources.first;
      expect(source.name, equals('Shinkanzen Master N3 文法'));

      // Verify units
      final units = await (db.select(db.units)
            ..where((u) => u.sourceId.equals(source.id)))
          .get();
      expect(units.length, equals(12));

      // Verify grammar items
      final grammarItems = await (db.select(db.grammarSourceItems)
            ..where((item) => item.sourceId.equals(source.id)))
          .get();
      expect(grammarItems.length, equals(100));

      // Verify grammar points have details
      final firstPoint = await (db.select(db.grammarPoints)
            ..where((p) => p.id.equals(grammarItems.first.grammarId)))
          .getSingle();

      expect(firstPoint.pattern, isNotEmpty);
      expect(firstPoint.connection, isNotNull);
      expect(firstPoint.meaningMy, isNotNull);
      expect(firstPoint.exampleJp, isNotNull);
      expect(firstPoint.exampleMy, isNotNull);
    });
  });
}
