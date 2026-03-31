import 'package:flutter/material.dart';
import '../../model/educational_center/educational_center_dummy_data.dart';
import '../../model/educational_center/educational_center_model.dart';
import '../../theme/app_colors.dart';

class EducationalCenterForm extends StatefulWidget {
  final bool isEditing;
  final EducationalCenter? center;

  const EducationalCenterForm({
    super.key,
    this.isEditing = false,
    this.center,
  });

  @override
  State<EducationalCenterForm> createState() => _EducationalCenterFormState();
}

class _EducationalCenterFormState extends State<EducationalCenterForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();

  String type = 'Pública';

  @override
  void initState() {
    super.initState();

    // Datos dummy para editar
    if (widget.isEditing) {
      final selectedCenter = widget.center;
      if (selectedCenter != null) {
        final detail = educationalCenterDummyById(selectedCenter.id);
        nameController.text = selectedCenter.name;
        addressController.text = detail.address;
        websiteController.text = detail.website;
        type = detail.type;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: AppColors.inputFill,
      labelStyle: const TextStyle(color: AppColors.textPrimary),
      hintStyle: const TextStyle(color: AppColors.placeholder),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );

    return AlertDialog(
      backgroundColor: AppColors.onPrimary,
      title: Text(
        widget.isEditing
            ? "Editar centro educativo"
            : "Agregar centro educativo",
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Nombre
            TextField(
              controller: nameController,
              decoration: inputDecoration.copyWith(labelText: "Nombre"),
            ),

            const SizedBox(height: 12),

            // Dirección
            TextField(
              controller: addressController,
              decoration: inputDecoration.copyWith(labelText: "Dirección"),
            ),

            const SizedBox(height: 12),

            // Tipo
            DropdownButtonFormField<String>(
              value: type,
              decoration: inputDecoration.copyWith(labelText: "Tipo"),
              dropdownColor: AppColors.onPrimary,
              items: const [
                DropdownMenuItem(value: "Pública", child: Text("Pública")),
                DropdownMenuItem(value: "Privada", child: Text("Privada")),
              ],
              onChanged: (value) {
                setState(() {
                  type = value!;
                });
              },
            ),

            const SizedBox(height: 12),

            // Sitio web
            TextField(
              controller: websiteController,
              decoration: inputDecoration.copyWith(labelText: "Sitio web"),
            ),
          ],
        ),
      ),
      actions: [
        // Cancelar
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "Cancelar",
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),

        // Guardar
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
          ),
          onPressed: () {
            // luego irá el backend
          },
          child: const Text("Guardar"),
        ),
      ],
    );
  }
}
