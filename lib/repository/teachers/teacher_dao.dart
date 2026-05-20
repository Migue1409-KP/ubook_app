import 'package:floor/floor.dart';
import 'package:ubook_app/model/teachers/teacher.dart';

@dao
abstract class TeacherDao {
  @Query('SELECT * FROM teachers')
  Future<List<Teacher>> findAll();

  @Query('SELECT * FROM teachers WHERE id = :id')
  Future<Teacher?> findById(String id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertTeacher(Teacher teacher);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateTeacher(Teacher teacher);

  @delete
  Future<void> deleteTeacher(Teacher teacher);
}
