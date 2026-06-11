/// Método de autenticación utilizado por el usuario.
enum AuthProvider {
  /// Inicio de sesión con correo electrónico y contraseña.
  emailPassword,

  /// Inicio de sesión con cuenta de Google (Gmail).
  google;

  /// Convierte el enum a String para serialización JSON.
  String toJson() => name;

  /// Crea un [AuthProvider] a partir de un String (deserialización JSON).
  static AuthProvider fromJson(String value) {
    return AuthProvider.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AuthProvider.emailPassword,
    );
  }
}
