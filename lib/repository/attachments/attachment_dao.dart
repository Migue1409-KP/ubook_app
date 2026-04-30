import 'package:floor/floor.dart';
import 'package:ubook_app/model/attachments/attachment.dart';

@dao
abstract class AttachmentDao {
  @Query('SELECT * FROM attachments WHERE id = :id LIMIT 1')
  Future<Attachment?> findById(String id);

  @Query('SELECT * FROM attachments WHERE subject_id = :subjectId')
  Future<List<Attachment>> findBySubjectId(String subjectId);

  @Query('SELECT * FROM attachments WHERE teacher_id = :teacherId')
  Future<List<Attachment>> findByTeacherId(String teacherId);

  @Query('SELECT * FROM attachments WHERE uploaded_by_id = :uploadedById')
  Future<List<Attachment>> findByUploadedById(String uploadedById);

  @Query('SELECT * FROM attachments ORDER BY uploaded_at DESC')
  Future<List<Attachment>> findAll();

  @insert
  Future<void> insertAttachment(Attachment attachment);

  @update
  Future<int> updateAttachment(Attachment attachment);

  @delete
  Future<int> deleteAttachment(Attachment attachment);

  @Query('DELETE FROM attachments WHERE id = :id')
  Future<void> deleteById(String id);

  @Query('DELETE FROM attachments')
  Future<void> deleteAll();

  @Query('SELECT COUNT(*) FROM attachments')
  Future<int?> count();
}
