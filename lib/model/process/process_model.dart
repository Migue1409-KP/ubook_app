import 'package:floor/floor.dart';

enum ProcessType {
  career, // Procesos de carrera
  subject, // Procesos de materia
  educationalCenter, // Procesos de centro educativo
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
  final ProcessType processType;

  @ColumnInfo(name: 'related_id')
  final String? relatedId;

  @ColumnInfo(name: 'is_active')
  final bool isActive;

  @ColumnInfo(name: 'created_at_ms')
  final DateTime? createdAt;

  @ColumnInfo(name: 'updated_at_ms')
  final DateTime? updatedAt;

  const ProcessModel({
    required this.id, // Obligatorio: necesitamos un ID
    required this.name, // Obligatorio: necesitamos un nombre
    required this.description, // Obligatorio: necesitamos una descripción
    required this.requiredDocuments, // Obligatorio: lista de documentos
    required this.processType, // Obligatorio: tipo de proceso
    this.relatedId, // Opcional: puede ser null
    this.isActive = true, // Opcional: por defecto es true (activo)
    this.createdAt, // Opcional: fecha de creación (puede ser null, suele venir del backend)
    this.updatedAt, // Opcional: fecha de actualización (puede ser null, suele venir del backend)
  });

  factory ProcessModel.fromJson(Map<String, dynamic> json) {
    final typeRaw = json['process_type'] as String?;
    final parsedType = switch (typeRaw) {
      'career' => ProcessType.career,
      'educationalCenter' => ProcessType.educationalCenter,
      _ => ProcessType.subject,
    };

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
      // .name convierte el enum a su nombre en texto ('career' o 'subject')
      'process_type': processType.name,
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
    ProcessType? processType,
    String? relatedId,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProcessModel(
      id: id ?? this.id, // Si id es null, usa this.id
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
    return 'ProcessModel(id: $id, name: $name, type: ${processType.name})';
  }

  @override
  bool operator ==(Object other) {
    // identical() verifica si son EXACTAMENTE el mismo objeto en memoria
    if (identical(this, other)) return true;
    // Verificamos si 'other' es un ProcessModel y si tienen el mismo id
    return other is ProcessModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
