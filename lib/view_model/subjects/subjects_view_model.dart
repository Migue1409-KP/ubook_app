import 'package:flutter/material.dart';
import '../../model/subjects/subjects.dart';

class SubjectsViewModel extends ChangeNotifier {

  final List<Subject> _subjects = [
    Subject(
      id: '1',
      nombre: 'Ingeniería de Sistemas',
      horas: 60,
      creditos: 4,
      prerrequisitos: [],
      contenido: 'Fundamentos de arquitectura de software.',
    ),
    Subject(
      id: '2',
      nombre: 'Cálculo Diferencial',
      horas: 64,
      creditos: 3,
      prerrequisitos: [],
      contenido: 'Límites y derivadas.',
    ),
  ];

  List<Subject> get subjects => _subjects;

  void addSubject(Subject subject) {
    _subjects.add(subject);
    notifyListeners();
  }

  void removeSubject(String id) {
    _subjects.removeWhere((s) => s.id == id);
    notifyListeners();
  }
  String _searchQuery = '';

  List<Subject> get filteredSubjects {
    if (_searchQuery.isEmpty) return _subjects;

    return _subjects
        .where((s) =>
            s.nombre.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void search(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}