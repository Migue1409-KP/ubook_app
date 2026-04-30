import 'package:ubook_app/model/attachments/attachment.dart';

abstract class AttachmentRepository {
  Future<Attachment?> findById(String id);
  Future<List<Attachment>> findBySubjectId(String subjectId);
  Future<List<Attachment>> findByTeacherId(String teacherId);
  Future<List<Attachment>> findByUploadedById(String uploadedById);
  Future<List<Attachment>> findAll();
  Future<void> insertAttachment(Attachment attachment);
  Future<int> updateAttachment(Attachment attachment);
  Future<int> deleteAttachment(Attachment attachment);
  Future<void> deleteById(String id);
  Future<void> deleteAll();
  Future<int> count();
}
