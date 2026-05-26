import 'package:floor/floor.dart';

class ProcessType {
  static const String career = 'career';
  static const String subject = 'subject';
  static const String educationalCenter = 'educationalCenter';
}

extension ProcessTypeStringX on String {
  String get apiValue => this;

  String get label {
    switch (this) {
      case ProcessType.career:
        return 'Carrera';
      case ProcessType.subject:
        return 'Materia';
      case ProcessType.educationalCenter:
        return 'Centro educativo';
      default:
        if (isEmpty) return '';
        return '${this[0].toUpperCase()}${substring(1)}';
    }
  }
}

final class ProcessTypeMapper {
  static String tryParse(String? rawValue) {
    return rawValue ?? ProcessType.subject;
  }

  static String parseOrDefault(String? rawValue) {
    return rawValue ?? ProcessType.subject;
  }
}

@Entity(tableName: 'processes')
class ProcessModel {
  @PrimaryKey()
  final String id;

  final String name;

  final String description;

  @ColumnInfo(name: 'required_documents_json')
  final List<String> requiredDocuments;

  @ColumnInfo(name: 'process_type')
  final String processType;

  @ColumnInfo(name: 'related_id')
  final String? relatedId;

  @ColumnInfo(name: 'is_active')
  final bool isActive;

  @ColumnInfo(name: 'created_at_ms')
  final DateTime? createdAt;

  @ColumnInfo(name: 'updated_at_ms')
  final DateTime? updatedAt;

  const ProcessModel({
    required this.id,
    required this.name,
    required this.description,
    required this.requiredDocuments,
    required this.processType,
    this.relatedId,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory ProcessModel.fromJson(Map<String, dynamic> json) {
    final typeRaw = json['process_type'] as String?;
    final parsedType = ProcessTypeMapper.parseOrDefault(typeRaw);

    return ProcessModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      requiredDocuments: List<String>.from(json['required_documents'] ?? []),
      processType: parsedType,
      relatedId: json['related_id'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'required_documents': requiredDocuments,
      'process_type': processType,
      'related_id': relatedId,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  ProcessModel copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? requiredDocuments,
    String? processType,
    String? relatedId,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProcessModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      requiredDocuments: requiredDocuments ?? this.requiredDocuments,
      processType: processType ?? this.processType,
      relatedId: relatedId ?? this.relatedId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'ProcessModel(id: $id, name: $name, type: $processType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProcessModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

