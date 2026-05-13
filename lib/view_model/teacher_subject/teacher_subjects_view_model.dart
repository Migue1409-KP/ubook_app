import 'package:flutter/material.dart';
import '../../model/teachers/teacher.dart';
import '../../model/subjectteacher/subjectteacher.dart';
import '../../model/subjects/subjects.dart';
import '../../repository/teacher_subject/floor_subject_teacher_repository.dart';
import '../../repository/teacher_subject/subject_teacher_repository.dart';

/// Catálogo de fallback usado cuando el caller no inyecta [allSubjects].
/// La capa Floor solo persiste las relaciones (tabla subject_teachers); el
/// catálogo de materias todavía no tiene su propio repositorio.
final List<Subject> _fallbackSubjects = [
  Subject(id: '1', nombre: 'Ingeniería de Sistemas', horas: 60, creditos: 4, prerrequisitos: const [], contenido: 'Fundamentos de arquitectura de software.'),
  Subject(id: '2', nombre: 'Cálculo Diferencial',    horas: 64, creditos: 3, prerrequisitos: const [], contenido: 'Límites y derivadas.'),
  Subject(id: '3', nombre: 'Fundamentos de IA',      horas: 48, creditos: 3, prerrequisitos: const [], contenido: 'Búsqueda, lógica y agentes.'),
  Subject(id: '4', nombre: 'Álgebra Lineal',         horas: 48, creditos: 3, prerrequisitos: const ['2'], contenido: 'Vectores y matrices.'),
  Subject(id: '5', nombre: 'Desarrollo Web',         horas: 64, creditos: 3, prerrequisitos: const [], contenido: 'HTML, CSS, JS y frameworks.'),
];

/// ViewModel para la pantalla de relaciones profesor ↔ materia.
///
/// Soporta dos modos:
/// - Modo profesor: lista materias asignadas / disponibles de un profesor.
/// - Modo materia : lista profesores asignados a una materia.
///
/// La persistencia se hace via [SubjectTeacherRepository] (Floor + SQLite).
class TeacherSubjectsViewModel extends ChangeNotifier {
  final Teacher? teacher;
  final Subject? subject;
  final List<Subject> allSubjects;
  final List<Teacher> allTeachers;
  final SubjectTeacherRepository _repository;

  TeacherSubjectsViewModel({
    this.teacher,
    this.subject,
    this.allSubjects = const [],
    this.allTeachers = const [],
    SubjectTeacherRepository? repository,
  })  : _repository = repository ?? FloorSubjectTeacherRepository.instance,
        assert(teacher != null || subject != null) {
    _load();
  }

  List<SubjectTeacher> _links = [];

  bool isInitialLoading = true;
  bool isBusy = false;
  String? errorMessage;
  String _searchQuery = '';

  int get storedLinkCount => _links.length;

  String get searchQuery => _searchQuery;
  bool get isTeacherMode => teacher != null;

  String get pageTitle => isTeacherMode
      ? 'Materias de ${teacher!.firstName}'
      : 'Profesores de ${subject!.nombre}';

  List<Subject> get _effectiveSubjects =>
      allSubjects.isNotEmpty ? allSubjects : _fallbackSubjects;

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

  Future<void> _load() async {
    isInitialLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      _links = isTeacherMode
          ? await _repository.findByTeacherId(teacher!.id)
          : await _repository.findBySubjectId(subject!.id);
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

  Future<bool> assignSubject(Subject subject) async {
    isBusy = true;
    notifyListeners();
    try {
      final now = DateTime.now();
      final link = SubjectTeacher(
        id: 'ST-${now.microsecondsSinceEpoch}',
        subjectId: subject.id,
        subjectNombre: subject.nombre,
        subjectCreditos: subject.creditos,
        subjectHoras: subject.horas,
        teacherId: teacher!.id,
        teacherName: teacher!.fullName,
        teacherEmail: teacher!.email,
        createdAt: now,
        updatedAt: now,
      );
      await _repository.insertSubjectTeacher(link);
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
      await _repository.deleteById(link.id);
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

  Future<bool> removeLink(SubjectTeacher link) async {
    isBusy = true;
    notifyListeners();
    try {
      await _repository.deleteById(link.id);
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
