import 'package:floor/floor.dart';
import 'package:ubook_app/model/subjects/subject_entity.dart';

@dao
abstract class SubjectDao {
  @Query('SELECT * FROM subjects')
  Future<List<SubjectEntity>> findAllSubjects();

  @Query('SELECT * FROM subjects WHERE id = :id')
  Future<SubjectEntity?> findSubjectById(String id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertSubject(SubjectEntity subject);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateSubject(SubjectEntity subject);

  @Query('DELETE FROM subjects WHERE id = :id')
  Future<void> deleteSubjectById(String id);
}
