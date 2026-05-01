import 'package:ubook_app/model/attachments/attachment_model.dart';

abstract class AttachmentRepository {
  Future<AttachmentModel?> findById(String id);
  Future<List<AttachmentModel>> findBySubjectId(String subjectId);
  @Deprecated('Use findBySubjectId instead')
  Future<List<AttachmentModel>> findBySubject(String subjectId);
  Future<List<AttachmentModel>> findByTeacherId(String teacherId);
  Future<List<AttachmentModel>> findByUploadedById(String uploadedById);
  Future<List<AttachmentModel>> findAll();

  /// Persiste los bytes en el sistema de archivos y guarda el registro en la BD.
  /// Devuelve el modelo actualizado con [AttachmentModel.filePath] definido.
  Future<AttachmentModel> saveFile(AttachmentModel attachment);

  /// Inserción de bajo nivel; preferir [saveFile] para uso normal.
  Future<void> insertAttachment(AttachmentModel attachment);
  Future<int> updateAttachment(AttachmentModel attachment);

  /// Elimina el registro de la BD y el archivo local si existe.
  Future<int> deleteAttachment(AttachmentModel attachment);
  Future<void> deleteById(String id);
  Future<void> deleteAll();
  Future<int> count();
}
