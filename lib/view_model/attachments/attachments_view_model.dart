import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as p;

import '../../model/attachments/attachment_model.dart';
import '../../repository/attachments/attachment_local_storage.dart';
import '../../repository/attachments/attachment_repository.dart';
import '../../repository/attachments/file_type_repository.dart';

class AttachmentsViewModel extends ChangeNotifier {
  AttachmentsViewModel._(this._contextKey) {
    ready = _loadCustomFileName();
  }

  /// Completa cuando [_loadCustomFileName] termina de hidratarse desde SharedPreferences.
  late final Future<void> ready;

  /// Clave que identifica el contexto (subjectId:teacherId).
  final String _contextKey;

  /// Cache de instancias por contexto. Una instancia por combinación
  /// subjectId+teacherId — el estado no se comparte entre distintas vistas.
  static final Map<String, AttachmentsViewModel> _instances = {};

  /// Devuelve (o crea) la instancia asociada al contexto dado.
  static AttachmentsViewModel forContext(String subjectId, String teacherId) {
    final key = '$subjectId:$teacherId';
    return _instances.putIfAbsent(key, () => AttachmentsViewModel._(key));
  }

  final _storage = AttachmentLocalStorage();

  final List<AttachmentModel> _attachments = [];
  List<AttachmentModel> get attachments => List.unmodifiable(_attachments);

  /// Mensaje de error para mostrar en la UI tras un fallo al cargar/guardar.
  String? errorMessage;

  bool isLoading = false;

  /// Carga el nombre del archivo guardado en SharedPreferences al arrancar.
  Future<void> _loadCustomFileName() async {
    final saved = await _storage.getCustomFileName(contextKey: _contextKey);
    if (saved != null) {
      customFileName = saved;
      notifyListeners();
    }
  }

  Uint8List? fileBytes;
  String? fileName;

  /// Nombre editable por el usuario. Se inicializa con el nombre del archivo
  /// al seleccionarlo y se mantiene aunque se cierre el formulario.
  String customFileName = '';
  int? fileSize;
  String detectedType = '';
  bool isSelecting = false;

  /// Id del adjunto que está siendo abierto actualmente.
  /// `null` cuando ninguno está en proceso de apertura.
  String? openingId;

  bool get isFileSelected => fileBytes != null;

  String get formattedFileSize {
    if (fileSize == null) return '';
    final size = fileSize!;
    if (size < 1024) return '$size B';
    if (size < 1048576) return '${(size / 1024).toStringAsFixed(1)} KB';
    return '${(size / 1048576).toStringAsFixed(1)} MB';
  }

  final _fileTypeRepo = FileTypeRepository.instance;

  /// Libera la instancia asociada a un contexto cuando ya no se necesita.
  /// Llamar desde el [State.dispose] de la vista si no se va a reutilizar.
  static void disposeContext(String subjectId, String teacherId) {
    final key = '$subjectId:$teacherId';
    _instances[key]?.dispose();
    _instances.remove(key);
  }

  Future<void> addAttachment(AttachmentModel attachment) async {
    final saved = await AttachmentRepository.current.saveFile(attachment);
    _attachments.add(saved);
    notifyListeners();
  }

  /// Carga desde la BD los adjuntos asociados a [subjectId].
  Future<void> loadBySubject(String subjectId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      _attachments
        ..clear()
        ..addAll(
          await AttachmentRepository.current.findBySubjectId(subjectId),
        );
    } catch (e) {
      errorMessage = 'Error al cargar adjuntos: $e';
      debugPrint('loadBySubject: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteAttachment(int index) async {
    final attachment = _attachments[index];
    await AttachmentRepository.current.deleteAttachment(attachment);
    _attachments.removeAt(index);
    notifyListeners();
  }

  /// Abre el selector de archivos usando las extensiones permitidas obtenidas
  /// desde la API. Si la consulta falla, se usa [FileType.any] como fallback.
  Future<void> selectFile() async {
    isSelecting = true;
    notifyListeners();
    try {
      List<String>? allowedExtensions;
      List<String> knownExtensions = [];
      try {
        allowedExtensions = await _fileTypeRepo.fetchAllowedExtensions();
        knownExtensions = allowedExtensions
            .map((e) => e.toUpperCase())
            .toList();
      } catch (e, st) {
        debugPrint('Error al obtener extensiones permitidas: $e\n$st');
        // Si la API no responde, se permite cualquier tipo.
        allowedExtensions = null;
      }

      final result = await FilePicker.platform.pickFiles(
        type: allowedExtensions != null ? FileType.custom : FileType.any,
        allowedExtensions: allowedExtensions,
        withData: true,
      );
      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        final ext = (file.extension ?? 'unknown').toUpperCase();
        fileBytes = file.bytes;
        fileName = file.name;
        customFileName = file.name; // auto-rellena; el usuario puede cambiarlo
        fileSize = file.size;
        detectedType = knownExtensions.contains(ext) ? ext : 'OTHER';
        await _storage.saveCustomFileName(
          customFileName,
          contextKey: _contextKey,
        );
      }
    } finally {
      isSelecting = false;
      notifyListeners();
    }
  }

  /// Actualiza el nombre personalizado desde el campo de texto del formulario.
  void updateCustomFileName(String name) {
    customFileName = name;
    _storage.saveCustomFileName(name, contextKey: _contextKey);
    // No notifyListeners: el controller ya refleja el cambio en la UI.
  }

  void clearSelection() {
    fileBytes = null;
    fileName = null;
    customFileName = '';
    fileSize = null;
    detectedType = '';
    _storage.clearCustomFileName(contextKey: _contextKey);
    notifyListeners();
  }

  AttachmentModel? buildAttachment({
    required String name,
    required String uploadedById,
    required String subjectId,
    required String teacherId,
  }) {
    if (fileBytes == null) return null;
    return AttachmentModel(
      fileName: name,
      fileType: detectedType,
      uploadedById: uploadedById,
      subjectId: subjectId,
      teacherId: teacherId,
      fileBytes: fileBytes,
      fileSize: fileSize,
      uploadedAtMs: DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<String?> openFile(AttachmentModel attachment) async {
    if (kIsWeb) return 'Download is not available in the web version';

    final filePath = attachment.filePath;
    if (filePath == null) return 'El archivo no tiene contenido guardado';

    openingId = attachment.id;
    notifyListeners();
    try {
      // Ruta absoluta → archivo local, abrir directamente.
      if (p.isAbsolute(filePath)) {
        final result = await OpenFile.open(filePath);
        if (result.type != ResultType.done) return result.message;
        return null;
      }

      // Ruta relativa → Supabase Storage, generar URL firmada y abrir.
      final url =
          await AttachmentRepository.current.getSignedUrl(attachment);
      if (url == null) {
        return 'No se pudo generar el enlace de descarga';
      }
      final launched = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
      if (!launched) return 'No se pudo abrir el archivo';
      return null;
    } catch (e) {
      return 'No se pudo abrir el archivo: $e';
    } finally {
      openingId = null;
      notifyListeners();
    }
  }
}
