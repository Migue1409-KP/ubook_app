import 'package:flutter/material.dart';
import '../../model/subjects/subject_dummy_data.dart';
import '../../model/subjects/subjects.dart';

class SubjectsViewModel extends ChangeNotifier {
  SubjectsViewModel() : _subjects = List<Subject>.from(SubjectDummyData.build());

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
  }

  void updateExistingSubject(Subject updatedSubject) {
    final index = _subjects.indexWhere((item) => item.id == updatedSubject.id);
    if (index == -1) return;

    _subjects[index] = updatedSubject;
    notifyListeners();
  }

  void removeSubject(String id) {
    _subjects.removeWhere((subject) => subject.id == id);
    notifyListeners();
  }

  String serializePrerequisites(List<String> items) {
    if (items.isEmpty) return '';
    return items.join(', ');
  }
}