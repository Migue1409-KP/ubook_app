import 'package:flutter/material.dart';
import 'package:ubook_app/repository/auth/auth_local_storage.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthLocalStorage _localStorage;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool submitted = false;
  String? errorMessage;

  final formKey = GlobalKey<FormState>();

  LoginViewModel({AuthLocalStorage? localStorage})
      : _localStorage = localStorage ?? AuthLocalStorage() {
    _restoreLastLoginEmail();
  }

  Future<void> _restoreLastLoginEmail() async {
    final lastEmail = await _localStorage.getLastLoginEmail();
    if (lastEmail == null || lastEmail.isEmpty) return;
    if (emailController.text.isNotEmpty) return;

    emailController.text = lastEmail;
    notifyListeners();
  }

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
        await _localStorage.saveLastLoginEmail(email);
        await _localStorage.saveLastLoginAt(DateTime.now());
        await _localStorage.setHasActiveSession(true);

        isLoading = false;
        notifyListeners();
        return true;
      } else {
        await _localStorage.setHasActiveSession(false);

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
