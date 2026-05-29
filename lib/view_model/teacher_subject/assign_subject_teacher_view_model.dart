import 'package:flutter/material.dart';
import '../../model/teachers/teacher.dart';
import '../../model/subjectteacher/subjectteacher.dart';
import '../../model/subjectteacher/academic_period.dart';
import '../../model/subjects/subjects.dart';
import '../../repository/teacher_subject/academic_period_api_repository.dart';
import '../../repository/teacher_subject/subject_teacher_repository.dart';
import '../../repository/teacher_subject/teacher_subject_prefs.dart';

/// Catálogos de fallback usados cuando el caller no inyecta listas externas.
/// La capa Floor solo persiste las relaciones (tabla subject_teachers).
final List<Teacher> _fallbackTeachers = [
  Teacher(id: 'TCH-001', firstName: 'Juan',   lastName: 'Pablo',  email: 'juan.pablo@uco.edu',   phone: '809-555-0101', age: 25, department: 'Ingeniería de Sistemas', specialty: 'Desarrollo Móvil',       subjects: const [], profileImageUrl: '', isActive: true, createdAt: DateTime(2024,1,15),  updatedAt: DateTime(2024,6,10)),
  Teacher(id: 'TCH-002', firstName: 'Maria',  lastName: 'Lopez',  email: 'maria.lopez@uco.edu',  phone: '809-555-0102', age: 34, department: 'Ingeniería de Sistemas', specialty: 'Inteligencia Artificial', subjects: const [], profileImageUrl: '', isActive: true, createdAt: DateTime(2023,8,20),  updatedAt: DateTime(2024,5,5)),
  Teacher(id: 'TCH-003', firstName: 'Carlos', lastName: 'Mendez', email: 'carlos.mendez@uco.edu', phone: '809-555-0103', age: 45, department: 'Matemáticas',            specialty: 'Ciencias Exactas',       subjects: const [], profileImageUrl: '', isActive: true, createdAt: DateTime(2022,3,1),   updatedAt: DateTime(2024,4,18)),
  Teacher(id: 'TCH-004', firstName: 'Ana',    lastName: 'Rivera', email: 'ana.rivera@uco.edu',   phone: '809-555-0104', age: 39, department: 'Ingeniería de Sistemas', specialty: 'Desarrollo Web',          subjects: const [], profileImageUrl: '', isActive: true, createdAt: DateTime(2023,1,10),  updatedAt: DateTime(2024,7,22)),
];

final List<Subject> _fallbackSubjects = [
  Subject(id: '1', nombre: 'Ingeniería de Sistemas', horas: 60, creditos: 4, prerrequisitos: const [], contenido: 'Fundamentos de arquitectura de software.'),
  Subject(id: '2', nombre: 'Cálculo Diferencial',    horas: 64, creditos: 3, prerrequisitos: const [], contenido: 'Límites y derivadas.'),
  Subject(id: '3', nombre: 'Fundamentos de IA',      horas: 48, creditos: 3, prerrequisitos: const [], contenido: 'Búsqueda, lógica y agentes.'),
  Subject(id: '4', nombre: 'Álgebra Lineal',         horas: 48, creditos: 3, prerrequisitos: const ['2'], contenido: 'Vectores y matrices.'),
  Subject(id: '5', nombre: 'Desarrollo Web',         horas: 64, creditos: 3, prerrequisitos: const [], contenido: 'HTML, CSS, JS y frameworks.'),
];

class AssignSubjectTeacherViewModel extends ChangeNotifier {
  final List<Teacher> allTeachers;
  final List<Subject> allSubjects;
  final SubjectTeacherRepository _repository;
  final TeacherSubjectPrefs _prefs;
  final AcademicPeriodApiRepository _periodoApi;

  AssignSubjectTeacherViewModel({
    this.allTeachers = const [],
    this.allSubjects = const [],
    SubjectTeacherRepository? repository,
    TeacherSubjectPrefs? prefs,
    AcademicPeriodApiRepository? periodoApi,
  })  : _repository = repository ?? SubjectTeacherRepository.instance,
        _prefs = prefs ?? TeacherSubjectPrefs(),
        _periodoApi = periodoApi ?? AcademicPeriodApiRepository.instance {
    _load();
  }

  /// teacherId_subjectId_periodoId → linkId. Permite saber si una pareja está
  /// asignada en el periodo seleccionado y obtener el linkId para borrarla.
  final Map<String, String?> _linkMap = {};

  bool isLoading = true;
  String? busyKey;
  String? errorMessage;

  String? apiWarning;

  String _searchTeacher = '';
  String _searchSubject = '';
  String? _selectedTeacherId;

  List<AcademicPeriod> _periodos = const [];
  AcademicPeriod? _selectedPeriodo;

  String get searchTeacher => _searchTeacher;
  String get searchSubject => _searchSubject;
  String? get selectedTeacherId => _selectedTeacherId;
  List<AcademicPeriod> get periodos => _periodos;
  AcademicPeriod? get selectedPeriodo => _selectedPeriodo;

  List<Teacher> get _effectiveTeachers =>
      allTeachers.isNotEmpty ? allTeachers : _fallbackTeachers;

  List<Subject> get _effectiveSubjects =>
      allSubjects.isNotEmpty ? allSubjects : _fallbackSubjects;

