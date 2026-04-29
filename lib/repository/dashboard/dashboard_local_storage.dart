import 'package:shared_preferences/shared_preferences.dart';

class DashboardLocalStorage {
  static const _selectedFilterKey = 'dashboard.selected_filter';

  Future<String?> getSelectedFilter() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedFilterKey);
  }

  Future<void> saveSelectedFilter(String filter) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedFilterKey, filter);
  }
}