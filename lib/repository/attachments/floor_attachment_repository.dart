import 'package:ubook_app/database/app_database.dart';
import 'package:ubook_app/model/attachments/attachment.dart';
import 'package:ubook_app/repository/attachments/attachment_dao.dart';
import 'package:ubook_app/repository/attachments/attachment_local_storage.dart';

import 'attachment_repository.dart';

/// Implementación concreta de [AttachmentRepository] usando Floor + SQLite.
///
/// Sigue el mismo patrón de [FloorUserRepository]: singleton inicializado
/// una sola vez desde `main.dart` al construir la base de datos.
///
/// También expone [localStorage] para persistir el nombre del archivo
/// pendiente de subir mediante SharedPreferences.
///
/// ```dart
/// // En main.dart
/// final database = await $FloorAppDatabase.databaseBuilder('ubook_app.db').build();
/// final attachmentRepository = FloorAttachmentRepository.initialize(database);
/// ```
class FloorAttachmentRepository implements AttachmentRepository {
  FloorAttachmentRepository._(this._database);

  static late final FloorAttachmentRepository instance;

  /// Crea e inicializa el singleton. Debe llamarse una sola vez al arrancar la app.
  static FloorAttachmentRepository initialize(AppDatabase database) {
    instance = FloorAttachmentRepository._(database);
    return instance;
  }

  final AppDatabase _database;

  /// Acceso al almacenamiento local (SharedPreferences) para el nombre
  /// del archivo pendiente de subir.
  final AttachmentLocalStorage localStorage = AttachmentLocalStorage();

  @override
  Future<Attachment?> findById(String id) {
    return _database.attachmentDao.findById(id);
  }

  @override
  Future<List<Attachment>> findBySubjectId(String subjectId) {
    return _database.attachmentDao.findBySubjectId(subjectId);
  }

  @override
  Future<List<Attachment>> findByTeacherId(String teacherId) {
    return _database.attachmentDao.findByTeacherId(teacherId);
  }

  @override
  Future<List<Attachment>> findByUploadedById(String uploadedById) {
    return _database.attachmentDao.findByUploadedById(uploadedById);
  }

  @override
  Future<List<Attachment>> findAll() {
    return _database.attachmentDao.findAll();
  }

  @override
  Future<void> insertAttachment(Attachment attachment) {
    return _database.attachmentDao.insertAttachment(attachment);
  }

  @override
  Future<int> updateAttachment(Attachment attachment) {
    return _database.attachmentDao.updateAttachment(attachment);
  }

  @override
  Future<int> deleteAttachment(Attachment attachment) {
    return _database.attachmentDao.deleteAttachment(attachment);
  }

  @override
  Future<void> deleteById(String id) {
    return _database.attachmentDao.deleteById(id);
  }

  @override
  Future<void> deleteAll() {
    return _database.attachmentDao.deleteAll();
  }

  @override
  Future<int> count() async {
    return await _database.attachmentDao.count() ?? 0;
  }
}
