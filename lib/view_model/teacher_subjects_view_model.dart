import 'package:flutter/material.dart';
import '../model/teachers/teacher.dart';
import '../model/subjectteacher/subjectteacher.dart';
import '../model/subjects/subjects.dart';

// ---------------------------------------------------------------------------
// FakeApi — simula backend. Incluye materias por defecto cuando no se inyectan.
// ---------------------------------------------------------------------------
class _FakeApi {
  static final List<Subject> _defaultSubjects = [
    Subject(id: '1', nombre: 'Ingeniería de Sistemas', horas: 60, creditos: 4, prerrequisitos: [], contenido: 'Fundamentos de arquitectura de software.'),
    Subject(id: '2', nombre: 'Cálculo Diferencial',    horas: 64, creditos: 3, prerrequisitos: [], contenido: 'Límites y derivadas.'),
    Subject(id: '3', nombre: 'Fundamentos de IA',      horas: 48, creditos: 3, prerrequisitos: [], contenido: 'Búsqueda, lógica y agentes.'),
    Subject(id: '4', nombre: 'Álgebra Lineal',         horas: 48, creditos: 3, prerrequisitos: ['2'], contenido: 'Vectores y matrices.'),
    Subject(id: '5', nombre: 'Desarrollo Web',         horas: 64, creditos: 3, prerrequisitos: [], contenido: 'HTML, CSS, JS y frameworks.'),
  ];

  static final List<SubjectTeacher> _links = [];

  static Future<List<Subject>> fetchSubjects() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.from(_defaultSubjects);
  }

  static Future<List<SubjectTeacher>> fetchLinksByTeacher(String teacherId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _links.where((l) => l.teacherId == teacherId).toList();
  }

  static Future<List<SubjectTeacher>> fetchLinksBySubject(String subjectId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _links.where((l) => l.subjectId == subjectId).toList();
  }

  static Future<SubjectTeacher> assign({
    required String teacherId,
    required String teacherName,
    required String teacherEmail,
    required Subject subject,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final link = SubjectTeacher(
      id: 'ST-${DateTime.now().millisecondsSinceEpoch}',
      subjectId: subject.id,
      subjectNombre: subject.nombre,
      subjectCreditos: subject.creditos,
      subjectHoras: subject.horas,
      teacherId: teacherId,
      teacherName: teacherName,
      teacherEmail: teacherEmail,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _links.add(link);
    return link;
  }

  static Future<void> removeLink(String linkId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _links.removeWhere((l) => l.id == linkId);
  }
}

// ---------------------------------------------------------------------------
// ViewModel
// ---------------------------------------------------------------------------
class TeacherSubjectsViewModel extends ChangeNotifier {
  final Teacher? teacher;
  final Subject? subject;
  final List<Subject> allSubjects;
  final List<Teacher> allTeachers;

  TeacherSubjectsViewModel({
    this.teacher,
    this.subject,
    this.allSubjects = const [],
    this.allTeachers = const [],
  }) : assert(teacher != null || subject != null) {
    _load();
  }

  List<SubjectTeacher> _links = [];
  List<Subject> _subjects = []; // se usa internamente

  bool isInitialLoading = true;
  bool isBusy = false;
  String? errorMessage;
  String _searchQuery = '';

  String get searchQuery => _searchQuery;
  bool get isTeacherMode => teacher != null;

  String get pageTitle => isTeacherMode
      ? 'Materias de ${teacher!.firstName}'
      : 'Profesores de ${subject!.nombre}';

  // ── derivados modo profesor ───────────────────────────────────────────────
  List<Subject> get _effectiveSubjects =>
      allSubjects.isNotEmpty ? allSubjects : _subjects;

  Set<String> get _assignedIds =>
      _links.where((l) => l.teacherId == teacher?.id).map((l) => l.subjectId).toSet();

  List<Subject> get assignedSubjects =>
      _effectiveSubjects.where((s) => _assignedIds.contains(s.id)).toList();

  List<Subject> get availableSubjects =>
      _effectiveSubjects.where((s) => !_assignedIds.contains(s.id)).toList();

  List<Subject> filteredAssigned() => _applySearch(assignedSubjects);
  List<Subject> filteredAvailable() => _applySearch(availableSubjects);

  bool isAssigned(String subjectId) => _assignedIds.contains(subjectId);

  int get totalCredits =>
      assignedSubjects.fold(0, (sum, s) => sum + s.creditos);

  // ── derivados modo materia ────────────────────────────────────────────────
  List<SubjectTeacher> get subjectLinks => _links;

  List<Subject> _applySearch(List<Subject> list) {
    if (_searchQuery.isEmpty) return list;
    final q = _searchQuery.toLowerCase();
    return list.where((s) => s.nombre.toLowerCase().contains(q)).toList();
  }

  void setSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // ── carga ─────────────────────────────────────────────────────────────────
  Future<void> _load() async {
    isInitialLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      // Si no llegaron materias de afuera, las carga internamente
      if (allSubjects.isEmpty) {
        _subjects = await _FakeApi.fetchSubjects();
      }
      _links = isTeacherMode
          ? await _FakeApi.fetchLinksByTeacher(teacher!.id)
          : await _FakeApi.fetchLinksBySubject(subject!.id);
    } catch (_) {
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
    await _load();
  }

  // ── asignar / quitar (modo profesor) ─────────────────────────────────────
  Future<bool> assignSubject(Subject subject) async {
    isBusy = true;
    notifyListeners();
    try {
      final link = await _FakeApi.assign(
        teacherId: teacher!.id,
        teacherName: teacher!.fullName,
        teacherEmail: teacher!.email,
        subject: subject,
      );
      _links.add(link);
      errorMessage = null;
      return true;
    } catch (_) {
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
      final link = _links.firstWhere(
        (l) => l.subjectId == subject.id && l.teacherId == teacher!.id,
      );
      await _FakeApi.removeLink(link.id);
      _links.remove(link);
      errorMessage = null;
      return true;
    } catch (_) {
      errorMessage = 'No se pudo quitar la materia. Intenta de nuevo.';
      return false;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  // ── quitar (modo materia) ─────────────────────────────────────────────────
  Future<bool> removeLink(SubjectTeacher link) async {
    isBusy = true;
    notifyListeners();
    try {
      await _FakeApi.removeLink(link.id);
      _links.remove(link);
      errorMessage = null;
      return true;
    } catch (_) {
      errorMessage = 'No se pudo quitar la asignación.';
      return false;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }
}