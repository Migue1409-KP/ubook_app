import 'package:flutter/material.dart';
import '../../model/teachers/teacher.dart';
import '../../repository/teachers/teacher_repository.dart';

class TeacherListViewModel extends ChangeNotifier {
  final TeacherRepository _repository;
  
  List<Teacher> _allTeachers = [];
  List<Teacher> _filteredTeachers = [];
  String _searchQuery = '';
  bool _isLoading = false;

  List<Teacher> get filteredTeachers => _filteredTeachers;
  String get searchQuery => _searchQuery;
  int get totalCount => _allTeachers.length;
  int get activeCount => _allTeachers.where((t) => t.isActive).length;
  bool get isLoading => _isLoading;

  TeacherListViewModel(this._repository) {
    _loadTeachers();
  }

  Future<void> _loadTeachers() async {
    _isLoading = true;
    notifyListeners();
    
    await _repository.ensureInitialized();
    _allTeachers = await _repository.getTeachers();
    _filteredTeachers = List.from(_allTeachers);
    
    _isLoading = false;
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

  Future<void> addTeacher(Teacher teacher) async {
    await _repository.saveTeacher(teacher);
    await _loadTeachers();
    search(_searchQuery);
  }

  Future<void> updateTeacher(Teacher teacher) async {
    await _repository.updateTeacher(teacher);
    await _loadTeachers();
    search(_searchQuery);
  }

  Future<void> deleteTeacher(String id) async {
    final teacher = _allTeachers.firstWhere((t) => t.id == id);
    await _repository.deleteTeacher(teacher);
    await _loadTeachers();
    search(_searchQuery);
  }
}
