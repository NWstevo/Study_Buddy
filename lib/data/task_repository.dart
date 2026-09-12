import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../models/task_definition.dart';
import '../models/task_occurrence.dart';
import '../models/weekday.dart';
import 'database.dart';
import 'occurrence_rules.dart';

/// Owns every status transition on [TaskOccurrence] and all occurrence
/// generation. Per CLAUDE.md: UI code must never mutate
/// `TaskOccurrence.status` directly — everything routes through here so the
/// OS-alarm cancel/reschedule logic (wired in on top of this in M4) can't
/// get missed on some code path.
class TaskRepository {
  TaskRepository(this._db, {Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Uuid _uuid;

  // ---- TaskDefinition CRUD ----

  Stream<List<TaskDefinition>> watchActiveDefinitions() {
    final query = _db.select(_db.taskDefinitions)
      ..where((t) => t.archivedAt.isNull())
      ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]);
    return query.watch().map((rows) => rows.map(_definitionToModel).toList());
  }

  /// Includes archived definitions — a weekly-view occurrence still needs
  /// its parent's title even if the definition was archived afterward.
  Stream<List<TaskDefinition>> watchAllDefinitions() {
    final query = _db.select(_db.taskDefinitions);
    return query.watch().map((rows) => rows.map(_definitionToModel).toList());
  }

  Future<List<TaskDefinition>> getAllDefinitions() async {
    final rows = await _db.select(_db.taskDefinitions).get();
    return rows.map(_definitionToModel).toList();
  }

  Future<TaskDefinition?> getDefinition(String id) async {
    final query = _db.select(_db.taskDefinitions)
      ..where((t) => t.id.equals(id));
    final row = await query.getSingleOrNull();
    return row == null ? null : _definitionToModel(row);
  }

  /// Creates the definition and immediately generates the occurrence(s) it
  /// implies (DATA_MODEL.md: a `once` task gets one occurrence on save; a
  /// `weekly` task gets its rolling window topped up right away).
  Future<void> createDefinition(TaskDefinition definition) async {
    await _db.into(_db.taskDefinitions).insert(_definitionToCompanion(definition));
    await topUpOccurrencesFor(definition.id, now: DateTime.now());
  }

  /// Updating a definition never touches occurrences already generated —
  /// only future generation uses the new weekdays/alarmTime/deadline
  /// (DATA_MODEL.md § Occurrence generation).
  Future<void> updateDefinition(TaskDefinition definition) {
    return _db.update(_db.taskDefinitions).replace(
      _definitionToCompanion(definition),
    );
  }

  /// Soft-delete: stops future generation but never touches past
  /// occurrences.
  Future<void> archiveDefinition(String id) {
    return (_db.update(_db.taskDefinitions)..where((t) => t.id.equals(id)))
        .write(TaskDefinitionsCompanion(archivedAt: Value(DateTime.now())));
  }

  // ---- Occurrence generation ----

  /// Tops up the rolling window of future occurrences for one definition.
  /// Safe to call repeatedly (e.g. on app open) — never regenerates a date
  /// that already has an occurrence.
  Future<void> topUpOccurrencesFor(
    String definitionId, {
    required DateTime now,
  }) async {
    final definition = await getDefinition(definitionId);
    if (definition == null || definition.isArchived) return;

    final existingDates = await _existingScheduledDates(definitionId);
    final toInsert = OccurrenceRules.generateMissingOccurrences(
      definition: definition,
      now: now,
      existingScheduledDates: existingDates,
      nextId: _uuid.v4,
    );
    if (toInsert.isEmpty) return;

    await _db.batch((batch) {
      batch.insertAll(
        _db.taskOccurrences,
        toInsert.map(_occurrenceToCompanion),
      );
    });
  }

  /// Tops up every active weekly/once definition — call on app open.
  Future<void> topUpAllOccurrences({required DateTime now}) async {
    final definitions = await _db.select(_db.taskDefinitions)
        .get()
        .then(
          (rows) => rows
              .map(_definitionToModel)
              .where((d) => !d.isArchived)
              .toList(),
        );
    for (final definition in definitions) {
      await topUpOccurrencesFor(definition.id, now: now);
    }
  }

  Future<Set<DateTime>> _existingScheduledDates(String definitionId) async {
    final query = _db.select(_db.taskOccurrences)
      ..where((o) => o.taskDefinitionId.equals(definitionId));
    final rows = await query.get();
    return rows.map((r) => OccurrenceRules.dateOnly(r.scheduledDate)).toSet();
  }

  // ---- Queries ----

  Stream<List<TaskOccurrence>> watchOccurrencesForWeek(DateTime anyDayInWeek) {
    final start = _startOfWeek(anyDayInWeek);
    final end = start.add(const Duration(days: 7));
    final query = _db.select(_db.taskOccurrences)
      ..where((o) => o.scheduledDate.isBiggerOrEqualValue(start))
      ..where((o) => o.scheduledDate.isSmallerThanValue(end))
      ..orderBy([(o) => OrderingTerm.asc(o.alarmAt)]);
    return query.watch().map((rows) => rows.map(_occurrenceToModel).toList());
  }

  Future<List<TaskOccurrence>> occurrencesInRange(
    DateTime start,
    DateTime endExclusive,
  ) {
    final query = _db.select(_db.taskOccurrences)
      ..where((o) => o.scheduledDate.isBiggerOrEqualValue(start))
      ..where((o) => o.scheduledDate.isSmallerThanValue(endExclusive));
    return query.get().then((rows) => rows.map(_occurrenceToModel).toList());
  }

  DateTime _startOfWeek(DateTime day) {
    final date = OccurrenceRules.dateOnly(day);
    return date.subtract(Duration(days: Weekday.fromDateTime(date).index));
  }

