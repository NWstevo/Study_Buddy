import 'package:drift/drift.dart';

import '../models/subject.dart';
import 'database.dart';

class SubjectRepository {
  SubjectRepository(this._db);

  final AppDatabase _db;

  Stream<List<Subject>> watchActive() {
    final query = _db.select(_db.subjects)
      ..where((s) => s.archivedAt.isNull())
      ..orderBy([(s) => OrderingTerm.asc(s.createdAt)]);
    return query.watch().map((rows) => rows.map(_toModel).toList());
  }

  Stream<List<Subject>> watchAll() {
    final query = _db.select(_db.subjects)
      ..orderBy([(s) => OrderingTerm.asc(s.createdAt)]);
    return query.watch().map((rows) => rows.map(_toModel).toList());
  }

  Future<Subject?> getById(String id) async {
    final query = _db.select(_db.subjects)
      ..where((s) => s.id.equals(id));
    final row = await query.getSingleOrNull();
    return row == null ? null : _toModel(row);
  }

  Future<void> create(Subject subject) {
    return _db.into(_db.subjects).insert(_toCompanion(subject));
  }

  Future<void> update(Subject subject) {
    return _db.update(_db.subjects).replace(_toCompanion(subject));
  }

  /// Soft-delete only — never hard-delete a subject with any task
  /// occurrences, it would corrupt past reports (DATA_MODEL.md).
  Future<void> archive(String id) {
    return (_db.update(_db.subjects)..where((s) => s.id.equals(id))).write(
      SubjectsCompanion(archivedAt: Value(DateTime.now())),
    );
  }

  Future<void> unarchive(String id) {
    return (_db.update(_db.subjects)..where((s) => s.id.equals(id))).write(
      const SubjectsCompanion(archivedAt: Value(null)),
    );
  }

  Subject _toModel(SubjectRow row) {
    return Subject(
      id: row.id,
      name: row.name,
      colorHue: row.colorHue,
      createdAt: row.createdAt,
      archivedAt: row.archivedAt,
    );
  }

  SubjectsCompanion _toCompanion(Subject subject) {
    return SubjectsCompanion(
      id: Value(subject.id),
      name: Value(subject.name),
      colorHue: Value(subject.colorHue),
      createdAt: Value(subject.createdAt),
      archivedAt: Value(subject.archivedAt),
    );
  }
}
