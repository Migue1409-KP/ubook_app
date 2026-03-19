import 'package:flutter/material.dart';
import 'package:ubook_app/theme/app_colors.dart';
import 'package:ubook_app/view_model/auth/profile_view_model.dart';
import 'package:ubook_app/widgets/auth/index.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late final ProfileViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = ProfileViewModel();
    _vm.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Mi Perfil',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Datos personales',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              Form(
                key: _vm.personalFormKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(
                children: [
                  AuthTextInput(
                    controller: _vm.nameController,
                    hint: 'Nombre',
                    icon: Icons.person_outline,
                    validator: _vm.validateName,
                  ),
                  const SizedBox(height: 12),
                  AuthTextInput(
                    controller: _vm.emailController,
                    hint: 'Correo electrónico',
                    icon: Icons.mail_outline,
                    keyboardType: TextInputType.emailAddress,
                    readOnly: true,
                    textStyle: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  AuthTextInput(
                    controller: _vm.educationalCenterController,
                    hint: 'Centro Educativo',
                    icon: Icons.school_outlined,
                  ),
                  const SizedBox(height: 12),
                  AuthTextInput(
                    controller: _vm.careerController,
                    hint: 'Carrera',
                    icon: Icons.menu_book_outlined,
                  ),
                  const SizedBox(height: 12),
                  AuthTextInput(
                    controller: _vm.cityController,
                    hint: 'Ciudad',
                    icon: Icons.location_on_outlined,
                  ),
                ],
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Guardar cambios',
                isLoading: _vm.isSavingProfile,
                onPressed: () async {
                  final success = await _vm.savePersonalData();
                  if (success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Datos personales actualizados'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 32),
              const Divider(color: AppColors.divider),
              const SizedBox(height: 20),
              const Text(
                'Cambiar contraseña',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              Form(
                key: _vm.passwordFormKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(
                  children: [
                    AuthTextInput(
                      controller: _vm.currentPasswordController,
                      hint: 'Contraseña actual *',
                      icon: Icons.lock_outline,
                      obscureText: true,
                      validator: _vm.validateCurrentPassword,
                    ),
                    const SizedBox(height: 12),
                    AuthTextInput(
                      controller: _vm.newPasswordController,
                      hint: 'Nueva contraseña *',
                      icon: Icons.shield_outlined,
                      obscureText: true,
                      validator: _vm.validateNewPassword,
                    ),
                    const SizedBox(height: 12),
                    AuthTextInput(
                      controller: _vm.confirmNewPasswordController,
                      hint: 'Confirmar nueva contraseña *',
                      icon: Icons.shield_outlined,
                      obscureText: true,
                      validator: _vm.validateConfirmNewPassword,
                    ),
                    if (_vm.passwordErrorMessage != null) ...[
                      const SizedBox(height: 12),
                      ErrorMessage(message: _vm.passwordErrorMessage!),
                    ],
                    const SizedBox(height: 16),
                    PrimaryButton(
                      label: 'Actualizar contraseña',
                      isLoading: _vm.isChangingPassword,
                      onPressed: () async {
                        final success = await _vm.changePassword();
                        if (success && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Contraseña actualizada'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
