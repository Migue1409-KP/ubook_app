import '../../model/teachers/teacher.dart';

abstract class TeacherRepository {
  Future<List<Teacher>> getTeachers();
  Future<Teacher?> getTeacherById(String id);
  Future<void> saveTeacher(Teacher teacher);
  Future<void> updateTeacher(Teacher teacher);
  Future<void> deleteTeacher(Teacher teacher);
  Future<void> ensureInitialized();
}
