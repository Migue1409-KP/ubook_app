import 'package:flutter/material.dart';
import '../../model/teachers/teacher.dart';
import '../../model/teachers/teacher_repository.dart';

class TeacherFormViewModel extends ChangeNotifier {
  TeacherFormViewModel({
    TeacherRepository? repository,
    Teacher? initial,
  }) : _repository = repository ?? InMemoryTeacherRepository.instance,
       _editingId = initial?.id {
    if (initial != null) _populate(initial);
  }

  final TeacherRepository _repository;
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
