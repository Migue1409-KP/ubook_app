import 'package:flutter/material.dart';
import '../model/teachers/teacher.dart';
import '../model/subject/subject.dart';
import '../model/subjectteacher/subjectteacher.dart';

// ---------------------------------------------------------------------------
// Simula las respuestas que vendría de un backend real (REST / Supabase / etc.)
// Reemplaza estos métodos por tus llamadas HTTP cuando tengas el backend listo.
// ---------------------------------------------------------------------------
class _FakeApi {
  static final List<Subject> _subjects = [
    Subject(id: 's1', name: 'Ing. Software I',      code: 'SW101', credits: 3, description: 'Fundamentos de ingeniería de software', createdAt: DateTime(2024, 1, 10), updatedAt: DateTime(2024, 1, 10)),
    Subject(id: 's2', name: 'Ing. Software II',     code: 'SW102', credits: 3, description: 'Arquitecturas y patrones de diseño',    createdAt: DateTime(2024, 1, 10), updatedAt: DateTime(2024, 1, 10)),
    Subject(id: 's3', name: 'Base de Datos',         code: 'DB201', credits: 4, description: 'Diseño y gestión de BD relacionales',  createdAt: DateTime(2024, 1, 10), updatedAt: DateTime(2024, 1, 10)),
    Subject(id: 's4', name: 'Redes',                 code: 'NET301',credits: 3, description: 'Fundamentos de redes de computadoras', createdAt: DateTime(2024, 1, 10), updatedAt: DateTime(2024, 1, 10)),
    Subject(id: 's5', name: 'Matemáticas Discretas', code: 'MAT101',credits: 4, description: 'Lógica, conjuntos y teoría de grafos', createdAt: DateTime(2024, 1, 10), updatedAt: DateTime(2024, 1, 10)),
  ];

  static final List<SubjectTeacher> _links = [
    SubjectTeacher(id: 'st1', subjectId: 's1', teacherId: 't1', createdAt: DateTime(2024, 2, 1), updatedAt: DateTime(2024, 2, 1)),
    SubjectTeacher(id: 'st2', subjectId: 's2', teacherId: 't1', createdAt: DateTime(2024, 2, 1), updatedAt: DateTime(2024, 2, 1)),
  ];

  // GET /subjects
  static Future<List<Subject>> fetchAllSubjects() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return List.from(_subjects);
  }

  // GET /subject-teachers?teacherId=xxx
  static Future<List<SubjectTeacher>> fetchLinksForTeacher(String teacherId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _links.where((l) => l.teacherId == teacherId).toList();
  }

  // POST /subject-teachers
  static Future<SubjectTeacher> assignSubject(String teacherId, String subjectId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newLink = SubjectTeacher(
      id: 'st_${DateTime.now().millisecondsSinceEpoch}',
      subjectId: subjectId,
      teacherId: teacherId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _links.add(newLink);
    return newLink;
  }

  // DELETE /subject-teachers/:id
  static Future<void> removeSubject(String teacherId, String subjectId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _links.removeWhere((l) => l.teacherId == teacherId && l.subjectId == subjectId);
  }
}

// ---------------------------------------------------------------------------
// ViewModel
// ---------------------------------------------------------------------------
class TeacherSubjectsViewModel extends ChangeNotifier {
  final Teacher teacher;

  TeacherSubjectsViewModel({required this.teacher}) {
    _init();
  }

  // --- state ---
  List<Subject> _allSubjects = [];
  List<SubjectTeacher> _links = [];

  bool isInitialLoading = true;   // carga inicial (skeleton)
  bool isBusy = false;            // acción en curso (assign / remove)
  String? errorMessage;
  String _searchQuery = '';

  String get searchQuery => _searchQuery;

  // --- derivados ---
  Set<String> get _assignedIds =>
      _links.where((l) => l.teacherId == teacher.id).map((l) => l.subjectId).toSet();

  List<Subject> get assignedSubjects =>
      _allSubjects.where((s) => _assignedIds.contains(s.id)).toList();

  List<Subject> get availableSubjects =>
      _allSubjects.where((s) => !_assignedIds.contains(s.id)).toList();

  List<Subject> filteredAssigned() => _applySearch(assignedSubjects);
  List<Subject> filteredAvailable() => _applySearch(availableSubjects);

  bool isAssigned(String subjectId) => _assignedIds.contains(subjectId);

  int get totalCredits => assignedSubjects.fold(0, (sum, s) => sum + s.credits);

  List<Subject> _applySearch(List<Subject> list) {
    if (_searchQuery.isEmpty) return list;
    final q = _searchQuery.toLowerCase();
    return list.where((s) =>
        s.name.toLowerCase().contains(q) || s.code.toLowerCase().contains(q)).toList();
  }

  // --- acciones ---
  Future<void> _init() async {
    try {
      final results = await Future.wait([
        _FakeApi.fetchAllSubjects(),
        _FakeApi.fetchLinksForTeacher(teacher.id),
      ]);
      _allSubjects = results[0] as List<Subject>;
      _links      = results[1] as List<SubjectTeacher>;
      errorMessage = null;
    } catch (e) {
      errorMessage = 'No se pudo cargar la información. Intenta de nuevo.';
    } finally {
      isInitialLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    isInitialLoading = true;
    errorMessage = null;
    notifyListeners();
    await _init();
  }

  void setSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<bool> assignSubject(Subject subject) async {
    isBusy = true;
    notifyListeners();
    try {
      final link = await _FakeApi.assignSubject(teacher.id, subject.id);
      _links.add(link);
      errorMessage = null;
      return true;
    } catch (e) {
      errorMessage = 'No se pudo asignar la materia. Intenta de nuevo.';
      return false;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  Future<bool> removeSubject(Subject subject) async {
    isBusy = true;
    notifyListeners();
    try {
      await _FakeApi.removeSubject(teacher.id, subject.id);
      _links.removeWhere(
          (l) => l.subjectId == subject.id && l.teacherId == teacher.id);
      errorMessage = null;
      return true;
    } catch (e) {
      errorMessage = 'No se pudo quitar la materia. Intenta de nuevo.';
      return false;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }
}