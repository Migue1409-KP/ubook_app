import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Supabase;
import 'package:ubook_app/model/attachments/attachment_model.dart';

import 'attachment_repository.dart';
import 'attachment_storage_service.dart';
import 'firebase_storage_service.dart';

/// Adaptador de salida de [AttachmentRepository] que combina dos backends:
///
/// - **Metadata** (nombre, tipo, fechas, relaciones): almacenada en Cloud
///   Firestore en la colección `attachments`.
/// - **Archivos binarios**: subidos/descargados/eliminados en Supabase Storage
///   via [SupabaseStorageService].
///
/// [AttachmentModel.filePath] almacena la ruta relativa en el bucket de
/// Supabase, por ejemplo:
/// `attachments/uid123/subjectAbc/KF1zRG7e9xDpYBkLm2nA.pdf`.
///
/// Sigue el mismo patrón singleton de inicialización que los demás repositorios.
///
/// ```dart
/// // En main.dart:
/// await Supabase.initialize(url: '...', anonKey: '...');
/// await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
/// AttachmentRepository.setCurrent(SupabaseAttachmentRepository.initialize());
/// ```
class SupabaseAttachmentRepository implements AttachmentRepository {
  SupabaseAttachmentRepository._(this._firestore, this._storageService);

  static SupabaseAttachmentRepository? _instance;

  static SupabaseAttachmentRepository get instance {
    final i = _instance;
    if (i == null) {
      throw StateError(
        'SupabaseAttachmentRepository.initialize() no fue llamado.',
      );
    }
    return i;
  }

  /// Crea e inicializa el singleton. Debe llamarse una sola vez al arrancar
  /// la app, después de inicializar Firebase y Supabase.
  ///
  /// Acepta dependencias opcionales [firestore] y [storageService] para
  /// facilitar los tests con mocks.
  static SupabaseAttachmentRepository initialize({
    FirebaseFirestore? firestore,
    AttachmentStorageService? storageService,
  }) {
    _instance = SupabaseAttachmentRepository._(
      firestore ?? FirebaseFirestore.instance,
      storageService ?? SupabaseStorageService.instance,
    );
    return _instance!;
  }

  /// Resetea el singleton. Solo para uso en tests.
  @visibleForTesting
  static void resetForTesting() => _instance = null;

  final FirebaseFirestore _firestore;
  final AttachmentStorageService _storageService;

  /// Nombre de la colección en Firestore donde se guardan los metadatos.
  static const _collection = 'attachments';

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection(_collection);

  // ── Serialización Firestore ───────────────────────────────────────────────

  /// Convierte un [AttachmentModel] al mapa que se almacena en Firestore.
  /// El ID del documento es [AttachmentModel.id] y no se incluye en el mapa.
  static Map<String, dynamic> _toMap(AttachmentModel m) => {
    'file_name': m.fileName,
    'file_type': m.fileType,
    'uploaded_by_id': m.uploadedById,
    'subject_id': m.subjectId,
    'teacher_id': m.teacherId,
    if (m.filePath != null) 'file_path': m.filePath,
    if (m.fileSize != null) 'file_size': m.fileSize,
    'uploaded_at': m.uploadedAtMs,
  };

