import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

import 'attachment_storage_service.dart';

/// Adaptador de salida para Firebase Storage.
///
/// Implementa [AttachmentStorageService] usando el SDK de `firebase_storage`.
///
/// Estructura de rutas en el bucket:
/// ```
/// attachments/
///   {uploadedById}/
///     {subjectId}/
///       {id}.{ext}     ← ej. KF1zRG7e9xDpYBkLm2nA.pdf
/// ```
///
/// El [storagePath] devuelto por [uploadFile] es la ruta relativa dentro del
/// bucket (sin el prefijo `gs://`). Este valor se almacena directamente en
/// [AttachmentModel.filePath] y se reutiliza en [downloadFile] y [deleteFile].
///
/// IMPORTANTE: requiere que [FirebaseApp] esté inicializado antes de usarse.
/// Llamar `await Firebase.initializeApp(...)` en `main.dart` antes de
/// registrar este servicio.
class FirebaseStorageService implements AttachmentStorageService {
  FirebaseStorageService._();

  static final FirebaseStorageService instance = FirebaseStorageService._();

  static const _basePath = 'attachments';

  /// Límite máximo de descarga en bytes (100 MB). Previene OOM en archivos grandes.
  static const int _maxDownloadBytes = 100 * 1024 * 1024;

  /// Referencia al bucket de Firebase Storage.
  FirebaseStorage get _storage => FirebaseStorage.instance;

  // ── Helpers de normalización ──────────────────────────────────────────────

  /// Normaliza una extensión de archivo: recorta espacios, elimina puntos
  /// iniciales y convierte a minúsculas.
  ///
  /// Ejemplos: `'.PDF'` → `'pdf'`, `' .docx '` → `'docx'`, `'pdf'` → `'pdf'`
  static String _normalizeExt(String fileType) =>
      fileType.trim().replaceAll(RegExp(r'^\.+'), '').toLowerCase();

  // ── Mapa de extensión → MIME type ─────────────────────────────────────────

  static const _mimeTypes = <String, String>{
    'pdf': 'application/pdf',
    'doc': 'application/msword',
    'docx':
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'xls': 'application/vnd.ms-excel',
    'xlsx':
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    'ppt': 'application/vnd.ms-powerpoint',
    'pptx':
        'application/vnd.openxmlformats-officedocument.presentationml.presentation',
    'jpg': 'image/jpeg',
    'jpeg': 'image/jpeg',
    'png': 'image/png',
    'gif': 'image/gif',
    'bmp': 'image/bmp',
    'webp': 'image/webp',
    'heic': 'image/heic',
    'zip': 'application/zip',
    'txt': 'text/plain',
    'mp4': 'video/mp4',
    'mp3': 'audio/mpeg',
  };

  String _contentType(String fileType) =>
      _mimeTypes[_normalizeExt(fileType)] ?? 'application/octet-stream';

  // ── AttachmentStorageService ──────────────────────────────────────────────

  /// Sube [bytes] a Firebase Storage y devuelve la ruta relativa en el bucket.
  ///
  /// Ruta resultante: `attachments/{uploadedById}/{subjectId}/{id}.{ext}`
  ///
  /// Lanza [FirebaseException] si la subida falla (permisos, red, etc.).
  @override
  Future<String> uploadFile({
    required String id,
    required String fileType,
    required Uint8List bytes,
    required String uploadedById,
    required String subjectId,
  }) async {
    final ext = _normalizeExt(fileType);
    final storagePath = '$_basePath/$uploadedById/$subjectId/$id.$ext';
    final ref = _storage.ref(storagePath);
    await ref.putData(
      bytes,
      SettableMetadata(contentType: _contentType(fileType)),
    );
    return storagePath;
  }

  /// Descarga y devuelve los bytes del archivo en [storagePath].
  ///
  /// Lanza [FirebaseException] si el archivo no existe o hay error de red.
  @override
  Future<Uint8List> downloadFile(String storagePath) async {
    final ref = _storage.ref(storagePath);
    final data = await ref.getData(_maxDownloadBytes);
    if (data == null) {
      throw FirebaseException(
        plugin: 'firebase_storage',
        code: 'object-not-found',
        message: 'No se encontraron datos en la ruta: $storagePath',
      );
    }
    return data;
  }

  /// Elimina el archivo en [storagePath] del bucket.
  ///
  /// Si el archivo ya no existe, el error `object-not-found` se ignora
  /// silenciosamente para que `deleteAttachment` sea idempotente.
  @override
  Future<void> deleteFile(String storagePath) async {
    try {
      await _storage.ref(storagePath).delete();
    } on FirebaseException catch (e) {
      if (e.code != 'object-not-found') rethrow;
      // Archivo ya eliminado: no es un error desde la perspectiva del negocio.
    }
  }
}
