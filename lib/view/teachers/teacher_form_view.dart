import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../view_model/teachers/teacher_form_view_model.dart';
import '../../view_model/teachers/teacher_count_provider.dart';
import '../../model/teachers/teacher.dart';

class TeacherFormView extends StatefulWidget {
  const TeacherFormView({super.key, this.teacher});

  final Teacher? teacher;

  @override
  State<TeacherFormView> createState() => _TeacherFormViewState();
}

class _TeacherFormViewState extends State<TeacherFormView> {
  late final TeacherFormViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = TeacherFormViewModel(initial: widget.teacher);
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
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        title: Text(
          _vm.isEditing ? 'Editar Profesor' : 'Nuevo Profesor',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: Form(
        key: _vm.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Consumer<TeacherCountProvider>(
                builder: (context, counter, _) {
                  final wasActive = widget.teacher?.isActive ?? false;
                  final previewTotal =
                      counter.total + (_vm.isEditing ? 0 : 1);
                  final previewActive = counter.active +
                      (_vm.isActive ? 1 : 0) -
                      (_vm.isEditing ? (wasActive ? 1 : 0) : 0);
                  final isActiveNow = _vm.isActive;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.person,
                            color: AppColors.primary, size: 22),
                        const SizedBox(width: 10),
                        Text(
                          'Profesores registrados: $previewTotal',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: (isActiveNow ? Colors.green : Colors.red)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Activos: $previewActive',
                            style: TextStyle(
                              color: isActiveNow
                                  ? Colors.green[700]
                                  : Colors.red[700],
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              _buildField(
                controller: _vm.firstNameController,
                label: 'Nombre',
                hint: 'ej. Juan Pablo',
                validator: (v) => _vm.validateRequired(v, field: 'Nombre'),
              ),
              _buildField(
                controller: _vm.lastNameController,
                label: 'Apellido',
                hint: 'ej. Gómez',
                validator: (v) => _vm.validateRequired(v, field: 'Apellido'),
              ),
              _buildField(
                controller: _vm.emailController,
                label: 'Email',
                hint: 'ej. juan@uni.edu',
                keyboardType: TextInputType.emailAddress,
                validator: _vm.validateEmail,
              ),
              _buildField(
                controller: _vm.phoneController,
                label: 'Teléfono',
                hint: 'ej. 809-555-0101',
                keyboardType: TextInputType.phone,
              ),
              _buildField(
                controller: _vm.ageController,
                label: 'Edad',
                hint: 'ej. 35',
                keyboardType: TextInputType.number,
                validator: (v) =>
                    _vm.validatePositiveInt(v, field: 'Edad'),
              ),
              _buildField(
                controller: _vm.departmentController,
                label: 'Departamento',
                hint: 'ej. Ingeniería de Sistemas',
                validator: (v) =>
                    _vm.validateRequired(v, field: 'Departamento'),
              ),
              _buildField(
                controller: _vm.specialtyController,
                label: 'Especialidad',
                hint: 'ej. Desarrollo Móvil',
              ),
              _buildField(
                controller: _vm.profileImageUrlController,
                label: 'URL de imagen de perfil',
                hint: 'ej. https://example.com/avatar.jpg',
                keyboardType: TextInputType.url,
                action: TextInputAction.done,
              ),
              const SizedBox(height: 12),
              _buildActiveSwitch(),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _vm.isSaving
                    ? null
                    : () async {
                        final Teacher? saved = await _vm.submit();
                        if (saved != null && mounted) {
                          if (!_vm.isEditing) {
                            context.read<TeacherCountProvider>().addTeacher(
                                  isActive: saved.isActive,
                                );
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(_vm.isEditing
                                  ? 'Profesor actualizado'
                                  : 'Profesor guardado'),
                            ),
                          );
                          Navigator.of(context).pop(saved);
                        }
                      },
                icon: _vm.isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(_vm.isSaving ? 'Guardando...' : 'Guardar'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputAction action = TextInputAction.next,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        textInputAction: action,
        keyboardType: keyboardType,
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: const TextStyle(color: AppColors.textSecondary),
          hintStyle: const TextStyle(color: AppColors.placeholder),
          filled: true,
          fillColor: AppColors.inputFill,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent, width: 2),
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildActiveSwitch() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified_user_outlined,
              color: AppColors.textSecondary, size: 20),
          const SizedBox(width: 12),
          const Text(
            'Activo',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 16),
          ),
          const Spacer(),
          Switch(
            value: _vm.isActive,
            activeColor: AppColors.primary,
            onChanged: (val) => setState(() => _vm.isActive = val),
          ),
        ],
      ),
    );
  }
}
