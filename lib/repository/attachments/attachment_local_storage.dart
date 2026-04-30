import 'package:shared_preferences/shared_preferences.dart';

class AttachmentLocalStorage {
  static const _customFileNameKey = 'attachment.custom_file_name';

  Future<void> saveCustomFileName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_customFileNameKey, name);
  }

  Future<String?> getCustomFileName() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_customFileNameKey);
    return (value != null && value.isNotEmpty) ? value : null;
  }

  Future<void> clearCustomFileName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_customFileNameKey);
  }
}
