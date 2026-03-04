class SubjectTeacher {
  final String id;
  final String subjectId;
  final String teacherId;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SubjectTeacher({
    required this.id,
    required this.subjectId,
    required this.teacherId,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubjectTeacher.fromJson(Map<String, dynamic> json) {
    return SubjectTeacher(
      id: json['id'] as String,
      subjectId: json['subject_id'] as String,
      teacherId: json['teacher_id'] as String,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject_id': subjectId,
      'teacher_id': teacherId,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  SubjectTeacher copyWith({
    String? id,
    String? subjectId,
    String? teacherId,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SubjectTeacher(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      teacherId: teacherId ?? this.teacherId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'SubjectTeacher(id: $id, subjectId: $subjectId, teacherId: $teacherId, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SubjectTeacher && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
