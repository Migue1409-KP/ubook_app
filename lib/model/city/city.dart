import 'package:flutter/foundation.dart';

@immutable
class City {
  const City({
    required this.name,
    required this.department,
    required this.daneCode,
  });

  final String name;
  final String department;
  final String daneCode;

  String get displayName => '$name - $department';

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['nombre']?.toString() ?? '',
      department: json['departamento']?.toString() ?? '',
      daneCode: json['codigoDane']?.toString() ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is City &&
            runtimeType == other.runtimeType &&
            daneCode == other.daneCode;
  }

  @override
  int get hashCode => daneCode.hashCode;
}
