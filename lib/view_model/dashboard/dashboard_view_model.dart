import 'package:flutter/material.dart';

class DashboardViewModel extends ChangeNotifier {
  // Dummy data for Top 5 Educational Centers
  final List<Map<String, dynamic>> topCenters = [
    {'name': 'Universidad Nacional', 'location': 'Bogotá', 'rating': 4.8},
    {'name': 'Universidad de los Andes', 'location': 'Bogotá', 'rating': 4.9},
    {'name': 'Universidad de Antioquia', 'location': 'Medellín', 'rating': 4.7},
    {'name': 'Universidad del Valle', 'location': 'Cali', 'rating': 4.6},
    {'name': 'Pontificia Universidad Javeriana', 'location': 'Bogotá', 'rating': 4.8},
  ];

  
  // Dummy data for Top 5 Careers
  final List<Map<String, dynamic>> topCareers = [
    {'name': 'Ingeniería de Sistemas', 'semesters': 10, 'credits':130, 'rating': 4.9},
    {'name': 'Medicina', 'semesters': 12, 'credits':168, 'rating': 4.8},
    {'name': 'Derecho', 'semesters': 9, 'credits':118, 'rating': 4.7},
    {'name': 'Administración de Empresas', 'semesters':8, 'credits':105, 'rating': 4.6},
    {'name': 'Psicología', 'semesters': 10, 'credits':148, 'rating': 4.8},
  ];

  // Dummy data for Top 5 Teachers
  final List<Map<String, dynamic>> topTeachers = [
    {'name': 'Carlos Rodríguez', 'subject': 'Cálculo Multivariado', 'rating': 4.9},
    {'name': 'Ana María Gómez', 'subject': 'Física Mecánica', 'rating': 4.8},
    {'name': 'Luis Fernando Pérez', 'subject': 'Programación Orientada a Objetos', 'rating': 4.7},
    {'name': 'María Fernanda López', 'subject': 'Bases de Datos', 'rating': 4.9},
    {'name': 'Jorge Ramírez', 'subject': 'Estructuras de Datos', 'rating': 4.6},
  ];

  // Search and Filter state
  String selectedFilter = 'Centro Educativo';
  final List<String> filterOptions = [
    'Centro Educativo',
    'Carrera',
    'Materia',
    'Profesor'
  ];

  void setFilter(String filter) {
    selectedFilter = filter;
    notifyListeners();
  }
}
