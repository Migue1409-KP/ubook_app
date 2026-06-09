import 'dart:async';

import 'package:flutter/material.dart';
import '../../model/teachers/teacher.dart';
import '../../model/subjectteacher/subjectteacher.dart';
import '../../model/subjectteacher/academic_period.dart';
import '../../model/subjects/subjects.dart';
import '../../repository/teacher_subject/floor_subject_teacher_repository.dart';
import '../../repository/teacher_subject/academic_period_api_repository.dart';
import '../../repository/teacher_subject/subject_teacher_repository.dart';
import '../../service/analytics_service.dart';

/// Catálogo de fallback usado cuando el caller no inyecta [allSubjects].
/// La capa Floor solo persiste las relaciones (tabla subject_teachers); el
/// catálogo de materias todavía no tiene su propio repositorio.
final List<Subject> _fallbackSubjects = [
  Subject(
    id: '1',
    nombre: 'Ingeniería de Sistemas',
    horas: 60,
    creditos: 4,
    prerrequisitos: const [],
    contenido: 'Fundamentos de arquitectura de software.',
  ),
  Subject(
    id: '2',
    nombre: 'Cálculo Diferencial',
    horas: 64,
    creditos: 3,
    prerrequisitos: const [],
    contenido: 'Límites y derivadas.',
  ),
  Subject(
    id: '3',
    nombre: 'Fundamentos de IA',
    horas: 48,
    creditos: 3,
    prerrequisitos: const [],
    contenido: 'Búsqueda, lógica y agentes.',
  ),
  Subject(
    id: '4',
    nombre: 'Álgebra Lineal',
    horas: 48,
    creditos: 3,
    prerrequisitos: const ['2'],
    contenido: 'Vectores y matrices.',
  ),
  Subject(
    id: '5',
    nombre: 'Desarrollo Web',
    horas: 64,
    creditos: 3,
    prerrequisitos: const [],
    contenido: 'HTML, CSS, JS y frameworks.',
  ),
];

/// ViewModel para la pantalla de relaciones profesor ↔ materia.
///
/// Soporta dos modos:
/// - Modo profesor: lista materias asignadas / disponibles de un profesor.
/// - Modo materia : lista profesores asignados a una materia.
///
/// La persistencia se hace via [SubjectTeacherRepository] (Floor + SQLite).
/// El catálogo de periodos académicos se obtiene desde la API remota
/// (ver [AcademicPeriodApiRepository]).
class TeacherSubjectsViewModel extends ChangeNotifier {
  final Teacher? teacher;
  final Subject? subject;
  final List<Subject> allSubjects;
  final List<Teacher> allTeachers;
  final SubjectTeacherRepository _repository;
  final AcademicPeriodApiRepository _periodoApi;

  TeacherSubjectsViewModel({
    this.teacher,
    this.subject,
    this.allSubjects = const [],
    this.allTeachers = const [],
    SubjectTeacherRepository? repository,
    AcademicPeriodApiRepository? periodoApi,
  }) : _repository = repository ?? FloorSubjectTeacherRepository.instance,
       _periodoApi = periodoApi ?? AcademicPeriodApiRepository.instance,
       assert(teacher != null || subject != null) {
    _load();
  }

  List<SubjectTeacher> _links = [];

  bool isInitialLoading = true;
  bool isBusy = false;
  String? errorMessage;
  String? apiWarning;
  String _searchQuery = '';

  List<AcademicPeriod> _periodos = const [];
  AcademicPeriod? _selectedPeriodo;

  int get storedLinkCount => _links.length;

  String get searchQuery => _searchQuery;
  bool get isTeacherMode => teacher != null;
  List<AcademicPeriod> get periodos => _periodos;
  AcademicPeriod? get selectedPeriodo => _selectedPeriodo;

  String get pageTitle => isTeacherMode
      ? 'Materias de ${teacher!.firstName}'
      : 'Profesores de ${subject!.nombre}';

  List<Subject> get _effectiveSubjects =>
      allSubjects.isNotEmpty ? allSubjects : _fallbackSubjects;

