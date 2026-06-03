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

  DateTime get uploadedAt =>
      DateTime.fromMillisecondsSinceEpoch(uploadedAtMs);

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

  Map<String, dynamic> toJson() => {
        'id': id,
        'file_name': fileName,
        'file_type': fileType,
        'uploaded_by_id': uploadedById,
        'subject_id': subjectId,
        'teacher_id': teacherId,
        'file_path': filePath,
        'file_size': fileSize,
        'uploaded_at': uploadedAt.toIso8601String(),
      };
}
