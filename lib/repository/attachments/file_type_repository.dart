import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../model/attachments/file_type_model.dart';

/// Consulta el catálogo de tipos de archivo permitidos desde la API remota.
class FileTypeRepository {
  FileTypeRepository._();
  static final FileTypeRepository instance = FileTypeRepository._();

  static const _url =
      'https://my-json-server.typicode.com/liljuanxxo6/api/tiposArchivosAdjuntos';

  /// Devuelve la lista de [FileTypeModel] disponibles.
  /// Lanza una [Exception] si la petición falla.
  Future<List<FileTypeModel>> fetchFileTypes() async {
    try {
      final response = await http
          .get(Uri.parse(_url))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) {
        throw Exception(
          'Error al obtener tipos de archivo: HTTP ${response.statusCode}',
        );
      }
      final List<dynamic> jsonList =
          json.decode(response.body) as List<dynamic>;
      return jsonList
          .map((e) => FileTypeModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on TimeoutException {
      throw Exception('Timeout fetching file types');
    } on SocketException {
      throw Exception('Network error fetching file types');
    } on FormatException {
      rethrow;
    }
  }

  /// Devuelve solo las extensiones sin punto en minúsculas. Ej: ['pdf', 'doc', ...].
  Future<List<String>> fetchAllowedExtensions() async {
    final types = await fetchFileTypes();
    return types.map((t) => t.ext).toList();
  }
}
