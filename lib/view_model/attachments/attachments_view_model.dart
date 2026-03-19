import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../../model/attachments/attachment.dart';

class AttachmentsViewModel extends ChangeNotifier {
  final List<Attachment> _attachments = [];
  List<Attachment> get attachments => List.unmodifiable(_attachments);

  Uint8List? fileBytes;
  String?    fileName;
  int?       fileSize;
  String     detectedType = '';
  bool       isSelecting = false;
  bool       isOpening      = false;

  bool get isFileSelected => fileBytes != null;

  String get formattedFileSize {
    if (fileSize == null) return '';
    final size = fileSize!;
    if (size < 1024)     return '$size B';
    if (size < 1048576)  return '${(size / 1024).toStringAsFixed(1)} KB';
    return '${(size / 1048576).toStringAsFixed(1)} MB';
  }

  static const _knownExtensions = [
    'PDF', 'DOC', 'DOCX', 'PPT', 'PPTX', 'XLS', 'XLSX',
    'JPG', 'JPEG', 'PNG', 'ZIP', 'RAR',
  ];

  void addAttachment(Attachment attachment) {
    _attachments.add(attachment);
    notifyListeners();
  }

  void deleteAttachment(int index) {
    _attachments.removeAt(index);
    notifyListeners();
  }

  Future<void> selectFile({List<String>? allowedExtensions}) async {
    isSelecting = true;
    notifyListeners();
    try {
      final result = await FilePicker.platform.pickFiles(
        type: allowedExtensions != null ? FileType.custom : FileType.any,
        allowedExtensions: allowedExtensions,
        withData: true,
      );
      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        final ext  = (file.extension ?? 'unknown').toUpperCase();
        fileBytes  = file.bytes;
        fileName = file.name;
        fileSize = file.size;
        detectedType = _knownExtensions.contains(ext) ? ext : 'OTHER';
      }
    } finally {
      isSelecting = false;
      notifyListeners();
    }
  }

  void clearSelection() {
    fileBytes  = null;
    fileName = null;
    fileSize = null;
    detectedType = '';
    notifyListeners();
  }

  Attachment? buildAttachment({
    required String name,
    required String uploadedById,
    required String subjectId,
    required String teacherId,
  }) {
    if (fileBytes == null) return null;
    return Attachment(
      fileName:     name,
      fileType:     detectedType,
      uploadedById: uploadedById,
      subjectId:    subjectId,
      teacherId:    teacherId,
      fileBytes:    fileBytes,
      fileSize:     fileSize,
      uploadedAt:   DateTime.now(),
    );
  }

  Future<String?> openFile(Attachment attachment) async {
    if (kIsWeb) return 'Download is not available in the web version';

    final bytes = attachment.fileBytes;
    if (bytes == null) return 'File does not have saved content locally';

    isOpening = true;
    notifyListeners();
    try {
      final directory    = await getTemporaryDirectory();
      final path   = '${directory.path}/${attachment.fileName}';
      await File(path).writeAsBytes(bytes, flush: true);
      final result = await OpenFile.open(path);
      if (result.type != ResultType.done) return result.message;
      return null;
    } catch (e) {
      return 'Could not open file: $e';
    } finally {
      isOpening = false;
      notifyListeners();
    }
  }
}
