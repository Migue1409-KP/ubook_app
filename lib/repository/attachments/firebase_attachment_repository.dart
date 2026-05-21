import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:ubook_app/database/app_database.dart';
import 'package:ubook_app/model/attachments/attachment_model.dart';

import 'attachment_repository.dart';
import 'attachment_storage_service.dart';
import 'firebase_storage_service.dart';

/// Adaptador de salida de [AttachmentRepository] respaldado por Firebase Storage.
///
/// - **Metadata** (nombre, tipo, fechas, relaciones): almacenada en SQLite via
///   [AttachmentDao], igual que [FloorAttachmentRepository].
/// - **Archivos binarios**: subidos/descargados/eliminados en Firebase Storage
///   via [FirebaseStorageService].
///
/// [AttachmentModel.filePath] almacena la ruta relativa en el bucket de Firebase,
/// por ejemplo: `attachments/uid123/subjectAbc/KF1zRG7e9xDpYBkLm2nA.pdf`.
///
/// Sigue el mismo patrón singleton de inicialización que [FloorAttachmentRepository].
///
/// ```dart
/// // En main.dart — reemplazar FloorAttachmentRepository cuando Firebase esté listo:
/// await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
/// AttachmentRepository.setCurrent(FirebaseAttachmentRepository.initialize(database));
/// ```
class FirebaseAttachmentRepository implements AttachmentRepository {
  FirebaseAttachmentRepository._(this._database, this._storageService);

  static FirebaseAttachmentRepository? _instance;

  static FirebaseAttachmentRepository get instance {
    final i = _instance;
    if (i == null) {
      throw StateError(
        'FirebaseAttachmentRepository.initialize() no fue llamado.',
      );
    }
    return i;
  }

  /// Crea e inicializa el singleton. Debe llamarse una sola vez al arrancar la app.
  ///
  /// Opcionalmente acepta un [storageService] personalizado; si se omite usa
  /// [FirebaseStorageService.instance] (útil para tests con mocks).
  static FirebaseAttachmentRepository initialize(
    AppDatabase database, {
    AttachmentStorageService? storageService,
  }) {
    _instance = FirebaseAttachmentRepository._(
      database,
      storageService ?? FirebaseStorageService.instance,
    );
    return _instance!;
  }

  /// Resetea el singleton. Solo para uso en tests.
  @visibleForTesting
  static void resetForTesting() => _instance = null;

  final AppDatabase _database;
  final AttachmentStorageService _storageService;

  // ── Consultas (delegan en el DAO de SQLite) ───────────────────────────────

  @override
  Future<AttachmentModel?> findById(String id) =>
      _database.attachmentDao.findById(id);

  @override
  Future<List<AttachmentModel>> findBySubjectId(String subjectId) =>
      _database.attachmentDao.findBySubjectId(subjectId);

  @override
  @Deprecated('Use findBySubjectId instead')
  Future<List<AttachmentModel>> findBySubject(String subjectId) =>
      findBySubjectId(subjectId);

  @override
  Future<List<AttachmentModel>> findByTeacherId(String teacherId) =>
      _database.attachmentDao.findByTeacherId(teacherId);

  @override
  Future<List<AttachmentModel>> findByUploadedById(String uploadedById) =>
      _database.attachmentDao.findByUploadedById(uploadedById);

  @override
  Future<List<AttachmentModel>> findAll() =>
      _database.attachmentDao.findAll();

  // ── Escritura ─────────────────────────────────────────────────────────────

