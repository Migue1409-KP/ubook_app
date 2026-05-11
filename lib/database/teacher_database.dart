import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../model/teachers/teacher.dart';
import '../repository/teachers/teacher_dao.dart';
import 'converters/string_list_converter.dart';

part 'teacher_database.g.dart';

@TypeConverters([StringListConverter])
@Database(version: 1, entities: [Teacher])
abstract class TeacherDatabase extends FloorDatabase {
  TeacherDao get teacherDao;
}
