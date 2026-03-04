enum ProcessType {
  career, // Procesos de carrera
  subject, // Procesos de materia
}

class ProcessModel {
  final String id;
  final String name;
  final String description;
  final List<String> requiredDocuments;
  final ProcessType processType;
  final String? relatedId;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProcessModel({
    required this.id, // Obligatorio: necesitamos un ID
    required this.name, // Obligatorio: necesitamos un nombre
    required this.description, // Obligatorio: necesitamos una descripción
    required this.requiredDocuments, // Obligatorio: lista de documentos
    required this.processType, // Obligatorio: tipo de proceso
    this.relatedId, // Opcional: puede ser null
    this.isActive = true, // Opcional: por defecto es true (activo)
    required this.createdAt, // Obligatorio: fecha de creación
    required this.updatedAt, // Obligatorio: fecha de actualización
  });

  factory ProcessModel.fromJson(Map<String, dynamic> json) {
    return ProcessModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      requiredDocuments: List<String>.from(json['required_documents'] ?? []),
      processType: json['process_type'] == 'career'
          ? ProcessType.career
          : ProcessType.subject,
      relatedId: json['related_id'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
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
      // .toIso8601String() convierte DateTime a texto formato estándar
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
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
