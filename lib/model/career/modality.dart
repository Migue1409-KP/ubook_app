/// Modalidad consumida desde la API remota
/// `https://my-json-server.typicode.com/cristiancamilo62/api/modalidades`.
///
/// DTO de transporte: no se persiste en Floor. Las carreras almacenan
/// únicamente `modalityId` y el `nombre` cacheado para poder mostrar la
/// modalidad sin re-consultar la API si la red no está disponible.
class Modality {
  final int id;
  final String nombre;

  const Modality({
    required this.id,
    required this.nombre,
  });

  factory Modality.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    if (id is! int) {
      throw FormatException(
        'Campo "id" debe ser int, recibido ${id.runtimeType}',
      );
    }

    final nombre = json['nombre'];
    if (nombre is! String) {
      throw FormatException(
        'Campo "nombre" debe ser String, recibido ${nombre.runtimeType}',
      );
    }

    return Modality(id: id, nombre: nombre);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Modality && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
