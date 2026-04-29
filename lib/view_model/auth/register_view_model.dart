import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ubook_app/model/auth/auth_provider.dart';
import 'package:ubook_app/model/auth/user_model.dart';
import 'package:ubook_app/repository/auth/auth_local_storage.dart';
import 'package:ubook_app/repository/auth/floor_user_repository.dart';
import 'package:ubook_app/repository/auth/user_repository.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthLocalStorage _localStorage;
  final UserRepository _userRepository;

  final name = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final educationalCenter = TextEditingController();
  final career = TextEditingController();
  final city = TextEditingController();

  bool isLoading = false;
  bool submitted = false;
  bool showPassword = false;
  String? errorMessage;

  final formKey = GlobalKey<FormState>();
  Timer? _draftDebounce;

  RegisterViewModel({
    AuthLocalStorage? localStorage,
    UserRepository? userRepository,
  }) : _localStorage = localStorage ?? AuthLocalStorage(),
       _userRepository = userRepository ?? FloorUserRepository.instance {
    _restoreRegisterDraft();
    _attachDraftListeners();
  }

  void _attachDraftListeners() {
    name.addListener(_onDraftChanged);
    emailController.addListener(_onDraftChanged);
    educationalCenter.addListener(_onDraftChanged);
    career.addListener(_onDraftChanged);
    city.addListener(_onDraftChanged);
  }

  void _removeDraftListeners() {
    name.removeListener(_onDraftChanged);
    emailController.removeListener(_onDraftChanged);
    educationalCenter.removeListener(_onDraftChanged);
    career.removeListener(_onDraftChanged);
    city.removeListener(_onDraftChanged);
  }

  void _onDraftChanged() {
    _draftDebounce?.cancel();
    _draftDebounce = Timer(const Duration(milliseconds: 300), () async {
      await _localStorage.saveRegisterDraft(
        name: name.text.trim(),
        email: emailController.text.trim(),
        educationalCenter: educationalCenter.text.trim(),
        career: career.text.trim(),
        city: city.text.trim(),
      );
    });
  }

  Future<void> _restoreRegisterDraft() async {
    final draft = await _localStorage.getRegisterDraft();
    if (draft.isEmpty) return;

    if (name.text.isEmpty) {
      name.text = draft['name'] ?? '';
    }
    if (emailController.text.isEmpty) {
      emailController.text = draft['email'] ?? '';
    }
    if (educationalCenter.text.isEmpty) {
      educationalCenter.text = draft['educationalCenter'] ?? '';
    }
    if (career.text.isEmpty) {
      career.text = draft['career'] ?? '';
    }
    if (city.text.isEmpty) {
      city.text = draft['city'] ?? '';
    }

    notifyListeners();
  }

  String? validateName(String? value) {
    if (!submitted) return null;
    if (value == null || value.trim().isEmpty) {
      return 'Nombre es requerido';
    }
    if (value.trim().length < 4) {
      return 'Nombre debe tener al menos 4 caracteres';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (!submitted) return null;
    if (value == null || value.trim().isEmpty) {
      return 'Correo es requerido';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Ingrese un correo válido';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (!submitted) return null;
    if (value == null || value.trim().isEmpty) {
      return 'Contraseña es requerida';
    }
    if (value.trim().length < 8) {
      return 'Contraseña debe tener al menos 8 caracteres';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (!submitted) return null;
    if (value == null || value.trim().isEmpty) {
      return 'Confirmar contraseña es requerido';
    }
    if (value.trim() != passwordController.text.trim()) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  String? validateRequired(String? value, {String field = 'Este campo'}) {
    if (!submitted) return null;
    if (value == null || value.trim().isEmpty) {
      return '$field es requerido';
    }
    return null;
  }

  Future<bool> register() async {
    submitted = true;
    notifyListeners();

    await _localStorage.saveRegisterDraft(
      name: name.text.trim(),
      email: emailController.text.trim(),
      educationalCenter: educationalCenter.text.trim(),
      career: career.text.trim(),
      city: city.text.trim(),
    );

    if (!(formKey.currentState?.validate() ?? false)) {
      return false;
    }

    errorMessage = null;
    isLoading = true;
    notifyListeners();

    try {
      final email = emailController.text.trim();
      final existingUser = await _userRepository.findByEmail(email);
      if (existingUser != null) {
        errorMessage = 'El correo ya está registrado';
        isLoading = false;
        notifyListeners();
        return false;
      }

      final now = DateTime.now();
      final user = UserModel(
        id: now.microsecondsSinceEpoch.toString(),
        email: email,
        name: name.text.trim(),
        password: passwordController.text.trim(),
        educationalCenter: educationalCenter.text.trim(),
        career: career.text.trim(),
        city: city.text.trim(),
        authProvider: AuthProvider.emailPassword,
        isActive: true,
        createdAt: now.millisecondsSinceEpoch,
        updatedAt: now.millisecondsSinceEpoch,
      );

      await _userRepository.insertUser(user);
      await _localStorage.saveLastLoginEmail(email);
      await _localStorage.clearRegisterDraft();

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = 'Error al registrar. Intente nuevamente.';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _draftDebounce?.cancel();
    _removeDraftListeners();

    name.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    educationalCenter.dispose();
    career.dispose();
    city.dispose();
    super.dispose();
  }
}
