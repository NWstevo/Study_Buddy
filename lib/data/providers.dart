import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'database.dart';
import 'subject_repository.dart';
import 'task_repository.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}

@Riverpod(keepAlive: true)
SubjectRepository subjectRepository(Ref ref) {
  return SubjectRepository(ref.watch(appDatabaseProvider));
}

@Riverpod(keepAlive: true)
TaskRepository taskRepository(Ref ref) {
  return TaskRepository(ref.watch(appDatabaseProvider));
}
