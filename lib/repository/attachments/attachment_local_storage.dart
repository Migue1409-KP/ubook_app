import 'package:shared_preferences/shared_preferences.dart';

class AttachmentLocalStorage {
  static const _baseKey = 'AttachmentModel.custom_file_name';

  String _key(String contextKey) =>
      contextKey.isEmpty ? _baseKey : '$_baseKey.$contextKey';

  Future<void> saveCustomFileName(String name, {String contextKey = ''}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(contextKey), name);
  }

  Future<String?> getCustomFileName({String contextKey = ''}) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_key(contextKey));
    return (value != null && value.isNotEmpty) ? value : null;
  }

  Future<void> clearCustomFileName({String contextKey = ''}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key(contextKey));
  }
}
