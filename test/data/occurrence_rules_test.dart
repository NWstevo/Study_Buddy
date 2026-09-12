import 'package:flutter_test/flutter_test.dart';
import 'package:study_planner/data/occurrence_rules.dart';
import 'package:study_planner/models/task_definition.dart';
import 'package:study_planner/models/task_occurrence.dart';
import 'package:study_planner/models/weekday.dart';

TaskDefinition weeklyDefinition({
  Set<Weekday> weekdays = const {Weekday.monday, Weekday.wednesday, Weekday.friday},
  DateTime? archivedAt,
  DateTime? deadline,
}) {
  return TaskDefinition(
    id: 'def-1',
    subjectId: 'subj-1',
    title: 'Practice set',
    frequency: Frequency.weekly,
    weekdays: weekdays,
    alarmTime: const AlarmTimeOfDay(hour: 7, minute: 30),
    deadline: deadline,
    createdAt: DateTime(2026, 1, 1),
    archivedAt: archivedAt,
  );
}

TaskDefinition onceDefinition({required DateTime oneTimeDate}) {
  return TaskDefinition(
    id: 'def-2',
    subjectId: 'subj-1',
    title: 'Lab report',
    frequency: Frequency.once,
    oneTimeDate: oneTimeDate,
    alarmTime: const AlarmTimeOfDay(hour: 9, minute: 0),
    createdAt: DateTime(2026, 1, 1),
  );
}

int _sequence = 0;
String fakeId() => 'gen-${_sequence++}';

