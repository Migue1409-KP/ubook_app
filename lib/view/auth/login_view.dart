import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:ubook_app/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:ubook_app/view_model/auth/user_count_provider.dart';
import 'package:ubook_app/view/auth/register_view.dart';
import 'package:ubook_app/view_model/auth/login_view_model.dart';
import 'package:ubook_app/widgets/auth/index.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final LoginViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = LoginViewModel();
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
          // ── Imágenes decorativas de fondo ──
          DecorativeImage(
            assetPath: 'assets/images/auth/light-1.png',
            left: 30,
            top: 0,
            width: 60,
            height: 200,
            animationDuration: const Duration(seconds: 1),
          ),
          DecorativeImage(
            assetPath: 'assets/images/auth/light-2.png',
            left: 100,
            top: 0,
            width: 60,
            height: 150,
            animationDuration: const Duration(milliseconds: 1200),
          ),
          DecorativeImage(
            assetPath: 'assets/images/auth/clock.png',
            right: 40,
            top: 40,
            width: 80,
            height: 150,
            animationDuration: const Duration(milliseconds: 1300),
            fadeDown: true,
          ),
          // ── Contenido principal ──
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _vm.formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(
                  children: [
                    const SizedBox(height: 60),

                    // ── Logo / App Icon ──
                    FadeInDown(
                      duration: const Duration(milliseconds: 800),
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ── Ubook ──
                    FadeInDown(
                      duration: const Duration(milliseconds: 1000),
                      child: const Text(
                        'UBOOK',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w300,
                          color: AppColors.primary,
                        ),
                      ),
                    ),

                    // Contador de usuarios activos
                    Consumer<UserCountProvider>(
                      builder: (context, userCountProvider, child) {
                        return Text(
                          '${userCountProvider.userCount} usuarios activos',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // ── Título ──
                    FadeInUp(
                      duration: const Duration(milliseconds: 900),
                      child: const Text(
                        'Iniciar Sesión',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ── Subtítulo ──
                    FadeInUp(
                      duration: const Duration(milliseconds: 1000),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'Para iniciar sesión en la aplicación, ingresa tu correo electrónico y contraseña',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Input E-mail ──
                    FadeInUp(
                      duration: const Duration(milliseconds: 1100),
                      child: AuthTextInput(
                        controller: _vm.emailController,
                        hint: 'Correo electrónico',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: _vm.validateEmail,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ── Input Password ──
                    FadeInUp(
                      duration: const Duration(milliseconds: 1300),
                      child: AuthTextInput(
                        controller: _vm.passwordController,
                        hint: 'Contraseña',
                        icon: Icons.lock_outline,
                        obscureText: true,
                        validator: _vm.validatePassword,
                      ),
                    ),

                    // ── Mensaje de error ──
                    if (_vm.errorMessage != null) ...[
                      const SizedBox(height: 12),
                      ErrorMessage(message: _vm.errorMessage!),
                    ],
                    const SizedBox(height: 16),

                    // ── ¿Olvidaste tu contraseña? ──
                    FadeInLeft(
                      duration: const Duration(milliseconds: 1400),
                      child: const Text(
                        '¿Olvidaste tu contraseña?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Botón "Continuar" (primario) ──
                    PrimaryButton(
                      label: 'Continuar',
                      isLoading: _vm.isLoading,
                      onPressed: () async {
                        final success = await _vm.login();
                        if (success && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Inicio de sesión exitoso'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pushNamed(context, '/dashboard');
                        }
                      },
                      animationDuration: const Duration(milliseconds: 1500),
                    ),
                    const SizedBox(height: 16),

                    // ── ¿No tienes cuenta? ──
                    const Text(
                      '¿Aún no tienes una cuenta?',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // ── Botón "Crear una cuenta" (secundario) ──
                    SecondaryButton(
                      label: 'Crear una cuenta',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterView(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),

                    // ── Botón "Iniciar sesión con Google" ──
                    SocialAuthButton(
                      label: 'Iniciar sesión con Google',
                      assetImage: 'assets/images/auth/logo-google.png',
                      onPressed: () {
                        // TODO: Implementar login con Google
                      },
                      animationDuration: const Duration(milliseconds: 1700),
                    ),
                    const SizedBox(height: 20),

                    // ── Texto legal ──
                    FadeIn(
                      duration: const Duration(milliseconds: 2000),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text.rich(
                          TextSpan(
                            text:
                                'Al hacer clic en "Continuar", he leído y acepto los ',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                            children: const [
                              TextSpan(
                                text: 'Términos de Servicio',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              TextSpan(text: ', '),
                              TextSpan(
                                text: 'Política de Privacidad',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
