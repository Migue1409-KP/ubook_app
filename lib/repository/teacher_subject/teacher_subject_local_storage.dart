import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../../model/subjectteacher/subjectteacher.dart';

enum TeacherSubjectOwner { teacher, subject }

class TeacherSubjectLocalStorage {
  static const _linksPrefix = 'teacher_subject_links';

  static String _linksKey(TeacherSubjectOwner owner, String ownerId) =>
      '${_linksPrefix}_${owner.name}_$ownerId';

  Future<List<SubjectTeacher>> getLinks(
    TeacherSubjectOwner owner,
    String ownerId,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _linksKey(owner, ownerId);
    final raw = prefs.getString(key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = json.decode(raw) as List<dynamic>;
      return decoded
          .map((e) => SubjectTeacher.fromJson(e as Map<String, dynamic>))
          .toList();
    } on FormatException {
      await prefs.remove(key);
      return [];
    }
  }

  Future<void> saveLinks(
    TeacherSubjectOwner owner,
    String ownerId,
    List<SubjectTeacher> links,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(links.map((l) => l.toJson()).toList());
    await prefs.setString(_linksKey(owner, ownerId), encoded);
  }

  Future<void> clearLinks(
    TeacherSubjectOwner owner,
    String ownerId,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_linksKey(owner, ownerId));
  }
}
