import 'package:ubook_app/model/subjectteacher/subjectteacher.dart';

abstract class SubjectTeacherRepository {
  Future<SubjectTeacher?> findById(String id);
  Future<List<SubjectTeacher>> findAll();
  Future<List<SubjectTeacher>> findByTeacherId(String teacherId);
  Future<List<SubjectTeacher>> findBySubjectId(String subjectId);

  Future<void> insertSubjectTeacher(SubjectTeacher subjectTeacher);
  Future<int> updateSubjectTeacher(SubjectTeacher subjectTeacher);

  Future<int> deleteSubjectTeacher(SubjectTeacher subjectTeacher);
  Future<void> deleteById(String id);
  Future<void> deleteAll();

  Future<int> count();
}
