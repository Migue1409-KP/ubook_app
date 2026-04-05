import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:ubook_app/theme/app_colors.dart';
import 'package:ubook_app/view_model/auth/register_view_model.dart';
import 'package:ubook_app/widgets/auth/index.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final RegisterViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = RegisterViewModel();
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // ── HEADER ──
                AuthHeader(
                  title: 'Registro',
                  subtitle: 'Crea tu cuenta para continuar',
                ),

                // ── FORMULARIO ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: _vm.formKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),

                        // ── GRUPO 1: Datos personales ──
                        FadeInUp(
                          duration: const Duration(milliseconds: 1000),
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
                              const SizedBox(height: 8),
                              AuthTextInput(
                                controller: _vm.name,
                                hint: 'Nombre *',
                                icon: Icons.person_outline,
                                validator: _vm.validateName,
                              ),
                              const SizedBox(height: 12),
                              AuthTextInput(
                                controller: _vm.emailController,
                                hint: 'Correo electrónico *',
                                icon: Icons.mail_outline,
                                keyboardType: TextInputType.emailAddress,
                                validator: _vm.validateEmail,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ── GRUPO 2: Seguridad ──
                        FadeInUp(
                          duration: const Duration(milliseconds: 1200),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Seguridad',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              AuthTextInput(
                                controller: _vm.passwordController,
                                hint: 'Contraseña *',
                                icon: Icons.shield_outlined,
                                obscureText: true,
                                validator: _vm.validatePassword,
                              ),
                              const SizedBox(height: 12),
                              AuthTextInput(
                                controller: _vm.confirmPasswordController,
                                hint: 'Confirmar contraseña *',
                                icon: Icons.shield_outlined,
                                obscureText: true,
                                validator: _vm.validateConfirmPassword,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ── GRUPO 3: Información académica (opcional) ──
                        FadeInUp(
                          duration: const Duration(milliseconds: 1400),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Información académica (opcional)',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              AuthTextInput(
                                controller: _vm.educationalCenter,
                                hint: 'Centro Educativo',
                                icon: Icons.school_outlined,
                              ),
                              const SizedBox(height: 12),
                              AuthTextInput(
                                controller: _vm.career,
                                hint: 'Carrera',
                                icon: Icons.menu_book_outlined,
                              ),
                              const SizedBox(height: 12),
                              AuthTextInput(
                                controller: _vm.city,
                                hint: 'Ciudad',
                                icon: Icons.location_on_outlined,
                              ),
                            ],
                          ),
                        ),

                        // ── Mensaje de error ──
                        if (_vm.errorMessage != null) ...[
                          const SizedBox(height: 16),
                          Center(
                            child: ErrorMessage(
                              message: _vm.errorMessage!,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 0,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),

                        // ── Botón "Registrarse" (primario) ──
                        PrimaryButton(
                          label: 'Registrarse',
                          isLoading: _vm.isLoading,
                          onPressed: () async {
                            final success = await _vm.register();
                            if (success && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Registro exitoso'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Navigator.pushNamed(context, '/login');
                            }
                          },
                          animationDuration: const Duration(milliseconds: 1600),
                        ),
                        const SizedBox(height: 24),

                        // ── Divider ──
                        FadeInUp(
                          duration: const Duration(milliseconds: 1800),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Divider(color: AppColors.divider),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: const Text(
                                  'O registrarse con',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                              const Expanded(
                                child: Divider(color: AppColors.divider),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // ── Botón "Registrarse con Google" ──
                        SocialAuthButton(
                          label: 'Registrarse con Google',
                          assetImage: 'assets/images/auth/logo-google.png',
                          onPressed: () {
                            // TODO: Implementar registro con Google
                          },
                          animationDuration: const Duration(milliseconds: 1800),
                        ),
                        const SizedBox(height: 20),

                        // ── Link "Ya tienes cuenta" ──
                        FadeInUp(
                          duration: const Duration(milliseconds: 2000),
                          child: Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/login',
                                );
                              },
                              child: const Text(
                                '¿Ya tienes cuenta? Inicia sesión',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
