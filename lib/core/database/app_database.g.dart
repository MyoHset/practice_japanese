// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SourcesTable extends Sources with TableInfo<$SourcesTable, Source> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SourcesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  @override
  late final GeneratedColumnWithTypeConverter<SourceType, int> type =
      GeneratedColumn<int>('type', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<SourceType>($SourcesTable.$convertertype);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _jlptLevelMeta =
      const VerificationMeta('jlptLevel');
  @override
  late final GeneratedColumn<String> jlptLevel = GeneratedColumn<String>(
      'jlpt_level', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _examYearMeta =
      const VerificationMeta('examYear');
  @override
  late final GeneratedColumn<int> examYear = GeneratedColumn<int>(
      'exam_year', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _examMonthMeta =
      const VerificationMeta('examMonth');
  @override
  late final GeneratedColumn<int> examMonth = GeneratedColumn<int>(
      'exam_month', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, type, name, jlptLevel, examYear, examMonth, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sources';
  @override
  VerificationContext validateIntegrity(Insertable<Source> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('jlpt_level')) {
      context.handle(_jlptLevelMeta,
          jlptLevel.isAcceptableOrUnknown(data['jlpt_level']!, _jlptLevelMeta));
    }
    if (data.containsKey('exam_year')) {
      context.handle(_examYearMeta,
          examYear.isAcceptableOrUnknown(data['exam_year']!, _examYearMeta));
    }
    if (data.containsKey('exam_month')) {
      context.handle(_examMonthMeta,
          examMonth.isAcceptableOrUnknown(data['exam_month']!, _examMonthMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Source map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Source(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      type: $SourcesTable.$convertertype.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type'])!),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      jlptLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}jlpt_level']),
      examYear: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}exam_year']),
      examMonth: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}exam_month']),
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
    );
  }

  @override
  $SourcesTable createAlias(String alias) {
    return $SourcesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SourceType, int, int> $convertertype =
      const EnumIndexConverter<SourceType>(SourceType.values);
}

class Source extends DataClass implements Insertable<Source> {
  final int id;
  final SourceType type;
  final String name;
  final String? jlptLevel;
  final int? examYear;
  final int? examMonth;
  final int sortOrder;
  const Source(
      {required this.id,
      required this.type,
      required this.name,
      this.jlptLevel,
      this.examYear,
      this.examMonth,
      required this.sortOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['type'] = Variable<int>($SourcesTable.$convertertype.toSql(type));
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || jlptLevel != null) {
      map['jlpt_level'] = Variable<String>(jlptLevel);
    }
    if (!nullToAbsent || examYear != null) {
      map['exam_year'] = Variable<int>(examYear);
    }
    if (!nullToAbsent || examMonth != null) {
      map['exam_month'] = Variable<int>(examMonth);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  SourcesCompanion toCompanion(bool nullToAbsent) {
    return SourcesCompanion(
      id: Value(id),
      type: Value(type),
      name: Value(name),
      jlptLevel: jlptLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(jlptLevel),
      examYear: examYear == null && nullToAbsent
          ? const Value.absent()
          : Value(examYear),
      examMonth: examMonth == null && nullToAbsent
          ? const Value.absent()
          : Value(examMonth),
      sortOrder: Value(sortOrder),
    );
  }

  factory Source.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Source(
      id: serializer.fromJson<int>(json['id']),
      type: $SourcesTable.$convertertype
          .fromJson(serializer.fromJson<int>(json['type'])),
      name: serializer.fromJson<String>(json['name']),
      jlptLevel: serializer.fromJson<String?>(json['jlptLevel']),
      examYear: serializer.fromJson<int?>(json['examYear']),
      examMonth: serializer.fromJson<int?>(json['examMonth']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<int>($SourcesTable.$convertertype.toJson(type)),
      'name': serializer.toJson<String>(name),
      'jlptLevel': serializer.toJson<String?>(jlptLevel),
      'examYear': serializer.toJson<int?>(examYear),
      'examMonth': serializer.toJson<int?>(examMonth),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  Source copyWith(
          {int? id,
          SourceType? type,
          String? name,
          Value<String?> jlptLevel = const Value.absent(),
          Value<int?> examYear = const Value.absent(),
          Value<int?> examMonth = const Value.absent(),
          int? sortOrder}) =>
      Source(
        id: id ?? this.id,
        type: type ?? this.type,
        name: name ?? this.name,
        jlptLevel: jlptLevel.present ? jlptLevel.value : this.jlptLevel,
        examYear: examYear.present ? examYear.value : this.examYear,
        examMonth: examMonth.present ? examMonth.value : this.examMonth,
        sortOrder: sortOrder ?? this.sortOrder,
      );
  Source copyWithCompanion(SourcesCompanion data) {
    return Source(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      name: data.name.present ? data.name.value : this.name,
      jlptLevel: data.jlptLevel.present ? data.jlptLevel.value : this.jlptLevel,
      examYear: data.examYear.present ? data.examYear.value : this.examYear,
      examMonth: data.examMonth.present ? data.examMonth.value : this.examMonth,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Source(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('jlptLevel: $jlptLevel, ')
          ..write('examYear: $examYear, ')
          ..write('examMonth: $examMonth, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, type, name, jlptLevel, examYear, examMonth, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Source &&
          other.id == this.id &&
          other.type == this.type &&
          other.name == this.name &&
          other.jlptLevel == this.jlptLevel &&
          other.examYear == this.examYear &&
          other.examMonth == this.examMonth &&
          other.sortOrder == this.sortOrder);
}

class SourcesCompanion extends UpdateCompanion<Source> {
  final Value<int> id;
  final Value<SourceType> type;
  final Value<String> name;
  final Value<String?> jlptLevel;
  final Value<int?> examYear;
  final Value<int?> examMonth;
  final Value<int> sortOrder;
  const SourcesCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.name = const Value.absent(),
    this.jlptLevel = const Value.absent(),
    this.examYear = const Value.absent(),
    this.examMonth = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  SourcesCompanion.insert({
    this.id = const Value.absent(),
    required SourceType type,
    required String name,
    this.jlptLevel = const Value.absent(),
    this.examYear = const Value.absent(),
    this.examMonth = const Value.absent(),
    this.sortOrder = const Value.absent(),
  })  : type = Value(type),
        name = Value(name);
  static Insertable<Source> custom({
    Expression<int>? id,
    Expression<int>? type,
    Expression<String>? name,
    Expression<String>? jlptLevel,
    Expression<int>? examYear,
    Expression<int>? examMonth,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (name != null) 'name': name,
      if (jlptLevel != null) 'jlpt_level': jlptLevel,
      if (examYear != null) 'exam_year': examYear,
      if (examMonth != null) 'exam_month': examMonth,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  SourcesCompanion copyWith(
      {Value<int>? id,
      Value<SourceType>? type,
      Value<String>? name,
      Value<String?>? jlptLevel,
      Value<int?>? examYear,
      Value<int?>? examMonth,
      Value<int>? sortOrder}) {
    return SourcesCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      jlptLevel: jlptLevel ?? this.jlptLevel,
      examYear: examYear ?? this.examYear,
      examMonth: examMonth ?? this.examMonth,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] =
          Variable<int>($SourcesTable.$convertertype.toSql(type.value));
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (jlptLevel.present) {
      map['jlpt_level'] = Variable<String>(jlptLevel.value);
    }
    if (examYear.present) {
      map['exam_year'] = Variable<int>(examYear.value);
    }
    if (examMonth.present) {
      map['exam_month'] = Variable<int>(examMonth.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SourcesCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('jlptLevel: $jlptLevel, ')
          ..write('examYear: $examYear, ')
          ..write('examMonth: $examMonth, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $UnitsTable extends Units with TableInfo<$UnitsTable, Unit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _sourceIdMeta =
      const VerificationMeta('sourceId');
  @override
  late final GeneratedColumn<int> sourceId = GeneratedColumn<int>(
      'source_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _orderNoMeta =
      const VerificationMeta('orderNo');
  @override
  late final GeneratedColumn<int> orderNo = GeneratedColumn<int>(
      'order_no', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, sourceId, name, orderNo];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'units';
  @override
  VerificationContext validateIntegrity(Insertable<Unit> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('source_id')) {
      context.handle(_sourceIdMeta,
          sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta));
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('order_no')) {
      context.handle(_orderNoMeta,
          orderNo.isAcceptableOrUnknown(data['order_no']!, _orderNoMeta));
    } else if (isInserting) {
      context.missing(_orderNoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {sourceId, orderNo},
      ];
  @override
  Unit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Unit(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sourceId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}source_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      orderNo: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order_no'])!,
    );
  }

  @override
  $UnitsTable createAlias(String alias) {
    return $UnitsTable(attachedDatabase, alias);
  }
}

class Unit extends DataClass implements Insertable<Unit> {
  final int id;
  final int sourceId;
  final String name;
  final int orderNo;
  const Unit(
      {required this.id,
      required this.sourceId,
      required this.name,
      required this.orderNo});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['source_id'] = Variable<int>(sourceId);
    map['name'] = Variable<String>(name);
    map['order_no'] = Variable<int>(orderNo);
    return map;
  }

  UnitsCompanion toCompanion(bool nullToAbsent) {
    return UnitsCompanion(
      id: Value(id),
      sourceId: Value(sourceId),
      name: Value(name),
      orderNo: Value(orderNo),
    );
  }

  factory Unit.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Unit(
      id: serializer.fromJson<int>(json['id']),
      sourceId: serializer.fromJson<int>(json['sourceId']),
      name: serializer.fromJson<String>(json['name']),
      orderNo: serializer.fromJson<int>(json['orderNo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sourceId': serializer.toJson<int>(sourceId),
      'name': serializer.toJson<String>(name),
      'orderNo': serializer.toJson<int>(orderNo),
    };
  }

  Unit copyWith({int? id, int? sourceId, String? name, int? orderNo}) => Unit(
        id: id ?? this.id,
        sourceId: sourceId ?? this.sourceId,
        name: name ?? this.name,
        orderNo: orderNo ?? this.orderNo,
      );
  Unit copyWithCompanion(UnitsCompanion data) {
    return Unit(
      id: data.id.present ? data.id.value : this.id,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      name: data.name.present ? data.name.value : this.name,
      orderNo: data.orderNo.present ? data.orderNo.value : this.orderNo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Unit(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('name: $name, ')
          ..write('orderNo: $orderNo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sourceId, name, orderNo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Unit &&
          other.id == this.id &&
          other.sourceId == this.sourceId &&
          other.name == this.name &&
          other.orderNo == this.orderNo);
}

class UnitsCompanion extends UpdateCompanion<Unit> {
  final Value<int> id;
  final Value<int> sourceId;
  final Value<String> name;
  final Value<int> orderNo;
  const UnitsCompanion({
    this.id = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.name = const Value.absent(),
    this.orderNo = const Value.absent(),
  });
  UnitsCompanion.insert({
    this.id = const Value.absent(),
    required int sourceId,
    required String name,
    required int orderNo,
  })  : sourceId = Value(sourceId),
        name = Value(name),
        orderNo = Value(orderNo);
  static Insertable<Unit> custom({
    Expression<int>? id,
    Expression<int>? sourceId,
    Expression<String>? name,
    Expression<int>? orderNo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceId != null) 'source_id': sourceId,
      if (name != null) 'name': name,
      if (orderNo != null) 'order_no': orderNo,
    });
  }

  UnitsCompanion copyWith(
      {Value<int>? id,
      Value<int>? sourceId,
      Value<String>? name,
      Value<int>? orderNo}) {
    return UnitsCompanion(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      name: name ?? this.name,
      orderNo: orderNo ?? this.orderNo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<int>(sourceId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (orderNo.present) {
      map['order_no'] = Variable<int>(orderNo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnitsCompanion(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('name: $name, ')
          ..write('orderNo: $orderNo')
          ..write(')'))
        .toString();
  }
}

class $KanjisTable extends Kanjis with TableInfo<$KanjisTable, Kanji> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KanjisTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _characterMeta =
      const VerificationMeta('character');
  @override
  late final GeneratedColumn<String> character = GeneratedColumn<String>(
      'character', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _meaningMyMeta =
      const VerificationMeta('meaningMy');
  @override
  late final GeneratedColumn<String> meaningMy = GeneratedColumn<String>(
      'meaning_my', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _meaningEnMeta =
      const VerificationMeta('meaningEn');
  @override
  late final GeneratedColumn<String> meaningEn = GeneratedColumn<String>(
      'meaning_en', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _strokeCountMeta =
      const VerificationMeta('strokeCount');
  @override
  late final GeneratedColumn<int> strokeCount = GeneratedColumn<int>(
      'stroke_count', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _radicalMeta =
      const VerificationMeta('radical');
  @override
  late final GeneratedColumn<String> radical = GeneratedColumn<String>(
      'radical', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, character, meaningMy, meaningEn, strokeCount, radical];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kanjis';
  @override
  VerificationContext validateIntegrity(Insertable<Kanji> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('character')) {
      context.handle(_characterMeta,
          character.isAcceptableOrUnknown(data['character']!, _characterMeta));
    } else if (isInserting) {
      context.missing(_characterMeta);
    }
    if (data.containsKey('meaning_my')) {
      context.handle(_meaningMyMeta,
          meaningMy.isAcceptableOrUnknown(data['meaning_my']!, _meaningMyMeta));
    }
    if (data.containsKey('meaning_en')) {
      context.handle(_meaningEnMeta,
          meaningEn.isAcceptableOrUnknown(data['meaning_en']!, _meaningEnMeta));
    }
    if (data.containsKey('stroke_count')) {
      context.handle(
          _strokeCountMeta,
          strokeCount.isAcceptableOrUnknown(
              data['stroke_count']!, _strokeCountMeta));
    }
    if (data.containsKey('radical')) {
      context.handle(_radicalMeta,
          radical.isAcceptableOrUnknown(data['radical']!, _radicalMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Kanji map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Kanji(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      character: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}character'])!,
      meaningMy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}meaning_my']),
      meaningEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}meaning_en']),
      strokeCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stroke_count']),
      radical: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}radical']),
    );
  }

  @override
  $KanjisTable createAlias(String alias) {
    return $KanjisTable(attachedDatabase, alias);
  }
}

class Kanji extends DataClass implements Insertable<Kanji> {
  final int id;
  final String character;
  final String? meaningMy;
  final String? meaningEn;
  final int? strokeCount;
  final String? radical;
  const Kanji(
      {required this.id,
      required this.character,
      this.meaningMy,
      this.meaningEn,
      this.strokeCount,
      this.radical});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['character'] = Variable<String>(character);
    if (!nullToAbsent || meaningMy != null) {
      map['meaning_my'] = Variable<String>(meaningMy);
    }
    if (!nullToAbsent || meaningEn != null) {
      map['meaning_en'] = Variable<String>(meaningEn);
    }
    if (!nullToAbsent || strokeCount != null) {
      map['stroke_count'] = Variable<int>(strokeCount);
    }
    if (!nullToAbsent || radical != null) {
      map['radical'] = Variable<String>(radical);
    }
    return map;
  }

  KanjisCompanion toCompanion(bool nullToAbsent) {
    return KanjisCompanion(
      id: Value(id),
      character: Value(character),
      meaningMy: meaningMy == null && nullToAbsent
          ? const Value.absent()
          : Value(meaningMy),
      meaningEn: meaningEn == null && nullToAbsent
          ? const Value.absent()
          : Value(meaningEn),
      strokeCount: strokeCount == null && nullToAbsent
          ? const Value.absent()
          : Value(strokeCount),
      radical: radical == null && nullToAbsent
          ? const Value.absent()
          : Value(radical),
    );
  }

  factory Kanji.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Kanji(
      id: serializer.fromJson<int>(json['id']),
      character: serializer.fromJson<String>(json['character']),
      meaningMy: serializer.fromJson<String?>(json['meaningMy']),
      meaningEn: serializer.fromJson<String?>(json['meaningEn']),
      strokeCount: serializer.fromJson<int?>(json['strokeCount']),
      radical: serializer.fromJson<String?>(json['radical']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'character': serializer.toJson<String>(character),
      'meaningMy': serializer.toJson<String?>(meaningMy),
      'meaningEn': serializer.toJson<String?>(meaningEn),
      'strokeCount': serializer.toJson<int?>(strokeCount),
      'radical': serializer.toJson<String?>(radical),
    };
  }

  Kanji copyWith(
          {int? id,
          String? character,
          Value<String?> meaningMy = const Value.absent(),
          Value<String?> meaningEn = const Value.absent(),
          Value<int?> strokeCount = const Value.absent(),
          Value<String?> radical = const Value.absent()}) =>
      Kanji(
        id: id ?? this.id,
        character: character ?? this.character,
        meaningMy: meaningMy.present ? meaningMy.value : this.meaningMy,
        meaningEn: meaningEn.present ? meaningEn.value : this.meaningEn,
        strokeCount: strokeCount.present ? strokeCount.value : this.strokeCount,
        radical: radical.present ? radical.value : this.radical,
      );
  Kanji copyWithCompanion(KanjisCompanion data) {
    return Kanji(
      id: data.id.present ? data.id.value : this.id,
      character: data.character.present ? data.character.value : this.character,
      meaningMy: data.meaningMy.present ? data.meaningMy.value : this.meaningMy,
      meaningEn: data.meaningEn.present ? data.meaningEn.value : this.meaningEn,
      strokeCount:
          data.strokeCount.present ? data.strokeCount.value : this.strokeCount,
      radical: data.radical.present ? data.radical.value : this.radical,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Kanji(')
          ..write('id: $id, ')
          ..write('character: $character, ')
          ..write('meaningMy: $meaningMy, ')
          ..write('meaningEn: $meaningEn, ')
          ..write('strokeCount: $strokeCount, ')
          ..write('radical: $radical')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, character, meaningMy, meaningEn, strokeCount, radical);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Kanji &&
          other.id == this.id &&
          other.character == this.character &&
          other.meaningMy == this.meaningMy &&
          other.meaningEn == this.meaningEn &&
          other.strokeCount == this.strokeCount &&
          other.radical == this.radical);
}

class KanjisCompanion extends UpdateCompanion<Kanji> {
  final Value<int> id;
  final Value<String> character;
  final Value<String?> meaningMy;
  final Value<String?> meaningEn;
  final Value<int?> strokeCount;
  final Value<String?> radical;
  const KanjisCompanion({
    this.id = const Value.absent(),
    this.character = const Value.absent(),
    this.meaningMy = const Value.absent(),
    this.meaningEn = const Value.absent(),
    this.strokeCount = const Value.absent(),
    this.radical = const Value.absent(),
  });
  KanjisCompanion.insert({
    this.id = const Value.absent(),
    required String character,
    this.meaningMy = const Value.absent(),
    this.meaningEn = const Value.absent(),
    this.strokeCount = const Value.absent(),
    this.radical = const Value.absent(),
  }) : character = Value(character);
  static Insertable<Kanji> custom({
    Expression<int>? id,
    Expression<String>? character,
    Expression<String>? meaningMy,
    Expression<String>? meaningEn,
    Expression<int>? strokeCount,
    Expression<String>? radical,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (character != null) 'character': character,
      if (meaningMy != null) 'meaning_my': meaningMy,
      if (meaningEn != null) 'meaning_en': meaningEn,
      if (strokeCount != null) 'stroke_count': strokeCount,
      if (radical != null) 'radical': radical,
    });
  }

  KanjisCompanion copyWith(
      {Value<int>? id,
      Value<String>? character,
      Value<String?>? meaningMy,
      Value<String?>? meaningEn,
      Value<int?>? strokeCount,
      Value<String?>? radical}) {
    return KanjisCompanion(
      id: id ?? this.id,
      character: character ?? this.character,
      meaningMy: meaningMy ?? this.meaningMy,
      meaningEn: meaningEn ?? this.meaningEn,
      strokeCount: strokeCount ?? this.strokeCount,
      radical: radical ?? this.radical,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (character.present) {
      map['character'] = Variable<String>(character.value);
    }
    if (meaningMy.present) {
      map['meaning_my'] = Variable<String>(meaningMy.value);
    }
    if (meaningEn.present) {
      map['meaning_en'] = Variable<String>(meaningEn.value);
    }
    if (strokeCount.present) {
      map['stroke_count'] = Variable<int>(strokeCount.value);
    }
    if (radical.present) {
      map['radical'] = Variable<String>(radical.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KanjisCompanion(')
          ..write('id: $id, ')
          ..write('character: $character, ')
          ..write('meaningMy: $meaningMy, ')
          ..write('meaningEn: $meaningEn, ')
          ..write('strokeCount: $strokeCount, ')
          ..write('radical: $radical')
          ..write(')'))
        .toString();
  }
}

class $KanjiReadingsTable extends KanjiReadings
    with TableInfo<$KanjiReadingsTable, KanjiReading> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KanjiReadingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _kanjiIdMeta =
      const VerificationMeta('kanjiId');
  @override
  late final GeneratedColumn<int> kanjiId = GeneratedColumn<int>(
      'kanji_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<ReadingType, int> type =
      GeneratedColumn<int>('type', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<ReadingType>($KanjiReadingsTable.$convertertype);
  static const VerificationMeta _readingMeta =
      const VerificationMeta('reading');
  @override
  late final GeneratedColumn<String> reading = GeneratedColumn<String>(
      'reading', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, kanjiId, type, reading];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kanji_readings';
  @override
  VerificationContext validateIntegrity(Insertable<KanjiReading> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kanji_id')) {
      context.handle(_kanjiIdMeta,
          kanjiId.isAcceptableOrUnknown(data['kanji_id']!, _kanjiIdMeta));
    } else if (isInserting) {
      context.missing(_kanjiIdMeta);
    }
    if (data.containsKey('reading')) {
      context.handle(_readingMeta,
          reading.isAcceptableOrUnknown(data['reading']!, _readingMeta));
    } else if (isInserting) {
      context.missing(_readingMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KanjiReading map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KanjiReading(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      kanjiId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}kanji_id'])!,
      type: $KanjiReadingsTable.$convertertype.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type'])!),
      reading: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reading'])!,
    );
  }

  @override
  $KanjiReadingsTable createAlias(String alias) {
    return $KanjiReadingsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ReadingType, int, int> $convertertype =
      const EnumIndexConverter<ReadingType>(ReadingType.values);
}

class KanjiReading extends DataClass implements Insertable<KanjiReading> {
  final int id;
  final int kanjiId;
  final ReadingType type;
  final String reading;
  const KanjiReading(
      {required this.id,
      required this.kanjiId,
      required this.type,
      required this.reading});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['kanji_id'] = Variable<int>(kanjiId);
    {
      map['type'] =
          Variable<int>($KanjiReadingsTable.$convertertype.toSql(type));
    }
    map['reading'] = Variable<String>(reading);
    return map;
  }

  KanjiReadingsCompanion toCompanion(bool nullToAbsent) {
    return KanjiReadingsCompanion(
      id: Value(id),
      kanjiId: Value(kanjiId),
      type: Value(type),
      reading: Value(reading),
    );
  }

  factory KanjiReading.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KanjiReading(
      id: serializer.fromJson<int>(json['id']),
      kanjiId: serializer.fromJson<int>(json['kanjiId']),
      type: $KanjiReadingsTable.$convertertype
          .fromJson(serializer.fromJson<int>(json['type'])),
      reading: serializer.fromJson<String>(json['reading']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kanjiId': serializer.toJson<int>(kanjiId),
      'type': serializer
          .toJson<int>($KanjiReadingsTable.$convertertype.toJson(type)),
      'reading': serializer.toJson<String>(reading),
    };
  }

  KanjiReading copyWith(
          {int? id, int? kanjiId, ReadingType? type, String? reading}) =>
      KanjiReading(
        id: id ?? this.id,
        kanjiId: kanjiId ?? this.kanjiId,
        type: type ?? this.type,
        reading: reading ?? this.reading,
      );
  KanjiReading copyWithCompanion(KanjiReadingsCompanion data) {
    return KanjiReading(
      id: data.id.present ? data.id.value : this.id,
      kanjiId: data.kanjiId.present ? data.kanjiId.value : this.kanjiId,
      type: data.type.present ? data.type.value : this.type,
      reading: data.reading.present ? data.reading.value : this.reading,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KanjiReading(')
          ..write('id: $id, ')
          ..write('kanjiId: $kanjiId, ')
          ..write('type: $type, ')
          ..write('reading: $reading')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, kanjiId, type, reading);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KanjiReading &&
          other.id == this.id &&
          other.kanjiId == this.kanjiId &&
          other.type == this.type &&
          other.reading == this.reading);
}

class KanjiReadingsCompanion extends UpdateCompanion<KanjiReading> {
  final Value<int> id;
  final Value<int> kanjiId;
  final Value<ReadingType> type;
  final Value<String> reading;
  const KanjiReadingsCompanion({
    this.id = const Value.absent(),
    this.kanjiId = const Value.absent(),
    this.type = const Value.absent(),
    this.reading = const Value.absent(),
  });
  KanjiReadingsCompanion.insert({
    this.id = const Value.absent(),
    required int kanjiId,
    required ReadingType type,
    required String reading,
  })  : kanjiId = Value(kanjiId),
        type = Value(type),
        reading = Value(reading);
  static Insertable<KanjiReading> custom({
    Expression<int>? id,
    Expression<int>? kanjiId,
    Expression<int>? type,
    Expression<String>? reading,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kanjiId != null) 'kanji_id': kanjiId,
      if (type != null) 'type': type,
      if (reading != null) 'reading': reading,
    });
  }

  KanjiReadingsCompanion copyWith(
      {Value<int>? id,
      Value<int>? kanjiId,
      Value<ReadingType>? type,
      Value<String>? reading}) {
    return KanjiReadingsCompanion(
      id: id ?? this.id,
      kanjiId: kanjiId ?? this.kanjiId,
      type: type ?? this.type,
      reading: reading ?? this.reading,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kanjiId.present) {
      map['kanji_id'] = Variable<int>(kanjiId.value);
    }
    if (type.present) {
      map['type'] =
          Variable<int>($KanjiReadingsTable.$convertertype.toSql(type.value));
    }
    if (reading.present) {
      map['reading'] = Variable<String>(reading.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KanjiReadingsCompanion(')
          ..write('id: $id, ')
          ..write('kanjiId: $kanjiId, ')
          ..write('type: $type, ')
          ..write('reading: $reading')
          ..write(')'))
        .toString();
  }
}

class $KanjiSourceItemsTable extends KanjiSourceItems
    with TableInfo<$KanjiSourceItemsTable, KanjiSourceItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KanjiSourceItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _kanjiIdMeta =
      const VerificationMeta('kanjiId');
  @override
  late final GeneratedColumn<int> kanjiId = GeneratedColumn<int>(
      'kanji_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _sourceIdMeta =
      const VerificationMeta('sourceId');
  @override
  late final GeneratedColumn<int> sourceId = GeneratedColumn<int>(
      'source_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _unitIdMeta = const VerificationMeta('unitId');
  @override
  late final GeneratedColumn<int> unitId = GeneratedColumn<int>(
      'unit_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _jlptLevelMeta =
      const VerificationMeta('jlptLevel');
  @override
  late final GeneratedColumn<String> jlptLevel = GeneratedColumn<String>(
      'jlpt_level', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, kanjiId, sourceId, unitId, position, jlptLevel];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kanji_source_items';
  @override
  VerificationContext validateIntegrity(Insertable<KanjiSourceItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kanji_id')) {
      context.handle(_kanjiIdMeta,
          kanjiId.isAcceptableOrUnknown(data['kanji_id']!, _kanjiIdMeta));
    } else if (isInserting) {
      context.missing(_kanjiIdMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(_sourceIdMeta,
          sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta));
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('unit_id')) {
      context.handle(_unitIdMeta,
          unitId.isAcceptableOrUnknown(data['unit_id']!, _unitIdMeta));
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    }
    if (data.containsKey('jlpt_level')) {
      context.handle(_jlptLevelMeta,
          jlptLevel.isAcceptableOrUnknown(data['jlpt_level']!, _jlptLevelMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {kanjiId, sourceId},
      ];
  @override
  KanjiSourceItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KanjiSourceItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      kanjiId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}kanji_id'])!,
      sourceId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}source_id'])!,
      unitId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}unit_id']),
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      jlptLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}jlpt_level']),
    );
  }

  @override
  $KanjiSourceItemsTable createAlias(String alias) {
    return $KanjiSourceItemsTable(attachedDatabase, alias);
  }
}

class KanjiSourceItem extends DataClass implements Insertable<KanjiSourceItem> {
  final int id;
  final int kanjiId;
  final int sourceId;
  final int? unitId;
  final int position;

  /// item အဆင့် level (source.jlptLevel ကို override)။ COALESCE(item, source) နဲ့ ယူ
  final String? jlptLevel;
  const KanjiSourceItem(
      {required this.id,
      required this.kanjiId,
      required this.sourceId,
      this.unitId,
      required this.position,
      this.jlptLevel});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['kanji_id'] = Variable<int>(kanjiId);
    map['source_id'] = Variable<int>(sourceId);
    if (!nullToAbsent || unitId != null) {
      map['unit_id'] = Variable<int>(unitId);
    }
    map['position'] = Variable<int>(position);
    if (!nullToAbsent || jlptLevel != null) {
      map['jlpt_level'] = Variable<String>(jlptLevel);
    }
    return map;
  }

  KanjiSourceItemsCompanion toCompanion(bool nullToAbsent) {
    return KanjiSourceItemsCompanion(
      id: Value(id),
      kanjiId: Value(kanjiId),
      sourceId: Value(sourceId),
      unitId:
          unitId == null && nullToAbsent ? const Value.absent() : Value(unitId),
      position: Value(position),
      jlptLevel: jlptLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(jlptLevel),
    );
  }

  factory KanjiSourceItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KanjiSourceItem(
      id: serializer.fromJson<int>(json['id']),
      kanjiId: serializer.fromJson<int>(json['kanjiId']),
      sourceId: serializer.fromJson<int>(json['sourceId']),
      unitId: serializer.fromJson<int?>(json['unitId']),
      position: serializer.fromJson<int>(json['position']),
      jlptLevel: serializer.fromJson<String?>(json['jlptLevel']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kanjiId': serializer.toJson<int>(kanjiId),
      'sourceId': serializer.toJson<int>(sourceId),
      'unitId': serializer.toJson<int?>(unitId),
      'position': serializer.toJson<int>(position),
      'jlptLevel': serializer.toJson<String?>(jlptLevel),
    };
  }

  KanjiSourceItem copyWith(
          {int? id,
          int? kanjiId,
          int? sourceId,
          Value<int?> unitId = const Value.absent(),
          int? position,
          Value<String?> jlptLevel = const Value.absent()}) =>
      KanjiSourceItem(
        id: id ?? this.id,
        kanjiId: kanjiId ?? this.kanjiId,
        sourceId: sourceId ?? this.sourceId,
        unitId: unitId.present ? unitId.value : this.unitId,
        position: position ?? this.position,
        jlptLevel: jlptLevel.present ? jlptLevel.value : this.jlptLevel,
      );
  KanjiSourceItem copyWithCompanion(KanjiSourceItemsCompanion data) {
    return KanjiSourceItem(
      id: data.id.present ? data.id.value : this.id,
      kanjiId: data.kanjiId.present ? data.kanjiId.value : this.kanjiId,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      unitId: data.unitId.present ? data.unitId.value : this.unitId,
      position: data.position.present ? data.position.value : this.position,
      jlptLevel: data.jlptLevel.present ? data.jlptLevel.value : this.jlptLevel,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KanjiSourceItem(')
          ..write('id: $id, ')
          ..write('kanjiId: $kanjiId, ')
          ..write('sourceId: $sourceId, ')
          ..write('unitId: $unitId, ')
          ..write('position: $position, ')
          ..write('jlptLevel: $jlptLevel')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, kanjiId, sourceId, unitId, position, jlptLevel);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KanjiSourceItem &&
          other.id == this.id &&
          other.kanjiId == this.kanjiId &&
          other.sourceId == this.sourceId &&
          other.unitId == this.unitId &&
          other.position == this.position &&
          other.jlptLevel == this.jlptLevel);
}

class KanjiSourceItemsCompanion extends UpdateCompanion<KanjiSourceItem> {
  final Value<int> id;
  final Value<int> kanjiId;
  final Value<int> sourceId;
  final Value<int?> unitId;
  final Value<int> position;
  final Value<String?> jlptLevel;
  const KanjiSourceItemsCompanion({
    this.id = const Value.absent(),
    this.kanjiId = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.unitId = const Value.absent(),
    this.position = const Value.absent(),
    this.jlptLevel = const Value.absent(),
  });
  KanjiSourceItemsCompanion.insert({
    this.id = const Value.absent(),
    required int kanjiId,
    required int sourceId,
    this.unitId = const Value.absent(),
    this.position = const Value.absent(),
    this.jlptLevel = const Value.absent(),
  })  : kanjiId = Value(kanjiId),
        sourceId = Value(sourceId);
  static Insertable<KanjiSourceItem> custom({
    Expression<int>? id,
    Expression<int>? kanjiId,
    Expression<int>? sourceId,
    Expression<int>? unitId,
    Expression<int>? position,
    Expression<String>? jlptLevel,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kanjiId != null) 'kanji_id': kanjiId,
      if (sourceId != null) 'source_id': sourceId,
      if (unitId != null) 'unit_id': unitId,
      if (position != null) 'position': position,
      if (jlptLevel != null) 'jlpt_level': jlptLevel,
    });
  }

  KanjiSourceItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? kanjiId,
      Value<int>? sourceId,
      Value<int?>? unitId,
      Value<int>? position,
      Value<String?>? jlptLevel}) {
    return KanjiSourceItemsCompanion(
      id: id ?? this.id,
      kanjiId: kanjiId ?? this.kanjiId,
      sourceId: sourceId ?? this.sourceId,
      unitId: unitId ?? this.unitId,
      position: position ?? this.position,
      jlptLevel: jlptLevel ?? this.jlptLevel,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kanjiId.present) {
      map['kanji_id'] = Variable<int>(kanjiId.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<int>(sourceId.value);
    }
    if (unitId.present) {
      map['unit_id'] = Variable<int>(unitId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (jlptLevel.present) {
      map['jlpt_level'] = Variable<String>(jlptLevel.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KanjiSourceItemsCompanion(')
          ..write('id: $id, ')
          ..write('kanjiId: $kanjiId, ')
          ..write('sourceId: $sourceId, ')
          ..write('unitId: $unitId, ')
          ..write('position: $position, ')
          ..write('jlptLevel: $jlptLevel')
          ..write(')'))
        .toString();
  }
}

class $VocabulariesTable extends Vocabularies
    with TableInfo<$VocabulariesTable, Vocabulary> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VocabulariesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _wordMeta = const VerificationMeta('word');
  @override
  late final GeneratedColumn<String> word = GeneratedColumn<String>(
      'word', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _readingMeta =
      const VerificationMeta('reading');
  @override
  late final GeneratedColumn<String> reading = GeneratedColumn<String>(
      'reading', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _meaningMyMeta =
      const VerificationMeta('meaningMy');
  @override
  late final GeneratedColumn<String> meaningMy = GeneratedColumn<String>(
      'meaning_my', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _meaningEnMeta =
      const VerificationMeta('meaningEn');
  @override
  late final GeneratedColumn<String> meaningEn = GeneratedColumn<String>(
      'meaning_en', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _partOfSpeechMeta =
      const VerificationMeta('partOfSpeech');
  @override
  late final GeneratedColumn<String> partOfSpeech = GeneratedColumn<String>(
      'part_of_speech', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _exampleJpMeta =
      const VerificationMeta('exampleJp');
  @override
  late final GeneratedColumn<String> exampleJp = GeneratedColumn<String>(
      'example_jp', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _exampleMyMeta =
      const VerificationMeta('exampleMy');
  @override
  late final GeneratedColumn<String> exampleMy = GeneratedColumn<String>(
      'example_my', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        word,
        reading,
        meaningMy,
        meaningEn,
        partOfSpeech,
        exampleJp,
        exampleMy
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vocabularies';
  @override
  VerificationContext validateIntegrity(Insertable<Vocabulary> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('word')) {
      context.handle(
          _wordMeta, word.isAcceptableOrUnknown(data['word']!, _wordMeta));
    } else if (isInserting) {
      context.missing(_wordMeta);
    }
    if (data.containsKey('reading')) {
      context.handle(_readingMeta,
          reading.isAcceptableOrUnknown(data['reading']!, _readingMeta));
    } else if (isInserting) {
      context.missing(_readingMeta);
    }
    if (data.containsKey('meaning_my')) {
      context.handle(_meaningMyMeta,
          meaningMy.isAcceptableOrUnknown(data['meaning_my']!, _meaningMyMeta));
    }
    if (data.containsKey('meaning_en')) {
      context.handle(_meaningEnMeta,
          meaningEn.isAcceptableOrUnknown(data['meaning_en']!, _meaningEnMeta));
    }
    if (data.containsKey('part_of_speech')) {
      context.handle(
          _partOfSpeechMeta,
          partOfSpeech.isAcceptableOrUnknown(
              data['part_of_speech']!, _partOfSpeechMeta));
    }
    if (data.containsKey('example_jp')) {
      context.handle(_exampleJpMeta,
          exampleJp.isAcceptableOrUnknown(data['example_jp']!, _exampleJpMeta));
    }
    if (data.containsKey('example_my')) {
      context.handle(_exampleMyMeta,
          exampleMy.isAcceptableOrUnknown(data['example_my']!, _exampleMyMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Vocabulary map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Vocabulary(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      word: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}word'])!,
      reading: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reading'])!,
      meaningMy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}meaning_my']),
      meaningEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}meaning_en']),
      partOfSpeech: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}part_of_speech']),
      exampleJp: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}example_jp']),
      exampleMy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}example_my']),
    );
  }

  @override
  $VocabulariesTable createAlias(String alias) {
    return $VocabulariesTable(attachedDatabase, alias);
  }
}

class Vocabulary extends DataClass implements Insertable<Vocabulary> {
  final int id;
  final String word;
  final String reading;
  final String? meaningMy;
  final String? meaningEn;
  final String? partOfSpeech;
  final String? exampleJp;
  final String? exampleMy;
  const Vocabulary(
      {required this.id,
      required this.word,
      required this.reading,
      this.meaningMy,
      this.meaningEn,
      this.partOfSpeech,
      this.exampleJp,
      this.exampleMy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['word'] = Variable<String>(word);
    map['reading'] = Variable<String>(reading);
    if (!nullToAbsent || meaningMy != null) {
      map['meaning_my'] = Variable<String>(meaningMy);
    }
    if (!nullToAbsent || meaningEn != null) {
      map['meaning_en'] = Variable<String>(meaningEn);
    }
    if (!nullToAbsent || partOfSpeech != null) {
      map['part_of_speech'] = Variable<String>(partOfSpeech);
    }
    if (!nullToAbsent || exampleJp != null) {
      map['example_jp'] = Variable<String>(exampleJp);
    }
    if (!nullToAbsent || exampleMy != null) {
      map['example_my'] = Variable<String>(exampleMy);
    }
    return map;
  }

  VocabulariesCompanion toCompanion(bool nullToAbsent) {
    return VocabulariesCompanion(
      id: Value(id),
      word: Value(word),
      reading: Value(reading),
      meaningMy: meaningMy == null && nullToAbsent
          ? const Value.absent()
          : Value(meaningMy),
      meaningEn: meaningEn == null && nullToAbsent
          ? const Value.absent()
          : Value(meaningEn),
      partOfSpeech: partOfSpeech == null && nullToAbsent
          ? const Value.absent()
          : Value(partOfSpeech),
      exampleJp: exampleJp == null && nullToAbsent
          ? const Value.absent()
          : Value(exampleJp),
      exampleMy: exampleMy == null && nullToAbsent
          ? const Value.absent()
          : Value(exampleMy),
    );
  }

  factory Vocabulary.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Vocabulary(
      id: serializer.fromJson<int>(json['id']),
      word: serializer.fromJson<String>(json['word']),
      reading: serializer.fromJson<String>(json['reading']),
      meaningMy: serializer.fromJson<String?>(json['meaningMy']),
      meaningEn: serializer.fromJson<String?>(json['meaningEn']),
      partOfSpeech: serializer.fromJson<String?>(json['partOfSpeech']),
      exampleJp: serializer.fromJson<String?>(json['exampleJp']),
      exampleMy: serializer.fromJson<String?>(json['exampleMy']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'word': serializer.toJson<String>(word),
      'reading': serializer.toJson<String>(reading),
      'meaningMy': serializer.toJson<String?>(meaningMy),
      'meaningEn': serializer.toJson<String?>(meaningEn),
      'partOfSpeech': serializer.toJson<String?>(partOfSpeech),
      'exampleJp': serializer.toJson<String?>(exampleJp),
      'exampleMy': serializer.toJson<String?>(exampleMy),
    };
  }

  Vocabulary copyWith(
          {int? id,
          String? word,
          String? reading,
          Value<String?> meaningMy = const Value.absent(),
          Value<String?> meaningEn = const Value.absent(),
          Value<String?> partOfSpeech = const Value.absent(),
          Value<String?> exampleJp = const Value.absent(),
          Value<String?> exampleMy = const Value.absent()}) =>
      Vocabulary(
        id: id ?? this.id,
        word: word ?? this.word,
        reading: reading ?? this.reading,
        meaningMy: meaningMy.present ? meaningMy.value : this.meaningMy,
        meaningEn: meaningEn.present ? meaningEn.value : this.meaningEn,
        partOfSpeech:
            partOfSpeech.present ? partOfSpeech.value : this.partOfSpeech,
        exampleJp: exampleJp.present ? exampleJp.value : this.exampleJp,
        exampleMy: exampleMy.present ? exampleMy.value : this.exampleMy,
      );
  Vocabulary copyWithCompanion(VocabulariesCompanion data) {
    return Vocabulary(
      id: data.id.present ? data.id.value : this.id,
      word: data.word.present ? data.word.value : this.word,
      reading: data.reading.present ? data.reading.value : this.reading,
      meaningMy: data.meaningMy.present ? data.meaningMy.value : this.meaningMy,
      meaningEn: data.meaningEn.present ? data.meaningEn.value : this.meaningEn,
      partOfSpeech: data.partOfSpeech.present
          ? data.partOfSpeech.value
          : this.partOfSpeech,
      exampleJp: data.exampleJp.present ? data.exampleJp.value : this.exampleJp,
      exampleMy: data.exampleMy.present ? data.exampleMy.value : this.exampleMy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Vocabulary(')
          ..write('id: $id, ')
          ..write('word: $word, ')
          ..write('reading: $reading, ')
          ..write('meaningMy: $meaningMy, ')
          ..write('meaningEn: $meaningEn, ')
          ..write('partOfSpeech: $partOfSpeech, ')
          ..write('exampleJp: $exampleJp, ')
          ..write('exampleMy: $exampleMy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, word, reading, meaningMy, meaningEn,
      partOfSpeech, exampleJp, exampleMy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Vocabulary &&
          other.id == this.id &&
          other.word == this.word &&
          other.reading == this.reading &&
          other.meaningMy == this.meaningMy &&
          other.meaningEn == this.meaningEn &&
          other.partOfSpeech == this.partOfSpeech &&
          other.exampleJp == this.exampleJp &&
          other.exampleMy == this.exampleMy);
}

class VocabulariesCompanion extends UpdateCompanion<Vocabulary> {
  final Value<int> id;
  final Value<String> word;
  final Value<String> reading;
  final Value<String?> meaningMy;
  final Value<String?> meaningEn;
  final Value<String?> partOfSpeech;
  final Value<String?> exampleJp;
  final Value<String?> exampleMy;
  const VocabulariesCompanion({
    this.id = const Value.absent(),
    this.word = const Value.absent(),
    this.reading = const Value.absent(),
    this.meaningMy = const Value.absent(),
    this.meaningEn = const Value.absent(),
    this.partOfSpeech = const Value.absent(),
    this.exampleJp = const Value.absent(),
    this.exampleMy = const Value.absent(),
  });
  VocabulariesCompanion.insert({
    this.id = const Value.absent(),
    required String word,
    required String reading,
    this.meaningMy = const Value.absent(),
    this.meaningEn = const Value.absent(),
    this.partOfSpeech = const Value.absent(),
    this.exampleJp = const Value.absent(),
    this.exampleMy = const Value.absent(),
  })  : word = Value(word),
        reading = Value(reading);
  static Insertable<Vocabulary> custom({
    Expression<int>? id,
    Expression<String>? word,
    Expression<String>? reading,
    Expression<String>? meaningMy,
    Expression<String>? meaningEn,
    Expression<String>? partOfSpeech,
    Expression<String>? exampleJp,
    Expression<String>? exampleMy,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (word != null) 'word': word,
      if (reading != null) 'reading': reading,
      if (meaningMy != null) 'meaning_my': meaningMy,
      if (meaningEn != null) 'meaning_en': meaningEn,
      if (partOfSpeech != null) 'part_of_speech': partOfSpeech,
      if (exampleJp != null) 'example_jp': exampleJp,
      if (exampleMy != null) 'example_my': exampleMy,
    });
  }

  VocabulariesCompanion copyWith(
      {Value<int>? id,
      Value<String>? word,
      Value<String>? reading,
      Value<String?>? meaningMy,
      Value<String?>? meaningEn,
      Value<String?>? partOfSpeech,
      Value<String?>? exampleJp,
      Value<String?>? exampleMy}) {
    return VocabulariesCompanion(
      id: id ?? this.id,
      word: word ?? this.word,
      reading: reading ?? this.reading,
      meaningMy: meaningMy ?? this.meaningMy,
      meaningEn: meaningEn ?? this.meaningEn,
      partOfSpeech: partOfSpeech ?? this.partOfSpeech,
      exampleJp: exampleJp ?? this.exampleJp,
      exampleMy: exampleMy ?? this.exampleMy,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (word.present) {
      map['word'] = Variable<String>(word.value);
    }
    if (reading.present) {
      map['reading'] = Variable<String>(reading.value);
    }
    if (meaningMy.present) {
      map['meaning_my'] = Variable<String>(meaningMy.value);
    }
    if (meaningEn.present) {
      map['meaning_en'] = Variable<String>(meaningEn.value);
    }
    if (partOfSpeech.present) {
      map['part_of_speech'] = Variable<String>(partOfSpeech.value);
    }
    if (exampleJp.present) {
      map['example_jp'] = Variable<String>(exampleJp.value);
    }
    if (exampleMy.present) {
      map['example_my'] = Variable<String>(exampleMy.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VocabulariesCompanion(')
          ..write('id: $id, ')
          ..write('word: $word, ')
          ..write('reading: $reading, ')
          ..write('meaningMy: $meaningMy, ')
          ..write('meaningEn: $meaningEn, ')
          ..write('partOfSpeech: $partOfSpeech, ')
          ..write('exampleJp: $exampleJp, ')
          ..write('exampleMy: $exampleMy')
          ..write(')'))
        .toString();
  }
}

class $VocabSourceItemsTable extends VocabSourceItems
    with TableInfo<$VocabSourceItemsTable, VocabSourceItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VocabSourceItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _vocabIdMeta =
      const VerificationMeta('vocabId');
  @override
  late final GeneratedColumn<int> vocabId = GeneratedColumn<int>(
      'vocab_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _sourceIdMeta =
      const VerificationMeta('sourceId');
  @override
  late final GeneratedColumn<int> sourceId = GeneratedColumn<int>(
      'source_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _unitIdMeta = const VerificationMeta('unitId');
  @override
  late final GeneratedColumn<int> unitId = GeneratedColumn<int>(
      'unit_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _jlptLevelMeta =
      const VerificationMeta('jlptLevel');
  @override
  late final GeneratedColumn<String> jlptLevel = GeneratedColumn<String>(
      'jlpt_level', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, vocabId, sourceId, unitId, position, jlptLevel];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vocab_source_items';
  @override
  VerificationContext validateIntegrity(Insertable<VocabSourceItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('vocab_id')) {
      context.handle(_vocabIdMeta,
          vocabId.isAcceptableOrUnknown(data['vocab_id']!, _vocabIdMeta));
    } else if (isInserting) {
      context.missing(_vocabIdMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(_sourceIdMeta,
          sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta));
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('unit_id')) {
      context.handle(_unitIdMeta,
          unitId.isAcceptableOrUnknown(data['unit_id']!, _unitIdMeta));
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    }
    if (data.containsKey('jlpt_level')) {
      context.handle(_jlptLevelMeta,
          jlptLevel.isAcceptableOrUnknown(data['jlpt_level']!, _jlptLevelMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {vocabId, sourceId},
      ];
  @override
  VocabSourceItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VocabSourceItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      vocabId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}vocab_id'])!,
      sourceId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}source_id'])!,
      unitId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}unit_id']),
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      jlptLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}jlpt_level']),
    );
  }

  @override
  $VocabSourceItemsTable createAlias(String alias) {
    return $VocabSourceItemsTable(attachedDatabase, alias);
  }
}

class VocabSourceItem extends DataClass implements Insertable<VocabSourceItem> {
  final int id;
  final int vocabId;
  final int sourceId;
  final int? unitId;
  final int position;
  final String? jlptLevel;
  const VocabSourceItem(
      {required this.id,
      required this.vocabId,
      required this.sourceId,
      this.unitId,
      required this.position,
      this.jlptLevel});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['vocab_id'] = Variable<int>(vocabId);
    map['source_id'] = Variable<int>(sourceId);
    if (!nullToAbsent || unitId != null) {
      map['unit_id'] = Variable<int>(unitId);
    }
    map['position'] = Variable<int>(position);
    if (!nullToAbsent || jlptLevel != null) {
      map['jlpt_level'] = Variable<String>(jlptLevel);
    }
    return map;
  }

  VocabSourceItemsCompanion toCompanion(bool nullToAbsent) {
    return VocabSourceItemsCompanion(
      id: Value(id),
      vocabId: Value(vocabId),
      sourceId: Value(sourceId),
      unitId:
          unitId == null && nullToAbsent ? const Value.absent() : Value(unitId),
      position: Value(position),
      jlptLevel: jlptLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(jlptLevel),
    );
  }

  factory VocabSourceItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VocabSourceItem(
      id: serializer.fromJson<int>(json['id']),
      vocabId: serializer.fromJson<int>(json['vocabId']),
      sourceId: serializer.fromJson<int>(json['sourceId']),
      unitId: serializer.fromJson<int?>(json['unitId']),
      position: serializer.fromJson<int>(json['position']),
      jlptLevel: serializer.fromJson<String?>(json['jlptLevel']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'vocabId': serializer.toJson<int>(vocabId),
      'sourceId': serializer.toJson<int>(sourceId),
      'unitId': serializer.toJson<int?>(unitId),
      'position': serializer.toJson<int>(position),
      'jlptLevel': serializer.toJson<String?>(jlptLevel),
    };
  }

  VocabSourceItem copyWith(
          {int? id,
          int? vocabId,
          int? sourceId,
          Value<int?> unitId = const Value.absent(),
          int? position,
          Value<String?> jlptLevel = const Value.absent()}) =>
      VocabSourceItem(
        id: id ?? this.id,
        vocabId: vocabId ?? this.vocabId,
        sourceId: sourceId ?? this.sourceId,
        unitId: unitId.present ? unitId.value : this.unitId,
        position: position ?? this.position,
        jlptLevel: jlptLevel.present ? jlptLevel.value : this.jlptLevel,
      );
  VocabSourceItem copyWithCompanion(VocabSourceItemsCompanion data) {
    return VocabSourceItem(
      id: data.id.present ? data.id.value : this.id,
      vocabId: data.vocabId.present ? data.vocabId.value : this.vocabId,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      unitId: data.unitId.present ? data.unitId.value : this.unitId,
      position: data.position.present ? data.position.value : this.position,
      jlptLevel: data.jlptLevel.present ? data.jlptLevel.value : this.jlptLevel,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VocabSourceItem(')
          ..write('id: $id, ')
          ..write('vocabId: $vocabId, ')
          ..write('sourceId: $sourceId, ')
          ..write('unitId: $unitId, ')
          ..write('position: $position, ')
          ..write('jlptLevel: $jlptLevel')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, vocabId, sourceId, unitId, position, jlptLevel);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VocabSourceItem &&
          other.id == this.id &&
          other.vocabId == this.vocabId &&
          other.sourceId == this.sourceId &&
          other.unitId == this.unitId &&
          other.position == this.position &&
          other.jlptLevel == this.jlptLevel);
}

class VocabSourceItemsCompanion extends UpdateCompanion<VocabSourceItem> {
  final Value<int> id;
  final Value<int> vocabId;
  final Value<int> sourceId;
  final Value<int?> unitId;
  final Value<int> position;
  final Value<String?> jlptLevel;
  const VocabSourceItemsCompanion({
    this.id = const Value.absent(),
    this.vocabId = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.unitId = const Value.absent(),
    this.position = const Value.absent(),
    this.jlptLevel = const Value.absent(),
  });
  VocabSourceItemsCompanion.insert({
    this.id = const Value.absent(),
    required int vocabId,
    required int sourceId,
    this.unitId = const Value.absent(),
    this.position = const Value.absent(),
    this.jlptLevel = const Value.absent(),
  })  : vocabId = Value(vocabId),
        sourceId = Value(sourceId);
  static Insertable<VocabSourceItem> custom({
    Expression<int>? id,
    Expression<int>? vocabId,
    Expression<int>? sourceId,
    Expression<int>? unitId,
    Expression<int>? position,
    Expression<String>? jlptLevel,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vocabId != null) 'vocab_id': vocabId,
      if (sourceId != null) 'source_id': sourceId,
      if (unitId != null) 'unit_id': unitId,
      if (position != null) 'position': position,
      if (jlptLevel != null) 'jlpt_level': jlptLevel,
    });
  }

  VocabSourceItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? vocabId,
      Value<int>? sourceId,
      Value<int?>? unitId,
      Value<int>? position,
      Value<String?>? jlptLevel}) {
    return VocabSourceItemsCompanion(
      id: id ?? this.id,
      vocabId: vocabId ?? this.vocabId,
      sourceId: sourceId ?? this.sourceId,
      unitId: unitId ?? this.unitId,
      position: position ?? this.position,
      jlptLevel: jlptLevel ?? this.jlptLevel,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (vocabId.present) {
      map['vocab_id'] = Variable<int>(vocabId.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<int>(sourceId.value);
    }
    if (unitId.present) {
      map['unit_id'] = Variable<int>(unitId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (jlptLevel.present) {
      map['jlpt_level'] = Variable<String>(jlptLevel.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VocabSourceItemsCompanion(')
          ..write('id: $id, ')
          ..write('vocabId: $vocabId, ')
          ..write('sourceId: $sourceId, ')
          ..write('unitId: $unitId, ')
          ..write('position: $position, ')
          ..write('jlptLevel: $jlptLevel')
          ..write(')'))
        .toString();
  }
}

class $KanjiCompoundsTable extends KanjiCompounds
    with TableInfo<$KanjiCompoundsTable, KanjiCompound> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KanjiCompoundsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _kanjiIdMeta =
      const VerificationMeta('kanjiId');
  @override
  late final GeneratedColumn<int> kanjiId = GeneratedColumn<int>(
      'kanji_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _vocabIdMeta =
      const VerificationMeta('vocabId');
  @override
  late final GeneratedColumn<int> vocabId = GeneratedColumn<int>(
      'vocab_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _sourceIdMeta =
      const VerificationMeta('sourceId');
  @override
  late final GeneratedColumn<int> sourceId = GeneratedColumn<int>(
      'source_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, kanjiId, vocabId, sourceId, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kanji_compounds';
  @override
  VerificationContext validateIntegrity(Insertable<KanjiCompound> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kanji_id')) {
      context.handle(_kanjiIdMeta,
          kanjiId.isAcceptableOrUnknown(data['kanji_id']!, _kanjiIdMeta));
    } else if (isInserting) {
      context.missing(_kanjiIdMeta);
    }
    if (data.containsKey('vocab_id')) {
      context.handle(_vocabIdMeta,
          vocabId.isAcceptableOrUnknown(data['vocab_id']!, _vocabIdMeta));
    } else if (isInserting) {
      context.missing(_vocabIdMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(_sourceIdMeta,
          sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta));
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {kanjiId, vocabId, sourceId},
      ];
  @override
  KanjiCompound map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KanjiCompound(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      kanjiId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}kanji_id'])!,
      vocabId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}vocab_id'])!,
      sourceId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}source_id'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
    );
  }

  @override
  $KanjiCompoundsTable createAlias(String alias) {
    return $KanjiCompoundsTable(attachedDatabase, alias);
  }
}

class KanjiCompound extends DataClass implements Insertable<KanjiCompound> {
  final int id;
  final int kanjiId;
  final int vocabId;
  final int sourceId;

  /// kanji အောက်က စီစဉ်ပုံ (1..6)
  final int position;
  const KanjiCompound(
      {required this.id,
      required this.kanjiId,
      required this.vocabId,
      required this.sourceId,
      required this.position});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['kanji_id'] = Variable<int>(kanjiId);
    map['vocab_id'] = Variable<int>(vocabId);
    map['source_id'] = Variable<int>(sourceId);
    map['position'] = Variable<int>(position);
    return map;
  }

  KanjiCompoundsCompanion toCompanion(bool nullToAbsent) {
    return KanjiCompoundsCompanion(
      id: Value(id),
      kanjiId: Value(kanjiId),
      vocabId: Value(vocabId),
      sourceId: Value(sourceId),
      position: Value(position),
    );
  }

  factory KanjiCompound.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KanjiCompound(
      id: serializer.fromJson<int>(json['id']),
      kanjiId: serializer.fromJson<int>(json['kanjiId']),
      vocabId: serializer.fromJson<int>(json['vocabId']),
      sourceId: serializer.fromJson<int>(json['sourceId']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kanjiId': serializer.toJson<int>(kanjiId),
      'vocabId': serializer.toJson<int>(vocabId),
      'sourceId': serializer.toJson<int>(sourceId),
      'position': serializer.toJson<int>(position),
    };
  }

  KanjiCompound copyWith(
          {int? id,
          int? kanjiId,
          int? vocabId,
          int? sourceId,
          int? position}) =>
      KanjiCompound(
        id: id ?? this.id,
        kanjiId: kanjiId ?? this.kanjiId,
        vocabId: vocabId ?? this.vocabId,
        sourceId: sourceId ?? this.sourceId,
        position: position ?? this.position,
      );
  KanjiCompound copyWithCompanion(KanjiCompoundsCompanion data) {
    return KanjiCompound(
      id: data.id.present ? data.id.value : this.id,
      kanjiId: data.kanjiId.present ? data.kanjiId.value : this.kanjiId,
      vocabId: data.vocabId.present ? data.vocabId.value : this.vocabId,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KanjiCompound(')
          ..write('id: $id, ')
          ..write('kanjiId: $kanjiId, ')
          ..write('vocabId: $vocabId, ')
          ..write('sourceId: $sourceId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, kanjiId, vocabId, sourceId, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KanjiCompound &&
          other.id == this.id &&
          other.kanjiId == this.kanjiId &&
          other.vocabId == this.vocabId &&
          other.sourceId == this.sourceId &&
          other.position == this.position);
}

class KanjiCompoundsCompanion extends UpdateCompanion<KanjiCompound> {
  final Value<int> id;
  final Value<int> kanjiId;
  final Value<int> vocabId;
  final Value<int> sourceId;
  final Value<int> position;
  const KanjiCompoundsCompanion({
    this.id = const Value.absent(),
    this.kanjiId = const Value.absent(),
    this.vocabId = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.position = const Value.absent(),
  });
  KanjiCompoundsCompanion.insert({
    this.id = const Value.absent(),
    required int kanjiId,
    required int vocabId,
    required int sourceId,
    this.position = const Value.absent(),
  })  : kanjiId = Value(kanjiId),
        vocabId = Value(vocabId),
        sourceId = Value(sourceId);
  static Insertable<KanjiCompound> custom({
    Expression<int>? id,
    Expression<int>? kanjiId,
    Expression<int>? vocabId,
    Expression<int>? sourceId,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kanjiId != null) 'kanji_id': kanjiId,
      if (vocabId != null) 'vocab_id': vocabId,
      if (sourceId != null) 'source_id': sourceId,
      if (position != null) 'position': position,
    });
  }

  KanjiCompoundsCompanion copyWith(
      {Value<int>? id,
      Value<int>? kanjiId,
      Value<int>? vocabId,
      Value<int>? sourceId,
      Value<int>? position}) {
    return KanjiCompoundsCompanion(
      id: id ?? this.id,
      kanjiId: kanjiId ?? this.kanjiId,
      vocabId: vocabId ?? this.vocabId,
      sourceId: sourceId ?? this.sourceId,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kanjiId.present) {
      map['kanji_id'] = Variable<int>(kanjiId.value);
    }
    if (vocabId.present) {
      map['vocab_id'] = Variable<int>(vocabId.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<int>(sourceId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KanjiCompoundsCompanion(')
          ..write('id: $id, ')
          ..write('kanjiId: $kanjiId, ')
          ..write('vocabId: $vocabId, ')
          ..write('sourceId: $sourceId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

class $GrammarPointsTable extends GrammarPoints
    with TableInfo<$GrammarPointsTable, GrammarPoint> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GrammarPointsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _patternMeta =
      const VerificationMeta('pattern');
  @override
  late final GeneratedColumn<String> pattern = GeneratedColumn<String>(
      'pattern', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _connectionMeta =
      const VerificationMeta('connection');
  @override
  late final GeneratedColumn<String> connection = GeneratedColumn<String>(
      'connection', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _meaningMyMeta =
      const VerificationMeta('meaningMy');
  @override
  late final GeneratedColumn<String> meaningMy = GeneratedColumn<String>(
      'meaning_my', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _meaningEnMeta =
      const VerificationMeta('meaningEn');
  @override
  late final GeneratedColumn<String> meaningEn = GeneratedColumn<String>(
      'meaning_en', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _exampleJpMeta =
      const VerificationMeta('exampleJp');
  @override
  late final GeneratedColumn<String> exampleJp = GeneratedColumn<String>(
      'example_jp', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _exampleMyMeta =
      const VerificationMeta('exampleMy');
  @override
  late final GeneratedColumn<String> exampleMy = GeneratedColumn<String>(
      'example_my', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        pattern,
        connection,
        meaningMy,
        meaningEn,
        exampleJp,
        exampleMy,
        note
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'grammar_points';
  @override
  VerificationContext validateIntegrity(Insertable<GrammarPoint> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pattern')) {
      context.handle(_patternMeta,
          pattern.isAcceptableOrUnknown(data['pattern']!, _patternMeta));
    } else if (isInserting) {
      context.missing(_patternMeta);
    }
    if (data.containsKey('connection')) {
      context.handle(
          _connectionMeta,
          connection.isAcceptableOrUnknown(
              data['connection']!, _connectionMeta));
    }
    if (data.containsKey('meaning_my')) {
      context.handle(_meaningMyMeta,
          meaningMy.isAcceptableOrUnknown(data['meaning_my']!, _meaningMyMeta));
    }
    if (data.containsKey('meaning_en')) {
      context.handle(_meaningEnMeta,
          meaningEn.isAcceptableOrUnknown(data['meaning_en']!, _meaningEnMeta));
    }
    if (data.containsKey('example_jp')) {
      context.handle(_exampleJpMeta,
          exampleJp.isAcceptableOrUnknown(data['example_jp']!, _exampleJpMeta));
    }
    if (data.containsKey('example_my')) {
      context.handle(_exampleMyMeta,
          exampleMy.isAcceptableOrUnknown(data['example_my']!, _exampleMyMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GrammarPoint map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GrammarPoint(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      pattern: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pattern'])!,
      connection: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}connection']),
      meaningMy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}meaning_my']),
      meaningEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}meaning_en']),
      exampleJp: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}example_jp']),
      exampleMy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}example_my']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
    );
  }

  @override
  $GrammarPointsTable createAlias(String alias) {
    return $GrammarPointsTable(attachedDatabase, alias);
  }
}

class GrammarPoint extends DataClass implements Insertable<GrammarPoint> {
  final int id;
  final String pattern;
  final String? connection;
  final String? meaningMy;
  final String? meaningEn;
  final String? exampleJp;
  final String? exampleMy;
  final String? note;
  const GrammarPoint(
      {required this.id,
      required this.pattern,
      this.connection,
      this.meaningMy,
      this.meaningEn,
      this.exampleJp,
      this.exampleMy,
      this.note});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pattern'] = Variable<String>(pattern);
    if (!nullToAbsent || connection != null) {
      map['connection'] = Variable<String>(connection);
    }
    if (!nullToAbsent || meaningMy != null) {
      map['meaning_my'] = Variable<String>(meaningMy);
    }
    if (!nullToAbsent || meaningEn != null) {
      map['meaning_en'] = Variable<String>(meaningEn);
    }
    if (!nullToAbsent || exampleJp != null) {
      map['example_jp'] = Variable<String>(exampleJp);
    }
    if (!nullToAbsent || exampleMy != null) {
      map['example_my'] = Variable<String>(exampleMy);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  GrammarPointsCompanion toCompanion(bool nullToAbsent) {
    return GrammarPointsCompanion(
      id: Value(id),
      pattern: Value(pattern),
      connection: connection == null && nullToAbsent
          ? const Value.absent()
          : Value(connection),
      meaningMy: meaningMy == null && nullToAbsent
          ? const Value.absent()
          : Value(meaningMy),
      meaningEn: meaningEn == null && nullToAbsent
          ? const Value.absent()
          : Value(meaningEn),
      exampleJp: exampleJp == null && nullToAbsent
          ? const Value.absent()
          : Value(exampleJp),
      exampleMy: exampleMy == null && nullToAbsent
          ? const Value.absent()
          : Value(exampleMy),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory GrammarPoint.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GrammarPoint(
      id: serializer.fromJson<int>(json['id']),
      pattern: serializer.fromJson<String>(json['pattern']),
      connection: serializer.fromJson<String?>(json['connection']),
      meaningMy: serializer.fromJson<String?>(json['meaningMy']),
      meaningEn: serializer.fromJson<String?>(json['meaningEn']),
      exampleJp: serializer.fromJson<String?>(json['exampleJp']),
      exampleMy: serializer.fromJson<String?>(json['exampleMy']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pattern': serializer.toJson<String>(pattern),
      'connection': serializer.toJson<String?>(connection),
      'meaningMy': serializer.toJson<String?>(meaningMy),
      'meaningEn': serializer.toJson<String?>(meaningEn),
      'exampleJp': serializer.toJson<String?>(exampleJp),
      'exampleMy': serializer.toJson<String?>(exampleMy),
      'note': serializer.toJson<String?>(note),
    };
  }

  GrammarPoint copyWith(
          {int? id,
          String? pattern,
          Value<String?> connection = const Value.absent(),
          Value<String?> meaningMy = const Value.absent(),
          Value<String?> meaningEn = const Value.absent(),
          Value<String?> exampleJp = const Value.absent(),
          Value<String?> exampleMy = const Value.absent(),
          Value<String?> note = const Value.absent()}) =>
      GrammarPoint(
        id: id ?? this.id,
        pattern: pattern ?? this.pattern,
        connection: connection.present ? connection.value : this.connection,
        meaningMy: meaningMy.present ? meaningMy.value : this.meaningMy,
        meaningEn: meaningEn.present ? meaningEn.value : this.meaningEn,
        exampleJp: exampleJp.present ? exampleJp.value : this.exampleJp,
        exampleMy: exampleMy.present ? exampleMy.value : this.exampleMy,
        note: note.present ? note.value : this.note,
      );
  GrammarPoint copyWithCompanion(GrammarPointsCompanion data) {
    return GrammarPoint(
      id: data.id.present ? data.id.value : this.id,
      pattern: data.pattern.present ? data.pattern.value : this.pattern,
      connection:
          data.connection.present ? data.connection.value : this.connection,
      meaningMy: data.meaningMy.present ? data.meaningMy.value : this.meaningMy,
      meaningEn: data.meaningEn.present ? data.meaningEn.value : this.meaningEn,
      exampleJp: data.exampleJp.present ? data.exampleJp.value : this.exampleJp,
      exampleMy: data.exampleMy.present ? data.exampleMy.value : this.exampleMy,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GrammarPoint(')
          ..write('id: $id, ')
          ..write('pattern: $pattern, ')
          ..write('connection: $connection, ')
          ..write('meaningMy: $meaningMy, ')
          ..write('meaningEn: $meaningEn, ')
          ..write('exampleJp: $exampleJp, ')
          ..write('exampleMy: $exampleMy, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, pattern, connection, meaningMy, meaningEn,
      exampleJp, exampleMy, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GrammarPoint &&
          other.id == this.id &&
          other.pattern == this.pattern &&
          other.connection == this.connection &&
          other.meaningMy == this.meaningMy &&
          other.meaningEn == this.meaningEn &&
          other.exampleJp == this.exampleJp &&
          other.exampleMy == this.exampleMy &&
          other.note == this.note);
}

class GrammarPointsCompanion extends UpdateCompanion<GrammarPoint> {
  final Value<int> id;
  final Value<String> pattern;
  final Value<String?> connection;
  final Value<String?> meaningMy;
  final Value<String?> meaningEn;
  final Value<String?> exampleJp;
  final Value<String?> exampleMy;
  final Value<String?> note;
  const GrammarPointsCompanion({
    this.id = const Value.absent(),
    this.pattern = const Value.absent(),
    this.connection = const Value.absent(),
    this.meaningMy = const Value.absent(),
    this.meaningEn = const Value.absent(),
    this.exampleJp = const Value.absent(),
    this.exampleMy = const Value.absent(),
    this.note = const Value.absent(),
  });
  GrammarPointsCompanion.insert({
    this.id = const Value.absent(),
    required String pattern,
    this.connection = const Value.absent(),
    this.meaningMy = const Value.absent(),
    this.meaningEn = const Value.absent(),
    this.exampleJp = const Value.absent(),
    this.exampleMy = const Value.absent(),
    this.note = const Value.absent(),
  }) : pattern = Value(pattern);
  static Insertable<GrammarPoint> custom({
    Expression<int>? id,
    Expression<String>? pattern,
    Expression<String>? connection,
    Expression<String>? meaningMy,
    Expression<String>? meaningEn,
    Expression<String>? exampleJp,
    Expression<String>? exampleMy,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pattern != null) 'pattern': pattern,
      if (connection != null) 'connection': connection,
      if (meaningMy != null) 'meaning_my': meaningMy,
      if (meaningEn != null) 'meaning_en': meaningEn,
      if (exampleJp != null) 'example_jp': exampleJp,
      if (exampleMy != null) 'example_my': exampleMy,
      if (note != null) 'note': note,
    });
  }

  GrammarPointsCompanion copyWith(
      {Value<int>? id,
      Value<String>? pattern,
      Value<String?>? connection,
      Value<String?>? meaningMy,
      Value<String?>? meaningEn,
      Value<String?>? exampleJp,
      Value<String?>? exampleMy,
      Value<String?>? note}) {
    return GrammarPointsCompanion(
      id: id ?? this.id,
      pattern: pattern ?? this.pattern,
      connection: connection ?? this.connection,
      meaningMy: meaningMy ?? this.meaningMy,
      meaningEn: meaningEn ?? this.meaningEn,
      exampleJp: exampleJp ?? this.exampleJp,
      exampleMy: exampleMy ?? this.exampleMy,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pattern.present) {
      map['pattern'] = Variable<String>(pattern.value);
    }
    if (connection.present) {
      map['connection'] = Variable<String>(connection.value);
    }
    if (meaningMy.present) {
      map['meaning_my'] = Variable<String>(meaningMy.value);
    }
    if (meaningEn.present) {
      map['meaning_en'] = Variable<String>(meaningEn.value);
    }
    if (exampleJp.present) {
      map['example_jp'] = Variable<String>(exampleJp.value);
    }
    if (exampleMy.present) {
      map['example_my'] = Variable<String>(exampleMy.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GrammarPointsCompanion(')
          ..write('id: $id, ')
          ..write('pattern: $pattern, ')
          ..write('connection: $connection, ')
          ..write('meaningMy: $meaningMy, ')
          ..write('meaningEn: $meaningEn, ')
          ..write('exampleJp: $exampleJp, ')
          ..write('exampleMy: $exampleMy, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $GrammarSourceItemsTable extends GrammarSourceItems
    with TableInfo<$GrammarSourceItemsTable, GrammarSourceItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GrammarSourceItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _grammarIdMeta =
      const VerificationMeta('grammarId');
  @override
  late final GeneratedColumn<int> grammarId = GeneratedColumn<int>(
      'grammar_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _sourceIdMeta =
      const VerificationMeta('sourceId');
  @override
  late final GeneratedColumn<int> sourceId = GeneratedColumn<int>(
      'source_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _unitIdMeta = const VerificationMeta('unitId');
  @override
  late final GeneratedColumn<int> unitId = GeneratedColumn<int>(
      'unit_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _jlptLevelMeta =
      const VerificationMeta('jlptLevel');
  @override
  late final GeneratedColumn<String> jlptLevel = GeneratedColumn<String>(
      'jlpt_level', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, grammarId, sourceId, unitId, position, jlptLevel];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'grammar_source_items';
  @override
  VerificationContext validateIntegrity(Insertable<GrammarSourceItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('grammar_id')) {
      context.handle(_grammarIdMeta,
          grammarId.isAcceptableOrUnknown(data['grammar_id']!, _grammarIdMeta));
    } else if (isInserting) {
      context.missing(_grammarIdMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(_sourceIdMeta,
          sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta));
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('unit_id')) {
      context.handle(_unitIdMeta,
          unitId.isAcceptableOrUnknown(data['unit_id']!, _unitIdMeta));
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    }
    if (data.containsKey('jlpt_level')) {
      context.handle(_jlptLevelMeta,
          jlptLevel.isAcceptableOrUnknown(data['jlpt_level']!, _jlptLevelMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {grammarId, sourceId},
      ];
  @override
  GrammarSourceItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GrammarSourceItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      grammarId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}grammar_id'])!,
      sourceId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}source_id'])!,
      unitId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}unit_id']),
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      jlptLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}jlpt_level']),
    );
  }

  @override
  $GrammarSourceItemsTable createAlias(String alias) {
    return $GrammarSourceItemsTable(attachedDatabase, alias);
  }
}

class GrammarSourceItem extends DataClass
    implements Insertable<GrammarSourceItem> {
  final int id;
  final int grammarId;
  final int sourceId;
  final int? unitId;
  final int position;
  final String? jlptLevel;
  const GrammarSourceItem(
      {required this.id,
      required this.grammarId,
      required this.sourceId,
      this.unitId,
      required this.position,
      this.jlptLevel});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['grammar_id'] = Variable<int>(grammarId);
    map['source_id'] = Variable<int>(sourceId);
    if (!nullToAbsent || unitId != null) {
      map['unit_id'] = Variable<int>(unitId);
    }
    map['position'] = Variable<int>(position);
    if (!nullToAbsent || jlptLevel != null) {
      map['jlpt_level'] = Variable<String>(jlptLevel);
    }
    return map;
  }

  GrammarSourceItemsCompanion toCompanion(bool nullToAbsent) {
    return GrammarSourceItemsCompanion(
      id: Value(id),
      grammarId: Value(grammarId),
      sourceId: Value(sourceId),
      unitId:
          unitId == null && nullToAbsent ? const Value.absent() : Value(unitId),
      position: Value(position),
      jlptLevel: jlptLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(jlptLevel),
    );
  }

  factory GrammarSourceItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GrammarSourceItem(
      id: serializer.fromJson<int>(json['id']),
      grammarId: serializer.fromJson<int>(json['grammarId']),
      sourceId: serializer.fromJson<int>(json['sourceId']),
      unitId: serializer.fromJson<int?>(json['unitId']),
      position: serializer.fromJson<int>(json['position']),
      jlptLevel: serializer.fromJson<String?>(json['jlptLevel']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'grammarId': serializer.toJson<int>(grammarId),
      'sourceId': serializer.toJson<int>(sourceId),
      'unitId': serializer.toJson<int?>(unitId),
      'position': serializer.toJson<int>(position),
      'jlptLevel': serializer.toJson<String?>(jlptLevel),
    };
  }

  GrammarSourceItem copyWith(
          {int? id,
          int? grammarId,
          int? sourceId,
          Value<int?> unitId = const Value.absent(),
          int? position,
          Value<String?> jlptLevel = const Value.absent()}) =>
      GrammarSourceItem(
        id: id ?? this.id,
        grammarId: grammarId ?? this.grammarId,
        sourceId: sourceId ?? this.sourceId,
        unitId: unitId.present ? unitId.value : this.unitId,
        position: position ?? this.position,
        jlptLevel: jlptLevel.present ? jlptLevel.value : this.jlptLevel,
      );
  GrammarSourceItem copyWithCompanion(GrammarSourceItemsCompanion data) {
    return GrammarSourceItem(
      id: data.id.present ? data.id.value : this.id,
      grammarId: data.grammarId.present ? data.grammarId.value : this.grammarId,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      unitId: data.unitId.present ? data.unitId.value : this.unitId,
      position: data.position.present ? data.position.value : this.position,
      jlptLevel: data.jlptLevel.present ? data.jlptLevel.value : this.jlptLevel,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GrammarSourceItem(')
          ..write('id: $id, ')
          ..write('grammarId: $grammarId, ')
          ..write('sourceId: $sourceId, ')
          ..write('unitId: $unitId, ')
          ..write('position: $position, ')
          ..write('jlptLevel: $jlptLevel')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, grammarId, sourceId, unitId, position, jlptLevel);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GrammarSourceItem &&
          other.id == this.id &&
          other.grammarId == this.grammarId &&
          other.sourceId == this.sourceId &&
          other.unitId == this.unitId &&
          other.position == this.position &&
          other.jlptLevel == this.jlptLevel);
}

class GrammarSourceItemsCompanion extends UpdateCompanion<GrammarSourceItem> {
  final Value<int> id;
  final Value<int> grammarId;
  final Value<int> sourceId;
  final Value<int?> unitId;
  final Value<int> position;
  final Value<String?> jlptLevel;
  const GrammarSourceItemsCompanion({
    this.id = const Value.absent(),
    this.grammarId = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.unitId = const Value.absent(),
    this.position = const Value.absent(),
    this.jlptLevel = const Value.absent(),
  });
  GrammarSourceItemsCompanion.insert({
    this.id = const Value.absent(),
    required int grammarId,
    required int sourceId,
    this.unitId = const Value.absent(),
    this.position = const Value.absent(),
    this.jlptLevel = const Value.absent(),
  })  : grammarId = Value(grammarId),
        sourceId = Value(sourceId);
  static Insertable<GrammarSourceItem> custom({
    Expression<int>? id,
    Expression<int>? grammarId,
    Expression<int>? sourceId,
    Expression<int>? unitId,
    Expression<int>? position,
    Expression<String>? jlptLevel,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (grammarId != null) 'grammar_id': grammarId,
      if (sourceId != null) 'source_id': sourceId,
      if (unitId != null) 'unit_id': unitId,
      if (position != null) 'position': position,
      if (jlptLevel != null) 'jlpt_level': jlptLevel,
    });
  }

  GrammarSourceItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? grammarId,
      Value<int>? sourceId,
      Value<int?>? unitId,
      Value<int>? position,
      Value<String?>? jlptLevel}) {
    return GrammarSourceItemsCompanion(
      id: id ?? this.id,
      grammarId: grammarId ?? this.grammarId,
      sourceId: sourceId ?? this.sourceId,
      unitId: unitId ?? this.unitId,
      position: position ?? this.position,
      jlptLevel: jlptLevel ?? this.jlptLevel,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (grammarId.present) {
      map['grammar_id'] = Variable<int>(grammarId.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<int>(sourceId.value);
    }
    if (unitId.present) {
      map['unit_id'] = Variable<int>(unitId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (jlptLevel.present) {
      map['jlpt_level'] = Variable<String>(jlptLevel.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GrammarSourceItemsCompanion(')
          ..write('id: $id, ')
          ..write('grammarId: $grammarId, ')
          ..write('sourceId: $sourceId, ')
          ..write('unitId: $unitId, ')
          ..write('position: $position, ')
          ..write('jlptLevel: $jlptLevel')
          ..write(')'))
        .toString();
  }
}

class $MondaiTypesTable extends MondaiTypes
    with TableInfo<$MondaiTypesTable, MondaiTypeData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MondaiTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  @override
  late final GeneratedColumnWithTypeConverter<MondaiType, int> type =
      GeneratedColumn<int>('type', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<MondaiType>($MondaiTypesTable.$convertertype);
  static const VerificationMeta _jlptLevelMeta =
      const VerificationMeta('jlptLevel');
  @override
  late final GeneratedColumn<String> jlptLevel = GeneratedColumn<String>(
      'jlpt_level', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<Subject, int> subject =
      GeneratedColumn<int>('subject', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<Subject>($MondaiTypesTable.$convertersubject);
  static const VerificationMeta _nameJpMeta = const VerificationMeta('nameJp');
  @override
  late final GeneratedColumn<String> nameJp = GeneratedColumn<String>(
      'name_jp', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMyMeta = const VerificationMeta('nameMy');
  @override
  late final GeneratedColumn<String> nameMy = GeneratedColumn<String>(
      'name_my', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _instructionJpMeta =
      const VerificationMeta('instructionJp');
  @override
  late final GeneratedColumn<String> instructionJp = GeneratedColumn<String>(
      'instruction_jp', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, type, jlptLevel, subject, nameJp, nameMy, instructionJp, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mondai_types';
  @override
  VerificationContext validateIntegrity(Insertable<MondaiTypeData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('jlpt_level')) {
      context.handle(_jlptLevelMeta,
          jlptLevel.isAcceptableOrUnknown(data['jlpt_level']!, _jlptLevelMeta));
    } else if (isInserting) {
      context.missing(_jlptLevelMeta);
    }
    if (data.containsKey('name_jp')) {
      context.handle(_nameJpMeta,
          nameJp.isAcceptableOrUnknown(data['name_jp']!, _nameJpMeta));
    } else if (isInserting) {
      context.missing(_nameJpMeta);
    }
    if (data.containsKey('name_my')) {
      context.handle(_nameMyMeta,
          nameMy.isAcceptableOrUnknown(data['name_my']!, _nameMyMeta));
    }
    if (data.containsKey('instruction_jp')) {
      context.handle(
          _instructionJpMeta,
          instructionJp.isAcceptableOrUnknown(
              data['instruction_jp']!, _instructionJpMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {type, jlptLevel},
      ];
  @override
  MondaiTypeData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MondaiTypeData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      type: $MondaiTypesTable.$convertertype.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type'])!),
      jlptLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}jlpt_level'])!,
      subject: $MondaiTypesTable.$convertersubject.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}subject'])!),
      nameJp: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_jp'])!,
      nameMy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_my']),
      instructionJp: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}instruction_jp']),
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
    );
  }

  @override
  $MondaiTypesTable createAlias(String alias) {
    return $MondaiTypesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MondaiType, int, int> $convertertype =
      const EnumIndexConverter<MondaiType>(MondaiType.values);
  static JsonTypeConverter2<Subject, int, int> $convertersubject =
      const EnumIndexConverter<Subject>(Subject.values);
}

class MondaiTypeData extends DataClass implements Insertable<MondaiTypeData> {
  final int id;
  final MondaiType type;
  final String jlptLevel;
  final Subject subject;
  final String nameJp;
  final String? nameMy;
  final String? instructionJp;
  final int sortOrder;
  const MondaiTypeData(
      {required this.id,
      required this.type,
      required this.jlptLevel,
      required this.subject,
      required this.nameJp,
      this.nameMy,
      this.instructionJp,
      required this.sortOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['type'] = Variable<int>($MondaiTypesTable.$convertertype.toSql(type));
    }
    map['jlpt_level'] = Variable<String>(jlptLevel);
    {
      map['subject'] =
          Variable<int>($MondaiTypesTable.$convertersubject.toSql(subject));
    }
    map['name_jp'] = Variable<String>(nameJp);
    if (!nullToAbsent || nameMy != null) {
      map['name_my'] = Variable<String>(nameMy);
    }
    if (!nullToAbsent || instructionJp != null) {
      map['instruction_jp'] = Variable<String>(instructionJp);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  MondaiTypesCompanion toCompanion(bool nullToAbsent) {
    return MondaiTypesCompanion(
      id: Value(id),
      type: Value(type),
      jlptLevel: Value(jlptLevel),
      subject: Value(subject),
      nameJp: Value(nameJp),
      nameMy:
          nameMy == null && nullToAbsent ? const Value.absent() : Value(nameMy),
      instructionJp: instructionJp == null && nullToAbsent
          ? const Value.absent()
          : Value(instructionJp),
      sortOrder: Value(sortOrder),
    );
  }

  factory MondaiTypeData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MondaiTypeData(
      id: serializer.fromJson<int>(json['id']),
      type: $MondaiTypesTable.$convertertype
          .fromJson(serializer.fromJson<int>(json['type'])),
      jlptLevel: serializer.fromJson<String>(json['jlptLevel']),
      subject: $MondaiTypesTable.$convertersubject
          .fromJson(serializer.fromJson<int>(json['subject'])),
      nameJp: serializer.fromJson<String>(json['nameJp']),
      nameMy: serializer.fromJson<String?>(json['nameMy']),
      instructionJp: serializer.fromJson<String?>(json['instructionJp']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type':
          serializer.toJson<int>($MondaiTypesTable.$convertertype.toJson(type)),
      'jlptLevel': serializer.toJson<String>(jlptLevel),
      'subject': serializer
          .toJson<int>($MondaiTypesTable.$convertersubject.toJson(subject)),
      'nameJp': serializer.toJson<String>(nameJp),
      'nameMy': serializer.toJson<String?>(nameMy),
      'instructionJp': serializer.toJson<String?>(instructionJp),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  MondaiTypeData copyWith(
          {int? id,
          MondaiType? type,
          String? jlptLevel,
          Subject? subject,
          String? nameJp,
          Value<String?> nameMy = const Value.absent(),
          Value<String?> instructionJp = const Value.absent(),
          int? sortOrder}) =>
      MondaiTypeData(
        id: id ?? this.id,
        type: type ?? this.type,
        jlptLevel: jlptLevel ?? this.jlptLevel,
        subject: subject ?? this.subject,
        nameJp: nameJp ?? this.nameJp,
        nameMy: nameMy.present ? nameMy.value : this.nameMy,
        instructionJp:
            instructionJp.present ? instructionJp.value : this.instructionJp,
        sortOrder: sortOrder ?? this.sortOrder,
      );
  MondaiTypeData copyWithCompanion(MondaiTypesCompanion data) {
    return MondaiTypeData(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      jlptLevel: data.jlptLevel.present ? data.jlptLevel.value : this.jlptLevel,
      subject: data.subject.present ? data.subject.value : this.subject,
      nameJp: data.nameJp.present ? data.nameJp.value : this.nameJp,
      nameMy: data.nameMy.present ? data.nameMy.value : this.nameMy,
      instructionJp: data.instructionJp.present
          ? data.instructionJp.value
          : this.instructionJp,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MondaiTypeData(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('jlptLevel: $jlptLevel, ')
          ..write('subject: $subject, ')
          ..write('nameJp: $nameJp, ')
          ..write('nameMy: $nameMy, ')
          ..write('instructionJp: $instructionJp, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, type, jlptLevel, subject, nameJp, nameMy, instructionJp, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MondaiTypeData &&
          other.id == this.id &&
          other.type == this.type &&
          other.jlptLevel == this.jlptLevel &&
          other.subject == this.subject &&
          other.nameJp == this.nameJp &&
          other.nameMy == this.nameMy &&
          other.instructionJp == this.instructionJp &&
          other.sortOrder == this.sortOrder);
}

class MondaiTypesCompanion extends UpdateCompanion<MondaiTypeData> {
  final Value<int> id;
  final Value<MondaiType> type;
  final Value<String> jlptLevel;
  final Value<Subject> subject;
  final Value<String> nameJp;
  final Value<String?> nameMy;
  final Value<String?> instructionJp;
  final Value<int> sortOrder;
  const MondaiTypesCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.jlptLevel = const Value.absent(),
    this.subject = const Value.absent(),
    this.nameJp = const Value.absent(),
    this.nameMy = const Value.absent(),
    this.instructionJp = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  MondaiTypesCompanion.insert({
    this.id = const Value.absent(),
    required MondaiType type,
    required String jlptLevel,
    required Subject subject,
    required String nameJp,
    this.nameMy = const Value.absent(),
    this.instructionJp = const Value.absent(),
    this.sortOrder = const Value.absent(),
  })  : type = Value(type),
        jlptLevel = Value(jlptLevel),
        subject = Value(subject),
        nameJp = Value(nameJp);
  static Insertable<MondaiTypeData> custom({
    Expression<int>? id,
    Expression<int>? type,
    Expression<String>? jlptLevel,
    Expression<int>? subject,
    Expression<String>? nameJp,
    Expression<String>? nameMy,
    Expression<String>? instructionJp,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (jlptLevel != null) 'jlpt_level': jlptLevel,
      if (subject != null) 'subject': subject,
      if (nameJp != null) 'name_jp': nameJp,
      if (nameMy != null) 'name_my': nameMy,
      if (instructionJp != null) 'instruction_jp': instructionJp,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  MondaiTypesCompanion copyWith(
      {Value<int>? id,
      Value<MondaiType>? type,
      Value<String>? jlptLevel,
      Value<Subject>? subject,
      Value<String>? nameJp,
      Value<String?>? nameMy,
      Value<String?>? instructionJp,
      Value<int>? sortOrder}) {
    return MondaiTypesCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      jlptLevel: jlptLevel ?? this.jlptLevel,
      subject: subject ?? this.subject,
      nameJp: nameJp ?? this.nameJp,
      nameMy: nameMy ?? this.nameMy,
      instructionJp: instructionJp ?? this.instructionJp,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] =
          Variable<int>($MondaiTypesTable.$convertertype.toSql(type.value));
    }
    if (jlptLevel.present) {
      map['jlpt_level'] = Variable<String>(jlptLevel.value);
    }
    if (subject.present) {
      map['subject'] = Variable<int>(
          $MondaiTypesTable.$convertersubject.toSql(subject.value));
    }
    if (nameJp.present) {
      map['name_jp'] = Variable<String>(nameJp.value);
    }
    if (nameMy.present) {
      map['name_my'] = Variable<String>(nameMy.value);
    }
    if (instructionJp.present) {
      map['instruction_jp'] = Variable<String>(instructionJp.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MondaiTypesCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('jlptLevel: $jlptLevel, ')
          ..write('subject: $subject, ')
          ..write('nameJp: $nameJp, ')
          ..write('nameMy: $nameMy, ')
          ..write('instructionJp: $instructionJp, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $QuestionGroupsTable extends QuestionGroups
    with TableInfo<$QuestionGroupsTable, QuestionGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestionGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _sourceIdMeta =
      const VerificationMeta('sourceId');
  @override
  late final GeneratedColumn<int> sourceId = GeneratedColumn<int>(
      'source_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _mondaiTypeIdMeta =
      const VerificationMeta('mondaiTypeId');
  @override
  late final GeneratedColumn<int> mondaiTypeId = GeneratedColumn<int>(
      'mondai_type_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _mondaiNoMeta =
      const VerificationMeta('mondaiNo');
  @override
  late final GeneratedColumn<int> mondaiNo = GeneratedColumn<int>(
      'mondai_no', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _passageMeta =
      const VerificationMeta('passage');
  @override
  late final GeneratedColumn<String> passage = GeneratedColumn<String>(
      'passage', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _audioPathMeta =
      const VerificationMeta('audioPath');
  @override
  late final GeneratedColumn<String> audioPath = GeneratedColumn<String>(
      'audio_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _instructionOverrideMeta =
      const VerificationMeta('instructionOverride');
  @override
  late final GeneratedColumn<String> instructionOverride =
      GeneratedColumn<String>('instruction_override', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        sourceId,
        mondaiTypeId,
        mondaiNo,
        passage,
        audioPath,
        instructionOverride
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'question_groups';
  @override
  VerificationContext validateIntegrity(Insertable<QuestionGroup> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('source_id')) {
      context.handle(_sourceIdMeta,
          sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta));
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('mondai_type_id')) {
      context.handle(
          _mondaiTypeIdMeta,
          mondaiTypeId.isAcceptableOrUnknown(
              data['mondai_type_id']!, _mondaiTypeIdMeta));
    } else if (isInserting) {
      context.missing(_mondaiTypeIdMeta);
    }
    if (data.containsKey('mondai_no')) {
      context.handle(_mondaiNoMeta,
          mondaiNo.isAcceptableOrUnknown(data['mondai_no']!, _mondaiNoMeta));
    }
    if (data.containsKey('passage')) {
      context.handle(_passageMeta,
          passage.isAcceptableOrUnknown(data['passage']!, _passageMeta));
    }
    if (data.containsKey('audio_path')) {
      context.handle(_audioPathMeta,
          audioPath.isAcceptableOrUnknown(data['audio_path']!, _audioPathMeta));
    }
    if (data.containsKey('instruction_override')) {
      context.handle(
          _instructionOverrideMeta,
          instructionOverride.isAcceptableOrUnknown(
              data['instruction_override']!, _instructionOverrideMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuestionGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuestionGroup(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sourceId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}source_id'])!,
      mondaiTypeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}mondai_type_id'])!,
      mondaiNo: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}mondai_no']),
      passage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}passage']),
      audioPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}audio_path']),
      instructionOverride: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}instruction_override']),
    );
  }

  @override
  $QuestionGroupsTable createAlias(String alias) {
    return $QuestionGroupsTable(attachedDatabase, alias);
  }
}

class QuestionGroup extends DataClass implements Insertable<QuestionGroup> {
  final int id;
  final int sourceId;
  final int mondaiTypeId;
  final int? mondaiNo;
  final String? passage;
  final String? audioPath;
  final String? instructionOverride;
  const QuestionGroup(
      {required this.id,
      required this.sourceId,
      required this.mondaiTypeId,
      this.mondaiNo,
      this.passage,
      this.audioPath,
      this.instructionOverride});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['source_id'] = Variable<int>(sourceId);
    map['mondai_type_id'] = Variable<int>(mondaiTypeId);
    if (!nullToAbsent || mondaiNo != null) {
      map['mondai_no'] = Variable<int>(mondaiNo);
    }
    if (!nullToAbsent || passage != null) {
      map['passage'] = Variable<String>(passage);
    }
    if (!nullToAbsent || audioPath != null) {
      map['audio_path'] = Variable<String>(audioPath);
    }
    if (!nullToAbsent || instructionOverride != null) {
      map['instruction_override'] = Variable<String>(instructionOverride);
    }
    return map;
  }

  QuestionGroupsCompanion toCompanion(bool nullToAbsent) {
    return QuestionGroupsCompanion(
      id: Value(id),
      sourceId: Value(sourceId),
      mondaiTypeId: Value(mondaiTypeId),
      mondaiNo: mondaiNo == null && nullToAbsent
          ? const Value.absent()
          : Value(mondaiNo),
      passage: passage == null && nullToAbsent
          ? const Value.absent()
          : Value(passage),
      audioPath: audioPath == null && nullToAbsent
          ? const Value.absent()
          : Value(audioPath),
      instructionOverride: instructionOverride == null && nullToAbsent
          ? const Value.absent()
          : Value(instructionOverride),
    );
  }

  factory QuestionGroup.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuestionGroup(
      id: serializer.fromJson<int>(json['id']),
      sourceId: serializer.fromJson<int>(json['sourceId']),
      mondaiTypeId: serializer.fromJson<int>(json['mondaiTypeId']),
      mondaiNo: serializer.fromJson<int?>(json['mondaiNo']),
      passage: serializer.fromJson<String?>(json['passage']),
      audioPath: serializer.fromJson<String?>(json['audioPath']),
      instructionOverride:
          serializer.fromJson<String?>(json['instructionOverride']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sourceId': serializer.toJson<int>(sourceId),
      'mondaiTypeId': serializer.toJson<int>(mondaiTypeId),
      'mondaiNo': serializer.toJson<int?>(mondaiNo),
      'passage': serializer.toJson<String?>(passage),
      'audioPath': serializer.toJson<String?>(audioPath),
      'instructionOverride': serializer.toJson<String?>(instructionOverride),
    };
  }

  QuestionGroup copyWith(
          {int? id,
          int? sourceId,
          int? mondaiTypeId,
          Value<int?> mondaiNo = const Value.absent(),
          Value<String?> passage = const Value.absent(),
          Value<String?> audioPath = const Value.absent(),
          Value<String?> instructionOverride = const Value.absent()}) =>
      QuestionGroup(
        id: id ?? this.id,
        sourceId: sourceId ?? this.sourceId,
        mondaiTypeId: mondaiTypeId ?? this.mondaiTypeId,
        mondaiNo: mondaiNo.present ? mondaiNo.value : this.mondaiNo,
        passage: passage.present ? passage.value : this.passage,
        audioPath: audioPath.present ? audioPath.value : this.audioPath,
        instructionOverride: instructionOverride.present
            ? instructionOverride.value
            : this.instructionOverride,
      );
  QuestionGroup copyWithCompanion(QuestionGroupsCompanion data) {
    return QuestionGroup(
      id: data.id.present ? data.id.value : this.id,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      mondaiTypeId: data.mondaiTypeId.present
          ? data.mondaiTypeId.value
          : this.mondaiTypeId,
      mondaiNo: data.mondaiNo.present ? data.mondaiNo.value : this.mondaiNo,
      passage: data.passage.present ? data.passage.value : this.passage,
      audioPath: data.audioPath.present ? data.audioPath.value : this.audioPath,
      instructionOverride: data.instructionOverride.present
          ? data.instructionOverride.value
          : this.instructionOverride,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuestionGroup(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('mondaiTypeId: $mondaiTypeId, ')
          ..write('mondaiNo: $mondaiNo, ')
          ..write('passage: $passage, ')
          ..write('audioPath: $audioPath, ')
          ..write('instructionOverride: $instructionOverride')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sourceId, mondaiTypeId, mondaiNo, passage,
      audioPath, instructionOverride);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuestionGroup &&
          other.id == this.id &&
          other.sourceId == this.sourceId &&
          other.mondaiTypeId == this.mondaiTypeId &&
          other.mondaiNo == this.mondaiNo &&
          other.passage == this.passage &&
          other.audioPath == this.audioPath &&
          other.instructionOverride == this.instructionOverride);
}

class QuestionGroupsCompanion extends UpdateCompanion<QuestionGroup> {
  final Value<int> id;
  final Value<int> sourceId;
  final Value<int> mondaiTypeId;
  final Value<int?> mondaiNo;
  final Value<String?> passage;
  final Value<String?> audioPath;
  final Value<String?> instructionOverride;
  const QuestionGroupsCompanion({
    this.id = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.mondaiTypeId = const Value.absent(),
    this.mondaiNo = const Value.absent(),
    this.passage = const Value.absent(),
    this.audioPath = const Value.absent(),
    this.instructionOverride = const Value.absent(),
  });
  QuestionGroupsCompanion.insert({
    this.id = const Value.absent(),
    required int sourceId,
    required int mondaiTypeId,
    this.mondaiNo = const Value.absent(),
    this.passage = const Value.absent(),
    this.audioPath = const Value.absent(),
    this.instructionOverride = const Value.absent(),
  })  : sourceId = Value(sourceId),
        mondaiTypeId = Value(mondaiTypeId);
  static Insertable<QuestionGroup> custom({
    Expression<int>? id,
    Expression<int>? sourceId,
    Expression<int>? mondaiTypeId,
    Expression<int>? mondaiNo,
    Expression<String>? passage,
    Expression<String>? audioPath,
    Expression<String>? instructionOverride,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceId != null) 'source_id': sourceId,
      if (mondaiTypeId != null) 'mondai_type_id': mondaiTypeId,
      if (mondaiNo != null) 'mondai_no': mondaiNo,
      if (passage != null) 'passage': passage,
      if (audioPath != null) 'audio_path': audioPath,
      if (instructionOverride != null)
        'instruction_override': instructionOverride,
    });
  }

  QuestionGroupsCompanion copyWith(
      {Value<int>? id,
      Value<int>? sourceId,
      Value<int>? mondaiTypeId,
      Value<int?>? mondaiNo,
      Value<String?>? passage,
      Value<String?>? audioPath,
      Value<String?>? instructionOverride}) {
    return QuestionGroupsCompanion(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      mondaiTypeId: mondaiTypeId ?? this.mondaiTypeId,
      mondaiNo: mondaiNo ?? this.mondaiNo,
      passage: passage ?? this.passage,
      audioPath: audioPath ?? this.audioPath,
      instructionOverride: instructionOverride ?? this.instructionOverride,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<int>(sourceId.value);
    }
    if (mondaiTypeId.present) {
      map['mondai_type_id'] = Variable<int>(mondaiTypeId.value);
    }
    if (mondaiNo.present) {
      map['mondai_no'] = Variable<int>(mondaiNo.value);
    }
    if (passage.present) {
      map['passage'] = Variable<String>(passage.value);
    }
    if (audioPath.present) {
      map['audio_path'] = Variable<String>(audioPath.value);
    }
    if (instructionOverride.present) {
      map['instruction_override'] = Variable<String>(instructionOverride.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestionGroupsCompanion(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('mondaiTypeId: $mondaiTypeId, ')
          ..write('mondaiNo: $mondaiNo, ')
          ..write('passage: $passage, ')
          ..write('audioPath: $audioPath, ')
          ..write('instructionOverride: $instructionOverride')
          ..write(')'))
        .toString();
  }
}

class $QuestionsTable extends Questions
    with TableInfo<$QuestionsTable, Question> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _sourceIdMeta =
      const VerificationMeta('sourceId');
  @override
  late final GeneratedColumn<int> sourceId = GeneratedColumn<int>(
      'source_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _jlptLevelMeta =
      const VerificationMeta('jlptLevel');
  @override
  late final GeneratedColumn<String> jlptLevel = GeneratedColumn<String>(
      'jlpt_level', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<Subject, int> subject =
      GeneratedColumn<int>('subject', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<Subject>($QuestionsTable.$convertersubject);
  static const VerificationMeta _mondaiTypeIdMeta =
      const VerificationMeta('mondaiTypeId');
  @override
  late final GeneratedColumn<int> mondaiTypeId = GeneratedColumn<int>(
      'mondai_type_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
      'group_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _mondaiNoMeta =
      const VerificationMeta('mondaiNo');
  @override
  late final GeneratedColumn<int> mondaiNo = GeneratedColumn<int>(
      'mondai_no', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _questionNoMeta =
      const VerificationMeta('questionNo');
  @override
  late final GeneratedColumn<int> questionNo = GeneratedColumn<int>(
      'question_no', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _questionTextMeta =
      const VerificationMeta('questionText');
  @override
  late final GeneratedColumn<String> questionText = GeneratedColumn<String>(
      'question_text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _targetWordMeta =
      const VerificationMeta('targetWord');
  @override
  late final GeneratedColumn<String> targetWord = GeneratedColumn<String>(
      'target_word', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _audioPathMeta =
      const VerificationMeta('audioPath');
  @override
  late final GeneratedColumn<String> audioPath = GeneratedColumn<String>(
      'audio_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _starPositionMeta =
      const VerificationMeta('starPosition');
  @override
  late final GeneratedColumn<int> starPosition = GeneratedColumn<int>(
      'star_position', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _correctOrderMeta =
      const VerificationMeta('correctOrder');
  @override
  late final GeneratedColumn<String> correctOrder = GeneratedColumn<String>(
      'correct_order', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _explanationMeta =
      const VerificationMeta('explanation');
  @override
  late final GeneratedColumn<String> explanation = GeneratedColumn<String>(
      'explanation', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        sourceId,
        jlptLevel,
        subject,
        mondaiTypeId,
        groupId,
        mondaiNo,
        questionNo,
        questionText,
        targetWord,
        audioPath,
        starPosition,
        correctOrder,
        explanation
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'questions';
  @override
  VerificationContext validateIntegrity(Insertable<Question> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('source_id')) {
      context.handle(_sourceIdMeta,
          sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta));
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('jlpt_level')) {
      context.handle(_jlptLevelMeta,
          jlptLevel.isAcceptableOrUnknown(data['jlpt_level']!, _jlptLevelMeta));
    } else if (isInserting) {
      context.missing(_jlptLevelMeta);
    }
    if (data.containsKey('mondai_type_id')) {
      context.handle(
          _mondaiTypeIdMeta,
          mondaiTypeId.isAcceptableOrUnknown(
              data['mondai_type_id']!, _mondaiTypeIdMeta));
    } else if (isInserting) {
      context.missing(_mondaiTypeIdMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    }
    if (data.containsKey('mondai_no')) {
      context.handle(_mondaiNoMeta,
          mondaiNo.isAcceptableOrUnknown(data['mondai_no']!, _mondaiNoMeta));
    }
    if (data.containsKey('question_no')) {
      context.handle(
          _questionNoMeta,
          questionNo.isAcceptableOrUnknown(
              data['question_no']!, _questionNoMeta));
    }
    if (data.containsKey('question_text')) {
      context.handle(
          _questionTextMeta,
          questionText.isAcceptableOrUnknown(
              data['question_text']!, _questionTextMeta));
    } else if (isInserting) {
      context.missing(_questionTextMeta);
    }
    if (data.containsKey('target_word')) {
      context.handle(
          _targetWordMeta,
          targetWord.isAcceptableOrUnknown(
              data['target_word']!, _targetWordMeta));
    }
    if (data.containsKey('audio_path')) {
      context.handle(_audioPathMeta,
          audioPath.isAcceptableOrUnknown(data['audio_path']!, _audioPathMeta));
    }
    if (data.containsKey('star_position')) {
      context.handle(
          _starPositionMeta,
          starPosition.isAcceptableOrUnknown(
              data['star_position']!, _starPositionMeta));
    }
    if (data.containsKey('correct_order')) {
      context.handle(
          _correctOrderMeta,
          correctOrder.isAcceptableOrUnknown(
              data['correct_order']!, _correctOrderMeta));
    }
    if (data.containsKey('explanation')) {
      context.handle(
          _explanationMeta,
          explanation.isAcceptableOrUnknown(
              data['explanation']!, _explanationMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Question map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Question(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sourceId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}source_id'])!,
      jlptLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}jlpt_level'])!,
      subject: $QuestionsTable.$convertersubject.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}subject'])!),
      mondaiTypeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}mondai_type_id'])!,
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}group_id']),
      mondaiNo: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}mondai_no']),
      questionNo: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}question_no']),
      questionText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}question_text'])!,
      targetWord: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target_word']),
      audioPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}audio_path']),
      starPosition: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}star_position']),
      correctOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}correct_order']),
      explanation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}explanation']),
    );
  }

  @override
  $QuestionsTable createAlias(String alias) {
    return $QuestionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Subject, int, int> $convertersubject =
      const EnumIndexConverter<Subject>(Subject.values);
}

class Question extends DataClass implements Insertable<Question> {
  final int id;
  final int sourceId;
  final String jlptLevel;
  final Subject subject;
  final int mondaiTypeId;
  final int? groupId;
  final int? mondaiNo;
  final int? questionNo;
  final String questionText;
  final String? targetWord;
  final String? audioPath;

  /// 文の組み立て (★) အတွက်
  final int? starPosition;
  final String? correctOrder;
  final String? explanation;
  const Question(
      {required this.id,
      required this.sourceId,
      required this.jlptLevel,
      required this.subject,
      required this.mondaiTypeId,
      this.groupId,
      this.mondaiNo,
      this.questionNo,
      required this.questionText,
      this.targetWord,
      this.audioPath,
      this.starPosition,
      this.correctOrder,
      this.explanation});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['source_id'] = Variable<int>(sourceId);
    map['jlpt_level'] = Variable<String>(jlptLevel);
    {
      map['subject'] =
          Variable<int>($QuestionsTable.$convertersubject.toSql(subject));
    }
    map['mondai_type_id'] = Variable<int>(mondaiTypeId);
    if (!nullToAbsent || groupId != null) {
      map['group_id'] = Variable<int>(groupId);
    }
    if (!nullToAbsent || mondaiNo != null) {
      map['mondai_no'] = Variable<int>(mondaiNo);
    }
    if (!nullToAbsent || questionNo != null) {
      map['question_no'] = Variable<int>(questionNo);
    }
    map['question_text'] = Variable<String>(questionText);
    if (!nullToAbsent || targetWord != null) {
      map['target_word'] = Variable<String>(targetWord);
    }
    if (!nullToAbsent || audioPath != null) {
      map['audio_path'] = Variable<String>(audioPath);
    }
    if (!nullToAbsent || starPosition != null) {
      map['star_position'] = Variable<int>(starPosition);
    }
    if (!nullToAbsent || correctOrder != null) {
      map['correct_order'] = Variable<String>(correctOrder);
    }
    if (!nullToAbsent || explanation != null) {
      map['explanation'] = Variable<String>(explanation);
    }
    return map;
  }

  QuestionsCompanion toCompanion(bool nullToAbsent) {
    return QuestionsCompanion(
      id: Value(id),
      sourceId: Value(sourceId),
      jlptLevel: Value(jlptLevel),
      subject: Value(subject),
      mondaiTypeId: Value(mondaiTypeId),
      groupId: groupId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupId),
      mondaiNo: mondaiNo == null && nullToAbsent
          ? const Value.absent()
          : Value(mondaiNo),
      questionNo: questionNo == null && nullToAbsent
          ? const Value.absent()
          : Value(questionNo),
      questionText: Value(questionText),
      targetWord: targetWord == null && nullToAbsent
          ? const Value.absent()
          : Value(targetWord),
      audioPath: audioPath == null && nullToAbsent
          ? const Value.absent()
          : Value(audioPath),
      starPosition: starPosition == null && nullToAbsent
          ? const Value.absent()
          : Value(starPosition),
      correctOrder: correctOrder == null && nullToAbsent
          ? const Value.absent()
          : Value(correctOrder),
      explanation: explanation == null && nullToAbsent
          ? const Value.absent()
          : Value(explanation),
    );
  }

  factory Question.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Question(
      id: serializer.fromJson<int>(json['id']),
      sourceId: serializer.fromJson<int>(json['sourceId']),
      jlptLevel: serializer.fromJson<String>(json['jlptLevel']),
      subject: $QuestionsTable.$convertersubject
          .fromJson(serializer.fromJson<int>(json['subject'])),
      mondaiTypeId: serializer.fromJson<int>(json['mondaiTypeId']),
      groupId: serializer.fromJson<int?>(json['groupId']),
      mondaiNo: serializer.fromJson<int?>(json['mondaiNo']),
      questionNo: serializer.fromJson<int?>(json['questionNo']),
      questionText: serializer.fromJson<String>(json['questionText']),
      targetWord: serializer.fromJson<String?>(json['targetWord']),
      audioPath: serializer.fromJson<String?>(json['audioPath']),
      starPosition: serializer.fromJson<int?>(json['starPosition']),
      correctOrder: serializer.fromJson<String?>(json['correctOrder']),
      explanation: serializer.fromJson<String?>(json['explanation']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sourceId': serializer.toJson<int>(sourceId),
      'jlptLevel': serializer.toJson<String>(jlptLevel),
      'subject': serializer
          .toJson<int>($QuestionsTable.$convertersubject.toJson(subject)),
      'mondaiTypeId': serializer.toJson<int>(mondaiTypeId),
      'groupId': serializer.toJson<int?>(groupId),
      'mondaiNo': serializer.toJson<int?>(mondaiNo),
      'questionNo': serializer.toJson<int?>(questionNo),
      'questionText': serializer.toJson<String>(questionText),
      'targetWord': serializer.toJson<String?>(targetWord),
      'audioPath': serializer.toJson<String?>(audioPath),
      'starPosition': serializer.toJson<int?>(starPosition),
      'correctOrder': serializer.toJson<String?>(correctOrder),
      'explanation': serializer.toJson<String?>(explanation),
    };
  }

  Question copyWith(
          {int? id,
          int? sourceId,
          String? jlptLevel,
          Subject? subject,
          int? mondaiTypeId,
          Value<int?> groupId = const Value.absent(),
          Value<int?> mondaiNo = const Value.absent(),
          Value<int?> questionNo = const Value.absent(),
          String? questionText,
          Value<String?> targetWord = const Value.absent(),
          Value<String?> audioPath = const Value.absent(),
          Value<int?> starPosition = const Value.absent(),
          Value<String?> correctOrder = const Value.absent(),
          Value<String?> explanation = const Value.absent()}) =>
      Question(
        id: id ?? this.id,
        sourceId: sourceId ?? this.sourceId,
        jlptLevel: jlptLevel ?? this.jlptLevel,
        subject: subject ?? this.subject,
        mondaiTypeId: mondaiTypeId ?? this.mondaiTypeId,
        groupId: groupId.present ? groupId.value : this.groupId,
        mondaiNo: mondaiNo.present ? mondaiNo.value : this.mondaiNo,
        questionNo: questionNo.present ? questionNo.value : this.questionNo,
        questionText: questionText ?? this.questionText,
        targetWord: targetWord.present ? targetWord.value : this.targetWord,
        audioPath: audioPath.present ? audioPath.value : this.audioPath,
        starPosition:
            starPosition.present ? starPosition.value : this.starPosition,
        correctOrder:
            correctOrder.present ? correctOrder.value : this.correctOrder,
        explanation: explanation.present ? explanation.value : this.explanation,
      );
  Question copyWithCompanion(QuestionsCompanion data) {
    return Question(
      id: data.id.present ? data.id.value : this.id,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      jlptLevel: data.jlptLevel.present ? data.jlptLevel.value : this.jlptLevel,
      subject: data.subject.present ? data.subject.value : this.subject,
      mondaiTypeId: data.mondaiTypeId.present
          ? data.mondaiTypeId.value
          : this.mondaiTypeId,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      mondaiNo: data.mondaiNo.present ? data.mondaiNo.value : this.mondaiNo,
      questionNo:
          data.questionNo.present ? data.questionNo.value : this.questionNo,
      questionText: data.questionText.present
          ? data.questionText.value
          : this.questionText,
      targetWord:
          data.targetWord.present ? data.targetWord.value : this.targetWord,
      audioPath: data.audioPath.present ? data.audioPath.value : this.audioPath,
      starPosition: data.starPosition.present
          ? data.starPosition.value
          : this.starPosition,
      correctOrder: data.correctOrder.present
          ? data.correctOrder.value
          : this.correctOrder,
      explanation:
          data.explanation.present ? data.explanation.value : this.explanation,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Question(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('jlptLevel: $jlptLevel, ')
          ..write('subject: $subject, ')
          ..write('mondaiTypeId: $mondaiTypeId, ')
          ..write('groupId: $groupId, ')
          ..write('mondaiNo: $mondaiNo, ')
          ..write('questionNo: $questionNo, ')
          ..write('questionText: $questionText, ')
          ..write('targetWord: $targetWord, ')
          ..write('audioPath: $audioPath, ')
          ..write('starPosition: $starPosition, ')
          ..write('correctOrder: $correctOrder, ')
          ..write('explanation: $explanation')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      sourceId,
      jlptLevel,
      subject,
      mondaiTypeId,
      groupId,
      mondaiNo,
      questionNo,
      questionText,
      targetWord,
      audioPath,
      starPosition,
      correctOrder,
      explanation);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Question &&
          other.id == this.id &&
          other.sourceId == this.sourceId &&
          other.jlptLevel == this.jlptLevel &&
          other.subject == this.subject &&
          other.mondaiTypeId == this.mondaiTypeId &&
          other.groupId == this.groupId &&
          other.mondaiNo == this.mondaiNo &&
          other.questionNo == this.questionNo &&
          other.questionText == this.questionText &&
          other.targetWord == this.targetWord &&
          other.audioPath == this.audioPath &&
          other.starPosition == this.starPosition &&
          other.correctOrder == this.correctOrder &&
          other.explanation == this.explanation);
}

class QuestionsCompanion extends UpdateCompanion<Question> {
  final Value<int> id;
  final Value<int> sourceId;
  final Value<String> jlptLevel;
  final Value<Subject> subject;
  final Value<int> mondaiTypeId;
  final Value<int?> groupId;
  final Value<int?> mondaiNo;
  final Value<int?> questionNo;
  final Value<String> questionText;
  final Value<String?> targetWord;
  final Value<String?> audioPath;
  final Value<int?> starPosition;
  final Value<String?> correctOrder;
  final Value<String?> explanation;
  const QuestionsCompanion({
    this.id = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.jlptLevel = const Value.absent(),
    this.subject = const Value.absent(),
    this.mondaiTypeId = const Value.absent(),
    this.groupId = const Value.absent(),
    this.mondaiNo = const Value.absent(),
    this.questionNo = const Value.absent(),
    this.questionText = const Value.absent(),
    this.targetWord = const Value.absent(),
    this.audioPath = const Value.absent(),
    this.starPosition = const Value.absent(),
    this.correctOrder = const Value.absent(),
    this.explanation = const Value.absent(),
  });
  QuestionsCompanion.insert({
    this.id = const Value.absent(),
    required int sourceId,
    required String jlptLevel,
    required Subject subject,
    required int mondaiTypeId,
    this.groupId = const Value.absent(),
    this.mondaiNo = const Value.absent(),
    this.questionNo = const Value.absent(),
    required String questionText,
    this.targetWord = const Value.absent(),
    this.audioPath = const Value.absent(),
    this.starPosition = const Value.absent(),
    this.correctOrder = const Value.absent(),
    this.explanation = const Value.absent(),
  })  : sourceId = Value(sourceId),
        jlptLevel = Value(jlptLevel),
        subject = Value(subject),
        mondaiTypeId = Value(mondaiTypeId),
        questionText = Value(questionText);
  static Insertable<Question> custom({
    Expression<int>? id,
    Expression<int>? sourceId,
    Expression<String>? jlptLevel,
    Expression<int>? subject,
    Expression<int>? mondaiTypeId,
    Expression<int>? groupId,
    Expression<int>? mondaiNo,
    Expression<int>? questionNo,
    Expression<String>? questionText,
    Expression<String>? targetWord,
    Expression<String>? audioPath,
    Expression<int>? starPosition,
    Expression<String>? correctOrder,
    Expression<String>? explanation,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceId != null) 'source_id': sourceId,
      if (jlptLevel != null) 'jlpt_level': jlptLevel,
      if (subject != null) 'subject': subject,
      if (mondaiTypeId != null) 'mondai_type_id': mondaiTypeId,
      if (groupId != null) 'group_id': groupId,
      if (mondaiNo != null) 'mondai_no': mondaiNo,
      if (questionNo != null) 'question_no': questionNo,
      if (questionText != null) 'question_text': questionText,
      if (targetWord != null) 'target_word': targetWord,
      if (audioPath != null) 'audio_path': audioPath,
      if (starPosition != null) 'star_position': starPosition,
      if (correctOrder != null) 'correct_order': correctOrder,
      if (explanation != null) 'explanation': explanation,
    });
  }

  QuestionsCompanion copyWith(
      {Value<int>? id,
      Value<int>? sourceId,
      Value<String>? jlptLevel,
      Value<Subject>? subject,
      Value<int>? mondaiTypeId,
      Value<int?>? groupId,
      Value<int?>? mondaiNo,
      Value<int?>? questionNo,
      Value<String>? questionText,
      Value<String?>? targetWord,
      Value<String?>? audioPath,
      Value<int?>? starPosition,
      Value<String?>? correctOrder,
      Value<String?>? explanation}) {
    return QuestionsCompanion(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      jlptLevel: jlptLevel ?? this.jlptLevel,
      subject: subject ?? this.subject,
      mondaiTypeId: mondaiTypeId ?? this.mondaiTypeId,
      groupId: groupId ?? this.groupId,
      mondaiNo: mondaiNo ?? this.mondaiNo,
      questionNo: questionNo ?? this.questionNo,
      questionText: questionText ?? this.questionText,
      targetWord: targetWord ?? this.targetWord,
      audioPath: audioPath ?? this.audioPath,
      starPosition: starPosition ?? this.starPosition,
      correctOrder: correctOrder ?? this.correctOrder,
      explanation: explanation ?? this.explanation,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<int>(sourceId.value);
    }
    if (jlptLevel.present) {
      map['jlpt_level'] = Variable<String>(jlptLevel.value);
    }
    if (subject.present) {
      map['subject'] =
          Variable<int>($QuestionsTable.$convertersubject.toSql(subject.value));
    }
    if (mondaiTypeId.present) {
      map['mondai_type_id'] = Variable<int>(mondaiTypeId.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (mondaiNo.present) {
      map['mondai_no'] = Variable<int>(mondaiNo.value);
    }
    if (questionNo.present) {
      map['question_no'] = Variable<int>(questionNo.value);
    }
    if (questionText.present) {
      map['question_text'] = Variable<String>(questionText.value);
    }
    if (targetWord.present) {
      map['target_word'] = Variable<String>(targetWord.value);
    }
    if (audioPath.present) {
      map['audio_path'] = Variable<String>(audioPath.value);
    }
    if (starPosition.present) {
      map['star_position'] = Variable<int>(starPosition.value);
    }
    if (correctOrder.present) {
      map['correct_order'] = Variable<String>(correctOrder.value);
    }
    if (explanation.present) {
      map['explanation'] = Variable<String>(explanation.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestionsCompanion(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('jlptLevel: $jlptLevel, ')
          ..write('subject: $subject, ')
          ..write('mondaiTypeId: $mondaiTypeId, ')
          ..write('groupId: $groupId, ')
          ..write('mondaiNo: $mondaiNo, ')
          ..write('questionNo: $questionNo, ')
          ..write('questionText: $questionText, ')
          ..write('targetWord: $targetWord, ')
          ..write('audioPath: $audioPath, ')
          ..write('starPosition: $starPosition, ')
          ..write('correctOrder: $correctOrder, ')
          ..write('explanation: $explanation')
          ..write(')'))
        .toString();
  }
}

class $QuestionChoicesTable extends QuestionChoices
    with TableInfo<$QuestionChoicesTable, QuestionChoice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestionChoicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _questionIdMeta =
      const VerificationMeta('questionId');
  @override
  late final GeneratedColumn<int> questionId = GeneratedColumn<int>(
      'question_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _choiceTextMeta =
      const VerificationMeta('choiceText');
  @override
  late final GeneratedColumn<String> choiceText = GeneratedColumn<String>(
      'text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isCorrectMeta =
      const VerificationMeta('isCorrect');
  @override
  late final GeneratedColumn<bool> isCorrect = GeneratedColumn<bool>(
      'is_correct', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_correct" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, questionId, position, choiceText, isCorrect];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'question_choices';
  @override
  VerificationContext validateIntegrity(Insertable<QuestionChoice> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('question_id')) {
      context.handle(
          _questionIdMeta,
          questionId.isAcceptableOrUnknown(
              data['question_id']!, _questionIdMeta));
    } else if (isInserting) {
      context.missing(_questionIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('text')) {
      context.handle(_choiceTextMeta,
          choiceText.isAcceptableOrUnknown(data['text']!, _choiceTextMeta));
    } else if (isInserting) {
      context.missing(_choiceTextMeta);
    }
    if (data.containsKey('is_correct')) {
      context.handle(_isCorrectMeta,
          isCorrect.isAcceptableOrUnknown(data['is_correct']!, _isCorrectMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {questionId, position},
      ];
  @override
  QuestionChoice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuestionChoice(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      questionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}question_id'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      choiceText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}text'])!,
      isCorrect: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_correct'])!,
    );
  }

  @override
  $QuestionChoicesTable createAlias(String alias) {
    return $QuestionChoicesTable(attachedDatabase, alias);
  }
}

class QuestionChoice extends DataClass implements Insertable<QuestionChoice> {
  final int id;
  final int questionId;
  final int position;
  final String choiceText;
  final bool isCorrect;
  const QuestionChoice(
      {required this.id,
      required this.questionId,
      required this.position,
      required this.choiceText,
      required this.isCorrect});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['question_id'] = Variable<int>(questionId);
    map['position'] = Variable<int>(position);
    map['text'] = Variable<String>(choiceText);
    map['is_correct'] = Variable<bool>(isCorrect);
    return map;
  }

  QuestionChoicesCompanion toCompanion(bool nullToAbsent) {
    return QuestionChoicesCompanion(
      id: Value(id),
      questionId: Value(questionId),
      position: Value(position),
      choiceText: Value(choiceText),
      isCorrect: Value(isCorrect),
    );
  }

  factory QuestionChoice.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuestionChoice(
      id: serializer.fromJson<int>(json['id']),
      questionId: serializer.fromJson<int>(json['questionId']),
      position: serializer.fromJson<int>(json['position']),
      choiceText: serializer.fromJson<String>(json['choiceText']),
      isCorrect: serializer.fromJson<bool>(json['isCorrect']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'questionId': serializer.toJson<int>(questionId),
      'position': serializer.toJson<int>(position),
      'choiceText': serializer.toJson<String>(choiceText),
      'isCorrect': serializer.toJson<bool>(isCorrect),
    };
  }

  QuestionChoice copyWith(
          {int? id,
          int? questionId,
          int? position,
          String? choiceText,
          bool? isCorrect}) =>
      QuestionChoice(
        id: id ?? this.id,
        questionId: questionId ?? this.questionId,
        position: position ?? this.position,
        choiceText: choiceText ?? this.choiceText,
        isCorrect: isCorrect ?? this.isCorrect,
      );
  QuestionChoice copyWithCompanion(QuestionChoicesCompanion data) {
    return QuestionChoice(
      id: data.id.present ? data.id.value : this.id,
      questionId:
          data.questionId.present ? data.questionId.value : this.questionId,
      position: data.position.present ? data.position.value : this.position,
      choiceText:
          data.choiceText.present ? data.choiceText.value : this.choiceText,
      isCorrect: data.isCorrect.present ? data.isCorrect.value : this.isCorrect,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuestionChoice(')
          ..write('id: $id, ')
          ..write('questionId: $questionId, ')
          ..write('position: $position, ')
          ..write('choiceText: $choiceText, ')
          ..write('isCorrect: $isCorrect')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, questionId, position, choiceText, isCorrect);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuestionChoice &&
          other.id == this.id &&
          other.questionId == this.questionId &&
          other.position == this.position &&
          other.choiceText == this.choiceText &&
          other.isCorrect == this.isCorrect);
}

class QuestionChoicesCompanion extends UpdateCompanion<QuestionChoice> {
  final Value<int> id;
  final Value<int> questionId;
  final Value<int> position;
  final Value<String> choiceText;
  final Value<bool> isCorrect;
  const QuestionChoicesCompanion({
    this.id = const Value.absent(),
    this.questionId = const Value.absent(),
    this.position = const Value.absent(),
    this.choiceText = const Value.absent(),
    this.isCorrect = const Value.absent(),
  });
  QuestionChoicesCompanion.insert({
    this.id = const Value.absent(),
    required int questionId,
    required int position,
    required String choiceText,
    this.isCorrect = const Value.absent(),
  })  : questionId = Value(questionId),
        position = Value(position),
        choiceText = Value(choiceText);
  static Insertable<QuestionChoice> custom({
    Expression<int>? id,
    Expression<int>? questionId,
    Expression<int>? position,
    Expression<String>? choiceText,
    Expression<bool>? isCorrect,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (questionId != null) 'question_id': questionId,
      if (position != null) 'position': position,
      if (choiceText != null) 'text': choiceText,
      if (isCorrect != null) 'is_correct': isCorrect,
    });
  }

  QuestionChoicesCompanion copyWith(
      {Value<int>? id,
      Value<int>? questionId,
      Value<int>? position,
      Value<String>? choiceText,
      Value<bool>? isCorrect}) {
    return QuestionChoicesCompanion(
      id: id ?? this.id,
      questionId: questionId ?? this.questionId,
      position: position ?? this.position,
      choiceText: choiceText ?? this.choiceText,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (questionId.present) {
      map['question_id'] = Variable<int>(questionId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (choiceText.present) {
      map['text'] = Variable<String>(choiceText.value);
    }
    if (isCorrect.present) {
      map['is_correct'] = Variable<bool>(isCorrect.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestionChoicesCompanion(')
          ..write('id: $id, ')
          ..write('questionId: $questionId, ')
          ..write('position: $position, ')
          ..write('choiceText: $choiceText, ')
          ..write('isCorrect: $isCorrect')
          ..write(')'))
        .toString();
  }
}

class $ProgressTable extends Progress
    with TableInfo<$ProgressTable, ProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  @override
  late final GeneratedColumnWithTypeConverter<ItemType, int> itemType =
      GeneratedColumn<int>('item_type', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<ItemType>($ProgressTable.$converteritemType);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
      'item_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<Direction, int> direction =
      GeneratedColumn<int>('direction', aliasedName, false,
              type: DriftSqlType.int,
              requiredDuringInsert: false,
              defaultValue: const Constant(0))
          .withConverter<Direction>($ProgressTable.$converterdirection);
  static const VerificationMeta _correctCountMeta =
      const VerificationMeta('correctCount');
  @override
  late final GeneratedColumn<int> correctCount = GeneratedColumn<int>(
      'correct_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _wrongCountMeta =
      const VerificationMeta('wrongCount');
  @override
  late final GeneratedColumn<int> wrongCount = GeneratedColumn<int>(
      'wrong_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _streakMeta = const VerificationMeta('streak');
  @override
  late final GeneratedColumn<int> streak = GeneratedColumn<int>(
      'streak', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _easeFactorMeta =
      const VerificationMeta('easeFactor');
  @override
  late final GeneratedColumn<double> easeFactor = GeneratedColumn<double>(
      'ease_factor', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(2.5));
  static const VerificationMeta _intervalDaysMeta =
      const VerificationMeta('intervalDays');
  @override
  late final GeneratedColumn<int> intervalDays = GeneratedColumn<int>(
      'interval_days', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastReviewedMeta =
      const VerificationMeta('lastReviewed');
  @override
  late final GeneratedColumn<DateTime> lastReviewed = GeneratedColumn<DateTime>(
      'last_reviewed', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _nextReviewMeta =
      const VerificationMeta('nextReview');
  @override
  late final GeneratedColumn<DateTime> nextReview = GeneratedColumn<DateTime>(
      'next_review', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isBookmarkedMeta =
      const VerificationMeta('isBookmarked');
  @override
  late final GeneratedColumn<bool> isBookmarked = GeneratedColumn<bool>(
      'is_bookmarked', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_bookmarked" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        itemType,
        itemId,
        direction,
        correctCount,
        wrongCount,
        streak,
        easeFactor,
        intervalDays,
        lastReviewed,
        nextReview,
        isBookmarked
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'progress';
  @override
  VerificationContext validateIntegrity(Insertable<ProgressData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('correct_count')) {
      context.handle(
          _correctCountMeta,
          correctCount.isAcceptableOrUnknown(
              data['correct_count']!, _correctCountMeta));
    }
    if (data.containsKey('wrong_count')) {
      context.handle(
          _wrongCountMeta,
          wrongCount.isAcceptableOrUnknown(
              data['wrong_count']!, _wrongCountMeta));
    }
    if (data.containsKey('streak')) {
      context.handle(_streakMeta,
          streak.isAcceptableOrUnknown(data['streak']!, _streakMeta));
    }
    if (data.containsKey('ease_factor')) {
      context.handle(
          _easeFactorMeta,
          easeFactor.isAcceptableOrUnknown(
              data['ease_factor']!, _easeFactorMeta));
    }
    if (data.containsKey('interval_days')) {
      context.handle(
          _intervalDaysMeta,
          intervalDays.isAcceptableOrUnknown(
              data['interval_days']!, _intervalDaysMeta));
    }
    if (data.containsKey('last_reviewed')) {
      context.handle(
          _lastReviewedMeta,
          lastReviewed.isAcceptableOrUnknown(
              data['last_reviewed']!, _lastReviewedMeta));
    }
    if (data.containsKey('next_review')) {
      context.handle(
          _nextReviewMeta,
          nextReview.isAcceptableOrUnknown(
              data['next_review']!, _nextReviewMeta));
    }
    if (data.containsKey('is_bookmarked')) {
      context.handle(
          _isBookmarkedMeta,
          isBookmarked.isAcceptableOrUnknown(
              data['is_bookmarked']!, _isBookmarkedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {itemType, itemId, direction},
      ];
  @override
  ProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProgressData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      itemType: $ProgressTable.$converteritemType.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}item_type'])!),
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}item_id'])!,
      direction: $ProgressTable.$converterdirection.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}direction'])!),
      correctCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}correct_count'])!,
      wrongCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}wrong_count'])!,
      streak: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}streak'])!,
      easeFactor: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}ease_factor'])!,
      intervalDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}interval_days'])!,
      lastReviewed: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_reviewed']),
      nextReview: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}next_review']),
      isBookmarked: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_bookmarked'])!,
    );
  }

  @override
  $ProgressTable createAlias(String alias) {
    return $ProgressTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ItemType, int, int> $converteritemType =
      const EnumIndexConverter<ItemType>(ItemType.values);
  static JsonTypeConverter2<Direction, int, int> $converterdirection =
      const EnumIndexConverter<Direction>(Direction.values);
}

class ProgressData extends DataClass implements Insertable<ProgressData> {
  final int id;
  final ItemType itemType;
  final int itemId;
  final Direction direction;
  final int correctCount;
  final int wrongCount;
  final int streak;
  final double easeFactor;
  final int intervalDays;
  final DateTime? lastReviewed;
  final DateTime? nextReview;
  final bool isBookmarked;
  const ProgressData(
      {required this.id,
      required this.itemType,
      required this.itemId,
      required this.direction,
      required this.correctCount,
      required this.wrongCount,
      required this.streak,
      required this.easeFactor,
      required this.intervalDays,
      this.lastReviewed,
      this.nextReview,
      required this.isBookmarked});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['item_type'] =
          Variable<int>($ProgressTable.$converteritemType.toSql(itemType));
    }
    map['item_id'] = Variable<int>(itemId);
    {
      map['direction'] =
          Variable<int>($ProgressTable.$converterdirection.toSql(direction));
    }
    map['correct_count'] = Variable<int>(correctCount);
    map['wrong_count'] = Variable<int>(wrongCount);
    map['streak'] = Variable<int>(streak);
    map['ease_factor'] = Variable<double>(easeFactor);
    map['interval_days'] = Variable<int>(intervalDays);
    if (!nullToAbsent || lastReviewed != null) {
      map['last_reviewed'] = Variable<DateTime>(lastReviewed);
    }
    if (!nullToAbsent || nextReview != null) {
      map['next_review'] = Variable<DateTime>(nextReview);
    }
    map['is_bookmarked'] = Variable<bool>(isBookmarked);
    return map;
  }

  ProgressCompanion toCompanion(bool nullToAbsent) {
    return ProgressCompanion(
      id: Value(id),
      itemType: Value(itemType),
      itemId: Value(itemId),
      direction: Value(direction),
      correctCount: Value(correctCount),
      wrongCount: Value(wrongCount),
      streak: Value(streak),
      easeFactor: Value(easeFactor),
      intervalDays: Value(intervalDays),
      lastReviewed: lastReviewed == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReviewed),
      nextReview: nextReview == null && nullToAbsent
          ? const Value.absent()
          : Value(nextReview),
      isBookmarked: Value(isBookmarked),
    );
  }

  factory ProgressData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProgressData(
      id: serializer.fromJson<int>(json['id']),
      itemType: $ProgressTable.$converteritemType
          .fromJson(serializer.fromJson<int>(json['itemType'])),
      itemId: serializer.fromJson<int>(json['itemId']),
      direction: $ProgressTable.$converterdirection
          .fromJson(serializer.fromJson<int>(json['direction'])),
      correctCount: serializer.fromJson<int>(json['correctCount']),
      wrongCount: serializer.fromJson<int>(json['wrongCount']),
      streak: serializer.fromJson<int>(json['streak']),
      easeFactor: serializer.fromJson<double>(json['easeFactor']),
      intervalDays: serializer.fromJson<int>(json['intervalDays']),
      lastReviewed: serializer.fromJson<DateTime?>(json['lastReviewed']),
      nextReview: serializer.fromJson<DateTime?>(json['nextReview']),
      isBookmarked: serializer.fromJson<bool>(json['isBookmarked']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'itemType': serializer
          .toJson<int>($ProgressTable.$converteritemType.toJson(itemType)),
      'itemId': serializer.toJson<int>(itemId),
      'direction': serializer
          .toJson<int>($ProgressTable.$converterdirection.toJson(direction)),
      'correctCount': serializer.toJson<int>(correctCount),
      'wrongCount': serializer.toJson<int>(wrongCount),
      'streak': serializer.toJson<int>(streak),
      'easeFactor': serializer.toJson<double>(easeFactor),
      'intervalDays': serializer.toJson<int>(intervalDays),
      'lastReviewed': serializer.toJson<DateTime?>(lastReviewed),
      'nextReview': serializer.toJson<DateTime?>(nextReview),
      'isBookmarked': serializer.toJson<bool>(isBookmarked),
    };
  }

  ProgressData copyWith(
          {int? id,
          ItemType? itemType,
          int? itemId,
          Direction? direction,
          int? correctCount,
          int? wrongCount,
          int? streak,
          double? easeFactor,
          int? intervalDays,
          Value<DateTime?> lastReviewed = const Value.absent(),
          Value<DateTime?> nextReview = const Value.absent(),
          bool? isBookmarked}) =>
      ProgressData(
        id: id ?? this.id,
        itemType: itemType ?? this.itemType,
        itemId: itemId ?? this.itemId,
        direction: direction ?? this.direction,
        correctCount: correctCount ?? this.correctCount,
        wrongCount: wrongCount ?? this.wrongCount,
        streak: streak ?? this.streak,
        easeFactor: easeFactor ?? this.easeFactor,
        intervalDays: intervalDays ?? this.intervalDays,
        lastReviewed:
            lastReviewed.present ? lastReviewed.value : this.lastReviewed,
        nextReview: nextReview.present ? nextReview.value : this.nextReview,
        isBookmarked: isBookmarked ?? this.isBookmarked,
      );
  ProgressData copyWithCompanion(ProgressCompanion data) {
    return ProgressData(
      id: data.id.present ? data.id.value : this.id,
      itemType: data.itemType.present ? data.itemType.value : this.itemType,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      direction: data.direction.present ? data.direction.value : this.direction,
      correctCount: data.correctCount.present
          ? data.correctCount.value
          : this.correctCount,
      wrongCount:
          data.wrongCount.present ? data.wrongCount.value : this.wrongCount,
      streak: data.streak.present ? data.streak.value : this.streak,
      easeFactor:
          data.easeFactor.present ? data.easeFactor.value : this.easeFactor,
      intervalDays: data.intervalDays.present
          ? data.intervalDays.value
          : this.intervalDays,
      lastReviewed: data.lastReviewed.present
          ? data.lastReviewed.value
          : this.lastReviewed,
      nextReview:
          data.nextReview.present ? data.nextReview.value : this.nextReview,
      isBookmarked: data.isBookmarked.present
          ? data.isBookmarked.value
          : this.isBookmarked,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProgressData(')
          ..write('id: $id, ')
          ..write('itemType: $itemType, ')
          ..write('itemId: $itemId, ')
          ..write('direction: $direction, ')
          ..write('correctCount: $correctCount, ')
          ..write('wrongCount: $wrongCount, ')
          ..write('streak: $streak, ')
          ..write('easeFactor: $easeFactor, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('lastReviewed: $lastReviewed, ')
          ..write('nextReview: $nextReview, ')
          ..write('isBookmarked: $isBookmarked')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      itemType,
      itemId,
      direction,
      correctCount,
      wrongCount,
      streak,
      easeFactor,
      intervalDays,
      lastReviewed,
      nextReview,
      isBookmarked);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProgressData &&
          other.id == this.id &&
          other.itemType == this.itemType &&
          other.itemId == this.itemId &&
          other.direction == this.direction &&
          other.correctCount == this.correctCount &&
          other.wrongCount == this.wrongCount &&
          other.streak == this.streak &&
          other.easeFactor == this.easeFactor &&
          other.intervalDays == this.intervalDays &&
          other.lastReviewed == this.lastReviewed &&
          other.nextReview == this.nextReview &&
          other.isBookmarked == this.isBookmarked);
}

class ProgressCompanion extends UpdateCompanion<ProgressData> {
  final Value<int> id;
  final Value<ItemType> itemType;
  final Value<int> itemId;
  final Value<Direction> direction;
  final Value<int> correctCount;
  final Value<int> wrongCount;
  final Value<int> streak;
  final Value<double> easeFactor;
  final Value<int> intervalDays;
  final Value<DateTime?> lastReviewed;
  final Value<DateTime?> nextReview;
  final Value<bool> isBookmarked;
  const ProgressCompanion({
    this.id = const Value.absent(),
    this.itemType = const Value.absent(),
    this.itemId = const Value.absent(),
    this.direction = const Value.absent(),
    this.correctCount = const Value.absent(),
    this.wrongCount = const Value.absent(),
    this.streak = const Value.absent(),
    this.easeFactor = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.lastReviewed = const Value.absent(),
    this.nextReview = const Value.absent(),
    this.isBookmarked = const Value.absent(),
  });
  ProgressCompanion.insert({
    this.id = const Value.absent(),
    required ItemType itemType,
    required int itemId,
    this.direction = const Value.absent(),
    this.correctCount = const Value.absent(),
    this.wrongCount = const Value.absent(),
    this.streak = const Value.absent(),
    this.easeFactor = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.lastReviewed = const Value.absent(),
    this.nextReview = const Value.absent(),
    this.isBookmarked = const Value.absent(),
  })  : itemType = Value(itemType),
        itemId = Value(itemId);
  static Insertable<ProgressData> custom({
    Expression<int>? id,
    Expression<int>? itemType,
    Expression<int>? itemId,
    Expression<int>? direction,
    Expression<int>? correctCount,
    Expression<int>? wrongCount,
    Expression<int>? streak,
    Expression<double>? easeFactor,
    Expression<int>? intervalDays,
    Expression<DateTime>? lastReviewed,
    Expression<DateTime>? nextReview,
    Expression<bool>? isBookmarked,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemType != null) 'item_type': itemType,
      if (itemId != null) 'item_id': itemId,
      if (direction != null) 'direction': direction,
      if (correctCount != null) 'correct_count': correctCount,
      if (wrongCount != null) 'wrong_count': wrongCount,
      if (streak != null) 'streak': streak,
      if (easeFactor != null) 'ease_factor': easeFactor,
      if (intervalDays != null) 'interval_days': intervalDays,
      if (lastReviewed != null) 'last_reviewed': lastReviewed,
      if (nextReview != null) 'next_review': nextReview,
      if (isBookmarked != null) 'is_bookmarked': isBookmarked,
    });
  }

  ProgressCompanion copyWith(
      {Value<int>? id,
      Value<ItemType>? itemType,
      Value<int>? itemId,
      Value<Direction>? direction,
      Value<int>? correctCount,
      Value<int>? wrongCount,
      Value<int>? streak,
      Value<double>? easeFactor,
      Value<int>? intervalDays,
      Value<DateTime?>? lastReviewed,
      Value<DateTime?>? nextReview,
      Value<bool>? isBookmarked}) {
    return ProgressCompanion(
      id: id ?? this.id,
      itemType: itemType ?? this.itemType,
      itemId: itemId ?? this.itemId,
      direction: direction ?? this.direction,
      correctCount: correctCount ?? this.correctCount,
      wrongCount: wrongCount ?? this.wrongCount,
      streak: streak ?? this.streak,
      easeFactor: easeFactor ?? this.easeFactor,
      intervalDays: intervalDays ?? this.intervalDays,
      lastReviewed: lastReviewed ?? this.lastReviewed,
      nextReview: nextReview ?? this.nextReview,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (itemType.present) {
      map['item_type'] = Variable<int>(
          $ProgressTable.$converteritemType.toSql(itemType.value));
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (direction.present) {
      map['direction'] = Variable<int>(
          $ProgressTable.$converterdirection.toSql(direction.value));
    }
    if (correctCount.present) {
      map['correct_count'] = Variable<int>(correctCount.value);
    }
    if (wrongCount.present) {
      map['wrong_count'] = Variable<int>(wrongCount.value);
    }
    if (streak.present) {
      map['streak'] = Variable<int>(streak.value);
    }
    if (easeFactor.present) {
      map['ease_factor'] = Variable<double>(easeFactor.value);
    }
    if (intervalDays.present) {
      map['interval_days'] = Variable<int>(intervalDays.value);
    }
    if (lastReviewed.present) {
      map['last_reviewed'] = Variable<DateTime>(lastReviewed.value);
    }
    if (nextReview.present) {
      map['next_review'] = Variable<DateTime>(nextReview.value);
    }
    if (isBookmarked.present) {
      map['is_bookmarked'] = Variable<bool>(isBookmarked.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgressCompanion(')
          ..write('id: $id, ')
          ..write('itemType: $itemType, ')
          ..write('itemId: $itemId, ')
          ..write('direction: $direction, ')
          ..write('correctCount: $correctCount, ')
          ..write('wrongCount: $wrongCount, ')
          ..write('streak: $streak, ')
          ..write('easeFactor: $easeFactor, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('lastReviewed: $lastReviewed, ')
          ..write('nextReview: $nextReview, ')
          ..write('isBookmarked: $isBookmarked')
          ..write(')'))
        .toString();
  }
}

class $PracticeSessionsTable extends PracticeSessions
    with TableInfo<$PracticeSessionsTable, PracticeSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PracticeSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  @override
  late final GeneratedColumnWithTypeConverter<QuizModeDb, int> mode =
      GeneratedColumn<int>('mode', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<QuizModeDb>($PracticeSessionsTable.$convertermode);
  @override
  late final GeneratedColumnWithTypeConverter<ItemType, int> contentType =
      GeneratedColumn<int>('content_type', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<ItemType>(
              $PracticeSessionsTable.$convertercontentType);
  static const VerificationMeta _filterJsonMeta =
      const VerificationMeta('filterJson');
  @override
  late final GeneratedColumn<String> filterJson = GeneratedColumn<String>(
      'filter_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startedAtMeta =
      const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
      'started_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _finishedAtMeta =
      const VerificationMeta('finishedAt');
  @override
  late final GeneratedColumn<DateTime> finishedAt = GeneratedColumn<DateTime>(
      'finished_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<int> total = GeneratedColumn<int>(
      'total', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _correctMeta =
      const VerificationMeta('correct');
  @override
  late final GeneratedColumn<int> correct = GeneratedColumn<int>(
      'correct', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _durationSecMeta =
      const VerificationMeta('durationSec');
  @override
  late final GeneratedColumn<int> durationSec = GeneratedColumn<int>(
      'duration_sec', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        mode,
        contentType,
        filterJson,
        startedAt,
        finishedAt,
        total,
        correct,
        durationSec
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'practice_sessions';
  @override
  VerificationContext validateIntegrity(Insertable<PracticeSession> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('filter_json')) {
      context.handle(
          _filterJsonMeta,
          filterJson.isAcceptableOrUnknown(
              data['filter_json']!, _filterJsonMeta));
    } else if (isInserting) {
      context.missing(_filterJsonMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta,
          startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('finished_at')) {
      context.handle(
          _finishedAtMeta,
          finishedAt.isAcceptableOrUnknown(
              data['finished_at']!, _finishedAtMeta));
    }
    if (data.containsKey('total')) {
      context.handle(
          _totalMeta, total.isAcceptableOrUnknown(data['total']!, _totalMeta));
    }
    if (data.containsKey('correct')) {
      context.handle(_correctMeta,
          correct.isAcceptableOrUnknown(data['correct']!, _correctMeta));
    }
    if (data.containsKey('duration_sec')) {
      context.handle(
          _durationSecMeta,
          durationSec.isAcceptableOrUnknown(
              data['duration_sec']!, _durationSecMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PracticeSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PracticeSession(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      mode: $PracticeSessionsTable.$convertermode.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}mode'])!),
      contentType: $PracticeSessionsTable.$convertercontentType.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.int, data['${effectivePrefix}content_type'])!),
      filterJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}filter_json'])!,
      startedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}started_at'])!,
      finishedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}finished_at']),
      total: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total'])!,
      correct: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}correct'])!,
      durationSec: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_sec'])!,
    );
  }

  @override
  $PracticeSessionsTable createAlias(String alias) {
    return $PracticeSessionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<QuizModeDb, int, int> $convertermode =
      const EnumIndexConverter<QuizModeDb>(QuizModeDb.values);
  static JsonTypeConverter2<ItemType, int, int> $convertercontentType =
      const EnumIndexConverter<ItemType>(ItemType.values);
}

class PracticeSession extends DataClass implements Insertable<PracticeSession> {
  final int id;
  final QuizModeDb mode;
  final ItemType contentType;
  final String filterJson;
  final DateTime startedAt;
  final DateTime? finishedAt;
  final int total;
  final int correct;
  final int durationSec;
  const PracticeSession(
      {required this.id,
      required this.mode,
      required this.contentType,
      required this.filterJson,
      required this.startedAt,
      this.finishedAt,
      required this.total,
      required this.correct,
      required this.durationSec});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['mode'] =
          Variable<int>($PracticeSessionsTable.$convertermode.toSql(mode));
    }
    {
      map['content_type'] = Variable<int>(
          $PracticeSessionsTable.$convertercontentType.toSql(contentType));
    }
    map['filter_json'] = Variable<String>(filterJson);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || finishedAt != null) {
      map['finished_at'] = Variable<DateTime>(finishedAt);
    }
    map['total'] = Variable<int>(total);
    map['correct'] = Variable<int>(correct);
    map['duration_sec'] = Variable<int>(durationSec);
    return map;
  }

  PracticeSessionsCompanion toCompanion(bool nullToAbsent) {
    return PracticeSessionsCompanion(
      id: Value(id),
      mode: Value(mode),
      contentType: Value(contentType),
      filterJson: Value(filterJson),
      startedAt: Value(startedAt),
      finishedAt: finishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(finishedAt),
      total: Value(total),
      correct: Value(correct),
      durationSec: Value(durationSec),
    );
  }

  factory PracticeSession.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PracticeSession(
      id: serializer.fromJson<int>(json['id']),
      mode: $PracticeSessionsTable.$convertermode
          .fromJson(serializer.fromJson<int>(json['mode'])),
      contentType: $PracticeSessionsTable.$convertercontentType
          .fromJson(serializer.fromJson<int>(json['contentType'])),
      filterJson: serializer.fromJson<String>(json['filterJson']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      finishedAt: serializer.fromJson<DateTime?>(json['finishedAt']),
      total: serializer.fromJson<int>(json['total']),
      correct: serializer.fromJson<int>(json['correct']),
      durationSec: serializer.fromJson<int>(json['durationSec']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mode': serializer
          .toJson<int>($PracticeSessionsTable.$convertermode.toJson(mode)),
      'contentType': serializer.toJson<int>(
          $PracticeSessionsTable.$convertercontentType.toJson(contentType)),
      'filterJson': serializer.toJson<String>(filterJson),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'finishedAt': serializer.toJson<DateTime?>(finishedAt),
      'total': serializer.toJson<int>(total),
      'correct': serializer.toJson<int>(correct),
      'durationSec': serializer.toJson<int>(durationSec),
    };
  }

  PracticeSession copyWith(
          {int? id,
          QuizModeDb? mode,
          ItemType? contentType,
          String? filterJson,
          DateTime? startedAt,
          Value<DateTime?> finishedAt = const Value.absent(),
          int? total,
          int? correct,
          int? durationSec}) =>
      PracticeSession(
        id: id ?? this.id,
        mode: mode ?? this.mode,
        contentType: contentType ?? this.contentType,
        filterJson: filterJson ?? this.filterJson,
        startedAt: startedAt ?? this.startedAt,
        finishedAt: finishedAt.present ? finishedAt.value : this.finishedAt,
        total: total ?? this.total,
        correct: correct ?? this.correct,
        durationSec: durationSec ?? this.durationSec,
      );
  PracticeSession copyWithCompanion(PracticeSessionsCompanion data) {
    return PracticeSession(
      id: data.id.present ? data.id.value : this.id,
      mode: data.mode.present ? data.mode.value : this.mode,
      contentType:
          data.contentType.present ? data.contentType.value : this.contentType,
      filterJson:
          data.filterJson.present ? data.filterJson.value : this.filterJson,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      finishedAt:
          data.finishedAt.present ? data.finishedAt.value : this.finishedAt,
      total: data.total.present ? data.total.value : this.total,
      correct: data.correct.present ? data.correct.value : this.correct,
      durationSec:
          data.durationSec.present ? data.durationSec.value : this.durationSec,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PracticeSession(')
          ..write('id: $id, ')
          ..write('mode: $mode, ')
          ..write('contentType: $contentType, ')
          ..write('filterJson: $filterJson, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('total: $total, ')
          ..write('correct: $correct, ')
          ..write('durationSec: $durationSec')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, mode, contentType, filterJson, startedAt,
      finishedAt, total, correct, durationSec);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PracticeSession &&
          other.id == this.id &&
          other.mode == this.mode &&
          other.contentType == this.contentType &&
          other.filterJson == this.filterJson &&
          other.startedAt == this.startedAt &&
          other.finishedAt == this.finishedAt &&
          other.total == this.total &&
          other.correct == this.correct &&
          other.durationSec == this.durationSec);
}

class PracticeSessionsCompanion extends UpdateCompanion<PracticeSession> {
  final Value<int> id;
  final Value<QuizModeDb> mode;
  final Value<ItemType> contentType;
  final Value<String> filterJson;
  final Value<DateTime> startedAt;
  final Value<DateTime?> finishedAt;
  final Value<int> total;
  final Value<int> correct;
  final Value<int> durationSec;
  const PracticeSessionsCompanion({
    this.id = const Value.absent(),
    this.mode = const Value.absent(),
    this.contentType = const Value.absent(),
    this.filterJson = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.finishedAt = const Value.absent(),
    this.total = const Value.absent(),
    this.correct = const Value.absent(),
    this.durationSec = const Value.absent(),
  });
  PracticeSessionsCompanion.insert({
    this.id = const Value.absent(),
    required QuizModeDb mode,
    required ItemType contentType,
    required String filterJson,
    required DateTime startedAt,
    this.finishedAt = const Value.absent(),
    this.total = const Value.absent(),
    this.correct = const Value.absent(),
    this.durationSec = const Value.absent(),
  })  : mode = Value(mode),
        contentType = Value(contentType),
        filterJson = Value(filterJson),
        startedAt = Value(startedAt);
  static Insertable<PracticeSession> custom({
    Expression<int>? id,
    Expression<int>? mode,
    Expression<int>? contentType,
    Expression<String>? filterJson,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? finishedAt,
    Expression<int>? total,
    Expression<int>? correct,
    Expression<int>? durationSec,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mode != null) 'mode': mode,
      if (contentType != null) 'content_type': contentType,
      if (filterJson != null) 'filter_json': filterJson,
      if (startedAt != null) 'started_at': startedAt,
      if (finishedAt != null) 'finished_at': finishedAt,
      if (total != null) 'total': total,
      if (correct != null) 'correct': correct,
      if (durationSec != null) 'duration_sec': durationSec,
    });
  }

  PracticeSessionsCompanion copyWith(
      {Value<int>? id,
      Value<QuizModeDb>? mode,
      Value<ItemType>? contentType,
      Value<String>? filterJson,
      Value<DateTime>? startedAt,
      Value<DateTime?>? finishedAt,
      Value<int>? total,
      Value<int>? correct,
      Value<int>? durationSec}) {
    return PracticeSessionsCompanion(
      id: id ?? this.id,
      mode: mode ?? this.mode,
      contentType: contentType ?? this.contentType,
      filterJson: filterJson ?? this.filterJson,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      total: total ?? this.total,
      correct: correct ?? this.correct,
      durationSec: durationSec ?? this.durationSec,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mode.present) {
      map['mode'] = Variable<int>(
          $PracticeSessionsTable.$convertermode.toSql(mode.value));
    }
    if (contentType.present) {
      map['content_type'] = Variable<int>($PracticeSessionsTable
          .$convertercontentType
          .toSql(contentType.value));
    }
    if (filterJson.present) {
      map['filter_json'] = Variable<String>(filterJson.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (finishedAt.present) {
      map['finished_at'] = Variable<DateTime>(finishedAt.value);
    }
    if (total.present) {
      map['total'] = Variable<int>(total.value);
    }
    if (correct.present) {
      map['correct'] = Variable<int>(correct.value);
    }
    if (durationSec.present) {
      map['duration_sec'] = Variable<int>(durationSec.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PracticeSessionsCompanion(')
          ..write('id: $id, ')
          ..write('mode: $mode, ')
          ..write('contentType: $contentType, ')
          ..write('filterJson: $filterJson, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('total: $total, ')
          ..write('correct: $correct, ')
          ..write('durationSec: $durationSec')
          ..write(')'))
        .toString();
  }
}

class $SessionAnswersTable extends SessionAnswers
    with TableInfo<$SessionAnswersTable, SessionAnswer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionAnswersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
      'session_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<ItemType, int> itemType =
      GeneratedColumn<int>('item_type', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<ItemType>($SessionAnswersTable.$converteritemType);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
      'item_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<Direction, int> direction =
      GeneratedColumn<int>('direction', aliasedName, false,
              type: DriftSqlType.int,
              requiredDuringInsert: false,
              defaultValue: const Constant(0))
          .withConverter<Direction>($SessionAnswersTable.$converterdirection);
  static const VerificationMeta _chosenIndexMeta =
      const VerificationMeta('chosenIndex');
  @override
  late final GeneratedColumn<int> chosenIndex = GeneratedColumn<int>(
      'chosen_index', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _isCorrectMeta =
      const VerificationMeta('isCorrect');
  @override
  late final GeneratedColumn<bool> isCorrect = GeneratedColumn<bool>(
      'is_correct', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_correct" IN (0, 1))'));
  static const VerificationMeta _timeMsMeta = const VerificationMeta('timeMs');
  @override
  late final GeneratedColumn<int> timeMs = GeneratedColumn<int>(
      'time_ms', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        sessionId,
        itemType,
        itemId,
        direction,
        chosenIndex,
        isCorrect,
        timeMs
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session_answers';
  @override
  VerificationContext validateIntegrity(Insertable<SessionAnswer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('chosen_index')) {
      context.handle(
          _chosenIndexMeta,
          chosenIndex.isAcceptableOrUnknown(
              data['chosen_index']!, _chosenIndexMeta));
    }
    if (data.containsKey('is_correct')) {
      context.handle(_isCorrectMeta,
          isCorrect.isAcceptableOrUnknown(data['is_correct']!, _isCorrectMeta));
    } else if (isInserting) {
      context.missing(_isCorrectMeta);
    }
    if (data.containsKey('time_ms')) {
      context.handle(_timeMsMeta,
          timeMs.isAcceptableOrUnknown(data['time_ms']!, _timeMsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionAnswer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionAnswer(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}session_id'])!,
      itemType: $SessionAnswersTable.$converteritemType.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}item_type'])!),
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}item_id'])!,
      direction: $SessionAnswersTable.$converterdirection.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.int, data['${effectivePrefix}direction'])!),
      chosenIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}chosen_index']),
      isCorrect: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_correct'])!,
      timeMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}time_ms'])!,
    );
  }

  @override
  $SessionAnswersTable createAlias(String alias) {
    return $SessionAnswersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ItemType, int, int> $converteritemType =
      const EnumIndexConverter<ItemType>(ItemType.values);
  static JsonTypeConverter2<Direction, int, int> $converterdirection =
      const EnumIndexConverter<Direction>(Direction.values);
}

class SessionAnswer extends DataClass implements Insertable<SessionAnswer> {
  final int id;
  final int sessionId;
  final ItemType itemType;
  final int itemId;
  final Direction direction;
  final int? chosenIndex;
  final bool isCorrect;
  final int timeMs;
  const SessionAnswer(
      {required this.id,
      required this.sessionId,
      required this.itemType,
      required this.itemId,
      required this.direction,
      this.chosenIndex,
      required this.isCorrect,
      required this.timeMs});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    {
      map['item_type'] = Variable<int>(
          $SessionAnswersTable.$converteritemType.toSql(itemType));
    }
    map['item_id'] = Variable<int>(itemId);
    {
      map['direction'] = Variable<int>(
          $SessionAnswersTable.$converterdirection.toSql(direction));
    }
    if (!nullToAbsent || chosenIndex != null) {
      map['chosen_index'] = Variable<int>(chosenIndex);
    }
    map['is_correct'] = Variable<bool>(isCorrect);
    map['time_ms'] = Variable<int>(timeMs);
    return map;
  }

  SessionAnswersCompanion toCompanion(bool nullToAbsent) {
    return SessionAnswersCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      itemType: Value(itemType),
      itemId: Value(itemId),
      direction: Value(direction),
      chosenIndex: chosenIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(chosenIndex),
      isCorrect: Value(isCorrect),
      timeMs: Value(timeMs),
    );
  }

  factory SessionAnswer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionAnswer(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      itemType: $SessionAnswersTable.$converteritemType
          .fromJson(serializer.fromJson<int>(json['itemType'])),
      itemId: serializer.fromJson<int>(json['itemId']),
      direction: $SessionAnswersTable.$converterdirection
          .fromJson(serializer.fromJson<int>(json['direction'])),
      chosenIndex: serializer.fromJson<int?>(json['chosenIndex']),
      isCorrect: serializer.fromJson<bool>(json['isCorrect']),
      timeMs: serializer.fromJson<int>(json['timeMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'itemType': serializer.toJson<int>(
          $SessionAnswersTable.$converteritemType.toJson(itemType)),
      'itemId': serializer.toJson<int>(itemId),
      'direction': serializer.toJson<int>(
          $SessionAnswersTable.$converterdirection.toJson(direction)),
      'chosenIndex': serializer.toJson<int?>(chosenIndex),
      'isCorrect': serializer.toJson<bool>(isCorrect),
      'timeMs': serializer.toJson<int>(timeMs),
    };
  }

  SessionAnswer copyWith(
          {int? id,
          int? sessionId,
          ItemType? itemType,
          int? itemId,
          Direction? direction,
          Value<int?> chosenIndex = const Value.absent(),
          bool? isCorrect,
          int? timeMs}) =>
      SessionAnswer(
        id: id ?? this.id,
        sessionId: sessionId ?? this.sessionId,
        itemType: itemType ?? this.itemType,
        itemId: itemId ?? this.itemId,
        direction: direction ?? this.direction,
        chosenIndex: chosenIndex.present ? chosenIndex.value : this.chosenIndex,
        isCorrect: isCorrect ?? this.isCorrect,
        timeMs: timeMs ?? this.timeMs,
      );
  SessionAnswer copyWithCompanion(SessionAnswersCompanion data) {
    return SessionAnswer(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      itemType: data.itemType.present ? data.itemType.value : this.itemType,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      direction: data.direction.present ? data.direction.value : this.direction,
      chosenIndex:
          data.chosenIndex.present ? data.chosenIndex.value : this.chosenIndex,
      isCorrect: data.isCorrect.present ? data.isCorrect.value : this.isCorrect,
      timeMs: data.timeMs.present ? data.timeMs.value : this.timeMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionAnswer(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('itemType: $itemType, ')
          ..write('itemId: $itemId, ')
          ..write('direction: $direction, ')
          ..write('chosenIndex: $chosenIndex, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('timeMs: $timeMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sessionId, itemType, itemId, direction,
      chosenIndex, isCorrect, timeMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionAnswer &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.itemType == this.itemType &&
          other.itemId == this.itemId &&
          other.direction == this.direction &&
          other.chosenIndex == this.chosenIndex &&
          other.isCorrect == this.isCorrect &&
          other.timeMs == this.timeMs);
}

class SessionAnswersCompanion extends UpdateCompanion<SessionAnswer> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<ItemType> itemType;
  final Value<int> itemId;
  final Value<Direction> direction;
  final Value<int?> chosenIndex;
  final Value<bool> isCorrect;
  final Value<int> timeMs;
  const SessionAnswersCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.itemType = const Value.absent(),
    this.itemId = const Value.absent(),
    this.direction = const Value.absent(),
    this.chosenIndex = const Value.absent(),
    this.isCorrect = const Value.absent(),
    this.timeMs = const Value.absent(),
  });
  SessionAnswersCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required ItemType itemType,
    required int itemId,
    this.direction = const Value.absent(),
    this.chosenIndex = const Value.absent(),
    required bool isCorrect,
    this.timeMs = const Value.absent(),
  })  : sessionId = Value(sessionId),
        itemType = Value(itemType),
        itemId = Value(itemId),
        isCorrect = Value(isCorrect);
  static Insertable<SessionAnswer> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<int>? itemType,
    Expression<int>? itemId,
    Expression<int>? direction,
    Expression<int>? chosenIndex,
    Expression<bool>? isCorrect,
    Expression<int>? timeMs,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (itemType != null) 'item_type': itemType,
      if (itemId != null) 'item_id': itemId,
      if (direction != null) 'direction': direction,
      if (chosenIndex != null) 'chosen_index': chosenIndex,
      if (isCorrect != null) 'is_correct': isCorrect,
      if (timeMs != null) 'time_ms': timeMs,
    });
  }

  SessionAnswersCompanion copyWith(
      {Value<int>? id,
      Value<int>? sessionId,
      Value<ItemType>? itemType,
      Value<int>? itemId,
      Value<Direction>? direction,
      Value<int?>? chosenIndex,
      Value<bool>? isCorrect,
      Value<int>? timeMs}) {
    return SessionAnswersCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      itemType: itemType ?? this.itemType,
      itemId: itemId ?? this.itemId,
      direction: direction ?? this.direction,
      chosenIndex: chosenIndex ?? this.chosenIndex,
      isCorrect: isCorrect ?? this.isCorrect,
      timeMs: timeMs ?? this.timeMs,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (itemType.present) {
      map['item_type'] = Variable<int>(
          $SessionAnswersTable.$converteritemType.toSql(itemType.value));
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (direction.present) {
      map['direction'] = Variable<int>(
          $SessionAnswersTable.$converterdirection.toSql(direction.value));
    }
    if (chosenIndex.present) {
      map['chosen_index'] = Variable<int>(chosenIndex.value);
    }
    if (isCorrect.present) {
      map['is_correct'] = Variable<bool>(isCorrect.value);
    }
    if (timeMs.present) {
      map['time_ms'] = Variable<int>(timeMs.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionAnswersCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('itemType: $itemType, ')
          ..write('itemId: $itemId, ')
          ..write('direction: $direction, ')
          ..write('chosenIndex: $chosenIndex, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('timeMs: $timeMs')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SourcesTable sources = $SourcesTable(this);
  late final $UnitsTable units = $UnitsTable(this);
  late final $KanjisTable kanjis = $KanjisTable(this);
  late final $KanjiReadingsTable kanjiReadings = $KanjiReadingsTable(this);
  late final $KanjiSourceItemsTable kanjiSourceItems =
      $KanjiSourceItemsTable(this);
  late final $VocabulariesTable vocabularies = $VocabulariesTable(this);
  late final $VocabSourceItemsTable vocabSourceItems =
      $VocabSourceItemsTable(this);
  late final $KanjiCompoundsTable kanjiCompounds = $KanjiCompoundsTable(this);
  late final $GrammarPointsTable grammarPoints = $GrammarPointsTable(this);
  late final $GrammarSourceItemsTable grammarSourceItems =
      $GrammarSourceItemsTable(this);
  late final $MondaiTypesTable mondaiTypes = $MondaiTypesTable(this);
  late final $QuestionGroupsTable questionGroups = $QuestionGroupsTable(this);
  late final $QuestionsTable questions = $QuestionsTable(this);
  late final $QuestionChoicesTable questionChoices =
      $QuestionChoicesTable(this);
  late final $ProgressTable progress = $ProgressTable(this);
  late final $PracticeSessionsTable practiceSessions =
      $PracticeSessionsTable(this);
  late final $SessionAnswersTable sessionAnswers = $SessionAnswersTable(this);
  late final Index idxSourcesTypeLevel = Index('idx_sources_type_level',
      'CREATE INDEX idx_sources_type_level ON sources (type, jlpt_level)');
  late final Index idxKanjiReadingsKanji = Index('idx_kanji_readings_kanji',
      'CREATE INDEX idx_kanji_readings_kanji ON kanji_readings (kanji_id)');
  late final Index idxKanjiItemsSourceUnit = Index(
      'idx_kanji_items_source_unit',
      'CREATE INDEX idx_kanji_items_source_unit ON kanji_source_items (source_id, unit_id)');
  late final Index idxKanjiItemsLevel = Index('idx_kanji_items_level',
      'CREATE INDEX idx_kanji_items_level ON kanji_source_items (jlpt_level)');
  late final Index idxVocabWord = Index(
      'idx_vocab_word', 'CREATE INDEX idx_vocab_word ON vocabularies (word)');
  late final Index idxVocabItemsSourceUnit = Index(
      'idx_vocab_items_source_unit',
      'CREATE INDEX idx_vocab_items_source_unit ON vocab_source_items (source_id, unit_id)');
  late final Index idxVocabItemsLevel = Index('idx_vocab_items_level',
      'CREATE INDEX idx_vocab_items_level ON vocab_source_items (jlpt_level)');
  late final Index idxKanjiCompoundsKanjiSource = Index(
      'idx_kanji_compounds_kanji_source',
      'CREATE INDEX idx_kanji_compounds_kanji_source ON kanji_compounds (kanji_id, source_id)');
  late final Index idxKanjiCompoundsVocab = Index('idx_kanji_compounds_vocab',
      'CREATE INDEX idx_kanji_compounds_vocab ON kanji_compounds (vocab_id)');
  late final Index idxGrammarItemsSourceUnit = Index(
      'idx_grammar_items_source_unit',
      'CREATE INDEX idx_grammar_items_source_unit ON grammar_source_items (source_id, unit_id)');
  late final Index idxQuestionsFilter = Index('idx_questions_filter',
      'CREATE INDEX idx_questions_filter ON questions (jlpt_level, subject, mondai_type_id, source_id)');
  late final Index idxQuestionsSource = Index('idx_questions_source',
      'CREATE INDEX idx_questions_source ON questions (source_id)');
  late final Index idxProgressNextReview = Index('idx_progress_next_review',
      'CREATE INDEX idx_progress_next_review ON progress (next_review)');
  late final Index idxSessionAnswersSession = Index(
      'idx_session_answers_session',
      'CREATE INDEX idx_session_answers_session ON session_answers (session_id)');
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        sources,
        units,
        kanjis,
        kanjiReadings,
        kanjiSourceItems,
        vocabularies,
        vocabSourceItems,
        kanjiCompounds,
        grammarPoints,
        grammarSourceItems,
        mondaiTypes,
        questionGroups,
        questions,
        questionChoices,
        progress,
        practiceSessions,
        sessionAnswers,
        idxSourcesTypeLevel,
        idxKanjiReadingsKanji,
        idxKanjiItemsSourceUnit,
        idxKanjiItemsLevel,
        idxVocabWord,
        idxVocabItemsSourceUnit,
        idxVocabItemsLevel,
        idxKanjiCompoundsKanjiSource,
        idxKanjiCompoundsVocab,
        idxGrammarItemsSourceUnit,
        idxQuestionsFilter,
        idxQuestionsSource,
        idxProgressNextReview,
        idxSessionAnswersSession
      ];
}

typedef $$SourcesTableCreateCompanionBuilder = SourcesCompanion Function({
  Value<int> id,
  required SourceType type,
  required String name,
  Value<String?> jlptLevel,
  Value<int?> examYear,
  Value<int?> examMonth,
  Value<int> sortOrder,
});
typedef $$SourcesTableUpdateCompanionBuilder = SourcesCompanion Function({
  Value<int> id,
  Value<SourceType> type,
  Value<String> name,
  Value<String?> jlptLevel,
  Value<int?> examYear,
  Value<int?> examMonth,
  Value<int> sortOrder,
});

class $$SourcesTableFilterComposer
    extends Composer<_$AppDatabase, $SourcesTable> {
  $$SourcesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<SourceType, SourceType, int> get type =>
      $composableBuilder(
          column: $table.type,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get jlptLevel => $composableBuilder(
      column: $table.jlptLevel, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get examYear => $composableBuilder(
      column: $table.examYear, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get examMonth => $composableBuilder(
      column: $table.examMonth, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));
}

class $$SourcesTableOrderingComposer
    extends Composer<_$AppDatabase, $SourcesTable> {
  $$SourcesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get jlptLevel => $composableBuilder(
      column: $table.jlptLevel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get examYear => $composableBuilder(
      column: $table.examYear, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get examMonth => $composableBuilder(
      column: $table.examMonth, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));
}

class $$SourcesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SourcesTable> {
  $$SourcesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SourceType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get jlptLevel =>
      $composableBuilder(column: $table.jlptLevel, builder: (column) => column);

  GeneratedColumn<int> get examYear =>
      $composableBuilder(column: $table.examYear, builder: (column) => column);

  GeneratedColumn<int> get examMonth =>
      $composableBuilder(column: $table.examMonth, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$SourcesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SourcesTable,
    Source,
    $$SourcesTableFilterComposer,
    $$SourcesTableOrderingComposer,
    $$SourcesTableAnnotationComposer,
    $$SourcesTableCreateCompanionBuilder,
    $$SourcesTableUpdateCompanionBuilder,
    (Source, BaseReferences<_$AppDatabase, $SourcesTable, Source>),
    Source,
    PrefetchHooks Function()> {
  $$SourcesTableTableManager(_$AppDatabase db, $SourcesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SourcesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SourcesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SourcesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<SourceType> type = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> jlptLevel = const Value.absent(),
            Value<int?> examYear = const Value.absent(),
            Value<int?> examMonth = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
          }) =>
              SourcesCompanion(
            id: id,
            type: type,
            name: name,
            jlptLevel: jlptLevel,
            examYear: examYear,
            examMonth: examMonth,
            sortOrder: sortOrder,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required SourceType type,
            required String name,
            Value<String?> jlptLevel = const Value.absent(),
            Value<int?> examYear = const Value.absent(),
            Value<int?> examMonth = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
          }) =>
              SourcesCompanion.insert(
            id: id,
            type: type,
            name: name,
            jlptLevel: jlptLevel,
            examYear: examYear,
            examMonth: examMonth,
            sortOrder: sortOrder,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SourcesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SourcesTable,
    Source,
    $$SourcesTableFilterComposer,
    $$SourcesTableOrderingComposer,
    $$SourcesTableAnnotationComposer,
    $$SourcesTableCreateCompanionBuilder,
    $$SourcesTableUpdateCompanionBuilder,
    (Source, BaseReferences<_$AppDatabase, $SourcesTable, Source>),
    Source,
    PrefetchHooks Function()>;
typedef $$UnitsTableCreateCompanionBuilder = UnitsCompanion Function({
  Value<int> id,
  required int sourceId,
  required String name,
  required int orderNo,
});
typedef $$UnitsTableUpdateCompanionBuilder = UnitsCompanion Function({
  Value<int> id,
  Value<int> sourceId,
  Value<String> name,
  Value<int> orderNo,
});

class $$UnitsTableFilterComposer extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sourceId => $composableBuilder(
      column: $table.sourceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get orderNo => $composableBuilder(
      column: $table.orderNo, builder: (column) => ColumnFilters(column));
}

class $$UnitsTableOrderingComposer
    extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sourceId => $composableBuilder(
      column: $table.sourceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get orderNo => $composableBuilder(
      column: $table.orderNo, builder: (column) => ColumnOrderings(column));
}

class $$UnitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get orderNo =>
      $composableBuilder(column: $table.orderNo, builder: (column) => column);
}

class $$UnitsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UnitsTable,
    Unit,
    $$UnitsTableFilterComposer,
    $$UnitsTableOrderingComposer,
    $$UnitsTableAnnotationComposer,
    $$UnitsTableCreateCompanionBuilder,
    $$UnitsTableUpdateCompanionBuilder,
    (Unit, BaseReferences<_$AppDatabase, $UnitsTable, Unit>),
    Unit,
    PrefetchHooks Function()> {
  $$UnitsTableTableManager(_$AppDatabase db, $UnitsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UnitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UnitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> sourceId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> orderNo = const Value.absent(),
          }) =>
              UnitsCompanion(
            id: id,
            sourceId: sourceId,
            name: name,
            orderNo: orderNo,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int sourceId,
            required String name,
            required int orderNo,
          }) =>
              UnitsCompanion.insert(
            id: id,
            sourceId: sourceId,
            name: name,
            orderNo: orderNo,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UnitsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UnitsTable,
    Unit,
    $$UnitsTableFilterComposer,
    $$UnitsTableOrderingComposer,
    $$UnitsTableAnnotationComposer,
    $$UnitsTableCreateCompanionBuilder,
    $$UnitsTableUpdateCompanionBuilder,
    (Unit, BaseReferences<_$AppDatabase, $UnitsTable, Unit>),
    Unit,
    PrefetchHooks Function()>;
typedef $$KanjisTableCreateCompanionBuilder = KanjisCompanion Function({
  Value<int> id,
  required String character,
  Value<String?> meaningMy,
  Value<String?> meaningEn,
  Value<int?> strokeCount,
  Value<String?> radical,
});
typedef $$KanjisTableUpdateCompanionBuilder = KanjisCompanion Function({
  Value<int> id,
  Value<String> character,
  Value<String?> meaningMy,
  Value<String?> meaningEn,
  Value<int?> strokeCount,
  Value<String?> radical,
});

class $$KanjisTableFilterComposer
    extends Composer<_$AppDatabase, $KanjisTable> {
  $$KanjisTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get character => $composableBuilder(
      column: $table.character, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get meaningMy => $composableBuilder(
      column: $table.meaningMy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get meaningEn => $composableBuilder(
      column: $table.meaningEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get strokeCount => $composableBuilder(
      column: $table.strokeCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get radical => $composableBuilder(
      column: $table.radical, builder: (column) => ColumnFilters(column));
}

class $$KanjisTableOrderingComposer
    extends Composer<_$AppDatabase, $KanjisTable> {
  $$KanjisTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get character => $composableBuilder(
      column: $table.character, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get meaningMy => $composableBuilder(
      column: $table.meaningMy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get meaningEn => $composableBuilder(
      column: $table.meaningEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get strokeCount => $composableBuilder(
      column: $table.strokeCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get radical => $composableBuilder(
      column: $table.radical, builder: (column) => ColumnOrderings(column));
}

class $$KanjisTableAnnotationComposer
    extends Composer<_$AppDatabase, $KanjisTable> {
  $$KanjisTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get character =>
      $composableBuilder(column: $table.character, builder: (column) => column);

  GeneratedColumn<String> get meaningMy =>
      $composableBuilder(column: $table.meaningMy, builder: (column) => column);

  GeneratedColumn<String> get meaningEn =>
      $composableBuilder(column: $table.meaningEn, builder: (column) => column);

  GeneratedColumn<int> get strokeCount => $composableBuilder(
      column: $table.strokeCount, builder: (column) => column);

  GeneratedColumn<String> get radical =>
      $composableBuilder(column: $table.radical, builder: (column) => column);
}

class $$KanjisTableTableManager extends RootTableManager<
    _$AppDatabase,
    $KanjisTable,
    Kanji,
    $$KanjisTableFilterComposer,
    $$KanjisTableOrderingComposer,
    $$KanjisTableAnnotationComposer,
    $$KanjisTableCreateCompanionBuilder,
    $$KanjisTableUpdateCompanionBuilder,
    (Kanji, BaseReferences<_$AppDatabase, $KanjisTable, Kanji>),
    Kanji,
    PrefetchHooks Function()> {
  $$KanjisTableTableManager(_$AppDatabase db, $KanjisTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KanjisTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KanjisTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KanjisTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> character = const Value.absent(),
            Value<String?> meaningMy = const Value.absent(),
            Value<String?> meaningEn = const Value.absent(),
            Value<int?> strokeCount = const Value.absent(),
            Value<String?> radical = const Value.absent(),
          }) =>
              KanjisCompanion(
            id: id,
            character: character,
            meaningMy: meaningMy,
            meaningEn: meaningEn,
            strokeCount: strokeCount,
            radical: radical,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String character,
            Value<String?> meaningMy = const Value.absent(),
            Value<String?> meaningEn = const Value.absent(),
            Value<int?> strokeCount = const Value.absent(),
            Value<String?> radical = const Value.absent(),
          }) =>
              KanjisCompanion.insert(
            id: id,
            character: character,
            meaningMy: meaningMy,
            meaningEn: meaningEn,
            strokeCount: strokeCount,
            radical: radical,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$KanjisTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $KanjisTable,
    Kanji,
    $$KanjisTableFilterComposer,
    $$KanjisTableOrderingComposer,
    $$KanjisTableAnnotationComposer,
    $$KanjisTableCreateCompanionBuilder,
    $$KanjisTableUpdateCompanionBuilder,
    (Kanji, BaseReferences<_$AppDatabase, $KanjisTable, Kanji>),
    Kanji,
    PrefetchHooks Function()>;
typedef $$KanjiReadingsTableCreateCompanionBuilder = KanjiReadingsCompanion
    Function({
  Value<int> id,
  required int kanjiId,
  required ReadingType type,
  required String reading,
});
typedef $$KanjiReadingsTableUpdateCompanionBuilder = KanjiReadingsCompanion
    Function({
  Value<int> id,
  Value<int> kanjiId,
  Value<ReadingType> type,
  Value<String> reading,
});

class $$KanjiReadingsTableFilterComposer
    extends Composer<_$AppDatabase, $KanjiReadingsTable> {
  $$KanjiReadingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get kanjiId => $composableBuilder(
      column: $table.kanjiId, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<ReadingType, ReadingType, int> get type =>
      $composableBuilder(
          column: $table.type,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get reading => $composableBuilder(
      column: $table.reading, builder: (column) => ColumnFilters(column));
}

class $$KanjiReadingsTableOrderingComposer
    extends Composer<_$AppDatabase, $KanjiReadingsTable> {
  $$KanjiReadingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get kanjiId => $composableBuilder(
      column: $table.kanjiId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reading => $composableBuilder(
      column: $table.reading, builder: (column) => ColumnOrderings(column));
}

class $$KanjiReadingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $KanjiReadingsTable> {
  $$KanjiReadingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get kanjiId =>
      $composableBuilder(column: $table.kanjiId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ReadingType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get reading =>
      $composableBuilder(column: $table.reading, builder: (column) => column);
}

class $$KanjiReadingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $KanjiReadingsTable,
    KanjiReading,
    $$KanjiReadingsTableFilterComposer,
    $$KanjiReadingsTableOrderingComposer,
    $$KanjiReadingsTableAnnotationComposer,
    $$KanjiReadingsTableCreateCompanionBuilder,
    $$KanjiReadingsTableUpdateCompanionBuilder,
    (
      KanjiReading,
      BaseReferences<_$AppDatabase, $KanjiReadingsTable, KanjiReading>
    ),
    KanjiReading,
    PrefetchHooks Function()> {
  $$KanjiReadingsTableTableManager(_$AppDatabase db, $KanjiReadingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KanjiReadingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KanjiReadingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KanjiReadingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> kanjiId = const Value.absent(),
            Value<ReadingType> type = const Value.absent(),
            Value<String> reading = const Value.absent(),
          }) =>
              KanjiReadingsCompanion(
            id: id,
            kanjiId: kanjiId,
            type: type,
            reading: reading,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int kanjiId,
            required ReadingType type,
            required String reading,
          }) =>
              KanjiReadingsCompanion.insert(
            id: id,
            kanjiId: kanjiId,
            type: type,
            reading: reading,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$KanjiReadingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $KanjiReadingsTable,
    KanjiReading,
    $$KanjiReadingsTableFilterComposer,
    $$KanjiReadingsTableOrderingComposer,
    $$KanjiReadingsTableAnnotationComposer,
    $$KanjiReadingsTableCreateCompanionBuilder,
    $$KanjiReadingsTableUpdateCompanionBuilder,
    (
      KanjiReading,
      BaseReferences<_$AppDatabase, $KanjiReadingsTable, KanjiReading>
    ),
    KanjiReading,
    PrefetchHooks Function()>;
typedef $$KanjiSourceItemsTableCreateCompanionBuilder
    = KanjiSourceItemsCompanion Function({
  Value<int> id,
  required int kanjiId,
  required int sourceId,
  Value<int?> unitId,
  Value<int> position,
  Value<String?> jlptLevel,
});
typedef $$KanjiSourceItemsTableUpdateCompanionBuilder
    = KanjiSourceItemsCompanion Function({
  Value<int> id,
  Value<int> kanjiId,
  Value<int> sourceId,
  Value<int?> unitId,
  Value<int> position,
  Value<String?> jlptLevel,
});

class $$KanjiSourceItemsTableFilterComposer
    extends Composer<_$AppDatabase, $KanjiSourceItemsTable> {
  $$KanjiSourceItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get kanjiId => $composableBuilder(
      column: $table.kanjiId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sourceId => $composableBuilder(
      column: $table.sourceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unitId => $composableBuilder(
      column: $table.unitId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get jlptLevel => $composableBuilder(
      column: $table.jlptLevel, builder: (column) => ColumnFilters(column));
}

class $$KanjiSourceItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $KanjiSourceItemsTable> {
  $$KanjiSourceItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get kanjiId => $composableBuilder(
      column: $table.kanjiId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sourceId => $composableBuilder(
      column: $table.sourceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unitId => $composableBuilder(
      column: $table.unitId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get jlptLevel => $composableBuilder(
      column: $table.jlptLevel, builder: (column) => ColumnOrderings(column));
}

class $$KanjiSourceItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $KanjiSourceItemsTable> {
  $$KanjiSourceItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get kanjiId =>
      $composableBuilder(column: $table.kanjiId, builder: (column) => column);

  GeneratedColumn<int> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<int> get unitId =>
      $composableBuilder(column: $table.unitId, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get jlptLevel =>
      $composableBuilder(column: $table.jlptLevel, builder: (column) => column);
}

class $$KanjiSourceItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $KanjiSourceItemsTable,
    KanjiSourceItem,
    $$KanjiSourceItemsTableFilterComposer,
    $$KanjiSourceItemsTableOrderingComposer,
    $$KanjiSourceItemsTableAnnotationComposer,
    $$KanjiSourceItemsTableCreateCompanionBuilder,
    $$KanjiSourceItemsTableUpdateCompanionBuilder,
    (
      KanjiSourceItem,
      BaseReferences<_$AppDatabase, $KanjiSourceItemsTable, KanjiSourceItem>
    ),
    KanjiSourceItem,
    PrefetchHooks Function()> {
  $$KanjiSourceItemsTableTableManager(
      _$AppDatabase db, $KanjiSourceItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KanjiSourceItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KanjiSourceItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KanjiSourceItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> kanjiId = const Value.absent(),
            Value<int> sourceId = const Value.absent(),
            Value<int?> unitId = const Value.absent(),
            Value<int> position = const Value.absent(),
            Value<String?> jlptLevel = const Value.absent(),
          }) =>
              KanjiSourceItemsCompanion(
            id: id,
            kanjiId: kanjiId,
            sourceId: sourceId,
            unitId: unitId,
            position: position,
            jlptLevel: jlptLevel,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int kanjiId,
            required int sourceId,
            Value<int?> unitId = const Value.absent(),
            Value<int> position = const Value.absent(),
            Value<String?> jlptLevel = const Value.absent(),
          }) =>
              KanjiSourceItemsCompanion.insert(
            id: id,
            kanjiId: kanjiId,
            sourceId: sourceId,
            unitId: unitId,
            position: position,
            jlptLevel: jlptLevel,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$KanjiSourceItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $KanjiSourceItemsTable,
    KanjiSourceItem,
    $$KanjiSourceItemsTableFilterComposer,
    $$KanjiSourceItemsTableOrderingComposer,
    $$KanjiSourceItemsTableAnnotationComposer,
    $$KanjiSourceItemsTableCreateCompanionBuilder,
    $$KanjiSourceItemsTableUpdateCompanionBuilder,
    (
      KanjiSourceItem,
      BaseReferences<_$AppDatabase, $KanjiSourceItemsTable, KanjiSourceItem>
    ),
    KanjiSourceItem,
    PrefetchHooks Function()>;
typedef $$VocabulariesTableCreateCompanionBuilder = VocabulariesCompanion
    Function({
  Value<int> id,
  required String word,
  required String reading,
  Value<String?> meaningMy,
  Value<String?> meaningEn,
  Value<String?> partOfSpeech,
  Value<String?> exampleJp,
  Value<String?> exampleMy,
});
typedef $$VocabulariesTableUpdateCompanionBuilder = VocabulariesCompanion
    Function({
  Value<int> id,
  Value<String> word,
  Value<String> reading,
  Value<String?> meaningMy,
  Value<String?> meaningEn,
  Value<String?> partOfSpeech,
  Value<String?> exampleJp,
  Value<String?> exampleMy,
});

class $$VocabulariesTableFilterComposer
    extends Composer<_$AppDatabase, $VocabulariesTable> {
  $$VocabulariesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get word => $composableBuilder(
      column: $table.word, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reading => $composableBuilder(
      column: $table.reading, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get meaningMy => $composableBuilder(
      column: $table.meaningMy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get meaningEn => $composableBuilder(
      column: $table.meaningEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get partOfSpeech => $composableBuilder(
      column: $table.partOfSpeech, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exampleJp => $composableBuilder(
      column: $table.exampleJp, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exampleMy => $composableBuilder(
      column: $table.exampleMy, builder: (column) => ColumnFilters(column));
}

class $$VocabulariesTableOrderingComposer
    extends Composer<_$AppDatabase, $VocabulariesTable> {
  $$VocabulariesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get word => $composableBuilder(
      column: $table.word, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reading => $composableBuilder(
      column: $table.reading, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get meaningMy => $composableBuilder(
      column: $table.meaningMy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get meaningEn => $composableBuilder(
      column: $table.meaningEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get partOfSpeech => $composableBuilder(
      column: $table.partOfSpeech,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exampleJp => $composableBuilder(
      column: $table.exampleJp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exampleMy => $composableBuilder(
      column: $table.exampleMy, builder: (column) => ColumnOrderings(column));
}

class $$VocabulariesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VocabulariesTable> {
  $$VocabulariesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get word =>
      $composableBuilder(column: $table.word, builder: (column) => column);

  GeneratedColumn<String> get reading =>
      $composableBuilder(column: $table.reading, builder: (column) => column);

  GeneratedColumn<String> get meaningMy =>
      $composableBuilder(column: $table.meaningMy, builder: (column) => column);

  GeneratedColumn<String> get meaningEn =>
      $composableBuilder(column: $table.meaningEn, builder: (column) => column);

  GeneratedColumn<String> get partOfSpeech => $composableBuilder(
      column: $table.partOfSpeech, builder: (column) => column);

  GeneratedColumn<String> get exampleJp =>
      $composableBuilder(column: $table.exampleJp, builder: (column) => column);

  GeneratedColumn<String> get exampleMy =>
      $composableBuilder(column: $table.exampleMy, builder: (column) => column);
}

class $$VocabulariesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $VocabulariesTable,
    Vocabulary,
    $$VocabulariesTableFilterComposer,
    $$VocabulariesTableOrderingComposer,
    $$VocabulariesTableAnnotationComposer,
    $$VocabulariesTableCreateCompanionBuilder,
    $$VocabulariesTableUpdateCompanionBuilder,
    (Vocabulary, BaseReferences<_$AppDatabase, $VocabulariesTable, Vocabulary>),
    Vocabulary,
    PrefetchHooks Function()> {
  $$VocabulariesTableTableManager(_$AppDatabase db, $VocabulariesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VocabulariesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VocabulariesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VocabulariesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> word = const Value.absent(),
            Value<String> reading = const Value.absent(),
            Value<String?> meaningMy = const Value.absent(),
            Value<String?> meaningEn = const Value.absent(),
            Value<String?> partOfSpeech = const Value.absent(),
            Value<String?> exampleJp = const Value.absent(),
            Value<String?> exampleMy = const Value.absent(),
          }) =>
              VocabulariesCompanion(
            id: id,
            word: word,
            reading: reading,
            meaningMy: meaningMy,
            meaningEn: meaningEn,
            partOfSpeech: partOfSpeech,
            exampleJp: exampleJp,
            exampleMy: exampleMy,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String word,
            required String reading,
            Value<String?> meaningMy = const Value.absent(),
            Value<String?> meaningEn = const Value.absent(),
            Value<String?> partOfSpeech = const Value.absent(),
            Value<String?> exampleJp = const Value.absent(),
            Value<String?> exampleMy = const Value.absent(),
          }) =>
              VocabulariesCompanion.insert(
            id: id,
            word: word,
            reading: reading,
            meaningMy: meaningMy,
            meaningEn: meaningEn,
            partOfSpeech: partOfSpeech,
            exampleJp: exampleJp,
            exampleMy: exampleMy,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$VocabulariesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $VocabulariesTable,
    Vocabulary,
    $$VocabulariesTableFilterComposer,
    $$VocabulariesTableOrderingComposer,
    $$VocabulariesTableAnnotationComposer,
    $$VocabulariesTableCreateCompanionBuilder,
    $$VocabulariesTableUpdateCompanionBuilder,
    (Vocabulary, BaseReferences<_$AppDatabase, $VocabulariesTable, Vocabulary>),
    Vocabulary,
    PrefetchHooks Function()>;
typedef $$VocabSourceItemsTableCreateCompanionBuilder
    = VocabSourceItemsCompanion Function({
  Value<int> id,
  required int vocabId,
  required int sourceId,
  Value<int?> unitId,
  Value<int> position,
  Value<String?> jlptLevel,
});
typedef $$VocabSourceItemsTableUpdateCompanionBuilder
    = VocabSourceItemsCompanion Function({
  Value<int> id,
  Value<int> vocabId,
  Value<int> sourceId,
  Value<int?> unitId,
  Value<int> position,
  Value<String?> jlptLevel,
});

class $$VocabSourceItemsTableFilterComposer
    extends Composer<_$AppDatabase, $VocabSourceItemsTable> {
  $$VocabSourceItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get vocabId => $composableBuilder(
      column: $table.vocabId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sourceId => $composableBuilder(
      column: $table.sourceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unitId => $composableBuilder(
      column: $table.unitId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get jlptLevel => $composableBuilder(
      column: $table.jlptLevel, builder: (column) => ColumnFilters(column));
}

class $$VocabSourceItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $VocabSourceItemsTable> {
  $$VocabSourceItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get vocabId => $composableBuilder(
      column: $table.vocabId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sourceId => $composableBuilder(
      column: $table.sourceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unitId => $composableBuilder(
      column: $table.unitId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get jlptLevel => $composableBuilder(
      column: $table.jlptLevel, builder: (column) => ColumnOrderings(column));
}

class $$VocabSourceItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VocabSourceItemsTable> {
  $$VocabSourceItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get vocabId =>
      $composableBuilder(column: $table.vocabId, builder: (column) => column);

  GeneratedColumn<int> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<int> get unitId =>
      $composableBuilder(column: $table.unitId, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get jlptLevel =>
      $composableBuilder(column: $table.jlptLevel, builder: (column) => column);
}

class $$VocabSourceItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $VocabSourceItemsTable,
    VocabSourceItem,
    $$VocabSourceItemsTableFilterComposer,
    $$VocabSourceItemsTableOrderingComposer,
    $$VocabSourceItemsTableAnnotationComposer,
    $$VocabSourceItemsTableCreateCompanionBuilder,
    $$VocabSourceItemsTableUpdateCompanionBuilder,
    (
      VocabSourceItem,
      BaseReferences<_$AppDatabase, $VocabSourceItemsTable, VocabSourceItem>
    ),
    VocabSourceItem,
    PrefetchHooks Function()> {
  $$VocabSourceItemsTableTableManager(
      _$AppDatabase db, $VocabSourceItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VocabSourceItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VocabSourceItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VocabSourceItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> vocabId = const Value.absent(),
            Value<int> sourceId = const Value.absent(),
            Value<int?> unitId = const Value.absent(),
            Value<int> position = const Value.absent(),
            Value<String?> jlptLevel = const Value.absent(),
          }) =>
              VocabSourceItemsCompanion(
            id: id,
            vocabId: vocabId,
            sourceId: sourceId,
            unitId: unitId,
            position: position,
            jlptLevel: jlptLevel,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int vocabId,
            required int sourceId,
            Value<int?> unitId = const Value.absent(),
            Value<int> position = const Value.absent(),
            Value<String?> jlptLevel = const Value.absent(),
          }) =>
              VocabSourceItemsCompanion.insert(
            id: id,
            vocabId: vocabId,
            sourceId: sourceId,
            unitId: unitId,
            position: position,
            jlptLevel: jlptLevel,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$VocabSourceItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $VocabSourceItemsTable,
    VocabSourceItem,
    $$VocabSourceItemsTableFilterComposer,
    $$VocabSourceItemsTableOrderingComposer,
    $$VocabSourceItemsTableAnnotationComposer,
    $$VocabSourceItemsTableCreateCompanionBuilder,
    $$VocabSourceItemsTableUpdateCompanionBuilder,
    (
      VocabSourceItem,
      BaseReferences<_$AppDatabase, $VocabSourceItemsTable, VocabSourceItem>
    ),
    VocabSourceItem,
    PrefetchHooks Function()>;
typedef $$KanjiCompoundsTableCreateCompanionBuilder = KanjiCompoundsCompanion
    Function({
  Value<int> id,
  required int kanjiId,
  required int vocabId,
  required int sourceId,
  Value<int> position,
});
typedef $$KanjiCompoundsTableUpdateCompanionBuilder = KanjiCompoundsCompanion
    Function({
  Value<int> id,
  Value<int> kanjiId,
  Value<int> vocabId,
  Value<int> sourceId,
  Value<int> position,
});

class $$KanjiCompoundsTableFilterComposer
    extends Composer<_$AppDatabase, $KanjiCompoundsTable> {
  $$KanjiCompoundsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get kanjiId => $composableBuilder(
      column: $table.kanjiId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get vocabId => $composableBuilder(
      column: $table.vocabId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sourceId => $composableBuilder(
      column: $table.sourceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnFilters(column));
}

class $$KanjiCompoundsTableOrderingComposer
    extends Composer<_$AppDatabase, $KanjiCompoundsTable> {
  $$KanjiCompoundsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get kanjiId => $composableBuilder(
      column: $table.kanjiId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get vocabId => $composableBuilder(
      column: $table.vocabId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sourceId => $composableBuilder(
      column: $table.sourceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnOrderings(column));
}

class $$KanjiCompoundsTableAnnotationComposer
    extends Composer<_$AppDatabase, $KanjiCompoundsTable> {
  $$KanjiCompoundsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get kanjiId =>
      $composableBuilder(column: $table.kanjiId, builder: (column) => column);

  GeneratedColumn<int> get vocabId =>
      $composableBuilder(column: $table.vocabId, builder: (column) => column);

  GeneratedColumn<int> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);
}

class $$KanjiCompoundsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $KanjiCompoundsTable,
    KanjiCompound,
    $$KanjiCompoundsTableFilterComposer,
    $$KanjiCompoundsTableOrderingComposer,
    $$KanjiCompoundsTableAnnotationComposer,
    $$KanjiCompoundsTableCreateCompanionBuilder,
    $$KanjiCompoundsTableUpdateCompanionBuilder,
    (
      KanjiCompound,
      BaseReferences<_$AppDatabase, $KanjiCompoundsTable, KanjiCompound>
    ),
    KanjiCompound,
    PrefetchHooks Function()> {
  $$KanjiCompoundsTableTableManager(
      _$AppDatabase db, $KanjiCompoundsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KanjiCompoundsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KanjiCompoundsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KanjiCompoundsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> kanjiId = const Value.absent(),
            Value<int> vocabId = const Value.absent(),
            Value<int> sourceId = const Value.absent(),
            Value<int> position = const Value.absent(),
          }) =>
              KanjiCompoundsCompanion(
            id: id,
            kanjiId: kanjiId,
            vocabId: vocabId,
            sourceId: sourceId,
            position: position,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int kanjiId,
            required int vocabId,
            required int sourceId,
            Value<int> position = const Value.absent(),
          }) =>
              KanjiCompoundsCompanion.insert(
            id: id,
            kanjiId: kanjiId,
            vocabId: vocabId,
            sourceId: sourceId,
            position: position,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$KanjiCompoundsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $KanjiCompoundsTable,
    KanjiCompound,
    $$KanjiCompoundsTableFilterComposer,
    $$KanjiCompoundsTableOrderingComposer,
    $$KanjiCompoundsTableAnnotationComposer,
    $$KanjiCompoundsTableCreateCompanionBuilder,
    $$KanjiCompoundsTableUpdateCompanionBuilder,
    (
      KanjiCompound,
      BaseReferences<_$AppDatabase, $KanjiCompoundsTable, KanjiCompound>
    ),
    KanjiCompound,
    PrefetchHooks Function()>;
typedef $$GrammarPointsTableCreateCompanionBuilder = GrammarPointsCompanion
    Function({
  Value<int> id,
  required String pattern,
  Value<String?> connection,
  Value<String?> meaningMy,
  Value<String?> meaningEn,
  Value<String?> exampleJp,
  Value<String?> exampleMy,
  Value<String?> note,
});
typedef $$GrammarPointsTableUpdateCompanionBuilder = GrammarPointsCompanion
    Function({
  Value<int> id,
  Value<String> pattern,
  Value<String?> connection,
  Value<String?> meaningMy,
  Value<String?> meaningEn,
  Value<String?> exampleJp,
  Value<String?> exampleMy,
  Value<String?> note,
});

class $$GrammarPointsTableFilterComposer
    extends Composer<_$AppDatabase, $GrammarPointsTable> {
  $$GrammarPointsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pattern => $composableBuilder(
      column: $table.pattern, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get connection => $composableBuilder(
      column: $table.connection, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get meaningMy => $composableBuilder(
      column: $table.meaningMy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get meaningEn => $composableBuilder(
      column: $table.meaningEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exampleJp => $composableBuilder(
      column: $table.exampleJp, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exampleMy => $composableBuilder(
      column: $table.exampleMy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));
}

class $$GrammarPointsTableOrderingComposer
    extends Composer<_$AppDatabase, $GrammarPointsTable> {
  $$GrammarPointsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pattern => $composableBuilder(
      column: $table.pattern, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get connection => $composableBuilder(
      column: $table.connection, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get meaningMy => $composableBuilder(
      column: $table.meaningMy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get meaningEn => $composableBuilder(
      column: $table.meaningEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exampleJp => $composableBuilder(
      column: $table.exampleJp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exampleMy => $composableBuilder(
      column: $table.exampleMy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));
}

class $$GrammarPointsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GrammarPointsTable> {
  $$GrammarPointsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get pattern =>
      $composableBuilder(column: $table.pattern, builder: (column) => column);

  GeneratedColumn<String> get connection => $composableBuilder(
      column: $table.connection, builder: (column) => column);

  GeneratedColumn<String> get meaningMy =>
      $composableBuilder(column: $table.meaningMy, builder: (column) => column);

  GeneratedColumn<String> get meaningEn =>
      $composableBuilder(column: $table.meaningEn, builder: (column) => column);

  GeneratedColumn<String> get exampleJp =>
      $composableBuilder(column: $table.exampleJp, builder: (column) => column);

  GeneratedColumn<String> get exampleMy =>
      $composableBuilder(column: $table.exampleMy, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$GrammarPointsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GrammarPointsTable,
    GrammarPoint,
    $$GrammarPointsTableFilterComposer,
    $$GrammarPointsTableOrderingComposer,
    $$GrammarPointsTableAnnotationComposer,
    $$GrammarPointsTableCreateCompanionBuilder,
    $$GrammarPointsTableUpdateCompanionBuilder,
    (
      GrammarPoint,
      BaseReferences<_$AppDatabase, $GrammarPointsTable, GrammarPoint>
    ),
    GrammarPoint,
    PrefetchHooks Function()> {
  $$GrammarPointsTableTableManager(_$AppDatabase db, $GrammarPointsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GrammarPointsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GrammarPointsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GrammarPointsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> pattern = const Value.absent(),
            Value<String?> connection = const Value.absent(),
            Value<String?> meaningMy = const Value.absent(),
            Value<String?> meaningEn = const Value.absent(),
            Value<String?> exampleJp = const Value.absent(),
            Value<String?> exampleMy = const Value.absent(),
            Value<String?> note = const Value.absent(),
          }) =>
              GrammarPointsCompanion(
            id: id,
            pattern: pattern,
            connection: connection,
            meaningMy: meaningMy,
            meaningEn: meaningEn,
            exampleJp: exampleJp,
            exampleMy: exampleMy,
            note: note,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String pattern,
            Value<String?> connection = const Value.absent(),
            Value<String?> meaningMy = const Value.absent(),
            Value<String?> meaningEn = const Value.absent(),
            Value<String?> exampleJp = const Value.absent(),
            Value<String?> exampleMy = const Value.absent(),
            Value<String?> note = const Value.absent(),
          }) =>
              GrammarPointsCompanion.insert(
            id: id,
            pattern: pattern,
            connection: connection,
            meaningMy: meaningMy,
            meaningEn: meaningEn,
            exampleJp: exampleJp,
            exampleMy: exampleMy,
            note: note,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GrammarPointsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GrammarPointsTable,
    GrammarPoint,
    $$GrammarPointsTableFilterComposer,
    $$GrammarPointsTableOrderingComposer,
    $$GrammarPointsTableAnnotationComposer,
    $$GrammarPointsTableCreateCompanionBuilder,
    $$GrammarPointsTableUpdateCompanionBuilder,
    (
      GrammarPoint,
      BaseReferences<_$AppDatabase, $GrammarPointsTable, GrammarPoint>
    ),
    GrammarPoint,
    PrefetchHooks Function()>;
typedef $$GrammarSourceItemsTableCreateCompanionBuilder
    = GrammarSourceItemsCompanion Function({
  Value<int> id,
  required int grammarId,
  required int sourceId,
  Value<int?> unitId,
  Value<int> position,
  Value<String?> jlptLevel,
});
typedef $$GrammarSourceItemsTableUpdateCompanionBuilder
    = GrammarSourceItemsCompanion Function({
  Value<int> id,
  Value<int> grammarId,
  Value<int> sourceId,
  Value<int?> unitId,
  Value<int> position,
  Value<String?> jlptLevel,
});

class $$GrammarSourceItemsTableFilterComposer
    extends Composer<_$AppDatabase, $GrammarSourceItemsTable> {
  $$GrammarSourceItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get grammarId => $composableBuilder(
      column: $table.grammarId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sourceId => $composableBuilder(
      column: $table.sourceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unitId => $composableBuilder(
      column: $table.unitId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get jlptLevel => $composableBuilder(
      column: $table.jlptLevel, builder: (column) => ColumnFilters(column));
}

class $$GrammarSourceItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $GrammarSourceItemsTable> {
  $$GrammarSourceItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get grammarId => $composableBuilder(
      column: $table.grammarId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sourceId => $composableBuilder(
      column: $table.sourceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unitId => $composableBuilder(
      column: $table.unitId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get jlptLevel => $composableBuilder(
      column: $table.jlptLevel, builder: (column) => ColumnOrderings(column));
}

class $$GrammarSourceItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GrammarSourceItemsTable> {
  $$GrammarSourceItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get grammarId =>
      $composableBuilder(column: $table.grammarId, builder: (column) => column);

  GeneratedColumn<int> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<int> get unitId =>
      $composableBuilder(column: $table.unitId, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get jlptLevel =>
      $composableBuilder(column: $table.jlptLevel, builder: (column) => column);
}

class $$GrammarSourceItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GrammarSourceItemsTable,
    GrammarSourceItem,
    $$GrammarSourceItemsTableFilterComposer,
    $$GrammarSourceItemsTableOrderingComposer,
    $$GrammarSourceItemsTableAnnotationComposer,
    $$GrammarSourceItemsTableCreateCompanionBuilder,
    $$GrammarSourceItemsTableUpdateCompanionBuilder,
    (
      GrammarSourceItem,
      BaseReferences<_$AppDatabase, $GrammarSourceItemsTable, GrammarSourceItem>
    ),
    GrammarSourceItem,
    PrefetchHooks Function()> {
  $$GrammarSourceItemsTableTableManager(
      _$AppDatabase db, $GrammarSourceItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GrammarSourceItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GrammarSourceItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GrammarSourceItemsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> grammarId = const Value.absent(),
            Value<int> sourceId = const Value.absent(),
            Value<int?> unitId = const Value.absent(),
            Value<int> position = const Value.absent(),
            Value<String?> jlptLevel = const Value.absent(),
          }) =>
              GrammarSourceItemsCompanion(
            id: id,
            grammarId: grammarId,
            sourceId: sourceId,
            unitId: unitId,
            position: position,
            jlptLevel: jlptLevel,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int grammarId,
            required int sourceId,
            Value<int?> unitId = const Value.absent(),
            Value<int> position = const Value.absent(),
            Value<String?> jlptLevel = const Value.absent(),
          }) =>
              GrammarSourceItemsCompanion.insert(
            id: id,
            grammarId: grammarId,
            sourceId: sourceId,
            unitId: unitId,
            position: position,
            jlptLevel: jlptLevel,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GrammarSourceItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GrammarSourceItemsTable,
    GrammarSourceItem,
    $$GrammarSourceItemsTableFilterComposer,
    $$GrammarSourceItemsTableOrderingComposer,
    $$GrammarSourceItemsTableAnnotationComposer,
    $$GrammarSourceItemsTableCreateCompanionBuilder,
    $$GrammarSourceItemsTableUpdateCompanionBuilder,
    (
      GrammarSourceItem,
      BaseReferences<_$AppDatabase, $GrammarSourceItemsTable, GrammarSourceItem>
    ),
    GrammarSourceItem,
    PrefetchHooks Function()>;
typedef $$MondaiTypesTableCreateCompanionBuilder = MondaiTypesCompanion
    Function({
  Value<int> id,
  required MondaiType type,
  required String jlptLevel,
  required Subject subject,
  required String nameJp,
  Value<String?> nameMy,
  Value<String?> instructionJp,
  Value<int> sortOrder,
});
typedef $$MondaiTypesTableUpdateCompanionBuilder = MondaiTypesCompanion
    Function({
  Value<int> id,
  Value<MondaiType> type,
  Value<String> jlptLevel,
  Value<Subject> subject,
  Value<String> nameJp,
  Value<String?> nameMy,
  Value<String?> instructionJp,
  Value<int> sortOrder,
});

class $$MondaiTypesTableFilterComposer
    extends Composer<_$AppDatabase, $MondaiTypesTable> {
  $$MondaiTypesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<MondaiType, MondaiType, int> get type =>
      $composableBuilder(
          column: $table.type,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get jlptLevel => $composableBuilder(
      column: $table.jlptLevel, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Subject, Subject, int> get subject =>
      $composableBuilder(
          column: $table.subject,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get nameJp => $composableBuilder(
      column: $table.nameJp, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameMy => $composableBuilder(
      column: $table.nameMy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get instructionJp => $composableBuilder(
      column: $table.instructionJp, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));
}

class $$MondaiTypesTableOrderingComposer
    extends Composer<_$AppDatabase, $MondaiTypesTable> {
  $$MondaiTypesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get jlptLevel => $composableBuilder(
      column: $table.jlptLevel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get subject => $composableBuilder(
      column: $table.subject, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameJp => $composableBuilder(
      column: $table.nameJp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameMy => $composableBuilder(
      column: $table.nameMy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get instructionJp => $composableBuilder(
      column: $table.instructionJp,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));
}

class $$MondaiTypesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MondaiTypesTable> {
  $$MondaiTypesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MondaiType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get jlptLevel =>
      $composableBuilder(column: $table.jlptLevel, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Subject, int> get subject =>
      $composableBuilder(column: $table.subject, builder: (column) => column);

  GeneratedColumn<String> get nameJp =>
      $composableBuilder(column: $table.nameJp, builder: (column) => column);

  GeneratedColumn<String> get nameMy =>
      $composableBuilder(column: $table.nameMy, builder: (column) => column);

  GeneratedColumn<String> get instructionJp => $composableBuilder(
      column: $table.instructionJp, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$MondaiTypesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MondaiTypesTable,
    MondaiTypeData,
    $$MondaiTypesTableFilterComposer,
    $$MondaiTypesTableOrderingComposer,
    $$MondaiTypesTableAnnotationComposer,
    $$MondaiTypesTableCreateCompanionBuilder,
    $$MondaiTypesTableUpdateCompanionBuilder,
    (
      MondaiTypeData,
      BaseReferences<_$AppDatabase, $MondaiTypesTable, MondaiTypeData>
    ),
    MondaiTypeData,
    PrefetchHooks Function()> {
  $$MondaiTypesTableTableManager(_$AppDatabase db, $MondaiTypesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MondaiTypesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MondaiTypesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MondaiTypesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<MondaiType> type = const Value.absent(),
            Value<String> jlptLevel = const Value.absent(),
            Value<Subject> subject = const Value.absent(),
            Value<String> nameJp = const Value.absent(),
            Value<String?> nameMy = const Value.absent(),
            Value<String?> instructionJp = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
          }) =>
              MondaiTypesCompanion(
            id: id,
            type: type,
            jlptLevel: jlptLevel,
            subject: subject,
            nameJp: nameJp,
            nameMy: nameMy,
            instructionJp: instructionJp,
            sortOrder: sortOrder,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required MondaiType type,
            required String jlptLevel,
            required Subject subject,
            required String nameJp,
            Value<String?> nameMy = const Value.absent(),
            Value<String?> instructionJp = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
          }) =>
              MondaiTypesCompanion.insert(
            id: id,
            type: type,
            jlptLevel: jlptLevel,
            subject: subject,
            nameJp: nameJp,
            nameMy: nameMy,
            instructionJp: instructionJp,
            sortOrder: sortOrder,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MondaiTypesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MondaiTypesTable,
    MondaiTypeData,
    $$MondaiTypesTableFilterComposer,
    $$MondaiTypesTableOrderingComposer,
    $$MondaiTypesTableAnnotationComposer,
    $$MondaiTypesTableCreateCompanionBuilder,
    $$MondaiTypesTableUpdateCompanionBuilder,
    (
      MondaiTypeData,
      BaseReferences<_$AppDatabase, $MondaiTypesTable, MondaiTypeData>
    ),
    MondaiTypeData,
    PrefetchHooks Function()>;
typedef $$QuestionGroupsTableCreateCompanionBuilder = QuestionGroupsCompanion
    Function({
  Value<int> id,
  required int sourceId,
  required int mondaiTypeId,
  Value<int?> mondaiNo,
  Value<String?> passage,
  Value<String?> audioPath,
  Value<String?> instructionOverride,
});
typedef $$QuestionGroupsTableUpdateCompanionBuilder = QuestionGroupsCompanion
    Function({
  Value<int> id,
  Value<int> sourceId,
  Value<int> mondaiTypeId,
  Value<int?> mondaiNo,
  Value<String?> passage,
  Value<String?> audioPath,
  Value<String?> instructionOverride,
});

class $$QuestionGroupsTableFilterComposer
    extends Composer<_$AppDatabase, $QuestionGroupsTable> {
  $$QuestionGroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sourceId => $composableBuilder(
      column: $table.sourceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get mondaiTypeId => $composableBuilder(
      column: $table.mondaiTypeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get mondaiNo => $composableBuilder(
      column: $table.mondaiNo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get passage => $composableBuilder(
      column: $table.passage, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get audioPath => $composableBuilder(
      column: $table.audioPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get instructionOverride => $composableBuilder(
      column: $table.instructionOverride,
      builder: (column) => ColumnFilters(column));
}

class $$QuestionGroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestionGroupsTable> {
  $$QuestionGroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sourceId => $composableBuilder(
      column: $table.sourceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get mondaiTypeId => $composableBuilder(
      column: $table.mondaiTypeId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get mondaiNo => $composableBuilder(
      column: $table.mondaiNo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get passage => $composableBuilder(
      column: $table.passage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get audioPath => $composableBuilder(
      column: $table.audioPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get instructionOverride => $composableBuilder(
      column: $table.instructionOverride,
      builder: (column) => ColumnOrderings(column));
}

class $$QuestionGroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestionGroupsTable> {
  $$QuestionGroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<int> get mondaiTypeId => $composableBuilder(
      column: $table.mondaiTypeId, builder: (column) => column);

  GeneratedColumn<int> get mondaiNo =>
      $composableBuilder(column: $table.mondaiNo, builder: (column) => column);

  GeneratedColumn<String> get passage =>
      $composableBuilder(column: $table.passage, builder: (column) => column);

  GeneratedColumn<String> get audioPath =>
      $composableBuilder(column: $table.audioPath, builder: (column) => column);

  GeneratedColumn<String> get instructionOverride => $composableBuilder(
      column: $table.instructionOverride, builder: (column) => column);
}

class $$QuestionGroupsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $QuestionGroupsTable,
    QuestionGroup,
    $$QuestionGroupsTableFilterComposer,
    $$QuestionGroupsTableOrderingComposer,
    $$QuestionGroupsTableAnnotationComposer,
    $$QuestionGroupsTableCreateCompanionBuilder,
    $$QuestionGroupsTableUpdateCompanionBuilder,
    (
      QuestionGroup,
      BaseReferences<_$AppDatabase, $QuestionGroupsTable, QuestionGroup>
    ),
    QuestionGroup,
    PrefetchHooks Function()> {
  $$QuestionGroupsTableTableManager(
      _$AppDatabase db, $QuestionGroupsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestionGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestionGroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestionGroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> sourceId = const Value.absent(),
            Value<int> mondaiTypeId = const Value.absent(),
            Value<int?> mondaiNo = const Value.absent(),
            Value<String?> passage = const Value.absent(),
            Value<String?> audioPath = const Value.absent(),
            Value<String?> instructionOverride = const Value.absent(),
          }) =>
              QuestionGroupsCompanion(
            id: id,
            sourceId: sourceId,
            mondaiTypeId: mondaiTypeId,
            mondaiNo: mondaiNo,
            passage: passage,
            audioPath: audioPath,
            instructionOverride: instructionOverride,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int sourceId,
            required int mondaiTypeId,
            Value<int?> mondaiNo = const Value.absent(),
            Value<String?> passage = const Value.absent(),
            Value<String?> audioPath = const Value.absent(),
            Value<String?> instructionOverride = const Value.absent(),
          }) =>
              QuestionGroupsCompanion.insert(
            id: id,
            sourceId: sourceId,
            mondaiTypeId: mondaiTypeId,
            mondaiNo: mondaiNo,
            passage: passage,
            audioPath: audioPath,
            instructionOverride: instructionOverride,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$QuestionGroupsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $QuestionGroupsTable,
    QuestionGroup,
    $$QuestionGroupsTableFilterComposer,
    $$QuestionGroupsTableOrderingComposer,
    $$QuestionGroupsTableAnnotationComposer,
    $$QuestionGroupsTableCreateCompanionBuilder,
    $$QuestionGroupsTableUpdateCompanionBuilder,
    (
      QuestionGroup,
      BaseReferences<_$AppDatabase, $QuestionGroupsTable, QuestionGroup>
    ),
    QuestionGroup,
    PrefetchHooks Function()>;
typedef $$QuestionsTableCreateCompanionBuilder = QuestionsCompanion Function({
  Value<int> id,
  required int sourceId,
  required String jlptLevel,
  required Subject subject,
  required int mondaiTypeId,
  Value<int?> groupId,
  Value<int?> mondaiNo,
  Value<int?> questionNo,
  required String questionText,
  Value<String?> targetWord,
  Value<String?> audioPath,
  Value<int?> starPosition,
  Value<String?> correctOrder,
  Value<String?> explanation,
});
typedef $$QuestionsTableUpdateCompanionBuilder = QuestionsCompanion Function({
  Value<int> id,
  Value<int> sourceId,
  Value<String> jlptLevel,
  Value<Subject> subject,
  Value<int> mondaiTypeId,
  Value<int?> groupId,
  Value<int?> mondaiNo,
  Value<int?> questionNo,
  Value<String> questionText,
  Value<String?> targetWord,
  Value<String?> audioPath,
  Value<int?> starPosition,
  Value<String?> correctOrder,
  Value<String?> explanation,
});

class $$QuestionsTableFilterComposer
    extends Composer<_$AppDatabase, $QuestionsTable> {
  $$QuestionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sourceId => $composableBuilder(
      column: $table.sourceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get jlptLevel => $composableBuilder(
      column: $table.jlptLevel, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Subject, Subject, int> get subject =>
      $composableBuilder(
          column: $table.subject,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get mondaiTypeId => $composableBuilder(
      column: $table.mondaiTypeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get groupId => $composableBuilder(
      column: $table.groupId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get mondaiNo => $composableBuilder(
      column: $table.mondaiNo, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get questionNo => $composableBuilder(
      column: $table.questionNo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get questionText => $composableBuilder(
      column: $table.questionText, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get targetWord => $composableBuilder(
      column: $table.targetWord, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get audioPath => $composableBuilder(
      column: $table.audioPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get starPosition => $composableBuilder(
      column: $table.starPosition, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get correctOrder => $composableBuilder(
      column: $table.correctOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get explanation => $composableBuilder(
      column: $table.explanation, builder: (column) => ColumnFilters(column));
}

class $$QuestionsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestionsTable> {
  $$QuestionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sourceId => $composableBuilder(
      column: $table.sourceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get jlptLevel => $composableBuilder(
      column: $table.jlptLevel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get subject => $composableBuilder(
      column: $table.subject, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get mondaiTypeId => $composableBuilder(
      column: $table.mondaiTypeId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get groupId => $composableBuilder(
      column: $table.groupId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get mondaiNo => $composableBuilder(
      column: $table.mondaiNo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get questionNo => $composableBuilder(
      column: $table.questionNo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get questionText => $composableBuilder(
      column: $table.questionText,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get targetWord => $composableBuilder(
      column: $table.targetWord, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get audioPath => $composableBuilder(
      column: $table.audioPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get starPosition => $composableBuilder(
      column: $table.starPosition,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get correctOrder => $composableBuilder(
      column: $table.correctOrder,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get explanation => $composableBuilder(
      column: $table.explanation, builder: (column) => ColumnOrderings(column));
}

class $$QuestionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestionsTable> {
  $$QuestionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<String> get jlptLevel =>
      $composableBuilder(column: $table.jlptLevel, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Subject, int> get subject =>
      $composableBuilder(column: $table.subject, builder: (column) => column);

  GeneratedColumn<int> get mondaiTypeId => $composableBuilder(
      column: $table.mondaiTypeId, builder: (column) => column);

  GeneratedColumn<int> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<int> get mondaiNo =>
      $composableBuilder(column: $table.mondaiNo, builder: (column) => column);

  GeneratedColumn<int> get questionNo => $composableBuilder(
      column: $table.questionNo, builder: (column) => column);

  GeneratedColumn<String> get questionText => $composableBuilder(
      column: $table.questionText, builder: (column) => column);

  GeneratedColumn<String> get targetWord => $composableBuilder(
      column: $table.targetWord, builder: (column) => column);

  GeneratedColumn<String> get audioPath =>
      $composableBuilder(column: $table.audioPath, builder: (column) => column);

  GeneratedColumn<int> get starPosition => $composableBuilder(
      column: $table.starPosition, builder: (column) => column);

  GeneratedColumn<String> get correctOrder => $composableBuilder(
      column: $table.correctOrder, builder: (column) => column);

  GeneratedColumn<String> get explanation => $composableBuilder(
      column: $table.explanation, builder: (column) => column);
}

class $$QuestionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $QuestionsTable,
    Question,
    $$QuestionsTableFilterComposer,
    $$QuestionsTableOrderingComposer,
    $$QuestionsTableAnnotationComposer,
    $$QuestionsTableCreateCompanionBuilder,
    $$QuestionsTableUpdateCompanionBuilder,
    (Question, BaseReferences<_$AppDatabase, $QuestionsTable, Question>),
    Question,
    PrefetchHooks Function()> {
  $$QuestionsTableTableManager(_$AppDatabase db, $QuestionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> sourceId = const Value.absent(),
            Value<String> jlptLevel = const Value.absent(),
            Value<Subject> subject = const Value.absent(),
            Value<int> mondaiTypeId = const Value.absent(),
            Value<int?> groupId = const Value.absent(),
            Value<int?> mondaiNo = const Value.absent(),
            Value<int?> questionNo = const Value.absent(),
            Value<String> questionText = const Value.absent(),
            Value<String?> targetWord = const Value.absent(),
            Value<String?> audioPath = const Value.absent(),
            Value<int?> starPosition = const Value.absent(),
            Value<String?> correctOrder = const Value.absent(),
            Value<String?> explanation = const Value.absent(),
          }) =>
              QuestionsCompanion(
            id: id,
            sourceId: sourceId,
            jlptLevel: jlptLevel,
            subject: subject,
            mondaiTypeId: mondaiTypeId,
            groupId: groupId,
            mondaiNo: mondaiNo,
            questionNo: questionNo,
            questionText: questionText,
            targetWord: targetWord,
            audioPath: audioPath,
            starPosition: starPosition,
            correctOrder: correctOrder,
            explanation: explanation,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int sourceId,
            required String jlptLevel,
            required Subject subject,
            required int mondaiTypeId,
            Value<int?> groupId = const Value.absent(),
            Value<int?> mondaiNo = const Value.absent(),
            Value<int?> questionNo = const Value.absent(),
            required String questionText,
            Value<String?> targetWord = const Value.absent(),
            Value<String?> audioPath = const Value.absent(),
            Value<int?> starPosition = const Value.absent(),
            Value<String?> correctOrder = const Value.absent(),
            Value<String?> explanation = const Value.absent(),
          }) =>
              QuestionsCompanion.insert(
            id: id,
            sourceId: sourceId,
            jlptLevel: jlptLevel,
            subject: subject,
            mondaiTypeId: mondaiTypeId,
            groupId: groupId,
            mondaiNo: mondaiNo,
            questionNo: questionNo,
            questionText: questionText,
            targetWord: targetWord,
            audioPath: audioPath,
            starPosition: starPosition,
            correctOrder: correctOrder,
            explanation: explanation,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$QuestionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $QuestionsTable,
    Question,
    $$QuestionsTableFilterComposer,
    $$QuestionsTableOrderingComposer,
    $$QuestionsTableAnnotationComposer,
    $$QuestionsTableCreateCompanionBuilder,
    $$QuestionsTableUpdateCompanionBuilder,
    (Question, BaseReferences<_$AppDatabase, $QuestionsTable, Question>),
    Question,
    PrefetchHooks Function()>;
typedef $$QuestionChoicesTableCreateCompanionBuilder = QuestionChoicesCompanion
    Function({
  Value<int> id,
  required int questionId,
  required int position,
  required String choiceText,
  Value<bool> isCorrect,
});
typedef $$QuestionChoicesTableUpdateCompanionBuilder = QuestionChoicesCompanion
    Function({
  Value<int> id,
  Value<int> questionId,
  Value<int> position,
  Value<String> choiceText,
  Value<bool> isCorrect,
});

class $$QuestionChoicesTableFilterComposer
    extends Composer<_$AppDatabase, $QuestionChoicesTable> {
  $$QuestionChoicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get questionId => $composableBuilder(
      column: $table.questionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get choiceText => $composableBuilder(
      column: $table.choiceText, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCorrect => $composableBuilder(
      column: $table.isCorrect, builder: (column) => ColumnFilters(column));
}

class $$QuestionChoicesTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestionChoicesTable> {
  $$QuestionChoicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get questionId => $composableBuilder(
      column: $table.questionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get choiceText => $composableBuilder(
      column: $table.choiceText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCorrect => $composableBuilder(
      column: $table.isCorrect, builder: (column) => ColumnOrderings(column));
}

class $$QuestionChoicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestionChoicesTable> {
  $$QuestionChoicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get questionId => $composableBuilder(
      column: $table.questionId, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get choiceText => $composableBuilder(
      column: $table.choiceText, builder: (column) => column);

  GeneratedColumn<bool> get isCorrect =>
      $composableBuilder(column: $table.isCorrect, builder: (column) => column);
}

class $$QuestionChoicesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $QuestionChoicesTable,
    QuestionChoice,
    $$QuestionChoicesTableFilterComposer,
    $$QuestionChoicesTableOrderingComposer,
    $$QuestionChoicesTableAnnotationComposer,
    $$QuestionChoicesTableCreateCompanionBuilder,
    $$QuestionChoicesTableUpdateCompanionBuilder,
    (
      QuestionChoice,
      BaseReferences<_$AppDatabase, $QuestionChoicesTable, QuestionChoice>
    ),
    QuestionChoice,
    PrefetchHooks Function()> {
  $$QuestionChoicesTableTableManager(
      _$AppDatabase db, $QuestionChoicesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestionChoicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestionChoicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestionChoicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> questionId = const Value.absent(),
            Value<int> position = const Value.absent(),
            Value<String> choiceText = const Value.absent(),
            Value<bool> isCorrect = const Value.absent(),
          }) =>
              QuestionChoicesCompanion(
            id: id,
            questionId: questionId,
            position: position,
            choiceText: choiceText,
            isCorrect: isCorrect,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int questionId,
            required int position,
            required String choiceText,
            Value<bool> isCorrect = const Value.absent(),
          }) =>
              QuestionChoicesCompanion.insert(
            id: id,
            questionId: questionId,
            position: position,
            choiceText: choiceText,
            isCorrect: isCorrect,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$QuestionChoicesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $QuestionChoicesTable,
    QuestionChoice,
    $$QuestionChoicesTableFilterComposer,
    $$QuestionChoicesTableOrderingComposer,
    $$QuestionChoicesTableAnnotationComposer,
    $$QuestionChoicesTableCreateCompanionBuilder,
    $$QuestionChoicesTableUpdateCompanionBuilder,
    (
      QuestionChoice,
      BaseReferences<_$AppDatabase, $QuestionChoicesTable, QuestionChoice>
    ),
    QuestionChoice,
    PrefetchHooks Function()>;
typedef $$ProgressTableCreateCompanionBuilder = ProgressCompanion Function({
  Value<int> id,
  required ItemType itemType,
  required int itemId,
  Value<Direction> direction,
  Value<int> correctCount,
  Value<int> wrongCount,
  Value<int> streak,
  Value<double> easeFactor,
  Value<int> intervalDays,
  Value<DateTime?> lastReviewed,
  Value<DateTime?> nextReview,
  Value<bool> isBookmarked,
});
typedef $$ProgressTableUpdateCompanionBuilder = ProgressCompanion Function({
  Value<int> id,
  Value<ItemType> itemType,
  Value<int> itemId,
  Value<Direction> direction,
  Value<int> correctCount,
  Value<int> wrongCount,
  Value<int> streak,
  Value<double> easeFactor,
  Value<int> intervalDays,
  Value<DateTime?> lastReviewed,
  Value<DateTime?> nextReview,
  Value<bool> isBookmarked,
});

class $$ProgressTableFilterComposer
    extends Composer<_$AppDatabase, $ProgressTable> {
  $$ProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<ItemType, ItemType, int> get itemType =>
      $composableBuilder(
          column: $table.itemType,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Direction, Direction, int> get direction =>
      $composableBuilder(
          column: $table.direction,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get correctCount => $composableBuilder(
      column: $table.correctCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get wrongCount => $composableBuilder(
      column: $table.wrongCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get streak => $composableBuilder(
      column: $table.streak, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get easeFactor => $composableBuilder(
      column: $table.easeFactor, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get intervalDays => $composableBuilder(
      column: $table.intervalDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastReviewed => $composableBuilder(
      column: $table.lastReviewed, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get nextReview => $composableBuilder(
      column: $table.nextReview, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isBookmarked => $composableBuilder(
      column: $table.isBookmarked, builder: (column) => ColumnFilters(column));
}

class $$ProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $ProgressTable> {
  $$ProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get itemType => $composableBuilder(
      column: $table.itemType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get direction => $composableBuilder(
      column: $table.direction, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get correctCount => $composableBuilder(
      column: $table.correctCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get wrongCount => $composableBuilder(
      column: $table.wrongCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get streak => $composableBuilder(
      column: $table.streak, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get easeFactor => $composableBuilder(
      column: $table.easeFactor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get intervalDays => $composableBuilder(
      column: $table.intervalDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastReviewed => $composableBuilder(
      column: $table.lastReviewed,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get nextReview => $composableBuilder(
      column: $table.nextReview, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isBookmarked => $composableBuilder(
      column: $table.isBookmarked,
      builder: (column) => ColumnOrderings(column));
}

class $$ProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProgressTable> {
  $$ProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ItemType, int> get itemType =>
      $composableBuilder(column: $table.itemType, builder: (column) => column);

  GeneratedColumn<int> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Direction, int> get direction =>
      $composableBuilder(column: $table.direction, builder: (column) => column);

  GeneratedColumn<int> get correctCount => $composableBuilder(
      column: $table.correctCount, builder: (column) => column);

  GeneratedColumn<int> get wrongCount => $composableBuilder(
      column: $table.wrongCount, builder: (column) => column);

  GeneratedColumn<int> get streak =>
      $composableBuilder(column: $table.streak, builder: (column) => column);

  GeneratedColumn<double> get easeFactor => $composableBuilder(
      column: $table.easeFactor, builder: (column) => column);

  GeneratedColumn<int> get intervalDays => $composableBuilder(
      column: $table.intervalDays, builder: (column) => column);

  GeneratedColumn<DateTime> get lastReviewed => $composableBuilder(
      column: $table.lastReviewed, builder: (column) => column);

  GeneratedColumn<DateTime> get nextReview => $composableBuilder(
      column: $table.nextReview, builder: (column) => column);

  GeneratedColumn<bool> get isBookmarked => $composableBuilder(
      column: $table.isBookmarked, builder: (column) => column);
}

class $$ProgressTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProgressTable,
    ProgressData,
    $$ProgressTableFilterComposer,
    $$ProgressTableOrderingComposer,
    $$ProgressTableAnnotationComposer,
    $$ProgressTableCreateCompanionBuilder,
    $$ProgressTableUpdateCompanionBuilder,
    (ProgressData, BaseReferences<_$AppDatabase, $ProgressTable, ProgressData>),
    ProgressData,
    PrefetchHooks Function()> {
  $$ProgressTableTableManager(_$AppDatabase db, $ProgressTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<ItemType> itemType = const Value.absent(),
            Value<int> itemId = const Value.absent(),
            Value<Direction> direction = const Value.absent(),
            Value<int> correctCount = const Value.absent(),
            Value<int> wrongCount = const Value.absent(),
            Value<int> streak = const Value.absent(),
            Value<double> easeFactor = const Value.absent(),
            Value<int> intervalDays = const Value.absent(),
            Value<DateTime?> lastReviewed = const Value.absent(),
            Value<DateTime?> nextReview = const Value.absent(),
            Value<bool> isBookmarked = const Value.absent(),
          }) =>
              ProgressCompanion(
            id: id,
            itemType: itemType,
            itemId: itemId,
            direction: direction,
            correctCount: correctCount,
            wrongCount: wrongCount,
            streak: streak,
            easeFactor: easeFactor,
            intervalDays: intervalDays,
            lastReviewed: lastReviewed,
            nextReview: nextReview,
            isBookmarked: isBookmarked,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required ItemType itemType,
            required int itemId,
            Value<Direction> direction = const Value.absent(),
            Value<int> correctCount = const Value.absent(),
            Value<int> wrongCount = const Value.absent(),
            Value<int> streak = const Value.absent(),
            Value<double> easeFactor = const Value.absent(),
            Value<int> intervalDays = const Value.absent(),
            Value<DateTime?> lastReviewed = const Value.absent(),
            Value<DateTime?> nextReview = const Value.absent(),
            Value<bool> isBookmarked = const Value.absent(),
          }) =>
              ProgressCompanion.insert(
            id: id,
            itemType: itemType,
            itemId: itemId,
            direction: direction,
            correctCount: correctCount,
            wrongCount: wrongCount,
            streak: streak,
            easeFactor: easeFactor,
            intervalDays: intervalDays,
            lastReviewed: lastReviewed,
            nextReview: nextReview,
            isBookmarked: isBookmarked,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProgressTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProgressTable,
    ProgressData,
    $$ProgressTableFilterComposer,
    $$ProgressTableOrderingComposer,
    $$ProgressTableAnnotationComposer,
    $$ProgressTableCreateCompanionBuilder,
    $$ProgressTableUpdateCompanionBuilder,
    (ProgressData, BaseReferences<_$AppDatabase, $ProgressTable, ProgressData>),
    ProgressData,
    PrefetchHooks Function()>;
typedef $$PracticeSessionsTableCreateCompanionBuilder
    = PracticeSessionsCompanion Function({
  Value<int> id,
  required QuizModeDb mode,
  required ItemType contentType,
  required String filterJson,
  required DateTime startedAt,
  Value<DateTime?> finishedAt,
  Value<int> total,
  Value<int> correct,
  Value<int> durationSec,
});
typedef $$PracticeSessionsTableUpdateCompanionBuilder
    = PracticeSessionsCompanion Function({
  Value<int> id,
  Value<QuizModeDb> mode,
  Value<ItemType> contentType,
  Value<String> filterJson,
  Value<DateTime> startedAt,
  Value<DateTime?> finishedAt,
  Value<int> total,
  Value<int> correct,
  Value<int> durationSec,
});

class $$PracticeSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $PracticeSessionsTable> {
  $$PracticeSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<QuizModeDb, QuizModeDb, int> get mode =>
      $composableBuilder(
          column: $table.mode,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<ItemType, ItemType, int> get contentType =>
      $composableBuilder(
          column: $table.contentType,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get filterJson => $composableBuilder(
      column: $table.filterJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get finishedAt => $composableBuilder(
      column: $table.finishedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get correct => $composableBuilder(
      column: $table.correct, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationSec => $composableBuilder(
      column: $table.durationSec, builder: (column) => ColumnFilters(column));
}

class $$PracticeSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $PracticeSessionsTable> {
  $$PracticeSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get mode => $composableBuilder(
      column: $table.mode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get contentType => $composableBuilder(
      column: $table.contentType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get filterJson => $composableBuilder(
      column: $table.filterJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get finishedAt => $composableBuilder(
      column: $table.finishedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get correct => $composableBuilder(
      column: $table.correct, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationSec => $composableBuilder(
      column: $table.durationSec, builder: (column) => ColumnOrderings(column));
}

class $$PracticeSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PracticeSessionsTable> {
  $$PracticeSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<QuizModeDb, int> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ItemType, int> get contentType =>
      $composableBuilder(
          column: $table.contentType, builder: (column) => column);

  GeneratedColumn<String> get filterJson => $composableBuilder(
      column: $table.filterJson, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get finishedAt => $composableBuilder(
      column: $table.finishedAt, builder: (column) => column);

  GeneratedColumn<int> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<int> get correct =>
      $composableBuilder(column: $table.correct, builder: (column) => column);

  GeneratedColumn<int> get durationSec => $composableBuilder(
      column: $table.durationSec, builder: (column) => column);
}

class $$PracticeSessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PracticeSessionsTable,
    PracticeSession,
    $$PracticeSessionsTableFilterComposer,
    $$PracticeSessionsTableOrderingComposer,
    $$PracticeSessionsTableAnnotationComposer,
    $$PracticeSessionsTableCreateCompanionBuilder,
    $$PracticeSessionsTableUpdateCompanionBuilder,
    (
      PracticeSession,
      BaseReferences<_$AppDatabase, $PracticeSessionsTable, PracticeSession>
    ),
    PracticeSession,
    PrefetchHooks Function()> {
  $$PracticeSessionsTableTableManager(
      _$AppDatabase db, $PracticeSessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PracticeSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PracticeSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PracticeSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<QuizModeDb> mode = const Value.absent(),
            Value<ItemType> contentType = const Value.absent(),
            Value<String> filterJson = const Value.absent(),
            Value<DateTime> startedAt = const Value.absent(),
            Value<DateTime?> finishedAt = const Value.absent(),
            Value<int> total = const Value.absent(),
            Value<int> correct = const Value.absent(),
            Value<int> durationSec = const Value.absent(),
          }) =>
              PracticeSessionsCompanion(
            id: id,
            mode: mode,
            contentType: contentType,
            filterJson: filterJson,
            startedAt: startedAt,
            finishedAt: finishedAt,
            total: total,
            correct: correct,
            durationSec: durationSec,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required QuizModeDb mode,
            required ItemType contentType,
            required String filterJson,
            required DateTime startedAt,
            Value<DateTime?> finishedAt = const Value.absent(),
            Value<int> total = const Value.absent(),
            Value<int> correct = const Value.absent(),
            Value<int> durationSec = const Value.absent(),
          }) =>
              PracticeSessionsCompanion.insert(
            id: id,
            mode: mode,
            contentType: contentType,
            filterJson: filterJson,
            startedAt: startedAt,
            finishedAt: finishedAt,
            total: total,
            correct: correct,
            durationSec: durationSec,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PracticeSessionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PracticeSessionsTable,
    PracticeSession,
    $$PracticeSessionsTableFilterComposer,
    $$PracticeSessionsTableOrderingComposer,
    $$PracticeSessionsTableAnnotationComposer,
    $$PracticeSessionsTableCreateCompanionBuilder,
    $$PracticeSessionsTableUpdateCompanionBuilder,
    (
      PracticeSession,
      BaseReferences<_$AppDatabase, $PracticeSessionsTable, PracticeSession>
    ),
    PracticeSession,
    PrefetchHooks Function()>;
typedef $$SessionAnswersTableCreateCompanionBuilder = SessionAnswersCompanion
    Function({
  Value<int> id,
  required int sessionId,
  required ItemType itemType,
  required int itemId,
  Value<Direction> direction,
  Value<int?> chosenIndex,
  required bool isCorrect,
  Value<int> timeMs,
});
typedef $$SessionAnswersTableUpdateCompanionBuilder = SessionAnswersCompanion
    Function({
  Value<int> id,
  Value<int> sessionId,
  Value<ItemType> itemType,
  Value<int> itemId,
  Value<Direction> direction,
  Value<int?> chosenIndex,
  Value<bool> isCorrect,
  Value<int> timeMs,
});

class $$SessionAnswersTableFilterComposer
    extends Composer<_$AppDatabase, $SessionAnswersTable> {
  $$SessionAnswersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<ItemType, ItemType, int> get itemType =>
      $composableBuilder(
          column: $table.itemType,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Direction, Direction, int> get direction =>
      $composableBuilder(
          column: $table.direction,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get chosenIndex => $composableBuilder(
      column: $table.chosenIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCorrect => $composableBuilder(
      column: $table.isCorrect, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get timeMs => $composableBuilder(
      column: $table.timeMs, builder: (column) => ColumnFilters(column));
}

class $$SessionAnswersTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionAnswersTable> {
  $$SessionAnswersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get itemType => $composableBuilder(
      column: $table.itemType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get direction => $composableBuilder(
      column: $table.direction, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get chosenIndex => $composableBuilder(
      column: $table.chosenIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCorrect => $composableBuilder(
      column: $table.isCorrect, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get timeMs => $composableBuilder(
      column: $table.timeMs, builder: (column) => ColumnOrderings(column));
}

class $$SessionAnswersTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionAnswersTable> {
  $$SessionAnswersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ItemType, int> get itemType =>
      $composableBuilder(column: $table.itemType, builder: (column) => column);

  GeneratedColumn<int> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Direction, int> get direction =>
      $composableBuilder(column: $table.direction, builder: (column) => column);

  GeneratedColumn<int> get chosenIndex => $composableBuilder(
      column: $table.chosenIndex, builder: (column) => column);

  GeneratedColumn<bool> get isCorrect =>
      $composableBuilder(column: $table.isCorrect, builder: (column) => column);

  GeneratedColumn<int> get timeMs =>
      $composableBuilder(column: $table.timeMs, builder: (column) => column);
}

class $$SessionAnswersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SessionAnswersTable,
    SessionAnswer,
    $$SessionAnswersTableFilterComposer,
    $$SessionAnswersTableOrderingComposer,
    $$SessionAnswersTableAnnotationComposer,
    $$SessionAnswersTableCreateCompanionBuilder,
    $$SessionAnswersTableUpdateCompanionBuilder,
    (
      SessionAnswer,
      BaseReferences<_$AppDatabase, $SessionAnswersTable, SessionAnswer>
    ),
    SessionAnswer,
    PrefetchHooks Function()> {
  $$SessionAnswersTableTableManager(
      _$AppDatabase db, $SessionAnswersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionAnswersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionAnswersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionAnswersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> sessionId = const Value.absent(),
            Value<ItemType> itemType = const Value.absent(),
            Value<int> itemId = const Value.absent(),
            Value<Direction> direction = const Value.absent(),
            Value<int?> chosenIndex = const Value.absent(),
            Value<bool> isCorrect = const Value.absent(),
            Value<int> timeMs = const Value.absent(),
          }) =>
              SessionAnswersCompanion(
            id: id,
            sessionId: sessionId,
            itemType: itemType,
            itemId: itemId,
            direction: direction,
            chosenIndex: chosenIndex,
            isCorrect: isCorrect,
            timeMs: timeMs,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int sessionId,
            required ItemType itemType,
            required int itemId,
            Value<Direction> direction = const Value.absent(),
            Value<int?> chosenIndex = const Value.absent(),
            required bool isCorrect,
            Value<int> timeMs = const Value.absent(),
          }) =>
              SessionAnswersCompanion.insert(
            id: id,
            sessionId: sessionId,
            itemType: itemType,
            itemId: itemId,
            direction: direction,
            chosenIndex: chosenIndex,
            isCorrect: isCorrect,
            timeMs: timeMs,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SessionAnswersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SessionAnswersTable,
    SessionAnswer,
    $$SessionAnswersTableFilterComposer,
    $$SessionAnswersTableOrderingComposer,
    $$SessionAnswersTableAnnotationComposer,
    $$SessionAnswersTableCreateCompanionBuilder,
    $$SessionAnswersTableUpdateCompanionBuilder,
    (
      SessionAnswer,
      BaseReferences<_$AppDatabase, $SessionAnswersTable, SessionAnswer>
    ),
    SessionAnswer,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SourcesTableTableManager get sources =>
      $$SourcesTableTableManager(_db, _db.sources);
  $$UnitsTableTableManager get units =>
      $$UnitsTableTableManager(_db, _db.units);
  $$KanjisTableTableManager get kanjis =>
      $$KanjisTableTableManager(_db, _db.kanjis);
  $$KanjiReadingsTableTableManager get kanjiReadings =>
      $$KanjiReadingsTableTableManager(_db, _db.kanjiReadings);
  $$KanjiSourceItemsTableTableManager get kanjiSourceItems =>
      $$KanjiSourceItemsTableTableManager(_db, _db.kanjiSourceItems);
  $$VocabulariesTableTableManager get vocabularies =>
      $$VocabulariesTableTableManager(_db, _db.vocabularies);
  $$VocabSourceItemsTableTableManager get vocabSourceItems =>
      $$VocabSourceItemsTableTableManager(_db, _db.vocabSourceItems);
  $$KanjiCompoundsTableTableManager get kanjiCompounds =>
      $$KanjiCompoundsTableTableManager(_db, _db.kanjiCompounds);
  $$GrammarPointsTableTableManager get grammarPoints =>
      $$GrammarPointsTableTableManager(_db, _db.grammarPoints);
  $$GrammarSourceItemsTableTableManager get grammarSourceItems =>
      $$GrammarSourceItemsTableTableManager(_db, _db.grammarSourceItems);
  $$MondaiTypesTableTableManager get mondaiTypes =>
      $$MondaiTypesTableTableManager(_db, _db.mondaiTypes);
  $$QuestionGroupsTableTableManager get questionGroups =>
      $$QuestionGroupsTableTableManager(_db, _db.questionGroups);
  $$QuestionsTableTableManager get questions =>
      $$QuestionsTableTableManager(_db, _db.questions);
  $$QuestionChoicesTableTableManager get questionChoices =>
      $$QuestionChoicesTableTableManager(_db, _db.questionChoices);
  $$ProgressTableTableManager get progress =>
      $$ProgressTableTableManager(_db, _db.progress);
  $$PracticeSessionsTableTableManager get practiceSessions =>
      $$PracticeSessionsTableTableManager(_db, _db.practiceSessions);
  $$SessionAnswersTableTableManager get sessionAnswers =>
      $$SessionAnswersTableTableManager(_db, _db.sessionAnswers);
}
