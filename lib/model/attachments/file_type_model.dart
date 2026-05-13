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
    final id = json['id'];
    if (id == null) {
      throw FormatException('Campo "id" es requerido y no puede ser null');
    }
    if (id is! int) {
      throw FormatException(
        'Campo "id" debe ser int, recibido ${id.runtimeType}',
      );
    }

    final extension = json['extension'];
    if (extension == null) {
      throw FormatException(
        'Campo "extension" es requerido y no puede ser null',
      );
    }
    if (extension is! String) {
      throw FormatException(
        'Campo "extension" debe ser String, recibido ${extension.runtimeType}',
      );
    }

    final mimeType = json['mimeType'];
    if (mimeType == null) {
      throw FormatException(
        'Campo "mimeType" es requerido y no puede ser null',
      );
    }
    if (mimeType is! String) {
      throw FormatException(
        'Campo "mimeType" debe ser String, recibido ${mimeType.runtimeType}',
      );
    }

    final descripcion = json['descripcion'];
    if (descripcion == null) {
      throw FormatException(
        'Campo "descripcion" es requerido y no puede ser null',
      );
    }
    if (descripcion is! String) {
      throw FormatException(
        'Campo "descripcion" debe ser String, recibido ${descripcion.runtimeType}',
      );
    }

    return FileTypeModel(
      id: id,
      extension: extension,
      mimeType: mimeType,
      descripcion: descripcion,
    );
  }

  /// Extensión sin el punto inicial, en minúsculas. Ej: "pdf", "docx".
  String get ext {
    final withoutDot =
        extension.startsWith('.') ? extension.substring(1) : extension;
    return withoutDot.toLowerCase();
  }

  /// Extensión en mayúsculas para comparación. Ej: "PDF", "DOCX".
  String get extUpper => ext.toUpperCase();
}
