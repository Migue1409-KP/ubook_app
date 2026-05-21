import 'dart:typed_data';

/// Puerto de salida para operaciones de I/O de archivos binarios.
///
/// Define el contrato que deben cumplir todos los adaptadores de almacenamiento
/// (sistema de archivos local, Firebase Storage, etc.) sin acoplar la lógica
/// de negocio a ninguna tecnología concreta.
///
/// Implementaciones disponibles:
/// - [LocalFileStorageService]: escribe/lee en el sistema de archivos del dispositivo.
/// - [FirebaseStorageService]: sube/descarga desde Firebase Storage.
abstract class AttachmentStorageService {
  /// Sube [bytes] al almacenamiento y devuelve el [storagePath] resultante.
  ///
  /// El [storagePath] devuelto se almacena en [AttachmentModel.filePath] y se
  /// usa posteriormente en [downloadFile] y [deleteFile].
  ///
  /// - Implementación local:  ruta absoluta en el sistema de archivos.
  ///   Ej: `/data/user/0/.../attachments/KF1zRG7e9xDpYBkLm2nA.pdf`
  /// - Implementación Firebase: ruta relativa en el bucket.
  ///   Ej: `attachments/uid123/subjectAbc/KF1zRG7e9xDpYBkLm2nA.pdf`
  Future<String> uploadFile({
    required String id,
    required String fileType,
    required Uint8List bytes,
    required String uploadedById,
    required String subjectId,
  });

  /// Descarga y devuelve los bytes del archivo identificado por [storagePath].
  ///
  /// [storagePath] es el valor devuelto previamente por [uploadFile].
  Future<Uint8List> downloadFile(String storagePath);

  /// Elimina el archivo identificado por [storagePath] del almacenamiento.
  ///
  /// No lanza excepción si el archivo ya no existe.
  Future<void> deleteFile(String storagePath);
}
