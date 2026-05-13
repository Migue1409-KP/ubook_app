import 'package:floor/floor.dart';
import 'package:ubook_app/model/subjectteacher/subjectteacher.dart';

@dao
abstract class SubjectTeacherDao {
  @Query('SELECT * FROM subject_teachers WHERE id = :id LIMIT 1')
  Future<SubjectTeacher?> findById(String id);

  @Query('SELECT * FROM subject_teachers ORDER BY created_at_ms DESC')
  Future<List<SubjectTeacher>> findAll();

  @Query('SELECT * FROM subject_teachers WHERE teacher_id = :teacherId')
  Future<List<SubjectTeacher>> findByTeacherId(String teacherId);

  @Query('SELECT * FROM subject_teachers WHERE subject_id = :subjectId')
  Future<List<SubjectTeacher>> findBySubjectId(String subjectId);

  @insert
  Future<void> insertSubjectTeacher(SubjectTeacher subjectTeacher);

  @update
  Future<int> updateSubjectTeacher(SubjectTeacher subjectTeacher);

  @delete
  Future<int> deleteSubjectTeacher(SubjectTeacher subjectTeacher);

  @Query('DELETE FROM subject_teachers WHERE id = :id')
  Future<void> deleteById(String id);

  @Query('DELETE FROM subject_teachers')
  Future<void> deleteAll();

  @Query('SELECT COUNT(*) FROM subject_teachers')
  Future<int?> count();
}
