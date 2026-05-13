import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../model/process/process_model.dart';
import '../../model/process/process_type_option.dart';

class ProcessTypeCatalogService {
  ProcessTypeCatalogService({http.Client? client}) : _client = client ?? http.Client();

  static const String _endpoint =
      'https://api.mockfly.dev/mocks/6e04a8c1-e040-4d2b-864a-eb43033532df/processTypes';

  final http.Client _client;

  Future<List<ProcessTypeOption>> getProcessTypes() async {
    try {
      final response = await _client.get(Uri.parse(_endpoint));
      if (response.statusCode != 200) {
        return fallbackOptions;
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        return fallbackOptions;
      }

      final processTypes = decoded['processTypes'];
      if (processTypes is! List) {
        return fallbackOptions;
      }

      final options = processTypes
          .whereType<Map<String, dynamic>>()
          .map(ProcessTypeOption.fromJson)
          .where(
            (option) =>
                option.label.isNotEmpty &&
                ProcessTypeMapper.tryParse(option.value) != null,
          )
          .toList(growable: false);

      return options.isEmpty ? fallbackOptions : options;
    } catch (_) {
      return fallbackOptions;
    }
  }

  static const List<ProcessTypeOption> fallbackOptions = [
    ProcessTypeOption(id: 1, value: 'career', label: 'Carrera'),
    ProcessTypeOption(id: 2, value: 'subject', label: 'Materia'),
    ProcessTypeOption(
      id: 3,
      value: 'educationalCenter',
      label: 'Centro educativo',
    ),
  ];
}
