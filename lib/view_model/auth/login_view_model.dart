import 'package:flutter/material.dart';
import 'package:ubook_app/model/auth/user_model.dart';
import 'package:ubook_app/repository/auth/auth_local_storage.dart';
import 'package:ubook_app/repository/auth/floor_user_repository.dart';
import 'package:ubook_app/repository/auth/user_repository.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthLocalStorage _localStorage;
  final UserRepository _userRepository;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool submitted = false;
  String? errorMessage;

  final formKey = GlobalKey<FormState>();

  LoginViewModel({
    AuthLocalStorage? localStorage,
    UserRepository? userRepository,
  }) : _localStorage = localStorage ?? AuthLocalStorage(),
       _userRepository = userRepository ?? FloorUserRepository.instance {
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

    if (!(formKey.currentState?.validate() ?? false)) {
      return false;
    }

    errorMessage = null;
    isLoading = true;
    notifyListeners();

    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      final UserModel? user = await _userRepository.findByEmail(email);
      if (user == null) {
        await _localStorage.setHasActiveSession(false);
        errorMessage = 'No existe una cuenta con este correo';
        isLoading = false;
        notifyListeners();
        return false;
      }

      if (user.password != password) {
        await _localStorage.setHasActiveSession(false);
        errorMessage = 'Credenciales incorrectas';
        isLoading = false;
        notifyListeners();
        return false;
      }

      if (!user.isActive) {
        await _localStorage.setHasActiveSession(false);
        errorMessage = 'La cuenta se encuentra inactiva';
        isLoading = false;
        notifyListeners();
        return false;
      }

      await _localStorage.saveLastLoginEmail(email);
      await _localStorage.saveLastLoginAt(DateTime.now());
      await _localStorage.setHasActiveSession(true);

      isLoading = false;
      notifyListeners();
      return true;
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
