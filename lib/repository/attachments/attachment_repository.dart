import 'dart:typed_data';

import 'package:ubook_app/model/attachments/attachment_model.dart';

abstract class AttachmentRepository {
  // ── Service locator ──────────────────────────────────────────────────────────
  //
  // Permite que el ViewModel y cualquier otro consumidor obtengan la
  // implementación activa sin acoplarse a la clase concreta.
  //
  // Uso en main.dart:
  //   AttachmentRepository.setCurrent(FloorAttachmentRepository.initialize(db));
  //   // o en el futuro:
  //   AttachmentRepository.setCurrent(SupabaseAttachmentRepository.initialize());
  //
  // Uso en el ViewModel:
  //   AttachmentRepository.current.saveFile(attachment);

  static AttachmentRepository? _current;

  /// Devuelve la implementación activa registrada con [setCurrent].
  ///
  /// Lanza [StateError] si [setCurrent] no fue llamado antes.
  static AttachmentRepository get current {
    final instance = _current;
    if (instance == null) {
      throw StateError(
        'AttachmentRepository.setCurrent() no fue llamado. '
        'Llámalo en main.dart antes de usar el repositorio.',
      );
    }
    return instance;
  }

  /// Registra la implementación activa. Debe llamarse una sola vez al arrancar
  /// la app, desde main.dart.
  static void setCurrent(AttachmentRepository repo) {
    if (_current != null) {
      throw StateError(
        'AttachmentRepository.setCurrent() ya fue llamado. '
        'Llama resetForTesting() antes de registrar una nueva implementación.',
      );
    }
    _current = repo;
  }

  /// Resetea el locator. Solo para uso en tests.
  static void resetForTesting() => _current = null;

  // ── Consultas ────────────────────────────────────────────────────────────────

  Future<AttachmentModel?> findById(String id);
  Future<List<AttachmentModel>> findBySubjectId(String subjectId);
  @Deprecated('Use findBySubjectId instead')
  Future<List<AttachmentModel>> findBySubject(String subjectId);
  Future<List<AttachmentModel>> findByTeacherId(String teacherId);
  Future<List<AttachmentModel>> findByUploadedById(String uploadedById);
  Future<List<AttachmentModel>> findAll();

  // ── Escritura ────────────────────────────────────────────────────────────────

  /// Persiste los bytes en el almacenamiento y guarda el registro en la BD.
  /// Devuelve el modelo actualizado con [AttachmentModel.filePath] definido.
  Future<AttachmentModel> saveFile(AttachmentModel attachment);

  /// Inserción de bajo nivel; preferir [saveFile] para uso normal.
  Future<void> insertAttachment(AttachmentModel attachment);
  Future<int> updateAttachment(AttachmentModel attachment);

  // ── Descarga ─────────────────────────────────────────────────────────────────

  /// Descarga y devuelve los bytes del archivo asociado a [attachment].
  ///
  /// - Implementación local: lee el archivo desde el filesystem usando
  ///   [AttachmentModel.filePath] (ruta absoluta).
  /// - Implementación Supabase: descarga desde Supabase Storage usando
  ///   [AttachmentModel.filePath] como ruta relativa en el bucket.
  ///
  /// Devuelve `null` si el archivo no existe o [filePath] es `null`.
  Future<Uint8List?> downloadFileBytes(AttachmentModel attachment);

  /// Genera una URL firmada temporal para acceder al archivo sin necesidad
  /// de autenticación adicional. Permite visualizar/descargar desde el
  /// navegador o la app predeterminada del sistema.
  ///
  /// - Implementación Supabase: genera un `createSignedUrl` contra el bucket.
  /// - Implementación local: devuelve `null` (no aplica al filesystem).
  ///
  /// Devuelve `null` si no hay [filePath] o la implementación no lo soporta.
  Future<String?> getSignedUrl(AttachmentModel attachment) async => null;

  // ── Eliminación ──────────────────────────────────────────────────────────────

  /// Elimina el registro de la BD y el archivo del almacenamiento si existe.
  Future<int> deleteAttachment(AttachmentModel attachment);
  Future<void> deleteById(String id);
  Future<void> deleteAll();
  Future<int> count();
}
