import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalStorage {
  static const _lastLoginEmailKey = 'auth.last_login_email';
  static const _lastLoginAtKey = 'auth.last_login_at';
  static const _hasActiveSessionKey = 'auth.has_active_session';
  static const _registerDraftKey = 'auth.register_draft';

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
}