  Teacher? get selectedTeacher {
    if (_selectedTeacherId == null || _effectiveTeachers.isEmpty) return null;
    return _effectiveTeachers.firstWhere(
      (t) => t.id == _selectedTeacherId,
      orElse: () => _effectiveTeachers.first,
    );
  }

  List<Teacher> get filteredTeachers {
    if (_searchTeacher.isEmpty) return _effectiveTeachers;
    final q = _searchTeacher.toLowerCase();
    return _effectiveTeachers
        .where((t) =>
            t.fullName.toLowerCase().contains(q) ||
            t.email.toLowerCase().contains(q))
        .toList();
  }

  List<Subject> get filteredSubjects {
    if (_searchSubject.isEmpty) return _effectiveSubjects;
    final q = _searchSubject.toLowerCase();
    return _effectiveSubjects
        .where((s) => s.nombre.toLowerCase().contains(q))
        .toList();
  }

  bool isAssigned(String teacherId, String subjectId) =>
      _linkMap[_linkKey(teacherId, subjectId)] != null;

  String _linkKey(String teacherId, String subjectId) {
    final periodoId = _selectedPeriodo?.id ?? '_no_periodo_';
    return '${teacherId}_${subjectId}_$periodoId';
  }

  Future<void> _load() async {
    isLoading = true;
    notifyListeners();
    try {
      // Cargar el catálogo remoto en paralelo con la BD local. Si la API
      // falla, mostramos un warning pero NO bloqueamos: la app sigue
      // funcionando con la BD local (sin el filtro de periodo).
      final results = await Future.wait([
        _repository.findAll(),
        _periodoApi.fetchPeriods().catchError((_) => <AcademicPeriod>[]),
      ]);

      final links = results[0] as List<SubjectTeacher>;
      _periodos = results[1] as List<AcademicPeriod>;

      apiWarning = _periodos.isEmpty
          ? 'No se pudo cargar el catálogo de periodos. '
              'La asignación seguirá funcionando localmente.'
          : null;

      // Periodo activo por defecto, o el primero si ninguno está activo.
      if (_periodos.isNotEmpty) {
        _selectedPeriodo = _periodos.firstWhere(
          (p) => p.estaActivo,
          orElse: () => _periodos.first,
        );
      }

      _rebuildLinkMap(links);

      // Restaurar el último profesor seleccionado.
      if (_selectedTeacherId == null && _effectiveTeachers.isNotEmpty) {
        final savedId = await _prefs.getLastSelectedTeacherId();
        final exists =
            savedId != null && _effectiveTeachers.any((t) => t.id == savedId);
        _selectedTeacherId = exists ? savedId : _effectiveTeachers.first.id;
      }
      errorMessage = null;
    } catch (_) {
      errorMessage = 'No se pudo cargar los datos.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _rebuildLinkMap(List<SubjectTeacher> links) {
    _linkMap.clear();
    for (final l in links) {
      // Una asignación cuenta para el periodo seleccionado solo si su
      // periodoAcademicoId coincide. Las asignaciones legadas (sin periodo)
      // se asocian al sentinel '_no_periodo_' para que no contaminen los
      // periodos remotos.
      final periodoKey = l.periodoAcademicoId ?? '_no_periodo_';
      final key = '${l.teacherId}_${l.subjectId}_$periodoKey';
      _linkMap[key] = l.id;
    }
  }

  void selectTeacher(String teacherId) {
    _selectedTeacherId = teacherId;
    _searchSubject = '';
    _prefs.saveLastSelectedTeacherId(teacherId);
    notifyListeners();
  }

  void selectPeriodo(AcademicPeriod periodo) {
    _selectedPeriodo = periodo;
    notifyListeners();
  }

  void setSearchTeacher(String q) {
    _searchTeacher = q;
    notifyListeners();
  }

  void setSearchSubject(String q) {
    _searchSubject = q;
    notifyListeners();
  }

  Future<bool> toggle(String teacherId, String subjectId) async {
    final key = _linkKey(teacherId, subjectId);
    busyKey = key;
    notifyListeners();
    try {
      if (isAssigned(teacherId, subjectId)) {
        await _repository.deleteById(_linkMap[key]!);
        _linkMap[key] = null;
      } else {
        final teacher =
            _effectiveTeachers.firstWhere((t) => t.id == teacherId);
        final subject =
            _effectiveSubjects.firstWhere((s) => s.id == subjectId);
        final now = DateTime.now();
        final link = SubjectTeacher(
          id: 'ST-${now.microsecondsSinceEpoch}',
          subjectId: subject.id,
          subjectNombre: subject.nombre,
          subjectCreditos: subject.creditos,
          subjectHoras: subject.horas,
          teacherId: teacher.id,
          teacherName: teacher.fullName,
          teacherEmail: teacher.email,
          periodoAcademicoId: _selectedPeriodo?.id,
          periodoEtiqueta: _selectedPeriodo?.etiqueta,
          createdAt: now,
          updatedAt: now,
        );
        await _repository.insertSubjectTeacher(link);
        _linkMap[key] = link.id;
      }
      errorMessage = null;
      return true;
    } catch (_) {
      errorMessage = 'Error al actualizar la asignación.';
      return false;
    } finally {
      busyKey = null;
      notifyListeners();
    }
  }
}