  /// Reconstruye un [AttachmentModel] a partir de un documento de Firestore.
  static AttachmentModel _fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final d = doc.data()!;
    return AttachmentModel(
      id: doc.id,
      fileName: d['file_name'] as String,
      fileType: d['file_type'] as String,
      uploadedById: d['uploaded_by_id'] as String,
      subjectId: d['subject_id'] as String,
      teacherId: d['teacher_id'] as String,
      filePath: d['file_path'] as String?,
      fileSize: (d['file_size'] as num?)?.toInt(),
      uploadedAtMs: (d['uploaded_at'] as num).toInt(),
    );
  }

  // ── Consultas ─────────────────────────────────────────────────────────────

  @override
  Future<AttachmentModel?> findById(String id) async {
    final doc = await _col.doc(id).get();
    if (!doc.exists || doc.data() == null) return null;
    return _fromDoc(doc);
  }

  @override
  Future<List<AttachmentModel>> findBySubjectId(String subjectId) async {
    final qs = await _col
        .where('subject_id', isEqualTo: subjectId)
        .orderBy('uploaded_at', descending: true)
        .get();
    return qs.docs.map(_fromDoc).toList();
  }

  @override
  @Deprecated('Use findBySubjectId instead')
  Future<List<AttachmentModel>> findBySubject(String subjectId) =>
      findBySubjectId(subjectId);

  @override
  Future<List<AttachmentModel>> findByTeacherId(String teacherId) async {
    final qs = await _col
        .where('teacher_id', isEqualTo: teacherId)
        .orderBy('uploaded_at', descending: true)
        .get();
    return qs.docs.map(_fromDoc).toList();
  }

  @override
  Future<List<AttachmentModel>> findByUploadedById(String uploadedById) async {
    final qs = await _col
        .where('uploaded_by_id', isEqualTo: uploadedById)
        .orderBy('uploaded_at', descending: true)
        .get();
    return qs.docs.map(_fromDoc).toList();
  }

  @override
  Future<List<AttachmentModel>> findAll() async {
    final qs = await _col
        .orderBy('uploaded_at', descending: true)
        .get();
    return qs.docs.map(_fromDoc).toList();
  }

  // ── Escritura ─────────────────────────────────────────────────────────────

  /// Sube el archivo a Supabase Storage y guarda los metadatos en Firestore.
  ///
  /// Si [attachment.fileBytes] es `null`, realiza solo la inserción en
  /// Firestore (metadata sin archivo binario).
  ///
  /// Devuelve el modelo actualizado con:
  /// - [AttachmentModel.id] definitivo (push ID de Firestore si no se proporcionó)
  /// - [AttachmentModel.filePath] con la ruta relativa en el bucket de Supabase
  @override
  Future<AttachmentModel> saveFile(AttachmentModel attachment) async {
    // Genera un ID localmente usando el SDK de Firestore (sin red).
    final id =
        attachment.id ?? _firestore.collection('_').doc().id;

    final bytes = attachment.fileBytes;

    if (bytes == null) {
      // Solo metadata, sin archivo binario.
      final saved = attachment.copyWith(id: id);
      await _col.doc(id).set(_toMap(saved));
      return saved;
    }

    // Sube el archivo a Supabase Storage y obtiene la ruta en el bucket.
    final storagePath = await _storageService.uploadFile(
      id: id,
      fileType: attachment.fileType,
      bytes: bytes,
      uploadedById: attachment.uploadedById,
      subjectId: attachment.subjectId,
    );

    // Persiste la metadata en Firestore con filePath = ruta de Supabase.
    // Si Firestore falla, elimina el archivo ya subido para evitar huérfanos.
    final saved = attachment.copyWith(id: id, filePath: storagePath);
    try {
      await _col.doc(id).set(_toMap(saved));
    } catch (e, st) {
      try {
        await _storageService.deleteFile(storagePath);
      } catch (cleanupError, cleanupSt) {
        debugPrint(
          'saveFile: cleanup de $storagePath falló tras error en Firestore'
          ' – $cleanupError\n$cleanupSt',
        );
      }
      Error.throwWithStackTrace(e, st);
    }
    return saved;
  }

  /// Inserción de bajo nivel; preferir [saveFile] para uso normal.
  @override
  Future<void> insertAttachment(AttachmentModel attachment) async {
    final id = attachment.id ?? _firestore.collection('_').doc().id;
    final saved = attachment.copyWith(id: id);
    await _col.doc(id).set(_toMap(saved));
  }

  @override
  Future<int> updateAttachment(AttachmentModel attachment) async {
    final id = attachment.id;
    if (id == null) return 0;
    try {
      await _col.doc(id).update(_toMap(attachment));
      return 1;
    } on FirebaseException catch (e) {
      if (e.code == 'not-found') return 0;
      rethrow;
    }
  }

  // ── Descarga ──────────────────────────────────────────────────────────────

  /// Descarga y devuelve los bytes del archivo desde Supabase Storage.
  ///
  /// Usa [AttachmentModel.filePath] como ruta relativa en el bucket.
  /// Devuelve `null` si [filePath] es `null`.
  ///
  /// Lanza [StorageException] si el archivo no existe o hay error de red.
  @override
  Future<Uint8List?> downloadFileBytes(AttachmentModel attachment) async {
    final path = attachment.filePath;
    if (path == null) return null;
    return _storageService.downloadFile(path);
  }

  /// Genera una URL firmada temporal (1 hora) para visualizar/descargar el
  /// archivo desde el navegador o la app del sistema.
  @override
  Future<String?> getSignedUrl(AttachmentModel attachment) async {
    final path = attachment.filePath;
    if (path == null) return null;
    return Supabase.instance.client.storage
        .from('ubook_attachments')
        .createSignedUrl(path, 3600);
  }

  // ── Eliminación ───────────────────────────────────────────────────────────

  /// Elimina el archivo de Supabase Storage y el documento de Firestore.
  ///
  /// Si el archivo ya no existe en Supabase (ej. fue eliminado manualmente),
  /// el error 404 se ignora para no bloquear la eliminación del documento.
  @override
  Future<int> deleteAttachment(AttachmentModel attachment) async {
    final storagePath = attachment.filePath;
    if (storagePath != null) {
      try {
        await _storageService.deleteFile(storagePath);
      } catch (e) {
        debugPrint(
          'deleteAttachment: no se pudo eliminar $storagePath en Supabase – $e',
        );
        rethrow;
      }
    }
    final id = attachment.id;
    if (id == null) return 0;
    await _col.doc(id).delete();
    return 1;
  }

  @override
  Future<void> deleteById(String id) async {
    final attachment = await findById(id);
    final storagePath = attachment?.filePath;
    if (storagePath != null) {
      try {
        await _storageService.deleteFile(storagePath);
      } catch (e) {
        debugPrint(
          'deleteById: no se pudo eliminar $storagePath en Supabase – $e',
        );
        rethrow;
      }
    }
    await _col.doc(id).delete();
  }

  @override
  Future<void> deleteAll() async {
    final attachments = await findAll();
    for (final attachment in attachments) {
      final storagePath = attachment.filePath;
      if (storagePath != null) {
        try {
          await _storageService.deleteFile(storagePath);
        } catch (e) {
          debugPrint(
            'deleteAll: no se pudo eliminar $storagePath en Supabase – $e',
          );
          rethrow;
        }
      }
    }
    // Elimina todos los documentos en lotes de 500 (límite de Firestore batch).
    final qs = await _col.get();
    const batchLimit = 500;
    for (var i = 0; i < qs.docs.length; i += batchLimit) {
      final batch = _firestore.batch();
      final end = (i + batchLimit).clamp(0, qs.docs.length);
      for (final doc in qs.docs.sublist(i, end)) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    }
  }

  @override
  Future<int> count() async {
    final snap = await _col.count().get();
    return snap.count ?? 0;
  }
}