  // ---- Status transitions (the only place these happen) ----

  Future<void> markCompleted(String occurrenceId, {DateTime? now}) async {
    final occurrence = await _getOccurrence(occurrenceId);
    final updated = OccurrenceRules.markCompleted(
      occurrence,
      now: now ?? DateTime.now(),
    );
    await _replaceOccurrence(updated);
  }

  /// Closes out [occurrenceId] as carried_forward and creates a new pending
  /// occurrence at [newAlarmAt]. Callers (the reschedule sheet) must always
  /// supply a concrete new time — there is no "carry forward, decide later"
  /// path, per DATA_MODEL.md.
  Future<void> carryForward(
    String occurrenceId, {
    required DateTime newAlarmAt,
  }) async {
    final occurrence = await _getOccurrence(occurrenceId);
    final result = OccurrenceRules.carryForward(
      occurrence,
      newAlarmAt: newAlarmAt,
      newId: _uuid.v4(),
    );
    await _db.batch((batch) {
      batch.update(
        _db.taskOccurrences,
        _occurrenceToCompanion(result.closedOut),
        where: (o) => o.id.equals(result.closedOut.id),
      );
      batch.insert(_db.taskOccurrences, _occurrenceToCompanion(result.spawned));
    });
  }

  /// Mutates [occurrenceId] in place with a new alarmAt — same "always a
  /// concrete new time" invariant as [carryForward].
  Future<void> reschedule(
    String occurrenceId, {
    required DateTime newAlarmAt,
  }) async {
    final occurrence = await _getOccurrence(occurrenceId);
    final updated = OccurrenceRules.reschedule(
      occurrence,
      newAlarmAt: newAlarmAt,
    );
    await _replaceOccurrence(updated);
  }

  /// Elapsed `pending` occurrences -> `missed`. Run on app open at minimum
  /// (DATA_MODEL.md).
  Future<int> sweepMissed({DateTime? now}) async {
    final effectiveNow = now ?? DateTime.now();
    final today = OccurrenceRules.dateOnly(effectiveNow);
    final query = _db.select(_db.taskOccurrences)
      ..where((o) => o.status.equalsValue(OccurrenceStatus.pending))
      ..where((o) => o.scheduledDate.isSmallerThanValue(today));
    final pending = await query.get().then(
      (rows) => rows.map(_occurrenceToModel).toList(),
    );
    final missed = OccurrenceRules.sweepMissed(pending, now: effectiveNow);
    if (missed.isEmpty) return 0;

    await _db.batch((batch) {
      for (final occurrence in missed) {
        batch.update(
          _db.taskOccurrences,
          _occurrenceToCompanion(occurrence),
          where: (o) => o.id.equals(occurrence.id),
        );
      }
    });
    return missed.length;
  }

  Future<TaskOccurrence> _getOccurrence(String id) async {
    final query = _db.select(_db.taskOccurrences)..where((o) => o.id.equals(id));
    final row = await query.getSingle();
    return _occurrenceToModel(row);
  }

  Future<void> _replaceOccurrence(TaskOccurrence occurrence) {
    return _db.update(_db.taskOccurrences).replace(
      _occurrenceToCompanion(occurrence),
    );
  }

  // ---- Model <-> Drift row mapping ----

  TaskDefinition _definitionToModel(TaskDefinitionRow row) {
    return TaskDefinition(
      id: row.id,
      subjectId: row.subjectId,
      title: row.title,
      notes: row.notes,
      frequency: row.frequency,
      weekdays: row.weekdaysMask,
      oneTimeDate: row.oneTimeDate,
      alarmTime: AlarmTimeOfDay.fromMinutesSinceMidnight(row.alarmTimeMinutes),
      deadline: row.deadline,
      createdAt: row.createdAt,
      archivedAt: row.archivedAt,
    );
  }

  TaskDefinitionsCompanion _definitionToCompanion(TaskDefinition definition) {
    return TaskDefinitionsCompanion(
      id: Value(definition.id),
      subjectId: Value(definition.subjectId),
      title: Value(definition.title),
      notes: Value(definition.notes),
      frequency: Value(definition.frequency),
      weekdaysMask: Value(definition.weekdays),
      oneTimeDate: Value(definition.oneTimeDate),
      alarmTimeMinutes: Value(definition.alarmTime.minutesSinceMidnight),
      deadline: Value(definition.deadline),
      createdAt: Value(definition.createdAt),
      archivedAt: Value(definition.archivedAt),
    );
  }

  TaskOccurrence _occurrenceToModel(TaskOccurrenceRow row) {
    return TaskOccurrence(
      id: row.id,
      taskDefinitionId: row.taskDefinitionId,
      subjectId: row.subjectId,
      scheduledDate: row.scheduledDate,
      alarmAt: row.alarmAt,
      deadline: row.deadline,
      status: row.status,
      completedAt: row.completedAt,
      carriedFromOccurrenceId: row.carriedFromOccurrenceId,
      carryCount: row.carryCount,
    );
  }

  TaskOccurrencesCompanion _occurrenceToCompanion(TaskOccurrence occurrence) {
    return TaskOccurrencesCompanion(
      id: Value(occurrence.id),
      taskDefinitionId: Value(occurrence.taskDefinitionId),
      subjectId: Value(occurrence.subjectId),
      scheduledDate: Value(occurrence.scheduledDate),
      alarmAt: Value(occurrence.alarmAt),
      deadline: Value(occurrence.deadline),
      status: Value(occurrence.status),
      completedAt: Value(occurrence.completedAt),
      carriedFromOccurrenceId: Value(occurrence.carriedFromOccurrenceId),
      carryCount: Value(occurrence.carryCount),
    );
  }
}
