import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:ubook_app/theme/app_colors.dart';
import 'package:ubook_app/view_model/auth/register_view_model.dart';

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

  // ── Builder reutilizable para inputs ──
  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 15,
        ),
        filled: true,
        fillColor: AppColors.inputFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        prefixIcon: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        suffixIcon: obscureText
            ? const Icon(
                Icons.visibility_off_outlined,
                color: AppColors.textSecondary,
              )
            : null,
      ),
    );
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
                FadeInDown(
                  duration: const Duration(milliseconds: 800),
                  child: Container(
                    width: double.infinity,
                    height: 260,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            // TODO: Reemplazar con Image.asset('assets/images/logo.png')
                            child: const Icon(
                              Icons.auto_awesome,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Título
                          const Text(
                            'Registro',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Subtítulo
                          Text(
                            'Crea tu cuenta para continuar',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.75),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
                              _buildInput(
                                controller: _vm.name,
                                hint: 'Nombre *',
                                icon: Icons.person_outline,
                                validator: _vm.validateName,
                              ),
                              const SizedBox(height: 12),
                              _buildInput(
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
                              _buildInput(
                                controller: _vm.passwordController,
                                hint: 'Contraseña *',
                                icon: Icons.shield_outlined,
                                obscureText: true,
                                validator: _vm.validatePassword,
                              ),
                              const SizedBox(height: 12),
                              _buildInput(
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
                              _buildInput(
                                controller: _vm.educationalCenter,
                                hint: 'Centro Educativo',
                                icon: Icons.school_outlined,
                              ),
                              const SizedBox(height: 12),
                              _buildInput(
                                controller: _vm.career,
                                hint: 'Carrera',
                                icon: Icons.menu_book_outlined,
                              ),
                              const SizedBox(height: 12),
                              _buildInput(
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
                            child: Text(
                              _vm.errorMessage!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),

                        // ── Botón "Registrarse" (primario) ──
                        FadeInUp(
                          duration: const Duration(milliseconds: 1600),
                          child: SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _vm.isLoading
                                  ? null
                                  : () async {
                                      final success = await _vm.register();
                                      if (success && context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text('Registro exitoso'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                        Navigator.pop(context);
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: AppColors.primary
                                    .withValues(alpha: 0.6),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: _vm.isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : const Text(
                                      'Registrarse',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
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
                        FadeInUp(
                          duration: const Duration(milliseconds: 1800),
                          child: SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                // TODO: Implementar registro con Google
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.inputFill,
                                foregroundColor: AppColors.textPrimary,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/auth/logo-google.png',
                                    width: 20,
                                    height: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'Registrarse con Google',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // ── Link "Ya tienes cuenta" ──
                        FadeInUp(
                          duration: const Duration(milliseconds: 2000),
                          child: Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
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
