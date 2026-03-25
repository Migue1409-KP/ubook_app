import 'package:flutter/material.dart';
import 'package:ubook_app/model/subjects/subjects.dart';

class SubjectFormData {
  const SubjectFormData({
    required this.nombre,
    required this.horas,
    required this.creditos,
    required this.prerrequisitos,
    required this.contenido,
  });

  final String nombre;
  final int horas;
  final int creditos;
  final String prerrequisitos;
  final String contenido;
}

class SubjectFormModal extends StatefulWidget {
  const SubjectFormModal({
    super.key,
    required this.title,
    required this.buttonText,
    required this.onSave,
    this.initialSubject,
  });

  final String title;
  final String buttonText;
  final Subject? initialSubject;
  final ValueChanged<SubjectFormData> onSave;

  @override
  State<SubjectFormModal> createState() => _SubjectFormModalState();
}

class _SubjectFormModalState extends State<SubjectFormModal> {
  late final TextEditingController _nombreController;
  late final TextEditingController _horasController;
  late final TextEditingController _creditosController;
  late final TextEditingController _prerrequisitosController;
  late final TextEditingController _contenidoController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final subject = widget.initialSubject;
    _nombreController = TextEditingController(text: subject?.nombre ?? '');
    _horasController = TextEditingController(text: subject?.horas.toString() ?? '');
    _creditosController = TextEditingController(text: subject?.creditos.toString() ?? '');
    _prerrequisitosController = TextEditingController(
      text: subject == null ? '' : subject.prerrequisitos.join(', '),
    );
    _contenidoController = TextEditingController(text: subject?.contenido ?? '');
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
    return Dialog(
      child: Container(
        width: 430,
        padding: const EdgeInsets.all(24),
        color: const Color(0xFFF3F3F3),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 22),
              _SubjectInputRow(label: 'Nombre', controller: _nombreController),
              const SizedBox(height: 12),
              _SubjectInputRow(
                label: 'Horas:',
                controller: _horasController,
                keyboardType: TextInputType.number,
                validator: _numberValidator,
              ),
              const SizedBox(height: 12),
              _SubjectInputRow(
                label: 'Creditos',
                controller: _creditosController,
                keyboardType: TextInputType.number,
                validator: _numberValidator,
              ),
              const SizedBox(height: 12),
              _SubjectInputRow(
                label: 'Prerrequisitos',
                controller: _prerrequisitosController,
              ),
              const SizedBox(height: 12),
              _SubjectInputRow(label: 'Contenido', controller: _contenidoController),
              const SizedBox(height: 18),
              SizedBox(
                width: 170,
                height: 48,
                child: OutlinedButton(
                  onPressed: _save,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.black87),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(widget.buttonText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _numberValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Requerido';
    }

    if (int.tryParse(value.trim()) == null) {
      return 'Solo números';
    }

    return null;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    widget.onSave(
      SubjectFormData(
        nombre: _nombreController.text,
        horas: int.parse(_horasController.text.trim()),
        creditos: int.parse(_creditosController.text.trim()),
        prerrequisitos: _prerrequisitosController.text,
        contenido: _contenidoController.text,
      ),
    );

    Navigator.of(context).pop();
  }
}

class _SubjectInputRow extends StatelessWidget {
  const _SubjectInputRow({
    required this.label,
    required this.controller,
    this.keyboardType,
    this.validator,
  });

  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 130,
          child: Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        Expanded(
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.black87),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
