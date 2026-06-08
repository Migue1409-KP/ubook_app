import 'package:floor/floor.dart';

@Entity(tableName: 'subjects')
class SubjectEntity {
  @PrimaryKey()
  final String id;

  @ColumnInfo(name: 'nombre')
  final String nombre;

  @ColumnInfo(name: 'creditos')
  final int creditos;

  @ColumnInfo(name: 'horas')
  final int horas;

  @ColumnInfo(name: 'descripcion')
  final String? descripcion;

  @ColumnInfo(name: 'is_sync')
  final bool isSync;

  @ColumnInfo(name: 'last_update')
  final int lastUpdate;

  SubjectEntity({
    required this.id,
    required this.nombre,
    required this.creditos,
    required this.horas,
    this.descripcion,
    required this.isSync,
    required this.lastUpdate,
  });

  SubjectEntity copyWith({
    String? id,
    String? nombre,
    int? creditos,
    int? horas,
    String? descripcion,
    bool? isSync,
    int? lastUpdate,
  }) {
    return SubjectEntity(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      creditos: creditos ?? this.creditos,
      horas: horas ?? this.horas,
      descripcion: descripcion ?? this.descripcion,
      isSync: isSync ?? this.isSync,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'creditos': creditos,
      'horas': horas,
      'descripcion': descripcion,
      'is_sync': isSync,
      'last_update': lastUpdate,
    };
  }

  factory SubjectEntity.fromJson(Map<String, dynamic> json) {
    return SubjectEntity(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      creditos: json['creditos'] as int,
      horas: json['horas'] as int,
      descripcion: json['descripcion'] as String?,
      isSync: json['is_sync'] as bool? ?? false,
      lastUpdate: json['last_update'] as int? ?? 0,
    );
  }

  @override
  String toString() {
    return 'SubjectEntity(id: $id, nombre: $nombre, isSync: $isSync)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SubjectEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