  /// Asignaciones del periodo seleccionado. Si no hay periodo seleccionado
  /// (porque la API falló) se devuelven todos los links.
  List<SubjectTeacher> get _filteredLinks {
    if (_selectedPeriodo == null) return _links;
    return _links
        .where((l) => l.periodoAcademicoId == _selectedPeriodo!.id)
        .toList();
  }

  Set<String> get _assignedIds => _filteredLinks
      .where((l) => l.teacherId == teacher?.id)
      .map((l) => l.subjectId)
      .toSet();

  List<Subject> get assignedSubjects =>
      _effectiveSubjects.where((s) => _assignedIds.contains(s.id)).toList();

  List<Subject> get availableSubjects =>
      _effectiveSubjects.where((s) => !_assignedIds.contains(s.id)).toList();

  List<Subject> filteredAssigned() => _applySearch(assignedSubjects);
  List<Subject> filteredAvailable() => _applySearch(availableSubjects);

  bool isAssigned(String subjectId) => _assignedIds.contains(subjectId);

  int get totalCredits =>
      assignedSubjects.fold(0, (sum, s) => sum + s.creditos);

  List<SubjectTeacher> get subjectLinks => _filteredLinks;

  SubjectTeacher? linkForSubject(String subjectId) {
    for (final l in _filteredLinks) {
      if (l.subjectId == subjectId && l.teacherId == teacher?.id) {
        return l;
      }
    }
    return null;
  }

  List<Subject> _applySearch(List<Subject> list) {
    if (_searchQuery.isEmpty) return list;
    final q = _searchQuery.toLowerCase();
    return list.where((s) => s.nombre.toLowerCase().contains(q)).toList();
  }

  void setSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void selectPeriodo(AcademicPeriod periodo) {
    _selectedPeriodo = periodo;
    notifyListeners();
  }

  Future<void> _load() async {
    isInitialLoading = true;
    errorMessage = null;
    apiWarning = null;
    notifyListeners();

    // Paso 1: BD local (crítico). Si falla aquí no podemos mostrar nada.
    try {
      _links = isTeacherMode
          ? await _repository.findByTeacherId(teacher!.id)
          : await _repository.findBySubjectId(subject!.id);
    } catch (_) {
      errorMessage = 'No se pudo cargar la información. Intenta de nuevo.';
      isInitialLoading = false;
      notifyListeners();
      return;
    }

    // Paso 2: API (no crítico). Si falla mostramos warning pero no bloqueamos.
    try {
      _periodos = await _periodoApi.fetchPeriods();
      if (_periodos.isNotEmpty) {
        _selectedPeriodo = _periodos.firstWhere(
          (p) => p.estaActivo,
          orElse: () => _periodos.first,
        );
      }
    } catch (_) {
      _periodos = const [];
      apiWarning =
          'Sin conexión al catálogo de periodos. '
          'Mostrando todas las asignaciones.';
    }

    isInitialLoading = false;
    notifyListeners();
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
        periodoAcademicoId: _selectedPeriodo?.id,
        periodoEtiqueta: _selectedPeriodo?.etiqueta,
        createdAt: now,
        updatedAt: now,
      );
      await _repository.insertSubjectTeacher(link);
      _links.add(link);
      unawaited(
        AnalyticsService.instance.logSubjectTeacherAssigned(
          source: subject == this.subject ? 'subject_detail' : 'teacher_detail',
        ),
      );
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
      final link = _filteredLinks.firstWhere(
        (l) => l.subjectId == subject.id && l.teacherId == teacher!.id,
      );
      await _repository.deleteById(link.id);
      _links.remove(link);
      unawaited(
        AnalyticsService.instance.logSubjectTeacherRemoved(
          source: subject == this.subject ? 'subject_detail' : 'teacher_detail',
        ),
      );
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
      unawaited(
        AnalyticsService.instance.logSubjectTeacherRemoved(
          source: 'link_detail',
        ),
      );
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
