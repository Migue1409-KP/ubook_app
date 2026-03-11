import 'package:flutter/material.dart';
import '../../model/teachers/teacher.dart';

class TeacherListViewModel extends ChangeNotifier {
  List<Teacher> _allTeachers = [];
  List<Teacher> _filteredTeachers = [];
  String _searchQuery = '';

  List<Teacher> get filteredTeachers => _filteredTeachers;
  String get searchQuery => _searchQuery;

  TeacherListViewModel() {
    _loadTeachers();
  }

  void _loadTeachers() {
    _allTeachers = [
      Teacher(
        id: 'TCH-001',
        firstName: 'Juan',
        lastName: 'Pablo',
        email: 'juan.pablo@uco.edu',
        phone: '809-555-0101',
        age: 25,
        department: 'Ingeniería de Sistemas',
        specialty: 'Desarrollo Móvil',
        subjects: ['Ingeniería de Software 3', 'Ingeniería de Software Avanzada 2'],
        profileImageUrl: 'https://example.com/avatars/juan.jpg',
        isActive: true,
        createdAt: DateTime(2024, 1, 15),
        updatedAt: DateTime(2024, 6, 10),
      ),
      Teacher(
        id: 'TCH-002',
        firstName: 'Maria',
        lastName: 'Lopez',
        email: 'maria.lopez@uco.edu',
        phone: '809-555-0102',
        age: 34,
        department: 'Ingeniería de Sistemas',
        specialty: 'Inteligencia Artificial',
        subjects: ['Fundamentos de IA', 'Aprendizaje Automático'],
        profileImageUrl: 'https://example.com/avatars/maria.jpg',
        isActive: true,
        createdAt: DateTime(2023, 8, 20),
        updatedAt: DateTime(2024, 5, 5),
      ),
      Teacher(
        id: 'TCH-003',
        firstName: 'Carlos',
        lastName: 'Mendez',
        email: 'carlos.mendez@uco.edu',
        phone: '809-555-0103',
        age: 45,
        department: 'Matemáticas',
        specialty: 'Ciencias Exactas',
        subjects: ['Cálculo I', 'Álgebra Lineal', 'Estadística'],
        profileImageUrl: 'https://example.com/avatars/carlos.jpg',
        isActive: true,
        createdAt: DateTime(2022, 3, 1),
        updatedAt: DateTime(2024, 4, 18),
      ),
      Teacher(
        id: 'TCH-004',
        firstName: 'Ana',
        lastName: 'Rivera',
        email: 'ana.rivera@uco.edu',
        phone: '809-555-0104',
        age: 39,
        department: 'Ingeniería de Sistemas',
        specialty: 'Desarrollo Web',
        subjects: ['Desarrollo Web', 'Diseño de Bases de Datos'],
        profileImageUrl: 'https://example.com/avatars/ana.jpg',
        isActive: true,
        createdAt: DateTime(2023, 1, 10),
        updatedAt: DateTime(2024, 7, 22),
      ),
    ];
    _filteredTeachers = List.from(_allTeachers);
    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredTeachers = List.from(_allTeachers);
    } else {
      final lowerQuery = query.toLowerCase();
      _filteredTeachers = _allTeachers.where((teacher) {
        return teacher.fullName.toLowerCase().contains(lowerQuery) ||
            teacher.id.toLowerCase().contains(lowerQuery) ||
            teacher.department.toLowerCase().contains(lowerQuery);
      }).toList();
    }
    notifyListeners();
  }

  void addTeacher(Teacher teacher) {
    _allTeachers.add(teacher);
    search(_searchQuery);
  }

  void updateTeacher(Teacher teacher) {
    final index = _allTeachers.indexWhere((t) => t.id == teacher.id);
    if (index >= 0) _allTeachers[index] = teacher;
    search(_searchQuery);
  }

  void deleteTeacher(String id) {
    _allTeachers.removeWhere((t) => t.id == id);
    search(_searchQuery);
  }
}
