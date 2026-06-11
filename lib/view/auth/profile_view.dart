import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ubook_app/theme/app_colors.dart';
import 'package:ubook_app/view_model/auth/profile_view_model.dart';
import 'package:ubook_app/widgets/auth/index.dart';

class _CityOption {
  final String nombre;
  final String departamento;

  const _CityOption({required this.nombre, required this.departamento});

  factory _CityOption.fromJson(Map<String, dynamic> json) => _CityOption(
    nombre: json['nombre']?.toString() ?? '',
    departamento: json['departamento']?.toString() ?? '',
  );

  String get label => '$nombre - $departamento';
}

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late final ProfileViewModel _vm;
  late Future<List<_CityOption>> _citiesFuture;

  static const String _citiesEndpoint =
      'https://my-json-server.typicode.com/juanpanore/api/ciudadesColombia';

  @override
  void initState() {
    super.initState();
    _vm = ProfileViewModel();
    _vm.addListener(() => setState(() {}));
    _citiesFuture = _loadCities();
  }

  Future<List<_CityOption>> _loadCities() async {
    final response = await http.get(Uri.parse(_citiesEndpoint));
    if (response.statusCode != 200) {
      throw Exception('No se pudieron cargar las ciudades');
    }
    final decoded = jsonDecode(response.body);
    if (decoded is! List) throw Exception('Respuesta inválida de ciudades');
    return decoded
        .whereType<Map<String, dynamic>>()
        .map(_CityOption.fromJson)
        .where((city) => city.nombre.isNotEmpty)
        .toList();
  }

  Widget _buildCityField() {
    return FutureBuilder<List<_CityOption>>(
      future: _citiesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return TextFormField(
            enabled: false,
            decoration: InputDecoration(
              hintText: 'Cargando ciudades...',
              hintStyle: const TextStyle(color: AppColors.placeholder),
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
                child: const Icon(
                  Icons.location_on_outlined,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              suffixIcon: const Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return InputDecorator(
            decoration: InputDecoration(
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
                child: const Icon(
                  Icons.location_on_outlined,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'No se pudieron cargar las ciudades',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() {
                    _citiesFuture = _loadCities();
                  }),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        final cities = snapshot.data ?? const <_CityOption>[];
        final selectedCity =
            cities.any((city) => city.nombre == _vm.cityController.text)
                ? _vm.cityController.text
                : null;

        return DropdownButtonFormField<String>(
          value: selectedCity,
          decoration: InputDecoration(
            hintText: 'Ciudad',
            hintStyle: const TextStyle(color: AppColors.placeholder),
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
              child: const Icon(
                Icons.location_on_outlined,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          isExpanded: true,
          dropdownColor: AppColors.onPrimary,
          items: cities
              .map(
                (city) => DropdownMenuItem<String>(
                  value: city.nombre,
                  child: Text(city.label, overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value == null) return;
            _vm.cityController.text = value;
          },
        );
      },
    );
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
                  _buildCityField(),
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
              if (!_vm.isGoogleUser) ...[
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
            ],
          ),
        ),
      ),
    );
  }
}
