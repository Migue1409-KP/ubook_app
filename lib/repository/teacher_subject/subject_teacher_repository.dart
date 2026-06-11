import 'package:ubook_app/model/subjectteacher/subjectteacher.dart';

abstract class SubjectTeacherRepository {
  static SubjectTeacherRepository? _instance;

  static SubjectTeacherRepository get instance {
    final i = _instance;
    if (i == null) {
      throw StateError(
        'SubjectTeacherRepository.instance no fue inicializado. '
        'Llámalo en main.dart antes de usar el repositorio.',
      );
    }
    return i;
  }

  static void setInstance(SubjectTeacherRepository repo) {
    _instance = repo;
  }

  Future<SubjectTeacher?> findById(String id);
  Future<List<SubjectTeacher>> findAll();
  Future<List<SubjectTeacher>> findByTeacherId(String teacherId);
  Future<List<SubjectTeacher>> findBySubjectId(String subjectId);
  Future<List<SubjectTeacher>> findByTeacherIdAndPeriodo(
    String teacherId,
    String periodoId,
  );
  Future<List<SubjectTeacher>> findByPeriodo(String periodoId);

  Future<void> insertSubjectTeacher(SubjectTeacher subjectTeacher);
  Future<int> updateSubjectTeacher(SubjectTeacher subjectTeacher);

  Future<int> deleteSubjectTeacher(SubjectTeacher subjectTeacher);
  Future<void> deleteById(String id);
  Future<void> deleteAll();

  Future<int> count();
}
