import 'package:flutter/material.dart';

class AdminUsersViewModel extends ChangeNotifier {
  // ─────────────────────────────
  // 📋 LISTA DE USUARIOS (MOCK)
  // ─────────────────────────────
  List<Map<String, String>> users = [
    {
      "name": "Juan Pérez",
      "email": "juan@gmail.com",
      "city": "Medellín",
      "career": "Ingeniería",
      "center": "UdeA",
      "password": "12345678",
    },
    {
      "name": "Ana Gómez",
      "email": "ana@gmail.com",
      "city": "Bogotá",
      "career": "Derecho",
      "center": "Nacional",
      "password": "12345678",
    },
    {
      "name": "Carlos Ruiz",
      "email": "carlos@gmail.com",
      "city": "Cali",
      "career": "Medicina",
      "center": "Univalle",
      "password": "12345678",
    },
  ];

  // ─────────────────────────────
  // 🧾 FORMULARIO
  // ─────────────────────────────
  final name = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final educationalCenter = TextEditingController();
  final career = TextEditingController();
  final city = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool submitted = false;
  String? errorMessage;

  // ─────────────────────────────
  // ✅ VALIDACIONES
  // ─────────────────────────────
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

  // ─────────────────────────────
  // ➕ CREAR USUARIO (MOCK)
  // ─────────────────────────────
  Future<bool> createUser() async {
    submitted = true;
    notifyListeners();

    if (!(formKey.currentState?.validate() ?? false)) {
      return false;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      users.add({
        "name": name.text.trim(),
        "email": emailController.text.trim(),
        "city": city.text.trim().isEmpty ? "Sin ciudad" : city.text.trim(),
        "career": career.text.trim(),
        "center": educationalCenter.text.trim(),
        "password": passwordController.text.trim(),
      });

      _clearForm();

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = 'Error al crear usuario';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ─────────────────────────────
  // 🗑️ ELIMINAR USUARIO
  // ─────────────────────────────
  void deleteUser(int index) {
    users.removeAt(index);
    notifyListeners();
  }

  // ─────────────────────────────
  // ✏️ EDITAR USUARIO (ACTUALIZADO)
  // ─────────────────────────────
  void updateUser(
      int index, {
        required String name,
        required String email,
        required String city,
        required String career,
        required String center,
        required String password,
      }) {
    users[index] = {
      "name": name,
      "email": email,
      "city": city,
      "career": career,
      "center": center,
      "password": password,
    };

    notifyListeners();
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