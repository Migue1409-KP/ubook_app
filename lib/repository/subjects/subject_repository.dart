import '../../model/subjects/subject_entity.dart';

abstract class SubjectRepository {
  static SubjectRepository? _instance;

  static SubjectRepository get instance {
    final repo = _instance;
    if (repo == null) {
      throw StateError(
        'SubjectRepository.instance no fue inicializado. '
        'Inicialízalo en main.dart antes de usarlo.',
      );
    }
    return repo;
  }

  static void setInstance(SubjectRepository repo) {
    _instance = repo;
  }

  Future<List<SubjectEntity>> getSubjects();
  Future<SubjectEntity?> getSubjectById(String subjectId);
  Future<void> addSubject(SubjectEntity subject);
  Future<void> updateSubject(SubjectEntity subject);
  Future<void> deleteSubject(String subjectId);
}
