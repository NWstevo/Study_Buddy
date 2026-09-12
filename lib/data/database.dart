import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../models/task_definition.dart' show Frequency;
import '../models/task_occurrence.dart' show OccurrenceStatus;
import '../models/weekday.dart';

part 'database.g.dart';

/// Stores a [Set<Weekday>] as a bitmask int (bit 0 = Monday .. bit 6 =
/// Sunday) — Drift has no native Set column type.
class WeekdaySetConverter extends TypeConverter<Set<Weekday>, int> {
  const WeekdaySetConverter();

  @override
  Set<Weekday> fromSql(int fromDb) {
    return {
      for (final day in Weekday.values)
        if (fromDb & (1 << day.index) != 0) day,
    };
  }

  @override
  int toSql(Set<Weekday> value) {
    var mask = 0;
    for (final day in value) {
      mask |= 1 << day.index;
    }
    return mask;
  }
}

// Explicit @DataClassName on every table: Drift's default naming strips a
// trailing 's' (Subjects -> Subject, TaskDefinitions -> TaskDefinition,
// TaskOccurrences -> TaskOccurrence), which collides with the domain model
// classes of the same names in lib/models/.
@DataClassName('SubjectRow')
class Subjects extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get colorHue => integer()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get archivedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('TaskDefinitionRow')
class TaskDefinitions extends Table {
  TextColumn get id => text()();
  TextColumn get subjectId =>
      text().references(Subjects, #id)();
  TextColumn get title => text()();
  TextColumn get notes => text().nullable()();
  TextColumn get frequency => textEnum<Frequency>()();
  IntColumn get weekdaysMask =>
      integer().map(const WeekdaySetConverter()).withDefault(const Constant(0))();

  /// The single occurrence's date when `frequency == Frequency.once` — see
  /// the doc comment on the model field of the same name for why this
  /// exists despite not being named in DATA_MODEL.md.
  DateTimeColumn get oneTimeDate => dateTime().nullable()();
  IntColumn get alarmTimeMinutes => integer()();
  DateTimeColumn get deadline => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get archivedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('TaskOccurrenceRow')
class TaskOccurrences extends Table {
  TextColumn get id => text()();
  TextColumn get taskDefinitionId =>
      text().references(TaskDefinitions, #id)();
  TextColumn get subjectId => text()();
  DateTimeColumn get scheduledDate => dateTime()();
  DateTimeColumn get alarmAt => dateTime()();
  DateTimeColumn get deadline => dateTime().nullable()();
  TextColumn get status =>
      textEnum<OccurrenceStatus>().withDefault(const Constant('pending'))();
  DateTimeColumn get completedAt => dateTime().nullable()();
  TextColumn get carriedFromOccurrenceId => text().nullable()();
  IntColumn get carryCount => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Subjects, TaskDefinitions, TaskOccurrences])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Used by tests to inject an in-memory executor.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'study_planner');
  }
}
