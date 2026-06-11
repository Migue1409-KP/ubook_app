import 'package:shared_preferences/shared_preferences.dart';

class TeacherPreferences {
  static const String _keyLastSync = 'teacher_last_sync_date';
  static const String _keySortAscending = 'teacher_sort_ascending';
  static const String _keyDefaultCountryCode = 'teacher_default_country_code';

  final SharedPreferences _prefs;

  TeacherPreferences(this._prefs);

  static Future<TeacherPreferences> init() async {
    final prefs = await SharedPreferences.getInstance();
    return TeacherPreferences(prefs);
  }

  Future<bool> setLastSyncDate(DateTime date) async {
    return _prefs.setString(_keyLastSync, date.toIso8601String());
  }

  DateTime? getLastSyncDate() {
    final dateString = _prefs.getString(_keyLastSync);
    if (dateString != null) {
      try {
        return DateTime.parse(dateString);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<bool> setSortAscending(bool value) async {
    return _prefs.setBool(_keySortAscending, value);
  }

  bool getSortAscending() {
    return _prefs.getBool(_keySortAscending) ?? true;
  }

  Future<bool> setDefaultCountryCode(String code) async {
    return _prefs.setString(_keyDefaultCountryCode, code);
  }

  String getDefaultCountryCode() {
    return _prefs.getString(_keyDefaultCountryCode) ?? '+57';
  }
}
