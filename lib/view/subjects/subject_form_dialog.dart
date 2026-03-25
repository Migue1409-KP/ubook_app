import 'package:flutter/material.dart';
import '../../model/subjects/subjects.dart';
import '../../theme/app_colors.dart';

class SubjectFormDialog extends StatefulWidget {
  const SubjectFormDialog({
    super.key,
    required this.onSave,
    this.subject,
  });

  final Subject? subject;
  final void Function({
    required String nombre,
    required int horas,
    required int creditos,
    required String prerrequisitosText,
    required String contenido,
  }) onSave;

  @override
  State<SubjectFormDialog> createState() => _SubjectFormDialogState();
}

class _SubjectFormDialogState extends State<SubjectFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nombreController;
  late final TextEditingController _horasController;
  late final TextEditingController _creditosController;
  late final TextEditingController _prerrequisitosController;
  late final TextEditingController _contenidoController;

  bool get isEdit => widget.subject != null;

  @override
  void initState() {
    super.initState();

    final subject = widget.subject;
    _nombreController = TextEditingController(text: subject?.nombre ?? '');
    _horasController =
        TextEditingController(text: subject?.horas.toString() ?? '');
    _creditosController =
        TextEditingController(text: subject?.creditos.toString() ?? '');
    _prerrequisitosController = TextEditingController(
      text: subject?.prerrequisitos.join(', ') ?? '',
    );
    _contenidoController =
        TextEditingController(text: subject?.contenido ?? '');
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _horasController.dispose();
    _creditosController.dispose();
    _prerrequisitosController.dispose();
    _contenidoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        isEdit ? 'Editar materia' : 'Crear materia',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
      content: SizedBox(
        width: 520,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildField(
                  controller: _nombreController,
                  label: 'Nombre',
                  validator: _requiredValidator,
                ),
                const SizedBox(height: 12),
                _buildField(
                  controller: _horasController,
                  label: 'Horas',
                  keyboardType: TextInputType.number,
                  validator: _numberValidator,
                ),
                const SizedBox(height: 12),
                _buildField(
                  controller: _creditosController,
                  label: 'Créditos',
                  keyboardType: TextInputType.number,
                  validator: _numberValidator,
                ),
                const SizedBox(height: 12),
                _buildField(
                  controller: _prerrequisitosController,
                  label: 'Prerrequisitos',
                  helperText: 'Sepáralos con coma',
                ),
                const SizedBox(height: 12),
                _buildField(
                  controller: _contenidoController,
                  label: 'Contenido',
                  maxLines: 4,
                  validator: _requiredValidator,
                ),
              ],
            ),
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancelar',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        FilledButton(
          onPressed: _save,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Guardar'),
        ),
      ],
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    String? helperText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        helperStyle: const TextStyle(color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.inputFill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
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
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.processDanger,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.processDanger,
            width: 2,
          ),
        ),
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }

  String? _numberValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo es obligatorio';
    }
    if (int.tryParse(value.trim()) == null) {
      return 'Ingresa solo números';
    }
    return null;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    widget.onSave(
      nombre: _nombreController.text,
      horas: int.parse(_horasController.text.trim()),
      creditos: int.parse(_creditosController.text.trim()),
      prerrequisitosText: _prerrequisitosController.text,
      contenido: _contenidoController.text,
    );

    Navigator.of(context).pop();
  }
}