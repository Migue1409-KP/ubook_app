import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Gestor centralizado de sesión de usuario.
/// Proporciona acceso a la información del usuario actualmente logueado.
class SessionManager {
  SessionManager._internal();

  static final SessionManager _instance = SessionManager._internal();

  factory SessionManager() {
    return _instance;
  }

  static const _userIdKey = 'session.user_id';
  static const _userEmailKey = 'session.user_email';
  static const _userNameKey = 'session.user_name';
  static const _userPhotoUrlKey = 'session.user_photo_url';

  /// Obtiene la instancia singleton del SessionManager
  static SessionManager get instance => _instance;

  /// ID del usuario actualmente logueado
  String? _currentUserId;

  /// Email del usuario actualmente logueado
  String? _currentUserEmail;

  /// Nombre del usuario actualmente logueado
  String? _currentUserName;

  /// URL de foto del usuario actualmente logueado
  String? _currentUserPhotoUrl;

  /// Inicializa el SessionManager cargando datos de SharedPreferences
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _currentUserId = prefs.getString(_userIdKey);
    _currentUserEmail = prefs.getString(_userEmailKey);
    _currentUserName = prefs.getString(_userNameKey);
    _currentUserPhotoUrl = prefs.getString(_userPhotoUrlKey);
    debugPrint('SessionManager.initialize() userId=$_currentUserId email=$_currentUserEmail');
  }

  /// Obtiene el ID del usuario actualmente logueado
  String? get currentUserId => _currentUserId;

  /// Obtiene el email del usuario actualmente logueado
  String? get currentUserEmail => _currentUserEmail;

  /// Obtiene el nombre del usuario actualmente logueado
  String? get currentUserName => _currentUserName;

  /// Obtiene la URL de foto del usuario actualmente logueado
  String? get currentUserPhotoUrl => _currentUserPhotoUrl;

  /// Verifica si hay un usuario actualmente logueado
  bool get isAuthenticated => _currentUserId != null && _currentUserId!.isNotEmpty;

  /// Guarda la información del usuario logueado
  Future<void> saveUserSession({
    required String userId,
    required String email,
    String? name,
    String? photoUrl,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    _currentUserId = userId;
    _currentUserEmail = email;
    _currentUserName = name;
    _currentUserPhotoUrl = photoUrl;

    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_userEmailKey, email);
    if (name != null) {
      await prefs.setString(_userNameKey, name);
    }
    if (photoUrl != null) {
      await prefs.setString(_userPhotoUrlKey, photoUrl);
    }
    debugPrint('SessionManager.saveUserSession() userId=$userId email=$email');
  }

  /// Limpia la sesión actual (logout)
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    _currentUserId = null;
    _currentUserEmail = null;
    _currentUserName = null;
    _currentUserPhotoUrl = null;

    await prefs.remove(_userIdKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userPhotoUrlKey);
  }
}
