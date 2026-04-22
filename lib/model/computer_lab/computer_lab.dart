import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:floor/floor.dart';

/// Entity representing a Computer Lab ("Sala de Cómputo").
@immutable
@Entity(tableName: 'computer_labs')
@TypeConverters([StringListConverter])
class ComputerLab {
  @primaryKey
  final String id;
  final String name;
  final String building;
  final String roomNumber;
  final int capacity;
  final bool available;
  final List<String> equipment; // e.g., ["Projector", "3D Printer"]
  final String notes;

  const ComputerLab({
    required this.id,
    required this.name,
    required this.building,
    required this.roomNumber,
    required this.capacity,
    required this.available,
    required this.equipment,
    required this.notes,
  });

  ComputerLab copyWith({
    String? id,
    String? name,
    String? building,
    String? roomNumber,
    int? capacity,
    bool? available,
    List<String>? equipment,
    String? notes,
  }) {
    return ComputerLab(
      id: id ?? this.id,
      name: name ?? this.name,
      building: building ?? this.building,
      roomNumber: roomNumber ?? this.roomNumber,
      capacity: capacity ?? this.capacity,
      available: available ?? this.available,
      equipment: equipment ?? this.equipment,
      notes: notes ?? this.notes,
    );
  }
}

class StringListConverter extends TypeConverter<List<String>, String> {
  @override
  List<String> decode(String databaseValue) {
    final decoded = jsonDecode(databaseValue);
    if (decoded is List) {
      return decoded.whereType<String>().toList(growable: false);
    }
    return const [];
  }

  @override
  String encode(List<String> value) {
    return jsonEncode(value);
  }
}
