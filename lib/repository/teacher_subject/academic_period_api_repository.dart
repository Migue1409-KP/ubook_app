import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../model/subjectteacher/academic_period.dart';

/// Consume el catálogo de periodos académicos desde la API remota.
///
/// Sigue el mismo patrón singleton que [FileTypeRepository]: una única
/// instancia, sin estado, métodos `Future` con manejo explícito de errores
/// de red.
class AcademicPeriodApiRepository {
  AcademicPeriodApiRepository._();
  static final AcademicPeriodApiRepository instance =
      AcademicPeriodApiRepository._();

  static const _url =
      'https://my-json-server.typicode.com/cristiancamilo62/api/periodosAcademicos';

  /// Devuelve la lista de [AcademicPeriod] disponibles.
  /// Lanza una [Exception] si la petición falla.
  Future<List<AcademicPeriod>> fetchPeriods() async {
    try {
      final response = await http
          .get(Uri.parse(_url))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) {
        throw Exception(
          'Error al obtener periodos académicos: HTTP ${response.statusCode}',
        );
      }
      final List<dynamic> jsonList =
          json.decode(response.body) as List<dynamic>;
      return jsonList
          .map((e) => AcademicPeriod.fromJson(e as Map<String, dynamic>))
          .toList();
    } on TimeoutException {
      throw Exception('Timeout al obtener periodos académicos');
    } on SocketException {
      throw Exception('Error de red al obtener periodos académicos');
    } on FormatException {
      rethrow;
    }
  }
}
