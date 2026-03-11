import 'auth_provider.dart';

/// Modelo del usuario autenticado en la aplicación.
///
/// Contiene la información del perfil del usuario tras registrarse
/// o iniciar sesión (con email/contraseña o con Google).
class UserModel {
  final String id;
  final String email;
  final String name;
  final DateTime? birthDate;
  final String educationalCenter;
  final String career;
  final String city;
  final String profileImageUrl;
  final AuthProvider authProvider;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.birthDate,
    this.educationalCenter = '',
    this.career = '',
    this.city = '',
    this.profileImageUrl = '',
    this.authProvider = AuthProvider.emailPassword,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Crea un [UserModel] a partir de un mapa JSON (respuesta del backend).
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      birthDate: json['birth_date'] != null
          ? DateTime.parse(json['birth_date'] as String)
          : null,
      educationalCenter: json['educational_center'] as String? ?? '',
      career: json['career'] as String? ?? '',
      city: json['city'] as String? ?? '',
      profileImageUrl: json['profile_image_url'] as String? ?? '',
      authProvider: json['auth_provider'] != null
          ? AuthProvider.fromJson(json['auth_provider'] as String)
          : AuthProvider.emailPassword,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Serializa el modelo a un mapa JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'birth_date': birthDate?.toIso8601String(),
      'educational_center': educationalCenter,
      'career': career,
      'city': city,
      'profile_image_url': profileImageUrl,
      'auth_provider': authProvider.toJson(),
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    DateTime? birthDate,
    String? educationalCenter,
    String? career,
    String? city,
    String? profileImageUrl,
    AuthProvider? authProvider,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      educationalCenter: educationalCenter ?? this.educationalCenter,
      career: career ?? this.career,
      city: city ?? this.city,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      authProvider: authProvider ?? this.authProvider,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, authProvider: $authProvider)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
