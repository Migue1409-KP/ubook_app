class PQRS {
  final String? id;
  final String userId;
  final String userName;
  final String tipo;
  final String descripcion;
  final DateTime fecha;
  final String estado;

  PQRS({
    this.id,
    required this.userId,
    required this.userName,
    required this.tipo,
    required this.descripcion,
    required this.fecha,
    required this.estado,
  });
}
