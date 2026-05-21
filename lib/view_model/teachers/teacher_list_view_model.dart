import 'dart:async';

import 'package:flutter/material.dart';
import '../../model/notification/notification_model.dart';
import '../../model/teachers/teacher.dart';
import '../../service/notification_service.dart';
import '../../repository/teachers/floor_teacher_repository.dart';
import '../../repository/teachers/teacher_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherListViewModel extends ChangeNotifier {
  List<Teacher> _allTeachers = [];
  List<Teacher> _filteredTeachers = [];
  String _searchQuery = '';

  List<Teacher> get filteredTeachers => _filteredTeachers;
  String get searchQuery => _searchQuery;
  int get totalCount => _allTeachers.length;
  int get activeCount => _allTeachers.where((t) => t.isActive).length;

  TeacherListViewModel() {
    _loadTeachers();
  }

  Future<void> _loadTeachers() async {
    _allTeachers = await FloorTeacherRepository.instance.getAll();
    if (_allTeachers.isEmpty) {
      // Initialize with dummy data if empty
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
      ];
      for (var t in _allTeachers) {
        await FloorTeacherRepository.instance.save(t);
      }
    }
    _applySortAndFilter();
  }

  Future<void> _applySortAndFilter() async {
    final prefs = await TeacherPreferences.init();
    final ascending = prefs.getSortAscending();
    
    _filteredTeachers = List.from(_allTeachers);
    _filteredTeachers.sort((a, b) {
      final comp = a.fullName.compareTo(b.fullName);
      return ascending ? comp : -comp;
    });
    
    search(_searchQuery);
  }

  Future<void> toggleSortOrder() async {
    final prefs = await TeacherPreferences.init();
    await prefs.setSortAscending(!prefs.getSortAscending());
    _applySortAndFilter();
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

  Future<void> addTeacher(Teacher teacher) async {
    await FloorTeacherRepository.instance.save(teacher);
    await _loadTeachers();
  }

  Future<void> updateTeacher(Teacher teacher) async {
    await FloorTeacherRepository.instance.save(teacher);
    await _loadTeachers();
  }

  void deleteTeacher(String id) {
    final teacher = _allTeachers.firstWhere((t) => t.id == id);
    _allTeachers.removeWhere((t) => t.id == id);
    search(_searchQuery);
    unawaited(NotificationService.push(
      title: 'Docente eliminado',
      message: 'El docente ${teacher.firstName} ${teacher.lastName} fue eliminado del sistema.',
      type: NotificationType.other,
    ));
  }
}
