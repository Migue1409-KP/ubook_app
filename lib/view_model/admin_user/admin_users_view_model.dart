import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ubook_app/model/auth/auth_provider.dart';
import 'package:ubook_app/model/auth/user_model.dart';
import 'package:ubook_app/repository/auth/user_repository.dart';

class AdminUsersViewModel extends ChangeNotifier {
  AdminUsersViewModel(this._userRepository);

  final UserRepository _userRepository;

  // ─────────────────────────────
  // 📋 ESTADO
  // ─────────────────────────────
  List<UserModel> users = [];
  bool isLoading = false;
  bool isSubmitting = false;
  bool submitted = false;
  String? errorMessage;

  // ─────────────────────────────
  // 🧾 FORMULARIO (crear)
  // ─────────────────────────────
  final name = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final educationalCenter = TextEditingController();
  final career = TextEditingController();
  final city = TextEditingController();

  final formKey = GlobalKey<FormState>();

  // ─────────────────────────────
  // 🔃 CARGAR USUARIOS
  // ─────────────────────────────
  Future<void> loadUsers() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      users = await _userRepository.findAll();
    } catch (e) {
      errorMessage = 'Error al cargar usuarios: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ─────────────────────────────
  // ✅ VALIDACIONES
  // ─────────────────────────────
  String? validateName(String? value) {
    if (!submitted) return null;
    if (value == null || value.trim().isEmpty) return 'Nombre es requerido';
    if (value.trim().length < 4) return 'Mínimo 4 caracteres';
    return null;
  }

  String? validateEmail(String? value) {
    if (!submitted) return null;
    if (value == null || value.trim().isEmpty) return 'Correo es requerido';
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value.trim())) return 'Correo inválido';
    return null;
  }

  String? validatePassword(String? value) {
    if (!submitted) return null;
    if (value == null || value.trim().isEmpty) return 'Contraseña es requerida';
    if (value.trim().length < 8) return 'Mínimo 8 caracteres';
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (!submitted) return null;
    if (value == null || value.trim().isEmpty) return 'Confirmar contraseña es requerido';
    if (value.trim() != passwordController.text.trim()) return 'Las contraseñas no coinciden';
    return null;
  }

  // ─────────────────────────────
  // ➕ CREAR USUARIO
  // ─────────────────────────────
  Future<bool> createUser() async {
    submitted = true;
    notifyListeners();

    if (!(formKey.currentState?.validate() ?? false)) return false;

    isSubmitting = true;
    errorMessage = null;
    notifyListeners();

    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final newUser = UserModel(
        id: _generateId(),
        email: emailController.text.trim(),
        name: name.text.trim(),
        password: passwordController.text.trim(),
        educationalCenter: educationalCenter.text.trim(),
        career: career.text.trim(),
        city: city.text.trim().isEmpty ? 'Sin ciudad' : city.text.trim(),
        authProvider: AuthProvider.emailPassword,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      );

      await _userRepository.insertUser(newUser);
      await loadUsers();

      _clearForm();
      isSubmitting = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = 'Error al crear usuario: $e';
      isSubmitting = false;
      notifyListeners();
      return false;
    }
  }

  // ─────────────────────────────
  // ✏️ EDITAR USUARIO
  // ─────────────────────────────
  Future<bool> updateUser(
    UserModel original, {
    required String newName,
    required String newEmail,
    required String newCity,
    required String newCareer,
    required String newCenter,
  }) async {
    isSubmitting = true;
    errorMessage = null;
    notifyListeners();

    try {
      final updated = UserModel(
        id: original.id,
        email: newEmail.trim(),
        name: newName.trim(),
        password: original.password,
        birthDate: original.birthDate,
        educationalCenter: newCenter.trim(),
        career: newCareer.trim(),
        city: newCity.trim(),
        profileImageUrl: original.profileImageUrl,
        authProvider: original.authProvider,
        isActive: original.isActive,
        createdAt: original.createdAt,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );

      await _userRepository.updateUser(updated);
      await loadUsers();

      isSubmitting = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = 'Error al actualizar usuario: $e';
      isSubmitting = false;
      notifyListeners();
      return false;
    }
  }

  // ─────────────────────────────
  // 🗑️ ELIMINAR USUARIO
  // ─────────────────────────────
  Future<void> deleteUser(UserModel user) async {
    try {
      await _userRepository.deleteUser(user);
      users.removeWhere((u) => u.id == user.id);
      notifyListeners();
    } catch (e) {
      errorMessage = 'Error al eliminar usuario: $e';
      notifyListeners();
    }
  }

  // ─────────────────────────────
  // 🧹 LIMPIAR FORMULARIO
  // ─────────────────────────────
  void _clearForm() {
    name.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    educationalCenter.clear();
    career.clear();
    city.clear();
    submitted = false;
  }

  // ─────────────────────────────
  // 🔑 GENERAR ID ÚNICO
  // ─────────────────────────────
  String _generateId() {
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final suffix = random.nextInt(999999).toString().padLeft(6, '0');
    return '${timestamp}_$suffix';
  }

  // ─────────────────────────────
  // 🧹 DISPOSE
  // ─────────────────────────────
  @override
  void dispose() {
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
