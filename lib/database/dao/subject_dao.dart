import 'package:floor/floor.dart';
import '../../database/entity/subject_entity.dart';

@dao
abstract class SubjectDao {
  @Query('SELECT * FROM subjects ORDER BY last_update DESC')
  Future<List<SubjectEntity>> getAllSubjects();

  @Query('SELECT * FROM subjects WHERE id = :id')
  Future<SubjectEntity?> getSubjectById(String id);

  @insert
  Future<void> insertSubject(SubjectEntity subject);

  @update
  Future<void> updateSubject(SubjectEntity subject);

  @delete
  Future<void> deleteSubject(SubjectEntity subject);

  @Query('SELECT * FROM subjects WHERE is_sync = 0 ORDER BY last_update DESC')
  Future<List<SubjectEntity>> getPendingSyncSubjects();
}
