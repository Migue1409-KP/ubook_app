import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:ubook_app/model/teachers/teacher.dart';
import 'package:ubook_app/model/teachers/teacher_repository.dart';
import 'package:ubook_app/database/teacher_database.dart';

class SqliteTeacherRepository implements TeacherRepository {
  SqliteTeacherRepository._internal();
  static final SqliteTeacherRepository instance =
      SqliteTeacherRepository._internal();

  @override
  Future<Teacher> save(Teacher teacher) async {
    final db = await TeacherDatabase.instance.database;

    final map = teacher.toJson();
    // Subjects is a List in JSON, convert it to a string for SQLite
    map['subjects'] = jsonEncode(teacher.subjects);
    map['is_active'] = teacher.isActive ? 1 : 0;

    await db.insert(
      'teachers',
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return teacher;
  }

  @override
  Future<List<Teacher>> getAll() async {
    final db = await TeacherDatabase.instance.database;
    final result = await db.query('teachers');

    return result.map((json) {
      final map = Map<String, dynamic>.from(json);
      // Restore subjects from JSON string
      if (map['subjects'] != null && map['subjects'] is String) {
        try {
          map['subjects'] = jsonDecode(map['subjects'] as String);
        } catch (e) {
          map['subjects'] = [];
        }
      }
      map['is_active'] = (map['is_active'] == 1);
      return Teacher.fromJson(map);
    }).toList();
  }
}
