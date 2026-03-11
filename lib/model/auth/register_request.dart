/// Modelo que representa los datos necesarios para registrar
/// una cuenta nueva con correo y contraseña.
///
/// Campos obligatorios: [email], [password], [name].
/// Campos opcionales: [birthDate], [educationalCenter], [career], [city].
class RegisterRequest {
  final String email;
  final String password;
  final String name;
  final DateTime? birthDate;
  final String? educationalCenter;
  final String? career;
  final String? city;

  const RegisterRequest({
    required this.email,
    required this.password,
    required this.name,
    this.birthDate,
    this.educationalCenter,
    this.career,
    this.city,
  });

  /// Serializa a JSON para enviar al backend.
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
      if (birthDate != null) 'birth_date': birthDate!.toIso8601String(),
      if (educationalCenter != null) 'educational_center': educationalCenter,
      if (career != null) 'career': career,
      if (city != null) 'city': city,
    };
  }

  /// Crea un [RegisterRequest] a partir de un mapa JSON.
  factory RegisterRequest.fromJson(Map<String, dynamic> json) {
    return RegisterRequest(
      email: json['email'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
      birthDate: json['birth_date'] != null
          ? DateTime.parse(json['birth_date'] as String)
          : null,
      educationalCenter: json['educational_center'] as String?,
      career: json['career'] as String?,
      city: json['city'] as String?,
    );
  }

  RegisterRequest copyWith({
    String? email,
    String? password,
    String? name,
    DateTime? birthDate,
    String? educationalCenter,
    String? career,
    String? city,
  }) {
    return RegisterRequest(
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      educationalCenter: educationalCenter ?? this.educationalCenter,
      career: career ?? this.career,
      city: city ?? this.city,
    );
  }

  @override
  String toString() {
    return 'RegisterRequest(email: $email, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RegisterRequest &&
        other.email == email &&
        other.name == name;
  }

  @override
  int get hashCode => email.hashCode ^ name.hashCode;
}
