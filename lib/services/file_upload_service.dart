import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

/// Servicio para subir archivos a Firebase Storage
/// Maneja upload de sílabos y documentos adjuntos
class FileUploadService {
  FileUploadService._internal();

  static final FileUploadService _instance = FileUploadService._internal();

  factory FileUploadService() {
    return _instance;
  }

  static FileUploadService get instance => _instance;

  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Rutas base en Firebase Storage
  static const String _subjectsBasePath = 'subjects';
  static const String _syllabusPath = 'syllabi';

  /// Sube un sílabo a Firebase Storage
  /// Retorna la URL descargable del archivo
  Future<String?> uploadSyllabus({
    required String subjectId,
    required File file,
  }) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      final ref = _storage.ref().child('$_subjectsBasePath/$subjectId/$_syllabusPath/$fileName');

      final uploadTask = ref.putFile(file);
      final taskSnapshot = await uploadTask;

      final downloadUrl = await taskSnapshot.ref.getDownloadURL();
      debugPrint('Syllabus uploaded successfully: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      debugPrint('Error uploading syllabus: $e');
      return null;
    }
  }

  /// Sube un archivo genérico a Firebase Storage
  Future<String?> uploadFile({
    required String path,
    required File file,
  }) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      final ref = _storage.ref().child('$path/$fileName');

      final uploadTask = ref.putFile(file);
      final taskSnapshot = await uploadTask;

      final downloadUrl = await taskSnapshot.ref.getDownloadURL();
      debugPrint('File uploaded successfully: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      debugPrint('Error uploading file: $e');
      return null;
    }
  }

  /// Elimina un archivo de Firebase Storage por su URL
  Future<bool> deleteFile(String downloadUrl) async {
    try {
      final ref = _storage.refFromURL(downloadUrl);
      await ref.delete();
      debugPrint('File deleted successfully');
      return true;
    } catch (e) {
      debugPrint('Error deleting file: $e');
      return false;
    }
  }

  /// Obtiene la lista de archivos en una ruta específica
  Future<List<String>> listFiles(String path) async {
    try {
      final ref = _storage.ref().child(path);
      final result = await ref.listAll();

      final urls = <String>[];
      for (final item in result.items) {
        final url = await item.getDownloadURL();
        urls.add(url);
      }
      return urls;
    } catch (e) {
      debugPrint('Error listing files: $e');
      return [];
    }
  }

  /// Verifica el progreso de un upload
  Future<void> uploadFileWithProgress({
    required String path,
    required File file,
    required Function(double) onProgress,
  }) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      final ref = _storage.ref().child('$path/$fileName');

      final uploadTask = ref.putFile(file);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        onProgress(progress);
      });

      await uploadTask;
    } catch (e) {
      debugPrint('Error during upload with progress: $e');
    }
  }
}
