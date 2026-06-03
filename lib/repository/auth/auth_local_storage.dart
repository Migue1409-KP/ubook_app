import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalStorage {
  static const _lastLoginEmailKey = 'auth.last_login_email';
  static const _lastLoginAtKey = 'auth.last_login_at';
  static const _hasActiveSessionKey = 'auth.has_active_session';
  static const _registerDraftKey = 'auth.register_draft';
  static const _userIdKey = 'auth.user_id';
  static const _userNameKey = 'auth.user_name';

  Future<void> saveLastLoginEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastLoginEmailKey, email);
  }

  Future<String?> getLastLoginEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastLoginEmailKey);
  }

  Future<void> saveLastLoginAt(DateTime dateTime) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastLoginAtKey, dateTime.toIso8601String());
  }

  Future<DateTime?> getLastLoginAt() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_lastLoginAtKey);
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }

  Future<void> setHasActiveSession(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasActiveSessionKey, value);
  }

  Future<bool> getHasActiveSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasActiveSessionKey) ?? false;
  }

  Future<void> saveRegisterDraft({
    required String name,
    required String email,
    required String educationalCenter,
    required String career,
    required String city,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final payload = <String, String>{
      'name': name,
      'email': email,
      'educationalCenter': educationalCenter,
      'career': career,
      'city': city,
    };
    await prefs.setString(_registerDraftKey, jsonEncode(payload));
  }

  Future<Map<String, String>> getRegisterDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_registerDraftKey);
    if (raw == null || raw.isEmpty) return {};

    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) return {};

    return decoded.map((key, value) => MapEntry(key, '${value ?? ''}'));
  }

  Future<void> clearRegisterDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_registerDraftKey);
  }

  /// Guarda el ID del usuario logueado
  Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
  }

  /// Obtiene el ID del usuario logueado
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  /// Guarda el nombre del usuario logueado
  Future<void> saveUserName(String userName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, userName);
  }

  /// Obtiene el nombre del usuario logueado
  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  /// Limpia toda la información del usuario (logout)
  Future<void> clearUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_lastLoginEmailKey);
    await prefs.remove(_lastLoginAtKey);
    await prefs.remove(_hasActiveSessionKey);
  }
}