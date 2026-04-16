import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubook_app/model/career/career_model.dart';

class CareerViewModel extends ChangeNotifier {

  final List<Career> _careers = [];
  String _searchQuery = '';

  static const String _careersKey = 'careers_list';

  List<Career> get careers => _careers;

  CareerViewModel() {
    _loadCareers();
  }

  // ─── PERSISTENCIA ───────────────────────────────────────────

  Future<void> _loadCareers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_careersKey);
    if (raw != null) {
      final List decoded = jsonDecode(raw);
      _careers.clear();
      _careers.addAll(decoded.map((e) => Career.fromJson(e)));
      notifyListeners();
    }
  }

  Future<void> _saveCareers() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_careers.map((c) => c.toJson()).toList());
    await prefs.setString(_careersKey, encoded);
  }

  // ─── CRUD ────────────────────────────────────────────────────

  void addCareer(Career career) {
    _careers.add(career);
    notifyListeners();
    _saveCareers();
  }

  void updateCareer(Career updatedCareer) {
    final index = _careers.indexWhere((c) => c.id == updatedCareer.id);
    if (index != -1) {
      _careers[index] = updatedCareer;
      notifyListeners();
      _saveCareers();
    }
  }

  void deleteCareer(String id) {
    _careers.removeWhere((c) => c.id == id);
    notifyListeners();
    _saveCareers();
  }

  // ─── FILTROS ─────────────────────────────────────────────────

  void setSearch(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  List<Career> getFilteredCareersByCenter(String? centerId) {
    List<Career> filtered = _careers;

    if (centerId != null) {
      filtered = filtered.where((c) => c.educationalCenterId == centerId).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((c) => c.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return filtered;
  }
}