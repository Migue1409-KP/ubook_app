import 'package:floor/floor.dart';
import 'package:ubook_app/model/attachments/attachment_model.dart';

@dao
abstract class AttachmentDao {
  @Query('SELECT * FROM attachments WHERE id = :id LIMIT 1')
  Future<AttachmentModel?> findById(String id);

  @Query('SELECT * FROM attachments WHERE subject_id = :subjectId')
  Future<List<AttachmentModel>> findBySubjectId(String subjectId);

  @Query('SELECT * FROM attachments WHERE teacher_id = :teacherId')
  Future<List<AttachmentModel>> findByTeacherId(String teacherId);

  @Query('SELECT * FROM attachments WHERE uploaded_by_id = :uploadedById')
  Future<List<AttachmentModel>> findByUploadedById(String uploadedById);

  @Query('SELECT * FROM attachments ORDER BY uploaded_at DESC')
  Future<List<AttachmentModel>> findAll();

  @insert
  Future<void> insertAttachment(AttachmentModel AttachmentModel);

  @update
  Future<int> updateAttachment(AttachmentModel AttachmentModel);

  @delete
  Future<int> deleteAttachment(AttachmentModel AttachmentModel);

  @Query('DELETE FROM attachments WHERE id = :id')
  Future<void> deleteById(String id);

  @Query('DELETE FROM attachments')
  Future<void> deleteAll();

  @Query('SELECT COUNT(*) FROM attachments')
  Future<int?> count();
}
