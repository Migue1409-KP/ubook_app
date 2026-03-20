import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool submitted = false;
  String? errorMessage;

  final formKey = GlobalKey<FormState>();

  String? validateEmail(String? value, {String field = 'Correo'}) {
    if (!submitted) return null;
    if (value == null || value.trim().isEmpty) {
      return '$field es requerido';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Ingrese un $field válido';
    }
    return null;
  }

  String? validatePassword(String? value, {String field = 'Contraseña'}) {
    if (!submitted) return null;
    if (value == null || value.trim().isEmpty) {
      return '$field es requerido';
    }
    if (value.trim().length < 8) {
      return '$field debe tener al menos 8 caracteres';
    }
    return null;
  }

  Future<bool> login() async {
    submitted = true;
    notifyListeners();

    // Validar formulario
    if (!(formKey.currentState?.validate() ?? false)) {
      return false;
    }

    errorMessage = null;
    isLoading = true;
    notifyListeners();

    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      // Login exitoso Solo para pruebas
      if (email == 'test@test.com' && password == 'test1234') {
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        errorMessage = 'Credenciales incorrectas';
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      errorMessage = 'Error al iniciar sesión: ${e.toString()}';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
