class Subject {
  final String id;
  final String nombre;
  final int horas;
  final int creditos;
  final List<String> prerrequisitos;
  final String contenido;

  const Subject({
    required this.id,
    required this.nombre,
    required this.horas,
    required this.creditos,
    required this.prerrequisitos,
    required this.contenido,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      horas: json['horas'] as int,
      creditos: json['creditos'] as int,
      prerrequisitos:
          List<String>.from(json['prerrequisitos'] ?? []),
      contenido: json['contenido'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'horas': horas,
      'creditos': creditos,
      'prerrequisitos': prerrequisitos,
      'contenido': contenido,
    };
  }

  Subject copyWith({
    String? id,
    String? nombre,
    int? horas,
    int? creditos,
    List<String>? prerrequisitos,
    String? contenido,
  }) {
    return Subject(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      horas: horas ?? this.horas,
      creditos: creditos ?? this.creditos,
      prerrequisitos: prerrequisitos ?? this.prerrequisitos,
      contenido: contenido ?? this.contenido,
    );
  }

  @override
  String toString() {
    return 'Subject(id: $id, nombre: $nombre, creditos: $creditos)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Subject && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}