void main() {
  setUp(() => _sequence = 0);

  group('TaskDefinition validation', () {
    test('weekly with empty weekdays is rejected', () {
      expect(
        () => weeklyDefinition(weekdays: {}),
        throwsArgumentError,
      );
    });

    test('once without oneTimeDate is rejected', () {
      expect(
        () => TaskDefinition(
          id: 'x',
          subjectId: 's',
          title: 't',
          frequency: Frequency.once,
          alarmTime: const AlarmTimeOfDay(hour: 8, minute: 0),
          createdAt: DateTime(2026, 1, 1),
        ),
        throwsArgumentError,
      );
    });
  });

  group('generateMissingOccurrences — weekly', () {
    test('generates one occurrence per selected weekday in the window', () {
      // 2026-01-05 is a Monday.
      final now = DateTime(2026, 1, 5);
      final definition = weeklyDefinition(
        weekdays: {Weekday.monday, Weekday.wednesday, Weekday.friday},
      );

      final occurrences = OccurrenceRules.generateMissingOccurrences(
        definition: definition,
        now: now,
        existingScheduledDates: {},
        nextId: fakeId,
        weeksAhead: 1,
      );

      // Mon Jan 5 .. Mon Jan 12 inclusive (8 days) contains
      // Mon 5, Wed 7, Fri 9, Mon 12 = 4 matches.
      final scheduledDates = occurrences.map((o) => o.scheduledDate).toList();
      expect(scheduledDates, [
        DateTime(2026, 1, 5),
        DateTime(2026, 1, 7),
        DateTime(2026, 1, 9),
        DateTime(2026, 1, 12),
      ]);
      for (final occurrence in occurrences) {
        expect(occurrence.status, OccurrenceStatus.pending);
        expect(occurrence.subjectId, definition.subjectId);
        expect(occurrence.alarmAt.hour, 7);
        expect(occurrence.alarmAt.minute, 30);
      }
    });

    test('does not regenerate dates that already have an occurrence', () {
      final now = DateTime(2026, 1, 5);
      final definition = weeklyDefinition(weekdays: {Weekday.monday});

      final occurrences = OccurrenceRules.generateMissingOccurrences(
        definition: definition,
        now: now,
        existingScheduledDates: {DateTime(2026, 1, 5), DateTime(2026, 1, 12)},
        nextId: fakeId,
        weeksAhead: 2,
      );

      expect(
        occurrences.map((o) => o.scheduledDate),
        isNot(contains(DateTime(2026, 1, 5))),
      );
      expect(
        occurrences.map((o) => o.scheduledDate),
        isNot(contains(DateTime(2026, 1, 12))),
      );
      expect(occurrences.map((o) => o.scheduledDate), contains(DateTime(2026, 1, 19)));
    });

    test('archived definitions generate nothing', () {
      final definition = weeklyDefinition(archivedAt: DateTime(2026, 1, 2));

      final occurrences = OccurrenceRules.generateMissingOccurrences(
        definition: definition,
        now: DateTime(2026, 1, 5),
        existingScheduledDates: {},
        nextId: fakeId,
      );

      expect(occurrences, isEmpty);
    });

    test('a later edit to weekdays only affects newly generated dates', () {
      // Simulates: definition originally Mon/Wed/Fri; already-generated
      // occurrences for this week exist under the old weekdays. The
      // definition is then edited to Tue/Thu. Regenerating must not
      // touch the existing dates and must only add new ones matching the
      // *current* weekdays.
      final editedDefinition = weeklyDefinition(
        weekdays: {Weekday.tuesday, Weekday.thursday},
      );
      final existingFromBeforeEdit = {DateTime(2026, 1, 5), DateTime(2026, 1, 9)};

      final occurrences = OccurrenceRules.generateMissingOccurrences(
        definition: editedDefinition,
        now: DateTime(2026, 1, 5),
        existingScheduledDates: existingFromBeforeEdit,
        nextId: fakeId,
        weeksAhead: 1,
      );

      // None of the newly generated occurrences duplicate the pre-edit dates.
      for (final date in existingFromBeforeEdit) {
        expect(occurrences.map((o) => o.scheduledDate), isNot(contains(date)));
      }
      // New generation follows the edited weekdays (Tue Jan 6, Thu Jan 8).
      expect(occurrences.map((o) => o.scheduledDate), contains(DateTime(2026, 1, 6)));
      expect(occurrences.map((o) => o.scheduledDate), contains(DateTime(2026, 1, 8)));
    });
  });

  group('generateMissingOccurrences — once', () {
    test('generates exactly one occurrence at oneTimeDate', () {
      final definition = onceDefinition(oneTimeDate: DateTime(2026, 2, 1));

      final occurrences = OccurrenceRules.generateMissingOccurrences(
        definition: definition,
        now: DateTime(2026, 1, 1),
        existingScheduledDates: {},
        nextId: fakeId,
      );

      expect(occurrences, hasLength(1));
      expect(occurrences.single.scheduledDate, DateTime(2026, 2, 1));
      expect(occurrences.single.alarmAt, DateTime(2026, 2, 1, 9, 0));
    });

    test('does not duplicate if already generated', () {
      final definition = onceDefinition(oneTimeDate: DateTime(2026, 2, 1));

      final occurrences = OccurrenceRules.generateMissingOccurrences(
        definition: definition,
        now: DateTime(2026, 1, 1),
        existingScheduledDates: {DateTime(2026, 2, 1)},
        nextId: fakeId,
      );

      expect(occurrences, isEmpty);
    });
  });

  group('status state machine', () {
    TaskOccurrence pendingOccurrence({
      DateTime? scheduledDate,
      int carryCount = 0,
    }) {
      final date = scheduledDate ?? DateTime(2026, 1, 5);
      return TaskOccurrence(
        id: 'occ-1',
        taskDefinitionId: 'def-1',
        subjectId: 'subj-1',
        scheduledDate: date,
        alarmAt: DateTime(date.year, date.month, date.day, 7, 30),
        carryCount: carryCount,
      );
    }

    test('markCompleted sets status and completedAt', () {
      final occurrence = pendingOccurrence();
      final now = DateTime(2026, 1, 5, 8);

      final result = OccurrenceRules.markCompleted(occurrence, now: now);

      expect(result.status, OccurrenceStatus.completed);
      expect(result.completedAt, now);
    });

    test(
      'carryForward closes out the original and spawns a new pending occurrence',
      () {
        final occurrence = pendingOccurrence(carryCount: 1);
        final newAlarmAt = DateTime(2026, 1, 6, 8, 0);

        final result = OccurrenceRules.carryForward(
          occurrence,
          newAlarmAt: newAlarmAt,
          newId: 'occ-2',
        );

        expect(result.closedOut.status, OccurrenceStatus.carriedForward);
        expect(result.closedOut.id, occurrence.id);

        expect(result.spawned.status, OccurrenceStatus.pending);
        expect(result.spawned.id, 'occ-2');
        expect(result.spawned.alarmAt, newAlarmAt);
        expect(result.spawned.scheduledDate, DateTime(2026, 1, 6));
        expect(result.spawned.carriedFromOccurrenceId, occurrence.id);
        expect(result.spawned.carryCount, 2);
      },
    );

    test('reschedule mutates the same occurrence in place with a new time', () {
      final occurrence = pendingOccurrence();
      // Crosses midnight into the next day.
      final newAlarmAt = DateTime(2026, 1, 6, 0, 30);

      final result = OccurrenceRules.reschedule(occurrence, newAlarmAt: newAlarmAt);

      expect(result.id, occurrence.id);
      expect(result.status, OccurrenceStatus.pending);
      expect(result.alarmAt, newAlarmAt);
      expect(result.scheduledDate, DateTime(2026, 1, 6));
    });
  });

  group('sweepMissed', () {
    test('flags only pending occurrences whose day has fully elapsed', () {
      final now = DateTime(2026, 1, 10, 9);
      final occurrences = [
        TaskOccurrence(
          id: 'past-pending',
          taskDefinitionId: 'd',
          subjectId: 's',
          scheduledDate: DateTime(2026, 1, 9),
          alarmAt: DateTime(2026, 1, 9, 7, 30),
        ),
        TaskOccurrence(
          id: 'today-pending',
          taskDefinitionId: 'd',
          subjectId: 's',
          scheduledDate: DateTime(2026, 1, 10),
          alarmAt: DateTime(2026, 1, 10, 7, 30),
        ),
        TaskOccurrence(
          id: 'past-completed',
          taskDefinitionId: 'd',
          subjectId: 's',
          scheduledDate: DateTime(2026, 1, 8),
          alarmAt: DateTime(2026, 1, 8, 7, 30),
          status: OccurrenceStatus.completed,
          completedAt: DateTime(2026, 1, 8, 8),
        ),
      ];

      final missed = OccurrenceRules.sweepMissed(occurrences, now: now);

      expect(missed, hasLength(1));
      expect(missed.single.id, 'past-pending');
      expect(missed.single.status, OccurrenceStatus.missed);
    });
  });
}
