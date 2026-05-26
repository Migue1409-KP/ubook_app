import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../model/career/modality.dart';

/// Consume el catálogo de modalidades desde la API remota.
///
/// Sigue el mismo patrón singleton que [AcademicPeriodApiRepository]: una
/// única instancia, sin estado, métodos `Future` con manejo explícito de
/// errores de red.
class ModalityApiRepository {
  ModalityApiRepository._();
  static final ModalityApiRepository instance = ModalityApiRepository._();

  static const _url =
      'https://my-json-server.typicode.com/cristiancamilo62/api/modalidades';

  /// Devuelve la lista de [Modality] disponibles.
  /// Lanza una [Exception] si la petición falla.
  Future<List<Modality>> fetchModalities() async {
    try {
      final response = await http
          .get(Uri.parse(_url))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) {
        throw Exception(
          'Error al obtener modalidades: HTTP ${response.statusCode}',
        );
      }
      final List<dynamic> jsonList =
          json.decode(response.body) as List<dynamic>;
      return jsonList
          .map((e) => Modality.fromJson(e as Map<String, dynamic>))
          .toList();
    } on TimeoutException {
      throw Exception('Timeout al obtener modalidades');
    } on SocketException {
      throw Exception('Error de red al obtener modalidades');
    } on FormatException {
      rethrow;
    }
  }
}
