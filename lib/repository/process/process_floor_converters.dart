// ignore_for_file: experimental_member_use

import 'dart:convert';

import 'package:floor/floor.dart';

class StringListConverter extends TypeConverter<List<String>, String> {
  @override
  List<String> decode(String databaseValue) {
    if (databaseValue.isEmpty) return const [];
    final decoded = jsonDecode(databaseValue);
    if (decoded is List) {
      return decoded.map((item) => item.toString()).toList(growable: false);
    }
    return const [];
  }

  @override
  String encode(List<String> value) {
    return jsonEncode(value);
  }
}



class NullableDateTimeConverter extends TypeConverter<DateTime?, int?> {
  @override
  DateTime? decode(int? databaseValue) {
    if (databaseValue == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(databaseValue);
  }

  @override
  int? encode(DateTime? value) {
    return value?.millisecondsSinceEpoch;
  }
}
