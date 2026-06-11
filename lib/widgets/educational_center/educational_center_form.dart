import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/educational_center/educational_center_dummy_data.dart';
import '../../model/educational_center/educational_center_model.dart';
import '../../theme/app_colors.dart';
import '../../view_model/educational_center/educational_center_view_model.dart';
import '../../view_model/educational_center/educational_center_count_provider.dart';

class EducationalCenterForm extends StatefulWidget {
  final bool isEditing;
  final EducationalCenter? center;

  const EducationalCenterForm({super.key, this.isEditing = false, this.center});

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

    if (widget.isEditing && widget.center != null) {
      nameController.text = widget.center!.name;
      addressController.text = widget.center!.address ?? '';
      websiteController.text = widget.center!.website ?? '';
      type = widget.center!.type ?? 'Pública';
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    websiteController.dispose();
    super.dispose();
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
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );

    return AlertDialog(
      backgroundColor: AppColors.onPrimary,
      title: Text(
        widget.isEditing ? "Editar centro educativo" : "Agregar centro educativo",
        style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: inputDecoration.copyWith(labelText: "Nombre"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: addressController,
              decoration: inputDecoration.copyWith(labelText: "Dirección"),
            ),
            const SizedBox(height: 12),
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
            TextField(
              controller: websiteController,
              decoration: inputDecoration.copyWith(labelText: "Sitio web"),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar", style: TextStyle(color: AppColors.textSecondary)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
          ),
          onPressed: () async {
            final name = nameController.text.trim();
            final address = addressController.text.trim();
            final website = websiteController.text.trim();

            if (name.isEmpty) return;

            final viewModel = Provider.of<EducationalCenterViewModel>(context, listen: false);
            final countProvider = Provider.of<EducationalCenterCountProvider>(context, listen: false);
            final int currentTime = DateTime.now().millisecondsSinceEpoch;

            if (widget.isEditing && widget.center != null) {
              // 📝 MODO EDICIÓN: Actualización limpia eliminando el antiguo para prevenir conflictos en SQLite
              await viewModel.removeCenter(widget.center!.id, countProvider);

              final centroEditado = EducationalCenter(
                id: widget.center!.id,
                name: name,
                address: address.isEmpty ? null : address,
                type: type,
                website: website.isEmpty ? null : website,
                createdAt: widget.center!.createdAt,
                updatedAt: currentTime,
              );
              await viewModel.addCenter(centroEditado, countProvider);
            } else {
              // ➕ MODO CREACIÓN:
              final nuevoCentro = EducationalCenter(
                id: currentTime.toString(),
                name: name,
                address: address.isEmpty ? null : address,
                type: type,
                website: website.isEmpty ? null : website,
                createdAt: currentTime,
                updatedAt: currentTime,
              );
              await viewModel.addCenter(nuevoCentro, countProvider);
            }

            if (context.mounted) {
              Navigator.pop(context);
            }
          },
          child: const Text("Guardar"),
        ),
      ],
    );
  }
}