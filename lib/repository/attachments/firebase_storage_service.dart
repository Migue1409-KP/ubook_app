import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'attachment_storage_service.dart';

/// Adaptador de salida para Supabase Storage.
///
/// Implementa [AttachmentStorageService] usando el SDK de `supabase_flutter`.
///
/// Estructura de rutas dentro del bucket [_bucket]:
/// ```
/// attachments/
///   {uploadedById}/
///     {subjectId}/
///       {id}.{ext}     ← ej. KF1zRG7e9xDpYBkLm2nA.pdf
/// ```
///
/// El [storagePath] devuelto por [uploadFile] es la ruta relativa dentro del
/// bucket. Este valor se almacena en [AttachmentModel.filePath] y se reutiliza
/// en [downloadFile] y [deleteFile].
///
/// IMPORTANTE: requiere que [Supabase] esté inicializado antes de usarse.
/// Llamar `await Supabase.initialize(url: ..., anonKey: ...)` en `main.dart`
/// antes de registrar este servicio.
class SupabaseStorageService implements AttachmentStorageService {
  SupabaseStorageService._();

  static final SupabaseStorageService instance = SupabaseStorageService._();

  /// Nombre del bucket de Supabase Storage donde se almacenan los archivos.
  /// Debe coincidir con el bucket creado en el proyecto de Supabase.
  static const _bucket = 'ubook_attachments';

  /// Prefijo de ruta dentro del bucket.
  static const _basePath = 'attachments';

  SupabaseStorageClient get _storage => Supabase.instance.client.storage;

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

  /// Sube [bytes] a Supabase Storage y devuelve la ruta relativa en el bucket.
  ///
  /// Ruta resultante: `attachments/{uploadedById}/{subjectId}/{id}.{ext}`
  ///
  /// Lanza [StorageException] si la subida falla (permisos, red, etc.).
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
    await _storage.from(_bucket).uploadBinary(
      storagePath,
      bytes,
      fileOptions: FileOptions(contentType: _contentType(fileType)),
    );
    return storagePath;
  }

  /// Descarga y devuelve los bytes del archivo en [storagePath].
  ///
  /// Lanza [StorageException] si el archivo no existe o hay error de red.
  @override
  Future<Uint8List> downloadFile(String storagePath) async {
    return _storage.from(_bucket).download(storagePath);
  }

  /// Elimina el archivo en [storagePath] del bucket.
  ///
  /// Si el archivo ya no existe, el error 404 se ignora silenciosamente
  /// para que `deleteAttachment` sea idempotente.
  @override
  Future<void> deleteFile(String storagePath) async {
    try {
      await _storage.from(_bucket).remove([storagePath]);
    } on StorageException catch (e) {
      // Archivo ya eliminado: no es un error desde la perspectiva del negocio.
      if (e.statusCode == '404' ||
          e.message.toLowerCase().contains('not found')) {
        return;
      }
      rethrow;
    }
  }
}
