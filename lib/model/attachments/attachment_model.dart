import 'dart:typed_data';

import 'package:floor/floor.dart';

@Entity(tableName: 'attachments')
class AttachmentModel {
  @PrimaryKey()
  final String? id;

  @ColumnInfo(name: 'file_name')
  final String fileName;

  @ColumnInfo(name: 'file_type')
  final String fileType;

  @ColumnInfo(name: 'uploaded_by_id')
  final String uploadedById;

  @ColumnInfo(name: 'subject_id')
  final String subjectId;

  @ColumnInfo(name: 'teacher_id')
  final String teacherId;

  @ignore
  final Uint8List? fileBytes;

  @ColumnInfo(name: 'file_path')
  final String? filePath;

  @ColumnInfo(name: 'file_size')
  final int? fileSize;

  @ColumnInfo(name: 'uploaded_at')
  final int uploadedAtMs;

  DateTime get uploadedAt => DateTime.fromMillisecondsSinceEpoch(uploadedAtMs);

  AttachmentModel({
    this.id,
    required this.fileName,
    required this.fileType,
    required this.uploadedById,
    required this.subjectId,
    required this.teacherId,
    this.fileBytes,
    this.filePath,
    this.fileSize,
    required this.uploadedAtMs,
  });

  factory AttachmentModel.fromJson(Map<String, dynamic> json) {
    return AttachmentModel(
      id: json['id'] as String?,
      fileName: json['file_name'] as String,
      fileType: json['file_type'] as String,
      uploadedById: json['uploaded_by_id'] as String,
      subjectId: json['subject_id'] as String,
      teacherId: json['teacher_id'] as String,
      filePath: json['file_path'] as String?,
      fileSize: json['file_size'] as int?,
      uploadedAtMs: DateTime.parse(
        json['uploaded_at'] as String,
      ).millisecondsSinceEpoch,
    );
  }

  /// Floor-compatible constructor used by generated DAO code.
  /// [uploadedAtMs] is the raw milliseconds value stored in the DB.
  AttachmentModel.fromDb({
    this.id,
    required this.fileName,
    required this.fileType,
    required this.uploadedById,
    required this.subjectId,
    required this.teacherId,
    this.fileBytes,
    this.filePath,
    this.fileSize,
    required this.uploadedAtMs,
  });

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

  AttachmentModel copyWith({
    String? id,
    String? fileName,
    String? fileType,
    String? uploadedById,
    String? subjectId,
    String? teacherId,
    Uint8List? fileBytes,
    String? filePath,
    int? fileSize,
    DateTime? uploadedAt,
  }) {
    return AttachmentModel(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
      fileType: fileType ?? this.fileType,
      uploadedById: uploadedById ?? this.uploadedById,
      subjectId: subjectId ?? this.subjectId,
      teacherId: teacherId ?? this.teacherId,
      fileBytes: fileBytes ?? this.fileBytes,
      filePath: filePath ?? this.filePath,
      fileSize: fileSize ?? this.fileSize,
      uploadedAtMs: uploadedAt?.millisecondsSinceEpoch ?? this.uploadedAtMs,
    );
  }

  Map<String, dynamic> toDbMap() {
    return {
      if (id != null) 'id': id,
      'file_name': fileName,
      'file_type': fileType,
      'uploaded_by_id': uploadedById,
      'subject_id': subjectId,
      'teacher_id': teacherId,
      if (filePath != null) 'file_path': filePath,
      if (fileSize != null) 'file_size': fileSize,
      'uploaded_at': uploadedAtMs,
    };
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
    return 'AttachmentModel(id: $id, fileName: $fileName, fileType: $fileType, '
        'uploadedById: $uploadedById, subjectId: $subjectId, '
        'teacherId: $teacherId, fileSize: $fileSizeFormatted)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AttachmentModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
