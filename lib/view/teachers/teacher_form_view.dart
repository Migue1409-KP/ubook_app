import 'package:flutter/material.dart';
import '../../view_model/teachers/teacher_form_view_model.dart';
import '../../model/teachers/teacher.dart';

class TeacherFormView extends StatefulWidget {
  const TeacherFormView({super.key, this.teacher});

  /// Pass a [Teacher] to enter edit mode with pre-filled fields.
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
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        foregroundColor: Colors.white,
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
                validator: (v) => _vm.validatePositiveInt(v, field: 'Edad'),
              ),
              _buildField(
                controller: _vm.departmentController,
                label: 'Departamento',
                hint: 'ej. Ingeniería de Sistemas',
                validator: (v) => _vm.validateRequired(v, field: 'Departamento'),
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
                  backgroundColor: const Color(0xFF4A90D9),
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
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: const TextStyle(color: Colors.white54),
          hintStyle: const TextStyle(color: Colors.white24),
          filled: true,
          fillColor: const Color(0xFF161B22),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF30363D)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF30363D)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF4A90D9), width: 2),
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
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF30363D)),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified_user_outlined,
              color: Colors.white54, size: 20),
          const SizedBox(width: 12),
          const Text(
            'Activo',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const Spacer(),
          Switch(
            value: _vm.isActive,
            activeColor: const Color(0xFF4A90D9),
            onChanged: (val) => setState(() => _vm.isActive = val),
          ),
        ],
      ),
    );
  }
}
