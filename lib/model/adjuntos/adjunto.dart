import 'dart:typed_data';

class Adjunto {
  final String? id;
  final String fileName;
  final String fileType;
  final String uploadedById;
  final String subjectId;
  final String teacherId;
  final Uint8List? fileBytes;
  final int? fileSize;

  final DateTime uploadedAt;

  const Adjunto({
    this.id,
    required this.fileName,
    required this.fileType,
    required this.uploadedById,
    required this.subjectId,
    required this.teacherId,
    this.fileBytes,
    this.fileSize,
    required this.uploadedAt,
  });

  factory Adjunto.fromJson(Map<String, dynamic> json) {
    return Adjunto(
      id: json['id'] as String?,
      fileName: json['file_name'] as String,
      fileType: json['file_type'] as String,
      uploadedById: json['uploaded_by_id'] as String,
      subjectId: json['subject_id'] as String,
      teacherId: json['teacher_id'] as String,
      fileSize: json['file_size'] as int?,
      uploadedAt: DateTime.parse(json['uploaded_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'file_name': fileName,
      'file_type': fileType,
      'uploaded_by_id': uploadedById,
      'subject_id': subjectId,
      'teacher_id': teacherId,
      if (fileSize != null) 'file_size': fileSize,
      'uploaded_at': uploadedAt.toIso8601String(),
    };
  }

  Adjunto copyWith({
    String? id,
    String? fileName,
    String? fileType,
    String? uploadedById,
    String? subjectId,
    String? teacherId,
    Uint8List? fileBytes,
    int? fileSize,
    DateTime? uploadedAt,
  }) {
    return Adjunto(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
      fileType: fileType ?? this.fileType,
      uploadedById: uploadedById ?? this.uploadedById,
      subjectId: subjectId ?? this.subjectId,
      teacherId: teacherId ?? this.teacherId,
      fileBytes: fileBytes ?? this.fileBytes,
      fileSize: fileSize ?? this.fileSize,
      uploadedAt: uploadedAt ?? this.uploadedAt,
    );
  }

  String get fileSizeFormatted {
    if (fileSize == null) return 'Desconocido';
    if (fileSize! < 1024) return '$fileSize B';
    if (fileSize! < 1024 * 1024) {
      return '${(fileSize! / 1024).toStringAsFixed(1)} KB';
    }
    return '${(fileSize! / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  bool get esImagen {
    const tipos = {'jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp', 'heic'};
    return tipos.contains(fileType.toLowerCase());
  }

  @override
  String toString() {
    return 'Adjunto(id: $id, fileName: $fileName, fileType: $fileType, '
        'uploadedById: $uploadedById, subjectId: $subjectId, '
        'teacherId: $teacherId, fileSize: $fileSizeFormatted)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Adjunto && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
