import 'package:flutter/foundation.dart';
import 'package:ubook_app/database/app_database.dart';
import 'package:ubook_app/model/subjectteacher/subjectteacher.dart';

import 'subject_teacher_repository.dart';

/// Implementación concreta de [SubjectTeacherRepository] usando Floor + SQLite.
///
/// Sigue el mismo patrón de [FloorAttachmentRepository]: singleton inicializado
/// una sola vez desde `main.dart` al construir la base de datos.
///
/// ```dart
/// final database = await $FloorAppDatabase.databaseBuilder('ubook_app.db').build();
/// final subjectTeacherRepository = FloorSubjectTeacherRepository.initialize(database);
/// ```
class FloorSubjectTeacherRepository implements SubjectTeacherRepository {
  FloorSubjectTeacherRepository._(this._database);

  static FloorSubjectTeacherRepository? _instance;

  static FloorSubjectTeacherRepository get instance {
    final i = _instance;
    if (i == null) {
      throw StateError(
        'FloorSubjectTeacherRepository.initialize() no fue llamado',
      );
    }
    return i;
  }

  /// Crea e inicializa el singleton. Debe llamarse una sola vez al arrancar la app.
  static FloorSubjectTeacherRepository initialize(AppDatabase database) {
    _instance = FloorSubjectTeacherRepository._(database);
    return _instance!;
  }

  /// Resetea el singleton. Solo para uso en tests.
  @visibleForTesting
  static void resetForTesting() => _instance = null;

  final AppDatabase _database;

  @override
  Future<SubjectTeacher?> findById(String id) {
    return _database.subjectTeacherDao.findById(id);
  }

  @override
  Future<List<SubjectTeacher>> findAll() {
    return _database.subjectTeacherDao.findAll();
  }

  @override
  Future<List<SubjectTeacher>> findByTeacherId(String teacherId) {
    return _database.subjectTeacherDao.findByTeacherId(teacherId);
  }

  @override
  Future<List<SubjectTeacher>> findBySubjectId(String subjectId) {
    return _database.subjectTeacherDao.findBySubjectId(subjectId);
  }

  @override
  Future<void> insertSubjectTeacher(SubjectTeacher subjectTeacher) {
    return _database.subjectTeacherDao.insertSubjectTeacher(subjectTeacher);
  }

  @override
  Future<int> updateSubjectTeacher(SubjectTeacher subjectTeacher) {
    return _database.subjectTeacherDao.updateSubjectTeacher(subjectTeacher);
  }

  @override
  Future<int> deleteSubjectTeacher(SubjectTeacher subjectTeacher) {
    return _database.subjectTeacherDao.deleteSubjectTeacher(subjectTeacher);
  }

  @override
  Future<void> deleteById(String id) {
    return _database.subjectTeacherDao.deleteById(id);
  }

  @override
  Future<void> deleteAll() {
    return _database.subjectTeacherDao.deleteAll();
  }

  @override
  Future<int> count() async {
    return await _database.subjectTeacherDao.count() ?? 0;
  }
}
