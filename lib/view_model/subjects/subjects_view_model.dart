import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../model/notification/notification_model.dart';
import '../../model/subjects/subjects.dart';
import '../../repository/subjects/subject_repository.dart';
import '../../service/notification_service.dart';
import '../../utils/session_manager.dart';

class SubjectsViewModel extends ChangeNotifier {

  final List<Subject> _subjects = <Subject>[];
  String _searchQuery = '';
  String? _currentUserId;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String? get currentUserId => _currentUserId;

  Future<void> initialize() async {
    await _initializeSession();
  }

  Future<void> _initializeSession() async {
    final sessionManager = SessionManager();
    _currentUserId = sessionManager.currentUserId;
    debugPrint('[SubjectsViewModel] auth=${sessionManager.isAuthenticated} userId=$_currentUserId');
    await loadUserSubjects();
  }

  Future<void> loadUserSubjects() async {
    _isLoading = true;
    notifyListeners();

    try {
      final sessionManager = SessionManager();
      final isAuthenticated = sessionManager.isAuthenticated;
      final userId = sessionManager.currentUserId;

      debugPrint('[SubjectsViewModel] cargando userId=$userId auth=$isAuthenticated');

      if (!isAuthenticated || userId == null || userId.isEmpty) {
        _subjects.clear();
        debugPrint('[SubjectsViewModel] sin sesión, lista vacía');
        return;
      }

      _currentUserId = userId;

      List<Subject> loadedSubjects = <Subject>[];
      try {
        final entities = await SubjectRepository.instance.getSubjects();
        loadedSubjects = entities.map(Subject.fromEntity).toList();
      } catch (e) {
        debugPrint('[SubjectsViewModel] error al consultar SubjectRepository: $e');
      }

      _subjects
        ..clear()
        ..addAll(loadedSubjects);
    } catch (e) {
      debugPrint('Error al cargar materias del usuario: $e');
      _subjects.clear();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Subject> get subjects => List<Subject>.unmodifiable(_subjects);

  List<Subject> get filteredSubjects {
    if (_searchQuery.trim().isEmpty) {
      return List<Subject>.unmodifiable(_subjects);
    }

    final query = _searchQuery.toLowerCase().trim();

    return List<Subject>.unmodifiable(
      _subjects.where((subject) {
        return subject.nombre.toLowerCase().contains(query) ||
            subject.contenido.toLowerCase().contains(query);
      }),
    );
  }

  void search(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> createSubject(Subject subject) async {
    final entity = subject.toEntity(isSync: false);
    await SubjectRepository.instance.addSubject(entity);
    _subjects.insert(0, subject);
    notifyListeners();
    unawaited(NotificationService.push(
      title: 'Nueva asignatura creada',
      message: 'La asignatura "${subject.nombre}" fue registrada en el sistema.',
      type: NotificationType.subjectCreated,
    ));
  }

  Future<void> updateExistingSubject(Subject updatedSubject) async {
    final index = _subjects.indexWhere((item) => item.id == updatedSubject.id);
    if (index == -1) return;

    final entity = updatedSubject.toEntity(isSync: false);
    await SubjectRepository.instance.updateSubject(entity);
    _subjects[index] = updatedSubject;
    notifyListeners();
    unawaited(NotificationService.push(
      title: 'Asignatura actualizada',
      message: 'La asignatura "${updatedSubject.nombre}" fue actualizada.',
      type: NotificationType.subjectCreated,
    ));
  }

  Future<void> removeSubject(String id) async {
    final subject = _subjects.firstWhere((s) => s.id == id);
    await SubjectRepository.instance.deleteSubject(id);
    _subjects.removeWhere((s) => s.id == id);
    notifyListeners();
    unawaited(NotificationService.push(
      title: 'Asignatura eliminada',
      message: 'La asignatura "${subject.nombre}" fue eliminada del sistema.',
      type: NotificationType.subjectCreated,
    ));
  }
}
