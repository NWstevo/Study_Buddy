// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $SubjectsTable extends Subjects
    with TableInfo<$SubjectsTable, SubjectRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _colorHueMeta =
      const VerificationMeta('colorHue');
  @override
  late final GeneratedColumn<int> colorHue = GeneratedColumn<int>(
      'color_hue', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _archivedAtMeta =
      const VerificationMeta('archivedAt');
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
      'archived_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, colorHue, createdAt, archivedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subjects';
  @override
  VerificationContext validateIntegrity(Insertable<SubjectRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color_hue')) {
      context.handle(_colorHueMeta,
          colorHue.isAcceptableOrUnknown(data['color_hue']!, _colorHueMeta));
    } else if (isInserting) {
      context.missing(_colorHueMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('archived_at')) {
      context.handle(
          _archivedAtMeta,
          archivedAt.isAcceptableOrUnknown(
              data['archived_at']!, _archivedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubjectRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubjectRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      colorHue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color_hue'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      archivedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}archived_at']),
    );
  }

  @override
  $SubjectsTable createAlias(String alias) {
    return $SubjectsTable(attachedDatabase, alias);
  }
}

class SubjectRow extends DataClass implements Insertable<SubjectRow> {
  final String id;
  final String name;
  final int colorHue;
  final DateTime createdAt;
  final DateTime? archivedAt;
  const SubjectRow(
      {required this.id,
      required this.name,
      required this.colorHue,
      required this.createdAt,
      this.archivedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['color_hue'] = Variable<int>(colorHue);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    return map;
  }

  SubjectsCompanion toCompanion(bool nullToAbsent) {
    return SubjectsCompanion(
      id: Value(id),
      name: Value(name),
      colorHue: Value(colorHue),
      createdAt: Value(createdAt),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
    );
  }

  factory SubjectRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubjectRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      colorHue: serializer.fromJson<int>(json['colorHue']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'colorHue': serializer.toJson<int>(colorHue),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
    };
  }

