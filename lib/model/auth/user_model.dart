import 'package:floor/floor.dart';

import 'auth_provider.dart';
import 'package:ubook_app/repository/auth/floor_converters.dart';

/// Modelo del usuario autenticado en la aplicación.
///
/// Contiene la información del perfil del usuario tras registrarse
/// o iniciar sesión (con email/contraseña o con Google).
@TypeConverters([AuthProviderConverter])
@Entity(
  tableName: 'users',
  indices: [
    Index(value: ['email'], unique: true),
  ],
)
class UserModel {
  @PrimaryKey()
  final String id;
  final String email;
  final String name;
  final String password;
  // TODO: Implementar funcionalidad de fecha de nacimiento
  final int? birthDate;
  final String educationalCenter;
  final String career;
  final String city;
  // TODO: Implementar funcionalidad de imagen de perfil
  final String? profileImageUrl;
  final AuthProvider authProvider;
  final bool isActive;
  final int createdAt;
  final int updatedAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.password = '',
    this.birthDate,
    this.educationalCenter = '',
    this.career = '',
    this.city = '',
    this.profileImageUrl,
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
      password: json['password'] as String? ?? '',
      birthDate: _readTimestamp(json['birth_date']),
      educationalCenter: json['educational_center'] as String? ?? '',
      career: json['career'] as String? ?? '',
      city: json['city'] as String? ?? '',
      profileImageUrl: json['profile_image_url'] as String?,
      authProvider: json['auth_provider'] != null
          ? AuthProvider.fromJson(json['auth_provider'] as String)
          : AuthProvider.emailPassword,
      isActive: json['is_active'] as bool? ?? true,
      createdAt:
          _readTimestamp(json['created_at']) ??
          DateTime.now().millisecondsSinceEpoch,
      updatedAt:
          _readTimestamp(json['updated_at']) ??
          DateTime.now().millisecondsSinceEpoch,
    );
  }

  static int? _readTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) {
      final parsedInt = int.tryParse(value);
      if (parsedInt != null) return parsedInt;
      final parsedDate = DateTime.tryParse(value);
      return parsedDate?.millisecondsSinceEpoch;
    }
    return null;
  }

  /// Serializa el modelo a un mapa JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'password': password,
      'birth_date': birthDate == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(birthDate!).toIso8601String(),
      'educational_center': educationalCenter,
      'career': career,
      'city': city,
      'profile_image_url': profileImageUrl,
      'auth_provider': authProvider.toJson(),
      'is_active': isActive,
      'created_at': DateTime.fromMillisecondsSinceEpoch(
        createdAt,
      ).toIso8601String(),
      'updated_at': DateTime.fromMillisecondsSinceEpoch(
        updatedAt,
      ).toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? password,
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
      password: password ?? this.password,
      birthDate: birthDate?.millisecondsSinceEpoch ?? this.birthDate,
      educationalCenter: educationalCenter ?? this.educationalCenter,
      career: career ?? this.career,
      city: city ?? this.city,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      authProvider: authProvider ?? this.authProvider,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt?.millisecondsSinceEpoch ?? this.createdAt,
      updatedAt: updatedAt?.millisecondsSinceEpoch ?? this.updatedAt,
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
