import 'package:flutter/material.dart';
import '../model/city/city.dart';
import '../model/city/city_service.dart';
import '../model/computer_lab/computer_lab.dart';
import '../model/computer_lab/computer_lab_repository.dart';

class ComputerLabFormViewModel extends ChangeNotifier {
  ComputerLabFormViewModel({
    ComputerLabRepository? repository,
    CityService cityService = const CityService(),
  }) : _repository = repository,
       _cityService = cityService;

  final ComputerLabRepository? _repository;
  final CityService _cityService;

  // Controllers
  final nameController = TextEditingController();
  final buildingController = TextEditingController();
  final roomNumberController = TextEditingController();
  final capacityController = TextEditingController();
  final equipmentController = TextEditingController(); // comma-separated
  final notesController = TextEditingController();

  bool available = true;
  bool isSaving = false;
  bool isLoadingLabs = false;
  bool isLoadingCities = false;
  int storedLabCount = 0;
  List<ComputerLab> savedLabs = const [];
  List<City> cities = const [];
  City? selectedCity;
  String? citiesError;

  final formKey = GlobalKey<FormState>();

  Future<void> loadCities() async {
    isLoadingCities = true;
    citiesError = null;
    notifyListeners();

    try {
      cities = await _cityService.fetchCities();
      if (selectedCity != null && !cities.contains(selectedCity)) {
        selectedCity = null;
      }
      if (cities.isEmpty) {
        citiesError = 'No hay ciudades disponibles.';
      }
    } on Exception catch (error) {
      cities = const [];
      selectedCity = null;
      citiesError = error.toString();
    } finally {
      isLoadingCities = false;
      notifyListeners();
    }
  }

  Future<void> loadSavedLabs() async {
    final repository = _repository;
    if (repository == null) {
      throw StateError(
        'ComputerLabFormViewModel requiere un ComputerLabRepository configurado.',
      );
    }

    isLoadingLabs = true;
    notifyListeners();

    savedLabs = await repository.getAll();
    storedLabCount = savedLabs.length;

    isLoadingLabs = false;
    notifyListeners();
  }

  String? validateRequired(String? value, {String field = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$field is required';
    }
    return null;
  }

  String? validateCity(City? value) {
    if (isLoadingCities) {
      return 'Espera a que carguen las ciudades';
    }
    if (value == null) {
      return 'Ciudad es requerida';
    }
    return null;
  }

  String? validatePositiveInt(String? value, {String field = 'Capacity'}) {
    if (value == null || value.trim().isEmpty) {
      return '$field is required';
    }
    final parsed = int.tryParse(value);
    if (parsed == null || parsed <= 0) {
      return '$field must be a positive number';
    }
    return null;
  }

  void selectCity(City? city) {
    selectedCity = city;
    notifyListeners();
  }

  Future<ComputerLab?> submit() async {
    final repository = _repository;
    if (repository == null) {
      throw StateError(
        'ComputerLabFormViewModel requiere un ComputerLabRepository configurado.',
      );
    }

    if (!(formKey.currentState?.validate() ?? false) || selectedCity == null) {
      return null;
    }
    isSaving = true;
    notifyListeners();

    final equipment = equipmentController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final lab = ComputerLab(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: nameController.text.trim(),
      building: buildingController.text.trim(),
      roomNumber: roomNumberController.text.trim(),
      city: selectedCity!.displayName,
      capacity: int.parse(capacityController.text.trim()),
      available: available,
      equipment: equipment,
      notes: notesController.text.trim(),
    );

    final saved = await repository.save(lab);
    savedLabs = await repository.getAll();
    storedLabCount = savedLabs.length;

    isSaving = false;
    notifyListeners();
    return saved;
  }

  void clearForm() {
    nameController.clear();
    buildingController.clear();
    roomNumberController.clear();
    capacityController.clear();
    equipmentController.clear();
    notesController.clear();
    selectedCity = null;
    available = true;
    formKey.currentState?.reset();
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    buildingController.dispose();
    roomNumberController.dispose();
    capacityController.dispose();
    equipmentController.dispose();
    notesController.dispose();
    super.dispose();
  }
}