  SubjectRow copyWith(
          {String? id,
          String? name,
          int? colorHue,
          DateTime? createdAt,
          Value<DateTime?> archivedAt = const Value.absent()}) =>
      SubjectRow(
        id: id ?? this.id,
        name: name ?? this.name,
        colorHue: colorHue ?? this.colorHue,
        createdAt: createdAt ?? this.createdAt,
        archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
      );
  SubjectRow copyWithCompanion(SubjectsCompanion data) {
    return SubjectRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      colorHue: data.colorHue.present ? data.colorHue.value : this.colorHue,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      archivedAt:
          data.archivedAt.present ? data.archivedAt.value : this.archivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubjectRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorHue: $colorHue, ')
          ..write('createdAt: $createdAt, ')
          ..write('archivedAt: $archivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, colorHue, createdAt, archivedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubjectRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.colorHue == this.colorHue &&
          other.createdAt == this.createdAt &&
          other.archivedAt == this.archivedAt);
}

class SubjectsCompanion extends UpdateCompanion<SubjectRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> colorHue;
  final Value<DateTime> createdAt;
  final Value<DateTime?> archivedAt;
  final Value<int> rowid;
  const SubjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.colorHue = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubjectsCompanion.insert({
    required String id,
    required String name,
    required int colorHue,
    required DateTime createdAt,
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        colorHue = Value(colorHue),
        createdAt = Value(createdAt);
  static Insertable<SubjectRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? colorHue,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? archivedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (colorHue != null) 'color_hue': colorHue,
      if (createdAt != null) 'created_at': createdAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubjectsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<int>? colorHue,
      Value<DateTime>? createdAt,
      Value<DateTime?>? archivedAt,
      Value<int>? rowid}) {
    return SubjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      colorHue: colorHue ?? this.colorHue,
      createdAt: createdAt ?? this.createdAt,
      archivedAt: archivedAt ?? this.archivedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (colorHue.present) {
      map['color_hue'] = Variable<int>(colorHue.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubjectsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorHue: $colorHue, ')
          ..write('createdAt: $createdAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskDefinitionsTable extends TaskDefinitions
    with TableInfo<$TaskDefinitionsTable, TaskDefinitionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskDefinitionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _subjectIdMeta =
      const VerificationMeta('subjectId');
  @override
  late final GeneratedColumn<String> subjectId = GeneratedColumn<String>(
      'subject_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES subjects (id)'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<Frequency, String> frequency =
      GeneratedColumn<String>('frequency', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<Frequency>($TaskDefinitionsTable.$converterfrequency);
  @override
  late final GeneratedColumnWithTypeConverter<Set<Weekday>, int> weekdaysMask =
      GeneratedColumn<int>('weekdays_mask', aliasedName, false,
              type: DriftSqlType.int,
              requiredDuringInsert: false,
              defaultValue: const Constant(0))
          .withConverter<Set<Weekday>>(
              $TaskDefinitionsTable.$converterweekdaysMask);
  static const VerificationMeta _oneTimeDateMeta =
      const VerificationMeta('oneTimeDate');
  @override
  late final GeneratedColumn<DateTime> oneTimeDate = GeneratedColumn<DateTime>(
      'one_time_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _alarmTimeMinutesMeta =
      const VerificationMeta('alarmTimeMinutes');
  @override
  late final GeneratedColumn<int> alarmTimeMinutes = GeneratedColumn<int>(
      'alarm_time_minutes', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _deadlineMeta =
      const VerificationMeta('deadline');
  @override
  late final GeneratedColumn<DateTime> deadline = GeneratedColumn<DateTime>(
      'deadline', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _archivedAtMeta =
      const VerificationMeta('archivedAt');
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
      'archived_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        subjectId,
        title,
        notes,
        frequency,
        weekdaysMask,
        oneTimeDate,
        alarmTimeMinutes,
        deadline,
        createdAt,
        archivedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_definitions';
  @override
  VerificationContext validateIntegrity(Insertable<TaskDefinitionRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('subject_id')) {
      context.handle(_subjectIdMeta,
          subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta));
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('one_time_date')) {
      context.handle(
          _oneTimeDateMeta,
          oneTimeDate.isAcceptableOrUnknown(
              data['one_time_date']!, _oneTimeDateMeta));
    }
    if (data.containsKey('alarm_time_minutes')) {
      context.handle(
          _alarmTimeMinutesMeta,
          alarmTimeMinutes.isAcceptableOrUnknown(
              data['alarm_time_minutes']!, _alarmTimeMinutesMeta));
    } else if (isInserting) {
      context.missing(_alarmTimeMinutesMeta);
    }
    if (data.containsKey('deadline')) {
      context.handle(_deadlineMeta,
          deadline.isAcceptableOrUnknown(data['deadline']!, _deadlineMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('archived_at')) {
      context.handle(
          _archivedAtMeta,
          archivedAt.isAcceptableOrUnknown(
              data['archived_at']!, _archivedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskDefinitionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskDefinitionRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      subjectId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}subject_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      frequency: $TaskDefinitionsTable.$converterfrequency.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.string, data['${effectivePrefix}frequency'])!),
      weekdaysMask: $TaskDefinitionsTable.$converterweekdaysMask.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.int, data['${effectivePrefix}weekdays_mask'])!),
      oneTimeDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}one_time_date']),
      alarmTimeMinutes: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}alarm_time_minutes'])!,
      deadline: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deadline']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      archivedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}archived_at']),
    );
  }

  @override
  $TaskDefinitionsTable createAlias(String alias) {
    return $TaskDefinitionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Frequency, String, String> $converterfrequency =
      const EnumNameConverter<Frequency>(Frequency.values);
  static TypeConverter<Set<Weekday>, int> $converterweekdaysMask =
      const WeekdaySetConverter();
}

class TaskDefinitionRow extends DataClass
    implements Insertable<TaskDefinitionRow> {
  final String id;
  final String subjectId;
  final String title;
  final String? notes;
  final Frequency frequency;
  final Set<Weekday> weekdaysMask;

  /// The single occurrence's date when `frequency == Frequency.once` — see
  /// the doc comment on the model field of the same name for why this
  /// exists despite not being named in DATA_MODEL.md.
  final DateTime? oneTimeDate;
  final int alarmTimeMinutes;
  final DateTime? deadline;
  final DateTime createdAt;
  final DateTime? archivedAt;
  const TaskDefinitionRow(
      {required this.id,
      required this.subjectId,
      required this.title,
      this.notes,
      required this.frequency,
      required this.weekdaysMask,
      this.oneTimeDate,
      required this.alarmTimeMinutes,
      this.deadline,
      required this.createdAt,
      this.archivedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['subject_id'] = Variable<String>(subjectId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    {
      map['frequency'] = Variable<String>(
          $TaskDefinitionsTable.$converterfrequency.toSql(frequency));
    }
    {
      map['weekdays_mask'] = Variable<int>(
          $TaskDefinitionsTable.$converterweekdaysMask.toSql(weekdaysMask));
    }
    if (!nullToAbsent || oneTimeDate != null) {
      map['one_time_date'] = Variable<DateTime>(oneTimeDate);
    }
    map['alarm_time_minutes'] = Variable<int>(alarmTimeMinutes);
    if (!nullToAbsent || deadline != null) {
      map['deadline'] = Variable<DateTime>(deadline);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    return map;
  }

  TaskDefinitionsCompanion toCompanion(bool nullToAbsent) {
    return TaskDefinitionsCompanion(
      id: Value(id),
      subjectId: Value(subjectId),
      title: Value(title),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      frequency: Value(frequency),
      weekdaysMask: Value(weekdaysMask),
      oneTimeDate: oneTimeDate == null && nullToAbsent
          ? const Value.absent()
          : Value(oneTimeDate),
      alarmTimeMinutes: Value(alarmTimeMinutes),
      deadline: deadline == null && nullToAbsent
          ? const Value.absent()
          : Value(deadline),
      createdAt: Value(createdAt),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
    );
  }

  factory TaskDefinitionRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskDefinitionRow(
      id: serializer.fromJson<String>(json['id']),
      subjectId: serializer.fromJson<String>(json['subjectId']),
      title: serializer.fromJson<String>(json['title']),
      notes: serializer.fromJson<String?>(json['notes']),
      frequency: $TaskDefinitionsTable.$converterfrequency
          .fromJson(serializer.fromJson<String>(json['frequency'])),
      weekdaysMask: serializer.fromJson<Set<Weekday>>(json['weekdaysMask']),
      oneTimeDate: serializer.fromJson<DateTime?>(json['oneTimeDate']),
      alarmTimeMinutes: serializer.fromJson<int>(json['alarmTimeMinutes']),
      deadline: serializer.fromJson<DateTime?>(json['deadline']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'subjectId': serializer.toJson<String>(subjectId),
      'title': serializer.toJson<String>(title),
      'notes': serializer.toJson<String?>(notes),
      'frequency': serializer.toJson<String>(
          $TaskDefinitionsTable.$converterfrequency.toJson(frequency)),
      'weekdaysMask': serializer.toJson<Set<Weekday>>(weekdaysMask),
      'oneTimeDate': serializer.toJson<DateTime?>(oneTimeDate),
      'alarmTimeMinutes': serializer.toJson<int>(alarmTimeMinutes),
      'deadline': serializer.toJson<DateTime?>(deadline),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
    };
  }

  TaskDefinitionRow copyWith(
          {String? id,
          String? subjectId,
          String? title,
          Value<String?> notes = const Value.absent(),
          Frequency? frequency,
          Set<Weekday>? weekdaysMask,
          Value<DateTime?> oneTimeDate = const Value.absent(),
          int? alarmTimeMinutes,
          Value<DateTime?> deadline = const Value.absent(),
          DateTime? createdAt,
          Value<DateTime?> archivedAt = const Value.absent()}) =>
      TaskDefinitionRow(
        id: id ?? this.id,
        subjectId: subjectId ?? this.subjectId,
        title: title ?? this.title,
        notes: notes.present ? notes.value : this.notes,
        frequency: frequency ?? this.frequency,
        weekdaysMask: weekdaysMask ?? this.weekdaysMask,
        oneTimeDate: oneTimeDate.present ? oneTimeDate.value : this.oneTimeDate,
        alarmTimeMinutes: alarmTimeMinutes ?? this.alarmTimeMinutes,
        deadline: deadline.present ? deadline.value : this.deadline,
        createdAt: createdAt ?? this.createdAt,
        archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
      );
  TaskDefinitionRow copyWithCompanion(TaskDefinitionsCompanion data) {
    return TaskDefinitionRow(
      id: data.id.present ? data.id.value : this.id,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      title: data.title.present ? data.title.value : this.title,
      notes: data.notes.present ? data.notes.value : this.notes,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      weekdaysMask: data.weekdaysMask.present
          ? data.weekdaysMask.value
          : this.weekdaysMask,
      oneTimeDate:
          data.oneTimeDate.present ? data.oneTimeDate.value : this.oneTimeDate,
      alarmTimeMinutes: data.alarmTimeMinutes.present
          ? data.alarmTimeMinutes.value
          : this.alarmTimeMinutes,
      deadline: data.deadline.present ? data.deadline.value : this.deadline,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      archivedAt:
          data.archivedAt.present ? data.archivedAt.value : this.archivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskDefinitionRow(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('frequency: $frequency, ')
          ..write('weekdaysMask: $weekdaysMask, ')
          ..write('oneTimeDate: $oneTimeDate, ')
          ..write('alarmTimeMinutes: $alarmTimeMinutes, ')
          ..write('deadline: $deadline, ')
          ..write('createdAt: $createdAt, ')
          ..write('archivedAt: $archivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      subjectId,
      title,
      notes,
      frequency,
      weekdaysMask,
      oneTimeDate,
      alarmTimeMinutes,
      deadline,
      createdAt,
      archivedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskDefinitionRow &&
          other.id == this.id &&
          other.subjectId == this.subjectId &&
          other.title == this.title &&
          other.notes == this.notes &&
          other.frequency == this.frequency &&
          other.weekdaysMask == this.weekdaysMask &&
          other.oneTimeDate == this.oneTimeDate &&
          other.alarmTimeMinutes == this.alarmTimeMinutes &&
          other.deadline == this.deadline &&
          other.createdAt == this.createdAt &&
          other.archivedAt == this.archivedAt);
}

class TaskDefinitionsCompanion extends UpdateCompanion<TaskDefinitionRow> {
  final Value<String> id;
  final Value<String> subjectId;
  final Value<String> title;
  final Value<String?> notes;
  final Value<Frequency> frequency;
  final Value<Set<Weekday>> weekdaysMask;
  final Value<DateTime?> oneTimeDate;
  final Value<int> alarmTimeMinutes;
  final Value<DateTime?> deadline;
  final Value<DateTime> createdAt;
  final Value<DateTime?> archivedAt;
  final Value<int> rowid;
  const TaskDefinitionsCompanion({
    this.id = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.title = const Value.absent(),
    this.notes = const Value.absent(),
    this.frequency = const Value.absent(),
    this.weekdaysMask = const Value.absent(),
    this.oneTimeDate = const Value.absent(),
    this.alarmTimeMinutes = const Value.absent(),
    this.deadline = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskDefinitionsCompanion.insert({
    required String id,
    required String subjectId,
    required String title,
    this.notes = const Value.absent(),
    required Frequency frequency,
    this.weekdaysMask = const Value.absent(),
    this.oneTimeDate = const Value.absent(),
    required int alarmTimeMinutes,
    this.deadline = const Value.absent(),
    required DateTime createdAt,
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        subjectId = Value(subjectId),
        title = Value(title),
        frequency = Value(frequency),
        alarmTimeMinutes = Value(alarmTimeMinutes),
        createdAt = Value(createdAt);
  static Insertable<TaskDefinitionRow> custom({
    Expression<String>? id,
    Expression<String>? subjectId,
    Expression<String>? title,
    Expression<String>? notes,
    Expression<String>? frequency,
    Expression<int>? weekdaysMask,
    Expression<DateTime>? oneTimeDate,
    Expression<int>? alarmTimeMinutes,
    Expression<DateTime>? deadline,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? archivedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subjectId != null) 'subject_id': subjectId,
      if (title != null) 'title': title,
      if (notes != null) 'notes': notes,
      if (frequency != null) 'frequency': frequency,
      if (weekdaysMask != null) 'weekdays_mask': weekdaysMask,
      if (oneTimeDate != null) 'one_time_date': oneTimeDate,
      if (alarmTimeMinutes != null) 'alarm_time_minutes': alarmTimeMinutes,
      if (deadline != null) 'deadline': deadline,
      if (createdAt != null) 'created_at': createdAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskDefinitionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? subjectId,
      Value<String>? title,
      Value<String?>? notes,
      Value<Frequency>? frequency,
      Value<Set<Weekday>>? weekdaysMask,
      Value<DateTime?>? oneTimeDate,
      Value<int>? alarmTimeMinutes,
      Value<DateTime?>? deadline,
      Value<DateTime>? createdAt,
      Value<DateTime?>? archivedAt,
      Value<int>? rowid}) {
    return TaskDefinitionsCompanion(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      frequency: frequency ?? this.frequency,
      weekdaysMask: weekdaysMask ?? this.weekdaysMask,
      oneTimeDate: oneTimeDate ?? this.oneTimeDate,
      alarmTimeMinutes: alarmTimeMinutes ?? this.alarmTimeMinutes,
      deadline: deadline ?? this.deadline,
      createdAt: createdAt ?? this.createdAt,
      archivedAt: archivedAt ?? this.archivedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<String>(subjectId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(
          $TaskDefinitionsTable.$converterfrequency.toSql(frequency.value));
    }
    if (weekdaysMask.present) {
      map['weekdays_mask'] = Variable<int>($TaskDefinitionsTable
          .$converterweekdaysMask
          .toSql(weekdaysMask.value));
    }
    if (oneTimeDate.present) {
      map['one_time_date'] = Variable<DateTime>(oneTimeDate.value);
    }
    if (alarmTimeMinutes.present) {
      map['alarm_time_minutes'] = Variable<int>(alarmTimeMinutes.value);
    }
    if (deadline.present) {
      map['deadline'] = Variable<DateTime>(deadline.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskDefinitionsCompanion(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('frequency: $frequency, ')
          ..write('weekdaysMask: $weekdaysMask, ')
          ..write('oneTimeDate: $oneTimeDate, ')
          ..write('alarmTimeMinutes: $alarmTimeMinutes, ')
          ..write('deadline: $deadline, ')
          ..write('createdAt: $createdAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskOccurrencesTable extends TaskOccurrences
    with TableInfo<$TaskOccurrencesTable, TaskOccurrenceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskOccurrencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _taskDefinitionIdMeta =
      const VerificationMeta('taskDefinitionId');
  @override
  late final GeneratedColumn<String> taskDefinitionId = GeneratedColumn<String>(
      'task_definition_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES task_definitions (id)'));
  static const VerificationMeta _subjectIdMeta =
      const VerificationMeta('subjectId');
  @override
  late final GeneratedColumn<String> subjectId = GeneratedColumn<String>(
      'subject_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scheduledDateMeta =
      const VerificationMeta('scheduledDate');
  @override
  late final GeneratedColumn<DateTime> scheduledDate =
      GeneratedColumn<DateTime>('scheduled_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _alarmAtMeta =
      const VerificationMeta('alarmAt');
  @override
  late final GeneratedColumn<DateTime> alarmAt = GeneratedColumn<DateTime>(
      'alarm_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _deadlineMeta =
      const VerificationMeta('deadline');
  @override
  late final GeneratedColumn<DateTime> deadline = GeneratedColumn<DateTime>(
      'deadline', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<OccurrenceStatus, String> status =
      GeneratedColumn<String>('status', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant('pending'))
          .withConverter<OccurrenceStatus>(
              $TaskOccurrencesTable.$converterstatus);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _carriedFromOccurrenceIdMeta =
      const VerificationMeta('carriedFromOccurrenceId');
  @override
  late final GeneratedColumn<String> carriedFromOccurrenceId =
      GeneratedColumn<String>('carried_from_occurrence_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _carryCountMeta =
      const VerificationMeta('carryCount');
  @override
  late final GeneratedColumn<int> carryCount = GeneratedColumn<int>(
      'carry_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        taskDefinitionId,
        subjectId,
        scheduledDate,
        alarmAt,
        deadline,
        status,
        completedAt,
        carriedFromOccurrenceId,
        carryCount
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_occurrences';
  @override
  VerificationContext validateIntegrity(Insertable<TaskOccurrenceRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_definition_id')) {
      context.handle(
          _taskDefinitionIdMeta,
          taskDefinitionId.isAcceptableOrUnknown(
              data['task_definition_id']!, _taskDefinitionIdMeta));
    } else if (isInserting) {
      context.missing(_taskDefinitionIdMeta);
    }
    if (data.containsKey('subject_id')) {
      context.handle(_subjectIdMeta,
          subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta));
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('scheduled_date')) {
      context.handle(
          _scheduledDateMeta,
          scheduledDate.isAcceptableOrUnknown(
              data['scheduled_date']!, _scheduledDateMeta));
    } else if (isInserting) {
      context.missing(_scheduledDateMeta);
    }
    if (data.containsKey('alarm_at')) {
      context.handle(_alarmAtMeta,
          alarmAt.isAcceptableOrUnknown(data['alarm_at']!, _alarmAtMeta));
    } else if (isInserting) {
      context.missing(_alarmAtMeta);
    }
    if (data.containsKey('deadline')) {
      context.handle(_deadlineMeta,
          deadline.isAcceptableOrUnknown(data['deadline']!, _deadlineMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('carried_from_occurrence_id')) {
      context.handle(
          _carriedFromOccurrenceIdMeta,
          carriedFromOccurrenceId.isAcceptableOrUnknown(
              data['carried_from_occurrence_id']!,
              _carriedFromOccurrenceIdMeta));
    }
    if (data.containsKey('carry_count')) {
      context.handle(
          _carryCountMeta,
          carryCount.isAcceptableOrUnknown(
              data['carry_count']!, _carryCountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskOccurrenceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskOccurrenceRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      taskDefinitionId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}task_definition_id'])!,
      subjectId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}subject_id'])!,
      scheduledDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}scheduled_date'])!,
      alarmAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}alarm_at'])!,
      deadline: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deadline']),
      status: $TaskOccurrencesTable.$converterstatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!),
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
      carriedFromOccurrenceId: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}carried_from_occurrence_id']),
      carryCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}carry_count'])!,
    );
  }

  @override
  $TaskOccurrencesTable createAlias(String alias) {
    return $TaskOccurrencesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<OccurrenceStatus, String, String> $converterstatus =
      const EnumNameConverter<OccurrenceStatus>(OccurrenceStatus.values);
}

class TaskOccurrenceRow extends DataClass
    implements Insertable<TaskOccurrenceRow> {
  final String id;
  final String taskDefinitionId;
  final String subjectId;
  final DateTime scheduledDate;
  final DateTime alarmAt;
  final DateTime? deadline;
  final OccurrenceStatus status;
  final DateTime? completedAt;
  final String? carriedFromOccurrenceId;
  final int carryCount;
  const TaskOccurrenceRow(
      {required this.id,
      required this.taskDefinitionId,
      required this.subjectId,
      required this.scheduledDate,
      required this.alarmAt,
      this.deadline,
      required this.status,
      this.completedAt,
      this.carriedFromOccurrenceId,
      required this.carryCount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['task_definition_id'] = Variable<String>(taskDefinitionId);
    map['subject_id'] = Variable<String>(subjectId);
    map['scheduled_date'] = Variable<DateTime>(scheduledDate);
    map['alarm_at'] = Variable<DateTime>(alarmAt);
    if (!nullToAbsent || deadline != null) {
      map['deadline'] = Variable<DateTime>(deadline);
    }
    {
      map['status'] = Variable<String>(
          $TaskOccurrencesTable.$converterstatus.toSql(status));
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || carriedFromOccurrenceId != null) {
      map['carried_from_occurrence_id'] =
          Variable<String>(carriedFromOccurrenceId);
    }
    map['carry_count'] = Variable<int>(carryCount);
    return map;
  }

  TaskOccurrencesCompanion toCompanion(bool nullToAbsent) {
    return TaskOccurrencesCompanion(
      id: Value(id),
      taskDefinitionId: Value(taskDefinitionId),
      subjectId: Value(subjectId),
      scheduledDate: Value(scheduledDate),
      alarmAt: Value(alarmAt),
      deadline: deadline == null && nullToAbsent
          ? const Value.absent()
          : Value(deadline),
      status: Value(status),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      carriedFromOccurrenceId: carriedFromOccurrenceId == null && nullToAbsent
          ? const Value.absent()
          : Value(carriedFromOccurrenceId),
      carryCount: Value(carryCount),
    );
  }

  factory TaskOccurrenceRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskOccurrenceRow(
      id: serializer.fromJson<String>(json['id']),
      taskDefinitionId: serializer.fromJson<String>(json['taskDefinitionId']),
      subjectId: serializer.fromJson<String>(json['subjectId']),
      scheduledDate: serializer.fromJson<DateTime>(json['scheduledDate']),
      alarmAt: serializer.fromJson<DateTime>(json['alarmAt']),
      deadline: serializer.fromJson<DateTime?>(json['deadline']),
      status: $TaskOccurrencesTable.$converterstatus
          .fromJson(serializer.fromJson<String>(json['status'])),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      carriedFromOccurrenceId:
          serializer.fromJson<String?>(json['carriedFromOccurrenceId']),
      carryCount: serializer.fromJson<int>(json['carryCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskDefinitionId': serializer.toJson<String>(taskDefinitionId),
      'subjectId': serializer.toJson<String>(subjectId),
      'scheduledDate': serializer.toJson<DateTime>(scheduledDate),
      'alarmAt': serializer.toJson<DateTime>(alarmAt),
      'deadline': serializer.toJson<DateTime?>(deadline),
      'status': serializer.toJson<String>(
          $TaskOccurrencesTable.$converterstatus.toJson(status)),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'carriedFromOccurrenceId':
          serializer.toJson<String?>(carriedFromOccurrenceId),
      'carryCount': serializer.toJson<int>(carryCount),
    };
  }

  TaskOccurrenceRow copyWith(
          {String? id,
          String? taskDefinitionId,
          String? subjectId,
          DateTime? scheduledDate,
          DateTime? alarmAt,
          Value<DateTime?> deadline = const Value.absent(),
          OccurrenceStatus? status,
          Value<DateTime?> completedAt = const Value.absent(),
          Value<String?> carriedFromOccurrenceId = const Value.absent(),
          int? carryCount}) =>
      TaskOccurrenceRow(
        id: id ?? this.id,
        taskDefinitionId: taskDefinitionId ?? this.taskDefinitionId,
        subjectId: subjectId ?? this.subjectId,
        scheduledDate: scheduledDate ?? this.scheduledDate,
        alarmAt: alarmAt ?? this.alarmAt,
        deadline: deadline.present ? deadline.value : this.deadline,
        status: status ?? this.status,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
        carriedFromOccurrenceId: carriedFromOccurrenceId.present
            ? carriedFromOccurrenceId.value
            : this.carriedFromOccurrenceId,
        carryCount: carryCount ?? this.carryCount,
      );
  TaskOccurrenceRow copyWithCompanion(TaskOccurrencesCompanion data) {
    return TaskOccurrenceRow(
      id: data.id.present ? data.id.value : this.id,
      taskDefinitionId: data.taskDefinitionId.present
          ? data.taskDefinitionId.value
          : this.taskDefinitionId,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      scheduledDate: data.scheduledDate.present
          ? data.scheduledDate.value
          : this.scheduledDate,
      alarmAt: data.alarmAt.present ? data.alarmAt.value : this.alarmAt,
      deadline: data.deadline.present ? data.deadline.value : this.deadline,
      status: data.status.present ? data.status.value : this.status,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      carriedFromOccurrenceId: data.carriedFromOccurrenceId.present
          ? data.carriedFromOccurrenceId.value
          : this.carriedFromOccurrenceId,
      carryCount:
          data.carryCount.present ? data.carryCount.value : this.carryCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskOccurrenceRow(')
          ..write('id: $id, ')
          ..write('taskDefinitionId: $taskDefinitionId, ')
          ..write('subjectId: $subjectId, ')
          ..write('scheduledDate: $scheduledDate, ')
          ..write('alarmAt: $alarmAt, ')
          ..write('deadline: $deadline, ')
          ..write('status: $status, ')
          ..write('completedAt: $completedAt, ')
          ..write('carriedFromOccurrenceId: $carriedFromOccurrenceId, ')
          ..write('carryCount: $carryCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      taskDefinitionId,
      subjectId,
      scheduledDate,
      alarmAt,
      deadline,
      status,
      completedAt,
      carriedFromOccurrenceId,
      carryCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskOccurrenceRow &&
          other.id == this.id &&
          other.taskDefinitionId == this.taskDefinitionId &&
          other.subjectId == this.subjectId &&
          other.scheduledDate == this.scheduledDate &&
          other.alarmAt == this.alarmAt &&
          other.deadline == this.deadline &&
          other.status == this.status &&
          other.completedAt == this.completedAt &&
          other.carriedFromOccurrenceId == this.carriedFromOccurrenceId &&
          other.carryCount == this.carryCount);
}

class TaskOccurrencesCompanion extends UpdateCompanion<TaskOccurrenceRow> {
  final Value<String> id;
  final Value<String> taskDefinitionId;
  final Value<String> subjectId;
  final Value<DateTime> scheduledDate;
  final Value<DateTime> alarmAt;
  final Value<DateTime?> deadline;
  final Value<OccurrenceStatus> status;
  final Value<DateTime?> completedAt;
  final Value<String?> carriedFromOccurrenceId;
  final Value<int> carryCount;
  final Value<int> rowid;
  const TaskOccurrencesCompanion({
    this.id = const Value.absent(),
    this.taskDefinitionId = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.scheduledDate = const Value.absent(),
    this.alarmAt = const Value.absent(),
    this.deadline = const Value.absent(),
    this.status = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.carriedFromOccurrenceId = const Value.absent(),
    this.carryCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskOccurrencesCompanion.insert({
    required String id,
    required String taskDefinitionId,
    required String subjectId,
    required DateTime scheduledDate,
    required DateTime alarmAt,
    this.deadline = const Value.absent(),
    this.status = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.carriedFromOccurrenceId = const Value.absent(),
    this.carryCount = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        taskDefinitionId = Value(taskDefinitionId),
        subjectId = Value(subjectId),
        scheduledDate = Value(scheduledDate),
        alarmAt = Value(alarmAt);
  static Insertable<TaskOccurrenceRow> custom({
    Expression<String>? id,
    Expression<String>? taskDefinitionId,
    Expression<String>? subjectId,
    Expression<DateTime>? scheduledDate,
    Expression<DateTime>? alarmAt,
    Expression<DateTime>? deadline,
    Expression<String>? status,
    Expression<DateTime>? completedAt,
    Expression<String>? carriedFromOccurrenceId,
    Expression<int>? carryCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskDefinitionId != null) 'task_definition_id': taskDefinitionId,
      if (subjectId != null) 'subject_id': subjectId,
      if (scheduledDate != null) 'scheduled_date': scheduledDate,
      if (alarmAt != null) 'alarm_at': alarmAt,
      if (deadline != null) 'deadline': deadline,
      if (status != null) 'status': status,
      if (completedAt != null) 'completed_at': completedAt,
      if (carriedFromOccurrenceId != null)
        'carried_from_occurrence_id': carriedFromOccurrenceId,
      if (carryCount != null) 'carry_count': carryCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskOccurrencesCompanion copyWith(
      {Value<String>? id,
      Value<String>? taskDefinitionId,
      Value<String>? subjectId,
      Value<DateTime>? scheduledDate,
      Value<DateTime>? alarmAt,
      Value<DateTime?>? deadline,
      Value<OccurrenceStatus>? status,
      Value<DateTime?>? completedAt,
      Value<String?>? carriedFromOccurrenceId,
      Value<int>? carryCount,
      Value<int>? rowid}) {
    return TaskOccurrencesCompanion(
      id: id ?? this.id,
      taskDefinitionId: taskDefinitionId ?? this.taskDefinitionId,
      subjectId: subjectId ?? this.subjectId,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      alarmAt: alarmAt ?? this.alarmAt,
      deadline: deadline ?? this.deadline,
      status: status ?? this.status,
      completedAt: completedAt ?? this.completedAt,
      carriedFromOccurrenceId:
          carriedFromOccurrenceId ?? this.carriedFromOccurrenceId,
      carryCount: carryCount ?? this.carryCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskDefinitionId.present) {
      map['task_definition_id'] = Variable<String>(taskDefinitionId.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<String>(subjectId.value);
    }
    if (scheduledDate.present) {
      map['scheduled_date'] = Variable<DateTime>(scheduledDate.value);
    }
    if (alarmAt.present) {
      map['alarm_at'] = Variable<DateTime>(alarmAt.value);
    }
    if (deadline.present) {
      map['deadline'] = Variable<DateTime>(deadline.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
          $TaskOccurrencesTable.$converterstatus.toSql(status.value));
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (carriedFromOccurrenceId.present) {
      map['carried_from_occurrence_id'] =
          Variable<String>(carriedFromOccurrenceId.value);
    }
    if (carryCount.present) {
      map['carry_count'] = Variable<int>(carryCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskOccurrencesCompanion(')
          ..write('id: $id, ')
          ..write('taskDefinitionId: $taskDefinitionId, ')
          ..write('subjectId: $subjectId, ')
          ..write('scheduledDate: $scheduledDate, ')
          ..write('alarmAt: $alarmAt, ')
          ..write('deadline: $deadline, ')
          ..write('status: $status, ')
          ..write('completedAt: $completedAt, ')
          ..write('carriedFromOccurrenceId: $carriedFromOccurrenceId, ')
          ..write('carryCount: $carryCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SubjectsTable subjects = $SubjectsTable(this);
  late final $TaskDefinitionsTable taskDefinitions =
      $TaskDefinitionsTable(this);
  late final $TaskOccurrencesTable taskOccurrences =
      $TaskOccurrencesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [subjects, taskDefinitions, taskOccurrences];
}

typedef $$SubjectsTableCreateCompanionBuilder = SubjectsCompanion Function({
  required String id,
  required String name,
  required int colorHue,
  required DateTime createdAt,
  Value<DateTime?> archivedAt,
  Value<int> rowid,
});
typedef $$SubjectsTableUpdateCompanionBuilder = SubjectsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<int> colorHue,
  Value<DateTime> createdAt,
  Value<DateTime?> archivedAt,
  Value<int> rowid,
});

final class $$SubjectsTableReferences
    extends BaseReferences<_$AppDatabase, $SubjectsTable, SubjectRow> {
  $$SubjectsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TaskDefinitionsTable, List<TaskDefinitionRow>>
      _taskDefinitionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.taskDefinitions,
              aliasName: 'subjects__id__task_definitions__subject_id');

  $$TaskDefinitionsTableProcessedTableManager get taskDefinitionsRefs {
    final manager = $$TaskDefinitionsTableTableManager(
            $_db, $_db.taskDefinitions)
        .filter((f) => f.subjectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_taskDefinitionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$SubjectsTableFilterComposer
    extends Composer<_$AppDatabase, $SubjectsTable> {
  $$SubjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get colorHue => $composableBuilder(
      column: $table.colorHue, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
      column: $table.archivedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> taskDefinitionsRefs(
      Expression<bool> Function($$TaskDefinitionsTableFilterComposer f) f) {
    final $$TaskDefinitionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.taskDefinitions,
        getReferencedColumn: (t) => t.subjectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TaskDefinitionsTableFilterComposer(
              $db: $db,
              $table: $db.taskDefinitions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SubjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $SubjectsTable> {
  $$SubjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get colorHue => $composableBuilder(
      column: $table.colorHue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
      column: $table.archivedAt, builder: (column) => ColumnOrderings(column));
}

class $$SubjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubjectsTable> {
  $$SubjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get colorHue =>
      $composableBuilder(column: $table.colorHue, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
      column: $table.archivedAt, builder: (column) => column);

  Expression<T> taskDefinitionsRefs<T extends Object>(
      Expression<T> Function($$TaskDefinitionsTableAnnotationComposer a) f) {
    final $$TaskDefinitionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.taskDefinitions,
        getReferencedColumn: (t) => t.subjectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TaskDefinitionsTableAnnotationComposer(
              $db: $db,
              $table: $db.taskDefinitions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SubjectsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SubjectsTable,
    SubjectRow,
    $$SubjectsTableFilterComposer,
    $$SubjectsTableOrderingComposer,
    $$SubjectsTableAnnotationComposer,
    $$SubjectsTableCreateCompanionBuilder,
    $$SubjectsTableUpdateCompanionBuilder,
    (SubjectRow, $$SubjectsTableReferences),
    SubjectRow,
    PrefetchHooks Function({bool taskDefinitionsRefs})> {
  $$SubjectsTableTableManager(_$AppDatabase db, $SubjectsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> colorHue = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> archivedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SubjectsCompanion(
            id: id,
            name: name,
            colorHue: colorHue,
            createdAt: createdAt,
            archivedAt: archivedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required int colorHue,
            required DateTime createdAt,
            Value<DateTime?> archivedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SubjectsCompanion.insert(
            id: id,
            name: name,
            colorHue: colorHue,
            createdAt: createdAt,
            archivedAt: archivedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$SubjectsTable, SubjectRow>(table),
                    $$SubjectsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({taskDefinitionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (taskDefinitionsRefs) db.taskDefinitions
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (taskDefinitionsRefs)
                    await $_getPrefetchedData<SubjectRow, $SubjectsTable,
                            TaskDefinitionRow>(
                        currentTable: table,
                        referencedTable: $$SubjectsTableReferences
                            ._taskDefinitionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SubjectsTableReferences(db, table, p0)
                                .taskDefinitionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.subjectId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$SubjectsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SubjectsTable,
    SubjectRow,
    $$SubjectsTableFilterComposer,
    $$SubjectsTableOrderingComposer,
    $$SubjectsTableAnnotationComposer,
    $$SubjectsTableCreateCompanionBuilder,
    $$SubjectsTableUpdateCompanionBuilder,
    (SubjectRow, $$SubjectsTableReferences),
    SubjectRow,
    PrefetchHooks Function({bool taskDefinitionsRefs})>;
typedef $$TaskDefinitionsTableCreateCompanionBuilder = TaskDefinitionsCompanion
    Function({
  required String id,
  required String subjectId,
  required String title,
  Value<String?> notes,
  required Frequency frequency,
  Value<Set<Weekday>> weekdaysMask,
  Value<DateTime?> oneTimeDate,
  required int alarmTimeMinutes,
  Value<DateTime?> deadline,
  required DateTime createdAt,
  Value<DateTime?> archivedAt,
  Value<int> rowid,
});
typedef $$TaskDefinitionsTableUpdateCompanionBuilder = TaskDefinitionsCompanion
    Function({
  Value<String> id,
  Value<String> subjectId,
  Value<String> title,
  Value<String?> notes,
  Value<Frequency> frequency,
  Value<Set<Weekday>> weekdaysMask,
  Value<DateTime?> oneTimeDate,
  Value<int> alarmTimeMinutes,
  Value<DateTime?> deadline,
  Value<DateTime> createdAt,
  Value<DateTime?> archivedAt,
  Value<int> rowid,
});

final class $$TaskDefinitionsTableReferences extends BaseReferences<
    _$AppDatabase, $TaskDefinitionsTable, TaskDefinitionRow> {
  $$TaskDefinitionsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $SubjectsTable _subjectIdTable(_$AppDatabase db) =>
      db.subjects.createAlias('task_definitions__subject_id__subjects__id');

  $$SubjectsTableProcessedTableManager get subjectId {
    final $_column = $_itemColumn<String>('subject_id')!;

    final manager = $$SubjectsTableTableManager($_db, $_db.subjects)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_subjectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$TaskOccurrencesTable, List<TaskOccurrenceRow>>
      _taskOccurrencesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.taskOccurrences,
              aliasName:
                  'task_definitions__id__task_occurrences__task_definition_id');

  $$TaskOccurrencesTableProcessedTableManager get taskOccurrencesRefs {
    final manager =
        $$TaskOccurrencesTableTableManager($_db, $_db.taskOccurrences).filter(
            (f) =>
                f.taskDefinitionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_taskOccurrencesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$TaskDefinitionsTableFilterComposer
    extends Composer<_$AppDatabase, $TaskDefinitionsTable> {
  $$TaskDefinitionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Frequency, Frequency, String> get frequency =>
      $composableBuilder(
          column: $table.frequency,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<Set<Weekday>, Set<Weekday>, int>
      get weekdaysMask => $composableBuilder(
          column: $table.weekdaysMask,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get oneTimeDate => $composableBuilder(
      column: $table.oneTimeDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get alarmTimeMinutes => $composableBuilder(
      column: $table.alarmTimeMinutes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deadline => $composableBuilder(
      column: $table.deadline, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
      column: $table.archivedAt, builder: (column) => ColumnFilters(column));

  $$SubjectsTableFilterComposer get subjectId {
    final $$SubjectsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.subjectId,
        referencedTable: $db.subjects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SubjectsTableFilterComposer(
              $db: $db,
              $table: $db.subjects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> taskOccurrencesRefs(
      Expression<bool> Function($$TaskOccurrencesTableFilterComposer f) f) {
    final $$TaskOccurrencesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.taskOccurrences,
        getReferencedColumn: (t) => t.taskDefinitionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TaskOccurrencesTableFilterComposer(
              $db: $db,
              $table: $db.taskOccurrences,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TaskDefinitionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskDefinitionsTable> {
  $$TaskDefinitionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get frequency => $composableBuilder(
      column: $table.frequency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get weekdaysMask => $composableBuilder(
      column: $table.weekdaysMask,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get oneTimeDate => $composableBuilder(
      column: $table.oneTimeDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get alarmTimeMinutes => $composableBuilder(
      column: $table.alarmTimeMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deadline => $composableBuilder(
      column: $table.deadline, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
      column: $table.archivedAt, builder: (column) => ColumnOrderings(column));

  $$SubjectsTableOrderingComposer get subjectId {
    final $$SubjectsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.subjectId,
        referencedTable: $db.subjects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SubjectsTableOrderingComposer(
              $db: $db,
              $table: $db.subjects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TaskDefinitionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskDefinitionsTable> {
  $$TaskDefinitionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Frequency, String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Set<Weekday>, int> get weekdaysMask =>
      $composableBuilder(
          column: $table.weekdaysMask, builder: (column) => column);

  GeneratedColumn<DateTime> get oneTimeDate => $composableBuilder(
      column: $table.oneTimeDate, builder: (column) => column);

  GeneratedColumn<int> get alarmTimeMinutes => $composableBuilder(
      column: $table.alarmTimeMinutes, builder: (column) => column);

  GeneratedColumn<DateTime> get deadline =>
      $composableBuilder(column: $table.deadline, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
      column: $table.archivedAt, builder: (column) => column);

  $$SubjectsTableAnnotationComposer get subjectId {
    final $$SubjectsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.subjectId,
        referencedTable: $db.subjects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SubjectsTableAnnotationComposer(
              $db: $db,
              $table: $db.subjects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> taskOccurrencesRefs<T extends Object>(
      Expression<T> Function($$TaskOccurrencesTableAnnotationComposer a) f) {
    final $$TaskOccurrencesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.taskOccurrences,
        getReferencedColumn: (t) => t.taskDefinitionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TaskOccurrencesTableAnnotationComposer(
              $db: $db,
              $table: $db.taskOccurrences,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TaskDefinitionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TaskDefinitionsTable,
    TaskDefinitionRow,
    $$TaskDefinitionsTableFilterComposer,
    $$TaskDefinitionsTableOrderingComposer,
    $$TaskDefinitionsTableAnnotationComposer,
    $$TaskDefinitionsTableCreateCompanionBuilder,
    $$TaskDefinitionsTableUpdateCompanionBuilder,
    (TaskDefinitionRow, $$TaskDefinitionsTableReferences),
    TaskDefinitionRow,
    PrefetchHooks Function({bool subjectId, bool taskOccurrencesRefs})> {
  $$TaskDefinitionsTableTableManager(
      _$AppDatabase db, $TaskDefinitionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskDefinitionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskDefinitionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskDefinitionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> subjectId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<Frequency> frequency = const Value.absent(),
            Value<Set<Weekday>> weekdaysMask = const Value.absent(),
            Value<DateTime?> oneTimeDate = const Value.absent(),
            Value<int> alarmTimeMinutes = const Value.absent(),
            Value<DateTime?> deadline = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> archivedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TaskDefinitionsCompanion(
            id: id,
            subjectId: subjectId,
            title: title,
            notes: notes,
            frequency: frequency,
            weekdaysMask: weekdaysMask,
            oneTimeDate: oneTimeDate,
            alarmTimeMinutes: alarmTimeMinutes,
            deadline: deadline,
            createdAt: createdAt,
            archivedAt: archivedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String subjectId,
            required String title,
            Value<String?> notes = const Value.absent(),
            required Frequency frequency,
            Value<Set<Weekday>> weekdaysMask = const Value.absent(),
            Value<DateTime?> oneTimeDate = const Value.absent(),
            required int alarmTimeMinutes,
            Value<DateTime?> deadline = const Value.absent(),
            required DateTime createdAt,
            Value<DateTime?> archivedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TaskDefinitionsCompanion.insert(
            id: id,
            subjectId: subjectId,
            title: title,
            notes: notes,
            frequency: frequency,
            weekdaysMask: weekdaysMask,
            oneTimeDate: oneTimeDate,
            alarmTimeMinutes: alarmTimeMinutes,
            deadline: deadline,
            createdAt: createdAt,
            archivedAt: archivedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$TaskDefinitionsTable, TaskDefinitionRow>(
                        table),
                    $$TaskDefinitionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {subjectId = false, taskOccurrencesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (taskOccurrencesRefs) db.taskOccurrences
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (subjectId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.subjectId,
                    referencedTable:
                        $$TaskDefinitionsTableReferences._subjectIdTable(db),
                    referencedColumn:
                        $$TaskDefinitionsTableReferences._subjectIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (taskOccurrencesRefs)
                    await $_getPrefetchedData<TaskDefinitionRow,
                            $TaskDefinitionsTable, TaskOccurrenceRow>(
                        currentTable: table,
                        referencedTable: $$TaskDefinitionsTableReferences
                            ._taskOccurrencesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TaskDefinitionsTableReferences(db, table, p0)
                                .taskOccurrencesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.taskDefinitionId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$TaskDefinitionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TaskDefinitionsTable,
    TaskDefinitionRow,
    $$TaskDefinitionsTableFilterComposer,
    $$TaskDefinitionsTableOrderingComposer,
    $$TaskDefinitionsTableAnnotationComposer,
    $$TaskDefinitionsTableCreateCompanionBuilder,
    $$TaskDefinitionsTableUpdateCompanionBuilder,
    (TaskDefinitionRow, $$TaskDefinitionsTableReferences),
    TaskDefinitionRow,
    PrefetchHooks Function({bool subjectId, bool taskOccurrencesRefs})>;
typedef $$TaskOccurrencesTableCreateCompanionBuilder = TaskOccurrencesCompanion
    Function({
  required String id,
  required String taskDefinitionId,
  required String subjectId,
  required DateTime scheduledDate,
  required DateTime alarmAt,
  Value<DateTime?> deadline,
  Value<OccurrenceStatus> status,
  Value<DateTime?> completedAt,
  Value<String?> carriedFromOccurrenceId,
  Value<int> carryCount,
  Value<int> rowid,
});
typedef $$TaskOccurrencesTableUpdateCompanionBuilder = TaskOccurrencesCompanion
    Function({
  Value<String> id,
  Value<String> taskDefinitionId,
  Value<String> subjectId,
  Value<DateTime> scheduledDate,
  Value<DateTime> alarmAt,
  Value<DateTime?> deadline,
  Value<OccurrenceStatus> status,
  Value<DateTime?> completedAt,
  Value<String?> carriedFromOccurrenceId,
  Value<int> carryCount,
  Value<int> rowid,
});

final class $$TaskOccurrencesTableReferences extends BaseReferences<
    _$AppDatabase, $TaskOccurrencesTable, TaskOccurrenceRow> {
  $$TaskOccurrencesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $TaskDefinitionsTable _taskDefinitionIdTable(_$AppDatabase db) =>
      db.taskDefinitions.createAlias(
          'task_occurrences__task_definition_id__task_definitions__id');

  $$TaskDefinitionsTableProcessedTableManager get taskDefinitionId {
    final $_column = $_itemColumn<String>('task_definition_id')!;

    final manager =
        $$TaskDefinitionsTableTableManager($_db, $_db.taskDefinitions)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskDefinitionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TaskOccurrencesTableFilterComposer
    extends Composer<_$AppDatabase, $TaskOccurrencesTable> {
  $$TaskOccurrencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get subjectId => $composableBuilder(
      column: $table.subjectId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get scheduledDate => $composableBuilder(
      column: $table.scheduledDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get alarmAt => $composableBuilder(
      column: $table.alarmAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deadline => $composableBuilder(
      column: $table.deadline, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<OccurrenceStatus, OccurrenceStatus, String>
      get status => $composableBuilder(
          column: $table.status,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get carriedFromOccurrenceId => $composableBuilder(
      column: $table.carriedFromOccurrenceId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get carryCount => $composableBuilder(
      column: $table.carryCount, builder: (column) => ColumnFilters(column));

  $$TaskDefinitionsTableFilterComposer get taskDefinitionId {
    final $$TaskDefinitionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.taskDefinitionId,
        referencedTable: $db.taskDefinitions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TaskDefinitionsTableFilterComposer(
              $db: $db,
              $table: $db.taskDefinitions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TaskOccurrencesTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskOccurrencesTable> {
  $$TaskOccurrencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get subjectId => $composableBuilder(
      column: $table.subjectId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get scheduledDate => $composableBuilder(
      column: $table.scheduledDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get alarmAt => $composableBuilder(
      column: $table.alarmAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deadline => $composableBuilder(
      column: $table.deadline, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get carriedFromOccurrenceId => $composableBuilder(
      column: $table.carriedFromOccurrenceId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get carryCount => $composableBuilder(
      column: $table.carryCount, builder: (column) => ColumnOrderings(column));

  $$TaskDefinitionsTableOrderingComposer get taskDefinitionId {
    final $$TaskDefinitionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.taskDefinitionId,
        referencedTable: $db.taskDefinitions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TaskDefinitionsTableOrderingComposer(
              $db: $db,
              $table: $db.taskDefinitions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TaskOccurrencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskOccurrencesTable> {
  $$TaskOccurrencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get subjectId =>
      $composableBuilder(column: $table.subjectId, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledDate => $composableBuilder(
      column: $table.scheduledDate, builder: (column) => column);

  GeneratedColumn<DateTime> get alarmAt =>
      $composableBuilder(column: $table.alarmAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deadline =>
      $composableBuilder(column: $table.deadline, builder: (column) => column);

  GeneratedColumnWithTypeConverter<OccurrenceStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<String> get carriedFromOccurrenceId => $composableBuilder(
      column: $table.carriedFromOccurrenceId, builder: (column) => column);

  GeneratedColumn<int> get carryCount => $composableBuilder(
      column: $table.carryCount, builder: (column) => column);

  $$TaskDefinitionsTableAnnotationComposer get taskDefinitionId {
    final $$TaskDefinitionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.taskDefinitionId,
        referencedTable: $db.taskDefinitions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TaskDefinitionsTableAnnotationComposer(
              $db: $db,
              $table: $db.taskDefinitions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TaskOccurrencesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TaskOccurrencesTable,
    TaskOccurrenceRow,
    $$TaskOccurrencesTableFilterComposer,
    $$TaskOccurrencesTableOrderingComposer,
    $$TaskOccurrencesTableAnnotationComposer,
    $$TaskOccurrencesTableCreateCompanionBuilder,
    $$TaskOccurrencesTableUpdateCompanionBuilder,
    (TaskOccurrenceRow, $$TaskOccurrencesTableReferences),
    TaskOccurrenceRow,
    PrefetchHooks Function({bool taskDefinitionId})> {
  $$TaskOccurrencesTableTableManager(
      _$AppDatabase db, $TaskOccurrencesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskOccurrencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskOccurrencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskOccurrencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> taskDefinitionId = const Value.absent(),
            Value<String> subjectId = const Value.absent(),
            Value<DateTime> scheduledDate = const Value.absent(),
            Value<DateTime> alarmAt = const Value.absent(),
            Value<DateTime?> deadline = const Value.absent(),
            Value<OccurrenceStatus> status = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<String?> carriedFromOccurrenceId = const Value.absent(),
            Value<int> carryCount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TaskOccurrencesCompanion(
            id: id,
            taskDefinitionId: taskDefinitionId,
            subjectId: subjectId,
            scheduledDate: scheduledDate,
            alarmAt: alarmAt,
            deadline: deadline,
            status: status,
            completedAt: completedAt,
            carriedFromOccurrenceId: carriedFromOccurrenceId,
            carryCount: carryCount,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String taskDefinitionId,
            required String subjectId,
            required DateTime scheduledDate,
            required DateTime alarmAt,
            Value<DateTime?> deadline = const Value.absent(),
            Value<OccurrenceStatus> status = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<String?> carriedFromOccurrenceId = const Value.absent(),
            Value<int> carryCount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TaskOccurrencesCompanion.insert(
            id: id,
            taskDefinitionId: taskDefinitionId,
            subjectId: subjectId,
            scheduledDate: scheduledDate,
            alarmAt: alarmAt,
            deadline: deadline,
            status: status,
            completedAt: completedAt,
            carriedFromOccurrenceId: carriedFromOccurrenceId,
            carryCount: carryCount,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$TaskOccurrencesTable, TaskOccurrenceRow>(
                        table),
                    $$TaskOccurrencesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({taskDefinitionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (taskDefinitionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.taskDefinitionId,
                    referencedTable: $$TaskOccurrencesTableReferences
                        ._taskDefinitionIdTable(db),
                    referencedColumn: $$TaskOccurrencesTableReferences
                        ._taskDefinitionIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$TaskOccurrencesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TaskOccurrencesTable,
    TaskOccurrenceRow,
    $$TaskOccurrencesTableFilterComposer,
    $$TaskOccurrencesTableOrderingComposer,
    $$TaskOccurrencesTableAnnotationComposer,
    $$TaskOccurrencesTableCreateCompanionBuilder,
    $$TaskOccurrencesTableUpdateCompanionBuilder,
    (TaskOccurrenceRow, $$TaskOccurrencesTableReferences),
    TaskOccurrenceRow,
    PrefetchHooks Function({bool taskDefinitionId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SubjectsTableTableManager get subjects =>
      $$SubjectsTableTableManager(_db, _db.subjects);
  $$TaskDefinitionsTableTableManager get taskDefinitions =>
      $$TaskDefinitionsTableTableManager(_db, _db.taskDefinitions);
  $$TaskOccurrencesTableTableManager get taskOccurrences =>
      $$TaskOccurrencesTableTableManager(_db, _db.taskOccurrences);
}
