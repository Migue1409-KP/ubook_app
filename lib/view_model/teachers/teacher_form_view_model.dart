import 'package:flutter/material.dart';
import '../../model/teachers/teacher.dart';
import '../../model/teachers/teacher_repository.dart';
import '../../repository/teachers/floor_teacher_repository.dart';
import '../../repository/teachers/country_api_service.dart';
import '../../repository/teachers/teacher_preferences.dart';

class TeacherFormViewModel extends ChangeNotifier {
  TeacherFormViewModel({
    TeacherRepository? repository,
    Teacher? initial,
  }) : _repository = repository ?? FloorTeacherRepository.instance,
       _editingId = initial?.id {
    if (initial != null) _populate(initial);
    _loadCountries();
  }

  final TeacherRepository _repository;
  final CountryApiService _countryApiService = CountryApiService();

  List<CountryPhoneCode> countries = [];
  bool isLoadingCountries = false;
  CountryPhoneCode? selectedCountry;

  Future<void> _loadCountries() async {
    isLoadingCountries = true;
    notifyListeners();
    try {
      countries = await _countryApiService.fetchCountries();
    } catch (e) {
      countries = _countryApiService.getFallbackCountries();
    }
    
    if (countries.isNotEmpty) {
      // Use preferences or default to CO
      final prefs = await TeacherPreferences.init();
      final defaultCode = prefs.getDefaultCountryCode();
      
      selectedCountry = countries.firstWhere(
        (c) => c.dialCode == defaultCode || c.code == defaultCode, 
        orElse: () => countries.firstWhere(
          (c) => c.code == 'CO',
          orElse: () => countries.first,
        ),
      );
      
      // If editing, try to guess the country based on the phone string if it contains a dialCode
      if (_editingId != null && phoneController.text.isNotEmpty) {
        for (var c in countries) {
          if (phoneController.text.startsWith(c.dialCode)) {
            selectedCountry = c;
            // Optionally remove dial code from text field if you want to keep them separated
            break;
          }
        }
      } else {
        // If creating new, optionally set the phone prefix automatically
        if (phoneController.text.isEmpty && selectedCountry != null) {
          phoneController.text = selectedCountry!.dialCode + ' ';
        }
      }
    }
    
    isLoadingCountries = false;
    notifyListeners();
  }

  void onCountryChanged(CountryPhoneCode? newCountry) async {
    if (newCountry == null) return;
    selectedCountry = newCountry;
    
    // Save to preferences
    final prefs = await TeacherPreferences.init();
    await prefs.setDefaultCountryCode(newCountry.dialCode);
    
    // Set the prefix in the text field if empty or replace old prefix
    phoneController.text = newCountry.dialCode + ' ';
    notifyListeners();
  }
  final String? _editingId;

  bool get isEditing => _editingId != null;

  // Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final ageController = TextEditingController();
  final departmentController = TextEditingController();
  final specialtyController = TextEditingController();
  final profileImageUrlController = TextEditingController();

  List<String> _subjects = [];

  bool isActive = true;
  bool isSaving = false;

  final formKey = GlobalKey<FormState>();

  void _populate(Teacher t) {
    firstNameController.text = t.firstName;
    lastNameController.text = t.lastName;
    emailController.text = t.email;
    phoneController.text = t.phone;
    ageController.text = t.age > 0 ? t.age.toString() : '';
    departmentController.text = t.department;
    specialtyController.text = t.specialty;
    _subjects = List.from(t.subjects);
    profileImageUrlController.text = t.profileImageUrl;
    isActive = t.isActive;
  }

  String? validateRequired(String? value, {String field = 'Este campo'}) {
    if (value == null || value.trim().isEmpty) {
      return '$field es obligatorio';
    }
    return null;
  }

  String? validatePositiveInt(String? value, {String field = 'Edad'}) {
    if (value == null || value.trim().isEmpty) return '$field es obligatoria';
    final parsed = int.tryParse(value);
    if (parsed == null || parsed <= 0) return '$field debe ser un número positivo';
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email es obligatorio';
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value.trim())) return 'Ingresa un email válido';
    return null;
  }

  Future<Teacher?> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return null;
    isSaving = true;
    notifyListeners();

    final now = DateTime.now();
    final teacher = Teacher(
      id: _editingId ?? 'TCH-${now.microsecondsSinceEpoch}',
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      age: int.parse(ageController.text.trim()),
      department: departmentController.text.trim(),
      specialty: specialtyController.text.trim(),
      subjects: _subjects,
      profileImageUrl: profileImageUrlController.text.trim(),
      isActive: isActive,
      createdAt: now,
      updatedAt: now,
    );

    final saved = await _repository.save(teacher);

    isSaving = false;
    notifyListeners();
    return saved;
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    ageController.dispose();
    departmentController.dispose();
    specialtyController.dispose();
    profileImageUrlController.dispose();
    super.dispose();
  }
}
