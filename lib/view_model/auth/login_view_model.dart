import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ubook_app/model/auth/auth_provider.dart' as app_auth;
import 'package:ubook_app/model/auth/user_model.dart';
import 'package:ubook_app/repository/auth/auth_local_storage.dart';
import 'package:ubook_app/repository/auth/firebase_auth_service.dart';
import 'package:ubook_app/repository/auth/syncing_user_repository.dart';
import 'package:ubook_app/repository/auth/user_repository.dart';
import 'package:ubook_app/service/analytics_service.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthLocalStorage _localStorage;
  final UserRepository _userRepository;
  final FirebaseAuthService _authService;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool submitted = false;
  String? errorMessage;

  final formKey = GlobalKey<FormState>();

  LoginViewModel({
    AuthLocalStorage? localStorage,
    UserRepository? userRepository,
    FirebaseAuthService? authService,
  }) : _localStorage = localStorage ?? AuthLocalStorage(),
       _userRepository = userRepository ?? SyncingUserRepository.instance,
       _authService = authService ?? FirebaseAuthService.instance {
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
    if (value == null || value.trim().isEmpty) return '$field es requerido';
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value.trim())) return 'Ingrese un $field válido';
    return null;
  }

  String? validatePassword(String? value, {String field = 'Contraseña'}) {
    if (!submitted) return null;
    if (value == null || value.trim().isEmpty) return '$field es requerido';
    if (value.trim().length < 6)
      return '$field debe tener al menos 6 caracteres';
    return null;
  }

  Future<bool> login() async {
    submitted = true;
    notifyListeners();

    if (!(formKey.currentState?.validate() ?? false)) return false;

    errorMessage = null;
    isLoading = true;
    notifyListeners();

    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      final firebaseUser = await _authService.signInWithEmail(email, password);
      if (firebaseUser == null) {
        errorMessage = 'Error al iniciar sesión';
        isLoading = false;
        notifyListeners();
        return false;
      }

      await _ensureLocalProfile(
        firebaseUser,
        app_auth.AuthProvider.emailPassword,
      );
      await _localStorage.saveLastLoginEmail(email);
      await _localStorage.saveLastLoginAt(DateTime.now());
      await AnalyticsService.instance.setCurrentUser(firebaseUser);
      await AnalyticsService.instance.logLogin(method: 'password');

      isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = FirebaseAuthService.mapError(e);
      isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = 'Error al iniciar sesión';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> loginWithGoogle() async {
    errorMessage = null;
    isLoading = true;
    notifyListeners();

    try {
      final firebaseUser = await _authService.signInWithGoogle();
      if (firebaseUser == null) {
        isLoading = false;
        notifyListeners();
        return false;
      }

      await _ensureLocalProfile(firebaseUser, app_auth.AuthProvider.google);
      await _localStorage.saveLastLoginEmail(firebaseUser.email ?? '');
      await _localStorage.saveLastLoginAt(DateTime.now());
      await AnalyticsService.instance.setCurrentUser(firebaseUser);
      await AnalyticsService.instance.logLogin(method: 'google');

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = FirebaseAuthService.mapError(e);
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> _ensureLocalProfile(
    User firebaseUser,
    app_auth.AuthProvider provider,
  ) async {
    final email = firebaseUser.email;
    if (email == null) return;

    final existing = await _userRepository.findByEmail(email);
    if (existing != null) return;

    final now = DateTime.now();
    await _userRepository.insertUser(
      UserModel(
        id: firebaseUser.uid,
        email: email,
        name: firebaseUser.displayName ?? email.split('@').first,
        educationalCenter: '',
        career: '',
        city: '',
        authProvider: provider,
        isActive: true,
        createdAt: now.millisecondsSinceEpoch,
        updatedAt: now.millisecondsSinceEpoch,
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
