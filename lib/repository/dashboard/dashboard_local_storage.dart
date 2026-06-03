import 'package:shared_preferences/shared_preferences.dart';

class DashboardLocalStorage {
  static const String _selectedFilterKey = 'dashboard.selected_filter';
  static const String _searchQueryKey = 'dashboard.search_query';

  Future<String?> getSelectedFilter() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedFilterKey);
  }

  Future<void> saveSelectedFilter(String filter) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedFilterKey, filter);
  }

  Future<String?> getSearchQuery() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_searchQueryKey);
  }

  Future<void> saveSearchQuery(String query) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_searchQueryKey, query);
  }
}
