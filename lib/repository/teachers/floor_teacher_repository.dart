import 'package:flutter/foundation.dart';
import 'package:ubook_app/database/app_database.dart';
import 'package:ubook_app/model/teachers/teacher.dart';
import 'package:ubook_app/model/teachers/teacher_repository.dart';

class FloorTeacherRepository implements TeacherRepository {
  FloorTeacherRepository._(this._database);

  static FloorTeacherRepository? _instance;

  static FloorTeacherRepository get instance {
    final i = _instance;
    if (i == null) {
      throw StateError(
        'FloorTeacherRepository.initialize() no fue llamado',
      );
    }
    return i;
  }

  static FloorTeacherRepository initialize(AppDatabase database) {
    _instance = FloorTeacherRepository._(database);
    return _instance!;
  }

  @visibleForTesting
  static void resetForTesting() => _instance = null;

  final AppDatabase _database;

  @override
  Future<List<Teacher>> getAll() async {
    return await _database.teacherDao.findAll();
  }

  @override
  Future<Teacher> save(Teacher teacher) async {
    // Determine if insert or update by checking if it exists?
    // Since OnConflictStrategy.replace is used in insert, we can just use insert
    await _database.teacherDao.insertTeacher(teacher);
    return teacher;
  }

  Future<void> deleteTeacher(Teacher teacher) async {
    await _database.teacherDao.deleteTeacher(teacher);
  }
}
