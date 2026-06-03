import 'package:shared_preferences/shared_preferences.dart';

class NotificationAdminPrefs {
  static const String _searchQueryKey = 'notification_admin.search_query';
  static const String _statusFilterKey = 'notification_admin.status_filter';
  static const String _typeFilterKey = 'notification_admin.type_filter';
  static const String _dateFilterKey = 'notification_admin.date_filter';
  static const String _sortOptionKey = 'notification_admin.sort_option';

  Future<String?> getSearchQuery() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_searchQueryKey);
  }

  Future<void> saveSearchQuery(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_searchQueryKey, value);
  }

  Future<String?> getStatusFilter() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_statusFilterKey);
  }

  Future<void> saveStatusFilter(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_statusFilterKey, value);
  }

  Future<String?> getTypeFilter() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_typeFilterKey);
  }

  Future<void> saveTypeFilter(String? value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value == null || value.isEmpty) {
      await prefs.remove(_typeFilterKey);
      return;
    }
    await prefs.setString(_typeFilterKey, value);
  }

  Future<String?> getDateFilter() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_dateFilterKey);
  }

  Future<void> saveDateFilter(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_dateFilterKey, value);
  }

  Future<String?> getSortOption() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_sortOptionKey);
  }

  Future<void> saveSortOption(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sortOptionKey, value);
  }

  Future<void> clearFilters() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_searchQueryKey);
    await prefs.remove(_statusFilterKey);
    await prefs.remove(_typeFilterKey);
    await prefs.remove(_dateFilterKey);
    await prefs.remove(_sortOptionKey);
  }
}
