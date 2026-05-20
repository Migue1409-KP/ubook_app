import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ubook_app/model/career/career_model.dart';
import 'package:ubook_app/model/notification/notification_model.dart';
import 'package:ubook_app/repository/career/career_prefs.dart';
import 'package:ubook_app/repository/career/career_repository.dart';
import 'package:ubook_app/service/notification_service.dart';

class CareerViewModel extends ChangeNotifier {
  final CareerRepository _repository;
  final CareerPrefs _prefs = CareerPrefs();

  final List<Career> _careers = [];
  String _searchQuery = '';
  String _sortOrder = 'name';

  List<Career> get careers => _careers;
  String get sortOrder => _sortOrder;

  CareerViewModel(this._repository) {
    _loadSortOrder(); // SharedPreferences — preferencia de UI
    loadCareers();    // Floor — datos reales
  }

  // ─── PERSISTENCIA UI (SharedPreferences) ─────────────────────

  Future<void> _loadSortOrder() async {
    final saved = await _prefs.getSortOrder(); // ← cambio
    if (saved != null) {
      _sortOrder = saved;
      notifyListeners();
    }
  }

  Future<void> setSortOrder(String order) async {
    _sortOrder = order;
    await _prefs.saveSortOrder(order); // ← cambio
    _applySortOrder();
    notifyListeners();
  }

  void _applySortOrder() {
    if (_sortOrder == 'name') {
      _careers.sort((a, b) => a.name.compareTo(b.name));
    } else if (_sortOrder == 'semesters') {
      _careers.sort((a, b) => a.semesters.compareTo(b.semesters));
    } else if (_sortOrder == 'credits') {
      _careers.sort((a, b) => a.credits.compareTo(b.credits));
    }
  }

  // ─── CRUD (Floor) ─────────────────────────────────────────────

  Future<void> loadCareers() async {
    final result = await _repository.getAll();
    _careers.clear();
    _careers.addAll(result);
    _applySortOrder();
    notifyListeners();
  }

  Future<void> addCareer(Career career) async {
    await _repository.save(career);
    await loadCareers();
    unawaited(NotificationService.push(
      title: 'Nueva carrera registrada',
      message: 'La carrera "${career.name}" fue registrada en el sistema.',
      type: NotificationType.other,
    ));
  }

  Future<void> updateCareer(Career updatedCareer) async {
    await _repository.save(updatedCareer);
    await loadCareers();
    unawaited(NotificationService.push(
      title: 'Carrera actualizada',
      message: 'La carrera "${updatedCareer.name}" fue actualizada.',
      type: NotificationType.other,
    ));
  }

  Future<void> deleteCareer(String id) async {
    final career = _careers.firstWhere((c) => c.id == id);
    await _repository.delete(career);
    await loadCareers();
    unawaited(NotificationService.push(
      title: 'Carrera eliminada',
      message: 'La carrera "${career.name}" fue eliminada del sistema.',
      type: NotificationType.other,
    ));
  }

  // ─── FILTROS ──────────────────────────────────────────────────

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