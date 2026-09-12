import '../models/task_definition.dart';
import '../models/task_occurrence.dart';
import '../models/weekday.dart';

/// Pure, DB-agnostic implementations of DATA_MODEL.md's "Occurrence
/// generation" section and "Occurrence status state machine" — kept free of
/// BuildContext/persistence so they're directly unit-testable, per
/// CLAUDE.md's Riverpod rationale.
class OccurrenceRules {
  const OccurrenceRules._();

  static DateTime dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// How many weeks of future occurrences to keep generated for a weekly
  /// task at any time (DATA_MODEL.md: "maintain 2–4 weeks of future
  /// occurrences ... don't pre-generate indefinitely").
  static const defaultWeeksAhead = 3;

  /// Generates the occurrences that should exist for [definition] but don't
  /// yet, given [existingScheduledDates] (dates already generated for this
  /// definition, normalized to midnight).
  ///
  /// For `once`: exactly one occurrence at [TaskDefinition.oneTimeDate].
  /// For `weekly`: one per selected weekday from today through [now] +
  /// [weeksAhead] weeks. Uses the definition's *current* weekdays/alarmTime,
  /// so an edit to those only affects occurrences generated after the edit —
  /// existing rows are never touched here.
  static List<TaskOccurrence> generateMissingOccurrences({
    required TaskDefinition definition,
    required DateTime now,
    required Set<DateTime> existingScheduledDates,
    required String Function() nextId,
    int weeksAhead = defaultWeeksAhead,
  }) {
    if (definition.isArchived) return const [];

    if (definition.frequency == Frequency.once) {
      final date = dateOnly(definition.oneTimeDate!);
      if (existingScheduledDates.contains(date)) return const [];
      return [_buildOccurrence(definition, date, nextId())];
    }

    final start = dateOnly(now);
    final end = start.add(Duration(days: weeksAhead * 7));
    final generated = <TaskOccurrence>[];
    for (
      var day = start;
      !day.isAfter(end);
      day = day.add(const Duration(days: 1))
    ) {
      if (!definition.weekdays.contains(Weekday.fromDateTime(day))) continue;
      if (existingScheduledDates.contains(day)) continue;
      generated.add(_buildOccurrence(definition, day, nextId()));
    }
    return generated;
  }

  static TaskOccurrence _buildOccurrence(
    TaskDefinition definition,
    DateTime scheduledDate,
    String id,
  ) {
    return TaskOccurrence(
      id: id,
      taskDefinitionId: definition.id,
      subjectId: definition.subjectId,
      scheduledDate: scheduledDate,
      alarmAt: definition.alarmTime.onDate(scheduledDate),
      deadline: definition.deadline,
    );
  }

  /// pending -> completed. Reachable directly from the weekly view without
  /// going through the alarm.
  static TaskOccurrence markCompleted(
    TaskOccurrence occurrence, {
    required DateTime now,
  }) {
    return occurrence.copyWith(
      status: OccurrenceStatus.completed,
      completedAt: now,
    );
  }

  /// pending -> carried_forward, spawning a new pending occurrence at
  /// [newAlarmAt]. Never optional — DATA_MODEL.md requires a concrete new
  /// alarmAt, so this takes it as a required parameter rather than letting a
  /// caller carry forward without one.
  static ({TaskOccurrence closedOut, TaskOccurrence spawned}) carryForward(
    TaskOccurrence occurrence, {
    required DateTime newAlarmAt,
    required String newId,
  }) {
    final closedOut = occurrence.copyWith(
      status: OccurrenceStatus.carriedForward,
    );
    final spawned = TaskOccurrence(
      id: newId,
      taskDefinitionId: occurrence.taskDefinitionId,
      subjectId: occurrence.subjectId,
      scheduledDate: dateOnly(newAlarmAt),
      alarmAt: newAlarmAt,
      deadline: occurrence.deadline,
      carriedFromOccurrenceId: occurrence.id,
      carryCount: occurrence.carryCount + 1,
    );
    return (closedOut: closedOut, spawned: spawned);
  }

  /// pending -> pending, mutated in place with a new alarmAt (and
  /// scheduledDate if the new time crosses midnight). Same "always needs a
  /// concrete new time" invariant as [carryForward].
  static TaskOccurrence reschedule(
    TaskOccurrence occurrence, {
    required DateTime newAlarmAt,
  }) {
    return occurrence.copyWith(
      alarmAt: newAlarmAt,
      scheduledDate: dateOnly(newAlarmAt),
    );
  }

  /// Any `pending` occurrence whose scheduledDate has fully elapsed (i.e. is
  /// strictly before today — not "today", which hasn't elapsed yet) becomes
  /// `missed`. A batch sweep, not something decided at alarm-fire time.
  static List<TaskOccurrence> sweepMissed(
    List<TaskOccurrence> occurrences, {
    required DateTime now,
  }) {
    final today = dateOnly(now);
    final missed = <TaskOccurrence>[];
    for (final occurrence in occurrences) {
      if (occurrence.status == OccurrenceStatus.pending &&
          occurrence.scheduledDate.isBefore(today)) {
        missed.add(occurrence.copyWith(status: OccurrenceStatus.missed));
      }
    }
    return missed;
  }
}
