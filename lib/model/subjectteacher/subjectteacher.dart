import 'package:floor/floor.dart';

@Entity(tableName: 'subject_teachers')
class SubjectTeacher {
  @PrimaryKey()
  final String id;

  @ColumnInfo(name: 'subject_id')
  final String subjectId;

  @ColumnInfo(name: 'subject_nombre')
  final String subjectNombre;

  @ColumnInfo(name: 'subject_creditos')
  final int subjectCreditos;

  @ColumnInfo(name: 'subject_horas')
  final int subjectHoras;

  @ColumnInfo(name: 'teacher_id')
  final String teacherId;

  @ColumnInfo(name: 'teacher_name')
  final String teacherName;

  @ColumnInfo(name: 'teacher_email')
  final String teacherEmail;

  @ColumnInfo(name: 'is_active')
  final bool isActive;

  @ColumnInfo(name: 'periodo_academico_id')
  final String? periodoAcademicoId;

  @ColumnInfo(name: 'periodo_etiqueta')
  final String? periodoEtiqueta;

  @ColumnInfo(name: 'created_at_ms')
  final int createdAtMs;

  @ColumnInfo(name: 'updated_at_ms')
  final int updatedAtMs;

  DateTime get createdAt => DateTime.fromMillisecondsSinceEpoch(createdAtMs);
  DateTime get updatedAt => DateTime.fromMillisecondsSinceEpoch(updatedAtMs);

  SubjectTeacher({
    required this.id,
    required this.subjectId,
    this.subjectNombre = '',
    this.subjectCreditos = 0,
    this.subjectHoras = 0,
    required this.teacherId,
    this.teacherName = '',
    this.teacherEmail = '',
    this.isActive = true,
    this.periodoAcademicoId,
    this.periodoEtiqueta,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? createdAtMs,
    int? updatedAtMs,
  }) : createdAtMs =
           createdAtMs ?? (createdAt ?? DateTime.now()).millisecondsSinceEpoch,
       updatedAtMs =
           updatedAtMs ?? (updatedAt ?? DateTime.now()).millisecondsSinceEpoch;

  factory SubjectTeacher.fromJson(Map<String, dynamic> json) {
    return SubjectTeacher(
      id: json['id'] as String,
      subjectId: json['subject_id'] as String,
      subjectNombre: json['subject_nombre'] as String? ?? '',
      subjectCreditos: json['subject_creditos'] as int? ?? 0,
      subjectHoras: json['subject_horas'] as int? ?? 0,
      teacherId: json['teacher_id'] as String,
      teacherName: json['teacher_name'] as String? ?? '',
      teacherEmail: json['teacher_email'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? true,
      periodoAcademicoId: json['periodo_academico_id'] as String?,
      periodoEtiqueta: json['periodo_etiqueta'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'subject_id': subjectId,
    'subject_nombre': subjectNombre,
    'subject_creditos': subjectCreditos,
    'subject_horas': subjectHoras,
    'teacher_id': teacherId,
    'teacher_name': teacherName,
    'teacher_email': teacherEmail,
    'is_active': isActive,
    'periodo_academico_id': periodoAcademicoId,
    'periodo_etiqueta': periodoEtiqueta,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}
