import 'package:floor/floor.dart';
import '../../model/teachers/teacher.dart';

@dao
abstract class TeacherDao {
  @Query('SELECT * FROM teachers')
  Future<List<Teacher>> findAllTeachers();

  @Query('SELECT * FROM teachers WHERE id = :id')
  Future<Teacher?> findTeacherById(String id);

  @insert
  Future<void> insertTeacher(Teacher teacher);

  @update
  Future<void> updateTeacher(Teacher teacher);

  @delete
  Future<void> deleteTeacher(Teacher teacher);

  @Query('SELECT COUNT(*) FROM teachers')
  Future<int?> countTeachers();

  @insert
  Future<void> insertTeachers(List<Teacher> teachers);
}
