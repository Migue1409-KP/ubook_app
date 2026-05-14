import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ubook_app/model/auth/user_model.dart';
import 'package:ubook_app/repository/auth/firebase_auth_service.dart';
import 'package:ubook_app/repository/auth/syncing_user_repository.dart';
import 'package:ubook_app/repository/auth/user_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  final UserRepository _userRepository;
  final FirebaseAuthService _authService;

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

  bool get isGoogleUser => _authService.isGoogleUser;

  ProfileViewModel({
    UserRepository? userRepository,
    FirebaseAuthService? authService,
  }) : _userRepository = userRepository ?? SyncingUserRepository.instance,
       _authService = authService ?? FirebaseAuthService.instance {
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final firebaseUser = _authService.currentUser;
    UserModel? user;

    if (firebaseUser?.email != null) {
      user = await _userRepository.findByEmail(firebaseUser!.email!);
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

  String? validateName(String? value) {
    if (!submittedPersonal) return null;
    if (value == null || value.trim().isEmpty) return 'Nombre es requerido';
    if (value.trim().length < 4) return 'Nombre debe tener al menos 4 caracteres';
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
    if (value == null || value.trim().isEmpty) return 'Nueva contraseña es requerida';
    if (value.trim().length < 6) {
      return 'Nueva contraseña debe tener al menos 6 caracteres';
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

    if (!(personalFormKey.currentState?.validate() ?? false)) return false;

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

    await _authService.currentUser?.updateDisplayName(nameController.text.trim());

    await Future<void>.delayed(const Duration(milliseconds: 300));

    isSavingProfile = false;
    notifyListeners();
    return true;
  }

  Future<bool> changePassword() async {
    submittedPassword = true;
    notifyListeners();

    if (!(passwordFormKey.currentState?.validate() ?? false)) return false;

    passwordErrorMessage = null;
    isChangingPassword = true;
    notifyListeners();

    try {
      await _authService.reauthenticateWithPassword(
        currentPasswordController.text.trim(),
      );
      await _authService.updatePassword(newPasswordController.text.trim());

      currentPasswordController.clear();
      newPasswordController.clear();
      confirmNewPasswordController.clear();

      isChangingPassword = false;
      submittedPassword = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      passwordErrorMessage = FirebaseAuthService.mapError(e);
      isChangingPassword = false;
      notifyListeners();
      return false;
    } catch (e) {
      passwordErrorMessage = 'Error al cambiar contraseña. Intenta nuevamente.';
      isChangingPassword = false;
      notifyListeners();
      return false;
    }
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
