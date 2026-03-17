class SubjectTeacher {
  final String id;
  // campos de Subject (denormalizados para mostrar sin join)
  final String subjectId;
  final String subjectNombre;
  final int subjectCreditos;
  final int subjectHoras;
  // campos de Teacher
  final String teacherId;
  final String teacherName;
  final String teacherEmail;

  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SubjectTeacher({
    required this.id,
    required this.subjectId,
    this.subjectNombre = '',
    this.subjectCreditos = 0,
    this.subjectHoras = 0,
    required this.teacherId,
    this.teacherName = '',
    this.teacherEmail = '',
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

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
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is SubjectTeacher && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'SubjectTeacher(id: $id, teacher: $teacherName, subject: $subjectNombre)';
}