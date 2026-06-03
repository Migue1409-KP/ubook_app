/// Constantes de API para consumir servicios de datos maestros.
class ApiConstants {
  ApiConstants._();

  // TODO: Reemplazar con URL real del servidor del docente
  static const String baseUrl = 'https://api.ejemplo.com/api/v1';

  // Endpoints de maestros de datos
  static const String categoriesEndpoint = '$baseUrl/categories';
  static const String semestersEndpoint = '$baseUrl/semesters';
  static const String careersEndpoint = '$baseUrl/careers';
  static const String academicPeriodsEndpoint = '$baseUrl/academic-periods';
  static const String modalitiesEndpoint = '$baseUrl/modalities';

  // Timeout para requests HTTP (en segundos)
  static const int requestTimeoutSeconds = 10;

  // Headers comunes
  static const Map<String, String> commonHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
