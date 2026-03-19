import 'package:flutter/material.dart';
import 'package:ubook_app/model/auth/user_model.dart';
import 'package:ubook_app/model/auth/auth_provider.dart';

class ProfileViewModel extends ChangeNotifier {
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

  final String _dummyPassword = 'test1234';

  ProfileViewModel() {
    _loadDummyUser();
  }

  void _loadDummyUser() {
    final dummyUser = UserModel(
      id: '1',
      email: 'test@test.com',
      name: 'test pepito',
      birthDate: null,
      educationalCenter: 'Universidad Católica del Oriente',
      career: 'Ingeniería de Sistemas',
      city: 'Rionegro',
      profileImageUrl: null,
      authProvider: AuthProvider.emailPassword,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    nameController.text = dummyUser.name;
    emailController.text = dummyUser.email;
    educationalCenterController.text = dummyUser.educationalCenter;
    careerController.text = dummyUser.career;
    cityController.text = dummyUser.city;
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

    isSavingProfile = true;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 600));

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

    if (currentPasswordController.text.trim() != _dummyPassword) {
      passwordErrorMessage = 'La contraseña actual no es correcta';
      notifyListeners();
      return false;
    }

    passwordErrorMessage = null;
    isChangingPassword = true;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 600));

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
