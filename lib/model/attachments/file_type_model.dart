class FileTypeModel {
  final int id;
  final String extension;
  final String mimeType;
  final String descripcion;

  const FileTypeModel({
    required this.id,
    required this.extension,
    required this.mimeType,
    required this.descripcion,
  });

  factory FileTypeModel.fromJson(Map<String, dynamic> json) {
    return FileTypeModel(
      id: json['id'] as int,
      extension: json['extension'] as String,
      mimeType: json['mimeType'] as String,
      descripcion: json['descripcion'] as String,
    );
  }

  /// Extensión sin el punto inicial, en minúsculas. Ej: "pdf", "docx".
  String get ext =>
      extension.startsWith('.') ? extension.substring(1) : extension;

  /// Extensión en mayúsculas para comparación. Ej: "PDF", "DOCX".
  String get extUpper => ext.toUpperCase();
}
