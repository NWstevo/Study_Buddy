import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:study_planner/data/database.dart';
import 'package:study_planner/data/subject_repository.dart';
import 'package:study_planner/data/task_repository.dart';
import 'package:study_planner/models/subject.dart';
import 'package:study_planner/models/task_definition.dart';
import 'package:study_planner/models/task_occurrence.dart';
import 'package:study_planner/models/weekday.dart';

void main() {
  late AppDatabase db;
  late SubjectRepository subjects;
  late TaskRepository tasks;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    subjects = SubjectRepository(db);
    tasks = TaskRepository(db);
  });

  tearDown(() => db.close());

  test(
    'creating a subject and a weekly task definition produces the '
    'correct future occurrences end-to-end',
    () async {
      final subject = Subject(
        id: 'subj-1',
        name: 'Cell Biology',
        colorHue: 195,
        createdAt: DateTime(2026, 1, 1),
      );
      await subjects.create(subject);

      final definition = TaskDefinition(
        id: 'def-1',
        subjectId: subject.id,
        title: 'Review notes',
        frequency: Frequency.weekly,
        weekdays: const {Weekday.monday, Weekday.wednesday, Weekday.friday},
        alarmTime: const AlarmTimeOfDay(hour: 19, minute: 0),
        createdAt: DateTime(2026, 1, 1),
      );

      final now = DateTime(2026, 1, 5); // a Monday
      await tasks.createDefinition(definition);
      // createDefinition tops up using DateTime.now() internally; also
      // explicitly top up against a fixed `now` so this test is deterministic.
      await tasks.topUpOccurrencesFor(definition.id, now: now);

      final occurrences = await tasks.occurrencesInRange(
        now,
        now.add(const Duration(days: 8)),
      );

      final dates = occurrences.map((o) => o.scheduledDate).toSet();
      expect(dates, {
        DateTime(2026, 1, 5),
        DateTime(2026, 1, 7),
        DateTime(2026, 1, 9),
        DateTime(2026, 1, 12),
      });
      for (final occurrence in occurrences) {
        expect(occurrence.status, OccurrenceStatus.pending);
        expect(occurrence.subjectId, subject.id);
        expect(occurrence.alarmAt.hour, 19);
      }
    },
  );

  test('topUpOccurrencesFor is idempotent — no duplicate occurrences', () async {
    final definition = TaskDefinition(
      id: 'def-1',
      subjectId: 'subj-1',
      title: 'Review notes',
      frequency: Frequency.weekly,
      weekdays: const {Weekday.monday},
      alarmTime: const AlarmTimeOfDay(hour: 19, minute: 0),
      createdAt: DateTime(2026, 1, 1),
    );
    await subjects.create(
      Subject(
        id: 'subj-1',
        name: 'Cell Biology',
        colorHue: 195,
        createdAt: DateTime(2026, 1, 1),
      ),
    );
    await tasks.createDefinition(definition);

    final now = DateTime(2026, 1, 5);
    await tasks.topUpOccurrencesFor(definition.id, now: now);
    await tasks.topUpOccurrencesFor(definition.id, now: now);
    await tasks.topUpOccurrencesFor(definition.id, now: now);

    final occurrences = await tasks.occurrencesInRange(
      DateTime(2020),
      DateTime(2030),
    );
    final mondaysOnly = occurrences.where((o) => o.scheduledDate == DateTime(2026, 1, 5));
    expect(mondaysOnly, hasLength(1));
  });

  test(
    'editing a definition does not retroactively change existing occurrences',
    () async {
      await subjects.create(
        Subject(
          id: 'subj-1',
          name: 'Cell Biology',
          colorHue: 195,
          createdAt: DateTime(2026, 1, 1),
        ),
      );
      final original = TaskDefinition(
        id: 'def-1',
        subjectId: 'subj-1',
        title: 'Review notes',
        frequency: Frequency.weekly,
        weekdays: const {Weekday.monday},
        alarmTime: const AlarmTimeOfDay(hour: 19, minute: 0),
        createdAt: DateTime(2026, 1, 1),
      );
      final now = DateTime(2026, 1, 5);
      await tasks.createDefinition(original);
      await tasks.topUpOccurrencesFor(original.id, now: now);

      final beforeEdit = await tasks.occurrencesInRange(DateTime(2020), DateTime(2030));
      final mondayOccurrence = beforeEdit.firstWhere(
        (o) => o.scheduledDate == DateTime(2026, 1, 5),
      );

      // Edit: move the routine to Tuesdays at a different time.
      final edited = original.copyWith(
        weekdays: {Weekday.tuesday},
        alarmTime: const AlarmTimeOfDay(hour: 20, minute: 30),
      );
      await tasks.updateDefinition(edited);
      await tasks.topUpOccurrencesFor(edited.id, now: now);

      final afterEdit = await tasks.occurrencesInRange(DateTime(2020), DateTime(2030));
      final sameOccurrence = afterEdit.firstWhere((o) => o.id == mondayOccurrence.id);

      // The already-generated Monday occurrence is untouched.
      expect(sameOccurrence.scheduledDate, DateTime(2026, 1, 5));
      expect(sameOccurrence.alarmAt.hour, 19);
      // New generation follows the edited definition (Tuesdays, 20:30).
      expect(
        afterEdit.any(
          (o) => o.scheduledDate.weekday == DateTime.tuesday && o.alarmAt.hour == 20,
        ),
        isTrue,
      );
    },
  );

  test('archiving a definition stops future generation', () async {
    await subjects.create(
      Subject(
        id: 'subj-1',
        name: 'Cell Biology',
        colorHue: 195,
        createdAt: DateTime(2026, 1, 1),
      ),
    );
    final definition = TaskDefinition(
      id: 'def-1',
      subjectId: 'subj-1',
      title: 'Review notes',
      frequency: Frequency.weekly,
      weekdays: const {Weekday.monday},
      alarmTime: const AlarmTimeOfDay(hour: 19, minute: 0),
      createdAt: DateTime(2026, 1, 1),
    );
    final now = DateTime(2026, 1, 5);
    await tasks.createDefinition(definition);
    await tasks.topUpOccurrencesFor(definition.id, now: now);

    final beforeArchive = await tasks.occurrencesInRange(DateTime(2020), DateTime(2030));
    await tasks.archiveDefinition(definition.id);
    await tasks.topUpOccurrencesFor(definition.id, now: now.add(const Duration(days: 30)));
    final afterArchive = await tasks.occurrencesInRange(DateTime(2020), DateTime(2030));

    expect(afterArchive.length, beforeArchive.length);
  });

  test('the three alarm outcomes update occurrence state correctly', () async {
    await subjects.create(
      Subject(
        id: 'subj-1',
        name: 'Cell Biology',
        colorHue: 195,
        createdAt: DateTime(2026, 1, 1),
      ),
    );
    final definition = TaskDefinition(
      id: 'def-1',
      subjectId: 'subj-1',
      title: 'Review notes',
      frequency: Frequency.weekly,
      weekdays: const {Weekday.monday, Weekday.tuesday, Weekday.wednesday},
      alarmTime: const AlarmTimeOfDay(hour: 19, minute: 0),
      createdAt: DateTime(2026, 1, 1),
    );
    final now = DateTime(2026, 1, 5);
    await tasks.createDefinition(definition);
    await tasks.topUpOccurrencesFor(definition.id, now: now);
    final occurrences = await tasks.occurrencesInRange(now, now.add(const Duration(days: 3)));
    occurrences.sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));
    final monday = occurrences[0];
    final tuesday = occurrences[1];
    final wednesday = occurrences[2];

    await tasks.markCompleted(monday.id, now: DateTime(2026, 1, 5, 19, 5));
    await tasks.carryForward(
      tuesday.id,
      newAlarmAt: DateTime(2026, 1, 7, 19, 0),
    );
    await tasks.reschedule(wednesday.id, newAlarmAt: DateTime(2026, 1, 7, 21, 0));

    final all = await tasks.occurrencesInRange(DateTime(2020), DateTime(2030));

    final mondayAfter = all.firstWhere((o) => o.id == monday.id);
    expect(mondayAfter.status, OccurrenceStatus.completed);
    expect(mondayAfter.completedAt, isNotNull);

    final tuesdayAfter = all.firstWhere((o) => o.id == tuesday.id);
    expect(tuesdayAfter.status, OccurrenceStatus.carriedForward);
    final spawned = all.firstWhere((o) => o.carriedFromOccurrenceId == tuesday.id);
    expect(spawned.status, OccurrenceStatus.pending);
    expect(spawned.scheduledDate, DateTime(2026, 1, 7));
    expect(spawned.carryCount, 1);

    final wednesdayAfter = all.firstWhere((o) => o.id == wednesday.id);
    expect(wednesdayAfter.status, OccurrenceStatus.pending);
    expect(wednesdayAfter.alarmAt, DateTime(2026, 1, 7, 21, 0));
    expect(wednesdayAfter.scheduledDate, DateTime(2026, 1, 7));
  });

  test('sweepMissed flags elapsed pending occurrences', () async {
    await subjects.create(
      Subject(
        id: 'subj-1',
        name: 'Cell Biology',
        colorHue: 195,
        createdAt: DateTime(2026, 1, 1),
      ),
    );
    final definition = TaskDefinition(
      id: 'def-1',
      subjectId: 'subj-1',
      title: 'Review notes',
      frequency: Frequency.weekly,
      weekdays: const {Weekday.monday},
      alarmTime: const AlarmTimeOfDay(hour: 19, minute: 0),
      createdAt: DateTime(2025, 1, 1),
    );
    await tasks.createDefinition(definition);
    await tasks.topUpOccurrencesFor(definition.id, now: DateTime(2026, 1, 5));

    final missedCount = await tasks.sweepMissed(now: DateTime(2026, 1, 20));
    expect(missedCount, greaterThan(0));

    final all = await tasks.occurrencesInRange(DateTime(2020), DateTime(2030));
    final past = all.where((o) => o.scheduledDate.isBefore(DateTime(2026, 1, 20)));
    expect(past.every((o) => o.status == OccurrenceStatus.missed), isTrue);
  });
}
