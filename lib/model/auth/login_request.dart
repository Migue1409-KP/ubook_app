/// Modelo que representa las credenciales para iniciar sesión
/// con correo electrónico y contraseña.
class LoginRequest {
  final String email;
  final String password;

  const LoginRequest({required this.email, required this.password});

  /// Serializa a JSON para enviar al backend.
  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }

  /// Crea un [LoginRequest] a partir de un mapa JSON.
  factory LoginRequest.fromJson(Map<String, dynamic> json) {
    return LoginRequest(
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  @override
  String toString() => 'LoginRequest(email: $email)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoginRequest && other.email == email;
  }

  @override
  int get hashCode => email.hashCode;
}
