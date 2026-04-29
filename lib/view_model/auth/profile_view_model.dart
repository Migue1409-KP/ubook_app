import 'package:flutter/material.dart';
import 'package:ubook_app/model/auth/user_model.dart';
import 'package:ubook_app/repository/auth/auth_local_storage.dart';
import 'package:ubook_app/repository/auth/floor_user_repository.dart';
import 'package:ubook_app/repository/auth/user_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  final AuthLocalStorage _localStorage;
  final UserRepository _userRepository;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final educationalCenterController = TextEditingController();
  final careerController = TextEditingController();
  final cityController = TextEditingController();

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  final personalFormKey = GlobalKey<FormState>();
  final passwordFormKey = GlobalKey<FormState>();

  bool isChangingPassword = false;
  bool isSavingProfile = false;
  bool submittedPassword = false;
  bool submittedPersonal = false;

  String? passwordErrorMessage;

  UserModel? _currentUser;

  ProfileViewModel({
    AuthLocalStorage? localStorage,
    UserRepository? userRepository,
  }) : _localStorage = localStorage ?? AuthLocalStorage(),
       _userRepository = userRepository ?? FloorUserRepository.instance {
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final lastEmail = await _localStorage.getLastLoginEmail();
    UserModel? user;

    if (lastEmail != null && lastEmail.isNotEmpty) {
      user = await _userRepository.findByEmail(lastEmail);
    }

    user ??= await _userRepository.findMostRecentUser();
    _currentUser = user;

    if (user != null) {
      nameController.text = user.name;
      emailController.text = user.email;
      educationalCenterController.text = user.educationalCenter;
      careerController.text = user.career;
      cityController.text = user.city;
    }

    notifyListeners();
  }

  // Reutilizar validadores de RegisterViewModel con submittedPersonal
  String? validateName(String? value) {
    if (!submittedPersonal) return null;
    if (value == null || value.trim().isEmpty) {
      return 'Nombre es requerido';
    }
    if (value.trim().length < 4) {
      return 'Nombre debe tener al menos 4 caracteres';
    }
    return null;
  }

  String? validateCurrentPassword(String? value) {
    if (!submittedPassword) return null;
    if (value == null || value.trim().isEmpty) {
      return 'Contraseña actual es requerida';
    }
    return null;
  }

  String? validateNewPassword(String? value) {
    if (!submittedPassword) return null;
    if (value == null || value.trim().isEmpty) {
      return 'Nueva contraseña es requerida';
    }
    if (value.trim().length < 8) {
      return 'Nueva contraseña debe tener al menos 8 caracteres';
    }
    return null;
  }

  String? validateConfirmNewPassword(String? value) {
    if (!submittedPassword) return null;
    if (value == null || value.trim().isEmpty) {
      return 'Confirmar nueva contraseña es requerido';
    }
    if (value.trim() != newPasswordController.text.trim()) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  Future<bool> savePersonalData() async {
    submittedPersonal = true;
    notifyListeners();

    if (!(personalFormKey.currentState?.validate() ?? false)) {
      return false;
    }

    final currentUser = _currentUser;
    if (currentUser == null) {
      passwordErrorMessage = 'No se encontró el usuario activo';
      notifyListeners();
      return false;
    }

    isSavingProfile = true;
    notifyListeners();

    final updatedUser = currentUser.copyWith(
      name: nameController.text.trim(),
      educationalCenter: educationalCenterController.text.trim(),
      career: careerController.text.trim(),
      city: cityController.text.trim(),
      updatedAt: DateTime.now(),
    );

    await _userRepository.updateUser(updatedUser);
    _currentUser = updatedUser;

    await Future<void>.delayed(const Duration(milliseconds: 300));

    isSavingProfile = false;
    notifyListeners();
    return true;
  }

  Future<bool> changePassword() async {
    submittedPassword = true;
    notifyListeners();

    if (!(passwordFormKey.currentState?.validate() ?? false)) {
      return false;
    }

    final currentUser = _currentUser;
    if (currentUser == null) {
      passwordErrorMessage = 'No se encontró el usuario activo';
      notifyListeners();
      return false;
    }

    if (currentPasswordController.text.trim() != currentUser.password) {
      passwordErrorMessage = 'La contraseña actual no es correcta';
      notifyListeners();
      return false;
    }

    passwordErrorMessage = null;
    isChangingPassword = true;
    notifyListeners();

    final updatedUser = currentUser.copyWith(
      password: newPasswordController.text.trim(),
      updatedAt: DateTime.now(),
    );

    await _userRepository.updateUser(updatedUser);
    _currentUser = updatedUser;

    await Future<void>.delayed(const Duration(milliseconds: 300));

    currentPasswordController.clear();
    newPasswordController.clear();
    confirmNewPasswordController.clear();

    isChangingPassword = false;
    submittedPassword = false;
    notifyListeners();
    return true;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    educationalCenterController.dispose();
    careerController.dispose();
    cityController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.dispose();
  }
}
