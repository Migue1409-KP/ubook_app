import 'package:flutter/material.dart';
import 'package:ubook_app/model/career/career_model.dart';

class CareerViewModel extends ChangeNotifier {

  final List<Career> _careers = [];

  String _searchQuery = '';

  List<Career> get careers => _careers;

  List<Career> getFilteredCareersByCenter(String centerId) {

    final filteredByCenter = _careers
        .where((c) => c.educationalCenterId == centerId)
        .toList();

    if (_searchQuery.isEmpty) return filteredByCenter;

    return filteredByCenter
        .where((c) =>
            c.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void setSearch(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  void addCareer(Career career) {
    _careers.add(career);
    notifyListeners();
  }

  void updateCareer(Career updatedCareer) {
    final index = _careers.indexWhere((c) => c.id == updatedCareer.id);

    if (index != -1) {
      _careers[index] = updatedCareer;
      notifyListeners();
    }
  }

  void deleteCareer(String id) {
    _careers.removeWhere((career) => career.id == id);
    notifyListeners();
  }
}