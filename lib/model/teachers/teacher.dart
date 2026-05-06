import 'package:floor/floor.dart';
import 'package:flutter/foundation.dart';

@Entity(tableName: 'teachers')
@immutable
class Teacher {
  @PrimaryKey()
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final int age;
  final String department;
  final String specialty;
  final List<String> subjects;
  final String profileImageUrl;
  final bool isActive;
  final int createdAtMs;
  final int updatedAtMs;

  Teacher({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone = '',
    this.age = 0,
    this.department = '',
    this.specialty = '',
    this.subjects = const [],
    this.profileImageUrl = '',
    this.isActive = true,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? createdAtMs,
    int? updatedAtMs,
  })  : createdAtMs = createdAtMs ?? (createdAt ?? DateTime.now()).millisecondsSinceEpoch,
        updatedAtMs = updatedAtMs ?? (updatedAt ?? DateTime.now()).millisecondsSinceEpoch;

  String get fullName => '$firstName $lastName';

  DateTime get createdAt => DateTime.fromMillisecondsSinceEpoch(createdAtMs);
  DateTime get updatedAt => DateTime.fromMillisecondsSinceEpoch(updatedAtMs);

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String? ?? '',
      age: json['age'] as int? ?? 0,
      department: json['department'] as String? ?? '',
      specialty: json['specialty'] as String? ?? '',
      subjects: (json['subjects'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      profileImageUrl: json['profile_image_url'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? true,
      createdAt: _readDate(json['created_at']),
      updatedAt: _readDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'age': age,
      'department': department,
      'specialty': specialty,
      'subjects': subjects,
      'profile_image_url': profileImageUrl,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  static DateTime? _readDate(dynamic value) {
    if (value == null) return null;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is String) return DateTime.tryParse(value);
    if (value is DateTime) return value;
    return null;
  }

  Teacher copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    int? age,
    String? department,
    String? specialty,
    List<String>? subjects,
    String? profileImageUrl,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Teacher(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      age: age ?? this.age,
      department: department ?? this.department,
      specialty: specialty ?? this.specialty,
      subjects: subjects ?? this.subjects,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Teacher(id: $id, name: $fullName, email: $email, department: $department)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Teacher && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
