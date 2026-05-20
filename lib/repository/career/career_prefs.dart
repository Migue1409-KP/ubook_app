import 'package:shared_preferences/shared_preferences.dart';

/// Preferencias de UX para la feature career.
///
/// `careers` de SQLite via Floor). Sigue el mismo patrón que
/// [TeacherSubjectPrefs], que recuerda el último profesor seleccionado.
class CareerPrefs {
  static const _sortOrderKey = 'career.sort_order';

  Future<void> saveSortOrder(String sortOrder) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sortOrderKey, sortOrder);
  }

  Future<String?> getSortOrder() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_sortOrderKey);
  }

  Future<void> clearSortOrder() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sortOrderKey);
  }
}