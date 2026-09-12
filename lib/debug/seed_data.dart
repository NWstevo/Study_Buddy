import '../data/subject_repository.dart';
import '../data/task_repository.dart';
import '../models/subject.dart';
import '../models/task_definition.dart';
import '../models/weekday.dart';

/// Debug-only demo data (mirrors Main.dc.html's mockup content) so the
/// weekly view has something to show before M3 builds task creation.
/// Delete this file once M3 ships.
Future<void> seedDebugDataIfEmpty({
  required SubjectRepository subjectRepository,
  required TaskRepository taskRepository,
}) async {
  final existing = await subjectRepository.watchAll().first;
  if (existing.isNotEmpty) return;

  final now = DateTime.now();
  final today = Weekday.fromDateTime(now);

  final calculus = Subject(
    id: 'seed-subj-calculus',
    name: 'Calculus II',
    colorHue: 240,
    createdAt: now,
  );
  final biology = Subject(
    id: 'seed-subj-biology',
    name: 'Cell Biology',
    colorHue: 195,
    createdAt: now,
  );
  await subjectRepository.create(calculus);
  await subjectRepository.create(biology);

  await taskRepository.createDefinition(
    TaskDefinition(
      id: 'seed-def-integrals',
      subjectId: calculus.id,
      title: 'Practice set — integrals',
      frequency: Frequency.weekly,
      weekdays: {today},
      alarmTime: const AlarmTimeOfDay(hour: 7, minute: 30),
      deadline: DateTime(now.year, now.month, now.day + 1),
      createdAt: now,
    ),
  );
  await taskRepository.createDefinition(
    TaskDefinition(
      id: 'seed-def-notes',
      subjectId: calculus.id,
      title: 'Review lecture notes',
      frequency: Frequency.weekly,
      weekdays: {today},
      alarmTime: const AlarmTimeOfDay(hour: 19, minute: 0),
      createdAt: now,
    ),
  );
  await taskRepository.createDefinition(
    TaskDefinition(
      id: 'seed-def-lab-report',
      subjectId: biology.id,
      title: 'Lab report draft',
      frequency: Frequency.weekly,
      weekdays: {today},
      alarmTime: const AlarmTimeOfDay(hour: 16, minute: 0),
      createdAt: now,
    ),
  );
}
