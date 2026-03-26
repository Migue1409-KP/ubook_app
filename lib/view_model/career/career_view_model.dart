import 'package:flutter/material.dart';
import 'package:ubook_app/model/career/career_model.dart';

class CareerViewModel extends ChangeNotifier {

  final List<Career> _careers = [];

  String searchQuery = "";

  List<Career> get careers {

    if (searchQuery.isEmpty) {
      return _careers;
    }

    return _careers
        .where((career) =>
            career.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  void setSearch(String value) {
    searchQuery = value;
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