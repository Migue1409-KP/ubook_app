import 'package:flutter/material.dart';
import 'package:ubook_app/model/career/career_model.dart';
import 'package:ubook_app/model/career/modality.dart';
import 'package:ubook_app/repository/career/career_prefs.dart';
import 'package:ubook_app/repository/career/career_repository.dart';
import 'package:ubook_app/repository/career/modality_api_repository.dart';

class CareerViewModel extends ChangeNotifier {
  final CareerRepository _repository;
  final CareerPrefs _prefs = CareerPrefs();
  final ModalityApiRepository _modalityApi;

  final List<Career> _careers = [];
  List<Modality> _modalities = const [];
  String? _modalitiesWarning;
  bool _modalitiesLoading = false;
  String _searchQuery = '';
  String _sortOrder = 'name';

  List<Career> get careers => _careers;
  List<Modality> get modalities => _modalities;
  String? get modalitiesWarning => _modalitiesWarning;
  bool get modalitiesLoading => _modalitiesLoading;
  String get sortOrder => _sortOrder;

  CareerViewModel(
    this._repository, {
    ModalityApiRepository? modalityApi,
  }) : _modalityApi = modalityApi ?? ModalityApiRepository.instance {
    _loadSortOrder(); // SharedPreferences — preferencia de UI
    loadCareers();    // Floor — datos reales
    loadModalities(); // API remota — catálogo
  }

  // ─── PERSISTENCIA UI (SharedPreferences) ─────────────────────

  Future<void> _loadSortOrder() async {
    final saved = await _prefs.getSortOrder();
    if (saved != null) {
      _sortOrder = saved;
      notifyListeners();
    }
  }

  Future<void> setSortOrder(String order) async {
    _sortOrder = order;
    await _prefs.saveSortOrder(order);
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
  }

  Future<void> updateCareer(Career updatedCareer) async {
    await _repository.save(updatedCareer);
    await loadCareers();
  }

  Future<void> deleteCareer(String id) async {
    final career = _careers.firstWhere((c) => c.id == id);
    await _repository.delete(career);
    await loadCareers();
  }

  // ─── CATÁLOGO REMOTO (API modalidades) ───────────────────────

  Future<void> loadModalities() async {
    _modalitiesLoading = true;
    notifyListeners();
    try {
      _modalities = await _modalityApi.fetchModalities();
      _modalitiesWarning = null;
    } catch (e, st) {
      _modalities = const [];
      _modalitiesWarning =
          'No se pudo cargar el catálogo de modalidades: $e';
      debugPrint('[CareerViewModel] loadModalities failed: $e\n$st');
    } finally {
      _modalitiesLoading = false;
      notifyListeners();
    }
  }

  Modality? findModalityById(int? id) {
    if (id == null) return null;
    for (final m in _modalities) {
      if (m.id == id) return m;
    }
    return null;
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
