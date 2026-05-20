import 'package:shared_preferences/shared_preferences.dart';

/// Preferencias de UX para la feature teacher_subject.
///
/// Solo guarda estado de UI (no datos relacionales — esos viven en la tabla
/// `subject_teachers` de SQLite via Floor). Sigue el mismo patrón que
/// [AuthLocalStorage], que recuerda el último email tecleado.
class TeacherSubjectPrefs {
  static const _lastSelectedTeacherIdKey =
      'teacher_subject.last_selected_teacher_id';

  /// Guarda el id del último profesor seleccionado en la pantalla
  /// "Asignar Profesor ↔ Materia".
  Future<void> saveLastSelectedTeacherId(String teacherId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastSelectedTeacherIdKey, teacherId);
  }

  Future<String?> getLastSelectedTeacherId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastSelectedTeacherIdKey);
  }

  Future<void> clearLastSelectedTeacherId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastSelectedTeacherIdKey);
  }
}
