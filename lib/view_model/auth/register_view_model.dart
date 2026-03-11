import 'package:flutter/material.dart';

class RegisterViewModel extends ChangeNotifier {
  final name = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final educationalCenter = TextEditingController();
  final career = TextEditingController();
  final city = TextEditingController();

  bool isLoading = false;
  bool submitted = false;
  String? errorMessage;

  final formKey = GlobalKey<FormState>();

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

    if (!(formKey.currentState?.validate() ?? false)) {
      return false;
    }

    errorMessage = null;
    isLoading = true;
    notifyListeners();

    try {
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
