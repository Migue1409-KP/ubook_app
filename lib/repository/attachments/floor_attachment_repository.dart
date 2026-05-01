import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:ubook_app/database/app_database.dart';
import 'package:ubook_app/model/attachments/attachment_model.dart';
import 'package:flutter/foundation.dart';

import 'attachment_repository.dart';

/// Implementación concreta de [AttachmentRepository] usando Floor + SQLite.
///
/// Sigue el mismo patrón de [FloorUserRepository]: singleton inicializado
/// una sola vez desde `main.dart` al construir la base de datos.
///
/// ```dart
/// // En main.dart
/// final database = await $FloorAppDatabase.databaseBuilder('ubook_app.db').build();
/// final attachmentRepository = FloorAttachmentRepository.initialize(database);
/// ```
class FloorAttachmentRepository implements AttachmentRepository {
  FloorAttachmentRepository._(this._database);

  static FloorAttachmentRepository? _instance;

  static FloorAttachmentRepository get instance {
    final i = _instance;
    if (i == null) {
      throw StateError('FloorAttachmentRepository.initialize() no fue llamado');
    }
    return i;
  }

  /// Crea e inicializa el singleton. Debe llamarse una sola vez al arrancar la app.
  static FloorAttachmentRepository initialize(AppDatabase database) {
    _instance = FloorAttachmentRepository._(database);
    return _instance!;
  }

  /// Resetea el singleton. Solo para uso en tests.
  @visibleForTesting
  static void resetForTesting() => _instance = null;

  final AppDatabase _database;

  @override
  Future<AttachmentModel?> findById(String id) {
    return _database.attachmentDao.findById(id);
  }

  @override
  Future<List<AttachmentModel>> findBySubjectId(String subjectId) {
    return _database.attachmentDao.findBySubjectId(subjectId);
  }

  @override
  Future<List<AttachmentModel>> findByTeacherId(String teacherId) {
    return _database.attachmentDao.findByTeacherId(teacherId);
  }

  @override
  Future<List<AttachmentModel>> findByUploadedById(String uploadedById) {
    return _database.attachmentDao.findByUploadedById(uploadedById);
  }

  @override
  Future<List<AttachmentModel>> findAll() {
    return _database.attachmentDao.findAll();
  }

  @override
  @Deprecated('Use findBySubjectId instead')
  Future<List<AttachmentModel>> findBySubject(String subjectId) =>
      findBySubjectId(subjectId);

  @override
  Future<AttachmentModel> saveFile(AttachmentModel attachment) async {
    final bytes = attachment.fileBytes;
    if (bytes == null) {
      await _database.attachmentDao.insertAttachment(attachment);
      return attachment;
    }
    // Directorio persistente de la app (no limpiado por el SO).
    final dir = await getApplicationDocumentsDirectory();
    final destDir = Directory(p.join(dir.path, 'attachments'));
    if (!await destDir.exists()) await destDir.create(recursive: true);
    // Nombre físico = id + extensión → evita colisiones entre archivos
    // con el mismo nombre de usuario (ej. dos "tarea.pdf" distintos).
    final id =
        attachment.id ?? DateTime.now().microsecondsSinceEpoch.toString();
    final ext = attachment.fileType
        .toLowerCase(); // usar fileType; no depender del nombre del archivo
    final filePath = p.join(destDir.path, '$id.$ext');
    await File(filePath).writeAsBytes(bytes, flush: true);
    final saved = attachment.copyWith(id: id, filePath: filePath);
    await _database.attachmentDao.insertAttachment(saved);
    return saved;
  }

  @override
  Future<int> deleteAttachment(AttachmentModel attachment) async {
    // Elimina el archivo local si existe antes de borrar el registro.
    final localPath = attachment.filePath;
    if (localPath != null) {
      final f = File(localPath);
      if (await f.exists()) await f.delete();
    }
    return _database.attachmentDao.deleteAttachment(attachment);
  }

  /// Inserción de bajo nivel; preferir [saveFile] para uso normal.
  @override
  Future<void> insertAttachment(AttachmentModel attachment) {
    return _database.attachmentDao.insertAttachment(attachment);
  }

  @override
  Future<int> updateAttachment(AttachmentModel attachment) {
    return _database.attachmentDao.updateAttachment(attachment);
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
