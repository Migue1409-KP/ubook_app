import 'package:flutter/material.dart';
import '../../model/teachers/teacher.dart';

class TeacherDetailViewModel extends ChangeNotifier {
  final Teacher _teacher;

  TeacherDetailViewModel(this._teacher);

  Teacher get teacher => _teacher;
  String get fullName => _teacher.fullName;
  String get id => _teacher.id;
  List<String> get subjects => _teacher.subjects;

  void onEdit() {
  }

  void onViewSubject(String subject) {
  }
}
