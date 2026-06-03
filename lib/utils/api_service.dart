import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_constants.dart';

/// Modelo para respuesta de categoría
class Category {
  final String id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }
}

/// Modelo para respuesta de semestre
class Semester {
  final String id;
  final String name;
  final int number;

  Semester({
    required this.id,
    required this.name,
    required this.number,
  });

  factory Semester.fromJson(Map<String, dynamic> json) {
    return Semester(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      number: json['number'] as int? ?? 0,
    );
  }
}

/// Modelo para respuesta de carrera
class Career {
  final String id;
  final String name;
  final String code;

  Career({
    required this.id,
    required this.name,
    required this.code,
  });

  factory Career.fromJson(Map<String, dynamic> json) {
    return Career(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
    );
  }
}

/// Servicio para consumir APIs HTTP de datos maestros
class ApiService {
  ApiService._internal();

  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  static ApiService get instance => _instance;

  final http.Client _httpClient = http.Client();

  // Cache en memoria para reducir llamadas
  final Map<String, dynamic> _cache = {};
  final Map<String, DateTime> _cacheTimestamps = {};

  static const Duration _cacheDuration = Duration(hours: 1);

  /// Obtiene la lista de categorías desde la API
  Future<List<Category>> fetchCategories({bool forceRefresh = false}) async {
    return _fetchData<Category>(
      'categories',
      ApiConstants.categoriesEndpoint,
      (json) => Category.fromJson(json),
      forceRefresh: forceRefresh,
    );
  }

  /// Obtiene la lista de semestres desde la API
  Future<List<Semester>> fetchSemesters({bool forceRefresh = false}) async {
    return _fetchData<Semester>(
      'semesters',
      ApiConstants.semestersEndpoint,
      (json) => Semester.fromJson(json),
      forceRefresh: forceRefresh,
    );
  }

  /// Obtiene la lista de carreras desde la API
  Future<List<Career>> fetchCareers({bool forceRefresh = false}) async {
    return _fetchData<Career>(
      'careers',
      ApiConstants.careersEndpoint,
      (json) => Career.fromJson(json),
      forceRefresh: forceRefresh,
    );
  }

  /// Método genérico para obtener datos con caché
  Future<List<T>> _fetchData<T>(
    String cacheKey,
    String endpoint,
    T Function(Map<String, dynamic>) fromJson, {
    bool forceRefresh = false,
  }) async {
    // Verificar caché
    if (!forceRefresh && _isCacheValid(cacheKey)) {
      final cachedData = _cache[cacheKey];
      if (cachedData is List<T>) {
        return cachedData;
      }
    }

    try {
      final response = await _httpClient
          .get(
            Uri.parse(endpoint),
            headers: ApiConstants.commonHeaders,
          )
          .timeout(
            const Duration(seconds: ApiConstants.requestTimeoutSeconds),
          );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        // Assume response is either a list or has a 'data' field
        final List<dynamic> items = jsonData is List
            ? jsonData
            : (jsonData['data'] is List ? jsonData['data'] : []);

        final result = items
            .map((item) => fromJson(item as Map<String, dynamic>))
            .toList();

        // Guardar en caché
        _cache[cacheKey] = result;
        _cacheTimestamps[cacheKey] = DateTime.now();

        return result;
      } else {
        throw Exception('Error al obtener datos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en solicitud HTTP: $e');
    }
  }

  /// Verifica si el caché es válido
  bool _isCacheValid(String cacheKey) {
    final timestamp = _cacheTimestamps[cacheKey];
    if (timestamp == null) return false;

    final now = DateTime.now();
    final difference = now.difference(timestamp);
    return difference < _cacheDuration;
  }

  /// Limpia el caché
  void clearCache() {
    _cache.clear();
    _cacheTimestamps.clear();
  }

  /// Limpia una entrada específica del caché
  void clearCacheEntry(String key) {
    _cache.remove(key);
    _cacheTimestamps.remove(key);
  }
}