  /// Sube los bytes a Firebase Storage y guarda el registro en SQLite.
  ///
  /// Si [attachment.fileBytes] es `null`, realiza solo la inserción en BD
  /// (metadata sin archivo).
  ///
  /// Devuelve el modelo actualizado con:
  /// - [AttachmentModel.id] definitivo (Firestore push ID si no se proporcionó)
  /// - [AttachmentModel.filePath] con la ruta relativa en el bucket de Firebase
  @override
  Future<AttachmentModel> saveFile(AttachmentModel attachment) async {
    final bytes = attachment.fileBytes;
    if (bytes == null) {
      // Inserción solo de metadata (sin archivo binario).
      await _database.attachmentDao.insertAttachment(attachment);
      return attachment;
    }

    // Genera un ID globalmente único usando el SDK de Firestore (sin red).
    // Mismo estilo que los UIDs de Firebase Authentication.
    final id =
        attachment.id ?? FirebaseFirestore.instance.collection('_').doc().id;

    // Sube el archivo a Firebase Storage y obtiene la ruta en el bucket.
    final storagePath = await _storageService.uploadFile(
      id: id,
      fileType: attachment.fileType,
      bytes: bytes,
      uploadedById: attachment.uploadedById,
      subjectId: attachment.subjectId,
    );

    // Persiste la metadata en SQLite con filePath = ruta de Firebase.
    // Si la inserción en BD falla, elimina el archivo ya subido para evitar
    // archivos huérfanos en Firebase Storage.
    final saved = attachment.copyWith(id: id, filePath: storagePath);
    try {
      await _database.attachmentDao.insertAttachment(saved);
    } catch (e, st) {
      // La inserción en BD falló: intenta limpiar el archivo ya subido para
      // evitar huérfanos en Firebase Storage, pero sin ocultar la causa real.
      try {
        await _storageService.deleteFile(storagePath);
      } catch (cleanupError, cleanupSt) {
        debugPrint(
          'saveFile: cleanup de $storagePath falló tras error en insertAttachment'
          ' – $cleanupError\n$cleanupSt',
        );
      }
      Error.throwWithStackTrace(e, st);
    }
    return saved;
  }

  /// Inserción de bajo nivel; preferir [saveFile] para uso normal.
  @override
  Future<void> insertAttachment(AttachmentModel attachment) =>
      _database.attachmentDao.insertAttachment(attachment);

  @override
  Future<int> updateAttachment(AttachmentModel attachment) =>
      _database.attachmentDao.updateAttachment(attachment);

  // ── Descarga ──────────────────────────────────────────────────────────────

  /// Descarga y devuelve los bytes del archivo desde Firebase Storage.
  ///
  /// Usa [AttachmentModel.filePath] como ruta relativa en el bucket.
  /// Devuelve `null` si [filePath] es `null`.
  ///
  /// Lanza [FirebaseException] si el archivo no existe en el bucket o hay
  /// error de conectividad.
  @override
  Future<Uint8List?> downloadFileBytes(AttachmentModel attachment) async {
    final path = attachment.filePath;
    if (path == null) return null;
    return _storageService.downloadFile(path);
  }

  // ── Eliminación ───────────────────────────────────────────────────────────

  /// Elimina el archivo de Firebase Storage y el registro de SQLite.
  ///
  /// Si el archivo ya no existe en Firebase (ej. fue eliminado manualmente),
  /// el error `object-not-found` se ignora para no bloquear la eliminación
  /// del registro en BD.
  @override
  Future<int> deleteAttachment(AttachmentModel attachment) async {
    final storagePath = attachment.filePath;
    if (storagePath != null) {
      try {
        await _storageService.deleteFile(storagePath);
      } catch (e) {
        debugPrint(
          'deleteAttachment: no se pudo eliminar $storagePath en Firebase – $e',
        );
        rethrow;
      }
    }
    return _database.attachmentDao.deleteAttachment(attachment);
  }

  @override
  Future<void> deleteById(String id) async {
    final attachment = await _database.attachmentDao.findById(id);
    final storagePath = attachment?.filePath;
    if (storagePath != null) {
      try {
        await _storageService.deleteFile(storagePath);
      } catch (e) {
        debugPrint(
          'deleteById: no se pudo eliminar $storagePath en Firebase – $e',
        );
        rethrow;
      }
    }
    return _database.attachmentDao.deleteById(id);
  }

  @override
  Future<void> deleteAll() async {
    final attachments = await _database.attachmentDao.findAll();
    for (final attachment in attachments) {
      final storagePath = attachment.filePath;
      if (storagePath != null) {
        try {
          await _storageService.deleteFile(storagePath);
        } catch (e) {
          debugPrint(
            'deleteAll: no se pudo eliminar $storagePath en Firebase – $e',
          );
          rethrow;
        }
      }
    }
    return _database.attachmentDao.deleteAll();
  }

  @override
  Future<int> count() async =>
      await _database.attachmentDao.count() ?? 0;
}
