import 'dart:async';

import 'package:flutter/material.dart';

import '../../repository/dashboard/dashboard_local_storage.dart';

class DashboardViewModel extends ChangeNotifier {
  DashboardViewModel() {
    unawaited(_loadSelectedFilter());
  }

  final DashboardLocalStorage _localStorage = DashboardLocalStorage();

  // Dummy data for Top 5 Educational Centers
  final List<Map<String, dynamic>> topCenters = [
    {
      'id': '1',
      'name': 'Universidad Nacional',
      'location': 'Bogotá',
      'rating': 4.8,
    },
    {
      'id': '2',
      'name': 'Universidad de los Andes',
      'location': 'Bogotá',
      'rating': 4.9,
    },
    {
      'id': '3',
      'name': 'Universidad de Antioquia',
      'location': 'Medellín',
      'rating': 4.7,
    },
    {
      'id': '4',
      'name': 'Universidad del Valle',
      'location': 'Cali',
      'rating': 4.6,
    },
    {
      'id': '5',
      'name': 'Pontificia Universidad Javeriana',
      'location': 'Bogotá',
      'rating': 4.8,
    },
  ];

  // Dummy data for Top 5 Careers
  final List<Map<String, dynamic>> topCareers = [
    {
      'educationalCenterId': '1',
      'name': 'Ingeniería de Sistemas',
      'semesters': 10,
      'credits': 130,
      'rating': 4.9,
    },
    {
      'educationalCenterId': '1',
      'name': 'Medicina',
      'semesters': 12,
      'credits': 168,
      'rating': 4.8,
    },
    {
      'educationalCenterId': '1',
      'name': 'Derecho',
      'semesters': 9,
      'credits': 118,
      'rating': 4.7,
    },
    {
      'educationalCenterId': '1',
      'name': 'Administración de Empresas',
      'semesters': 8,
      'credits': 105,
      'rating': 4.6,
    },
    {
      'educationalCenterId': '1',
      'name': 'Psicología',
      'semesters': 10,
      'credits': 148,
      'rating': 4.8,
    },
  ];

  // Dummy data for Top 5 Subjects
  final List<Map<String, dynamic>> topSubjects = [
    {'id': 'sub-1', 'name': 'Cálculo Diferencial', 'faculty': 'Ingeniería', 'rating': 4.9},
    {'id': 'sub-2', 'name': 'Programación I', 'faculty': 'Ingeniería', 'rating': 4.8},
    {'id': 'sub-3', 'name': 'Bases de Datos', 'faculty': 'Sistemas', 'rating': 4.7},
    {'id': 'sub-4', 'name': 'Derecho Constitucional', 'faculty': 'Derecho', 'rating': 4.6},
    {
      'id': 'sub-5',
      'name': 'Psicología General',
      'faculty': 'Ciencias Sociales',
      'rating': 4.8,
    },
  ];

  // Dummy data for Top 5 Teachers
  final List<Map<String, dynamic>> topTeachers = [
    {
      'name': 'Carlos Rodríguez',
      'subject': 'Cálculo Multivariado',
      'rating': 4.9,
    },
    {'name': 'Ana María Gómez', 'subject': 'Física Mecánica', 'rating': 4.8},
    {
      'name': 'Luis Fernando Pérez',
      'subject': 'Programación Orientada a Objetos',
      'rating': 4.7,
    },
    {
      'name': 'María Fernanda López',
      'subject': 'Bases de Datos',
      'rating': 4.9,
    },
    {'name': 'Jorge Ramírez', 'subject': 'Estructuras de Datos', 'rating': 4.6},
  ];

  // Search and Filter state
  String selectedFilter = 'Centro Educativo';
  final List<String> filterOptions = [
    'Centro Educativo',
    'Carrera',
    'Materia',
    'Profesor',
  ];

  void setFilter(String filter) {
    selectedFilter = filter;
    unawaited(_localStorage.saveSelectedFilter(filter));
    notifyListeners();
  }

  Future<void> _loadSelectedFilter() async {
    final savedFilter = await _localStorage.getSelectedFilter();
    if (savedFilter == null || !filterOptions.contains(savedFilter)) return;

    selectedFilter = savedFilter;
    notifyListeners();
  }
}
