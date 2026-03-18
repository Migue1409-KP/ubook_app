import 'package:flutter/material.dart';
import '../model/computer_lab/computer_lab.dart';
import '../model/computer_lab/computer_lab_repository.dart';

class ComputerLabFormViewModel extends ChangeNotifier {
  ComputerLabFormViewModel({
    ComputerLabRepository? repository,
  }) : _repository = repository ?? InMemoryComputerLabRepository.instance;

  final ComputerLabRepository _repository;

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
  List<ComputerLab> savedLabs = const [];

  final formKey = GlobalKey<FormState>();

  Future<void> loadSavedLabs() async {
    isLoadingLabs = true;
    notifyListeners();

    savedLabs = await _repository.getAll();

    isLoadingLabs = false;
    notifyListeners();
  }

  String? validateRequired(String? value, {String field = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$field is required';
    }
    return null;
  }

  String? validatePositiveInt(String? value, {String field = 'Capacity'}) {
    if (value == null || value.trim().isEmpty) return '$field is required';
    final parsed = int.tryParse(value);
    if (parsed == null || parsed <= 0) return '$field must be a positive number';
    return null;
  }

  Future<ComputerLab?> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return null;
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
      capacity: int.parse(capacityController.text.trim()),
      available: available,
      equipment: equipment,
      notes: notesController.text.trim(),
    );

    final saved = await _repository.save(lab);
    savedLabs = await _repository.getAll();

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
