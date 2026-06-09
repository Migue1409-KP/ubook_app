import 'dart:async';

import 'package:flutter/material.dart';
import '../../model/notification/notification_model.dart';
import '../../model/subjects/subject_dummy_data.dart';
import '../../model/subjects/subjects.dart';
import '../../service/analytics_service.dart';
import '../../service/notification_service.dart';

class SubjectsViewModel extends ChangeNotifier {
  SubjectsViewModel()
    : _subjects = List<Subject>.from(SubjectDummyData.build());

  final List<Subject> _subjects;
  String _searchQuery = '';

  List<Subject> get subjects => List<Subject>.unmodifiable(_subjects);

  List<Subject> get filteredSubjects {
    if (_searchQuery.trim().isEmpty) {
      return List<Subject>.unmodifiable(_subjects);
    }

    final query = _searchQuery.toLowerCase().trim();

    return List<Subject>.unmodifiable(
      _subjects.where((subject) {
        return subject.nombre.toLowerCase().contains(query) ||
            subject.contenido.toLowerCase().contains(query) ||
            subject.prerrequisitos.any(
              (item) => item.toLowerCase().contains(query),
            );
      }),
    );
  }

  void search(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void addExistingSubject(Subject subject) {
    _subjects.insert(0, subject);
    notifyListeners();
    unawaited(
      AnalyticsService.instance.logSubjectCreated(
        credits: subject.creditos,
        prerequisiteCount: subject.prerrequisitos.length,
      ),
    );
    unawaited(
      NotificationService.push(
        title: 'Nueva asignatura creada',
        message:
            'La asignatura "${subject.nombre}" fue registrada en el sistema.',
        type: NotificationType.subjectCreated,
      ),
    );
  }

  void updateExistingSubject(Subject updatedSubject) {
    final index = _subjects.indexWhere((item) => item.id == updatedSubject.id);
    if (index == -1) return;

    _subjects[index] = updatedSubject;
    notifyListeners();
    unawaited(
      AnalyticsService.instance.logSubjectUpdated(
        credits: updatedSubject.creditos,
        prerequisiteCount: updatedSubject.prerrequisitos.length,
      ),
    );
    unawaited(
      NotificationService.push(
        title: 'Asignatura actualizada',
        message: 'La asignatura "${updatedSubject.nombre}" fue actualizada.',
        type: NotificationType.subjectCreated,
      ),
    );
  }

  void removeSubject(String id) {
    final subject = _subjects.firstWhere((s) => s.id == id);
    _subjects.removeWhere((s) => s.id == id);
    notifyListeners();
    unawaited(AnalyticsService.instance.logSubjectDeleted());
    unawaited(
      NotificationService.push(
        title: 'Asignatura eliminada',
        message: 'La asignatura "${subject.nombre}" fue eliminada del sistema.',
        type: NotificationType.subjectCreated,
      ),
    );
  }

  String serializePrerequisites(List<String> items) {
    if (items.isEmpty) return '';
    return items.join(', ');
  }
}
