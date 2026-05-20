/// Periodo académico consumido desde la API remota
/// `https://my-json-server.typicode.com/cristiancamilo62/api/periodosAcademicos`.
///
/// Esta clase es solo de transporte (DTO): no se persiste en Floor. Las
/// asignaciones profesor↔materia almacenan únicamente `periodoAcademicoId`
/// y la `etiqueta` cacheada para poder mostrar el periodo sin re-consultar la
/// API si la red no está disponible.
class AcademicPeriod {
  final String id;
  final int anio;
  final int semestre;
  final String etiqueta;
  final bool estaActivo;
  final String fechaInicio;
  final String fechaFin;

  const AcademicPeriod({
    required this.id,
    required this.anio,
    required this.semestre,
    required this.etiqueta,
    required this.estaActivo,
    required this.fechaInicio,
    required this.fechaFin,
  });

  factory AcademicPeriod.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    if (id is! String) {
      throw FormatException(
        'Campo "id" debe ser String, recibido ${id.runtimeType}',
      );
    }

    final anio = json['anio'];
    if (anio is! int) {
      throw FormatException(
        'Campo "anio" debe ser int, recibido ${anio.runtimeType}',
      );
    }

    final semestre = json['semestre'];
    if (semestre is! int) {
      throw FormatException(
        'Campo "semestre" debe ser int, recibido ${semestre.runtimeType}',
      );
    }

    final etiqueta = json['etiqueta'];
    if (etiqueta is! String) {
      throw FormatException(
        'Campo "etiqueta" debe ser String, recibido ${etiqueta.runtimeType}',
      );
    }

    final estaActivo = json['estaActivo'];
    if (estaActivo is! bool) {
      throw FormatException(
        'Campo "estaActivo" debe ser bool, recibido ${estaActivo.runtimeType}',
      );
    }

    final fechaInicio = json['fechaInicio'] as String? ?? '';
    final fechaFin = json['fechaFin'] as String? ?? '';

    return AcademicPeriod(
      id: id,
      anio: anio,
      semestre: semestre,
      etiqueta: etiqueta,
      estaActivo: estaActivo,
      fechaInicio: fechaInicio,
      fechaFin: fechaFin,
    );
  }
}
