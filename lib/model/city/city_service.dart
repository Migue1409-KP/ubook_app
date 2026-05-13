import 'dart:convert';

import 'package:http/http.dart' as http;

import 'city.dart';

class CityService {
  const CityService({
    this.endpoint =
        'https://my-json-server.typicode.com/juanpanore/api/ciudadesColombia',
  });

  final String endpoint;

  Future<List<City>> fetchCities() async {
    final response = await http.get(Uri.parse(endpoint));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw CityServiceException(
        'No se pudieron cargar las ciudades (${response.statusCode}).',
      );
    }

    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    if (decoded is! List) {
      throw const CityServiceException(
        'La respuesta de ciudades no tiene el formato esperado.',
      );
    }

    return decoded
        .whereType<Map<String, dynamic>>()
        .map(City.fromJson)
        .where((city) => city.name.isNotEmpty)
        .toList(growable: false);
  }
}

class CityServiceException implements Exception {
  const CityServiceException(this.message);

  final String message;

  @override
  String toString() => message;
}
