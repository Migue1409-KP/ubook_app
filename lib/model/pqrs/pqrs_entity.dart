import 'package:floor/floor.dart';
import 'pqrs.dart';

@Entity(tableName: 'pqrs')
class PQRSEntity {
  @primaryKey
  final String id;

  final String userId;
  final String userName;

  final String tipo;
  final String descripcion;

  final int fechaMs;

  final String estado;

  const PQRSEntity({
    required this.id,
    required this.userId,
    required this.userName,
    required this.tipo,
    required this.descripcion,
    required this.fechaMs,
    required this.estado,
  });

  factory PQRSEntity.fromPQRS(PQRS pqrs) {
    return PQRSEntity(
      id: pqrs.id!,
      userId: pqrs.userId,
      userName: pqrs.userName,
      tipo: pqrs.tipo,
      descripcion: pqrs.descripcion,
      fechaMs: pqrs.fecha.millisecondsSinceEpoch,
      estado: pqrs.estado,
    );
  }

  PQRS toPQRS() {
    return PQRS(
      id: id,
      userId: userId,
      userName: userName,
      tipo: tipo,
      descripcion: descripcion,
      fecha: DateTime.fromMillisecondsSinceEpoch(fechaMs),
      estado: estado,
    );
  }
}