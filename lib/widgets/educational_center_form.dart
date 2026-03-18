import 'package:flutter/material.dart';

class EducationalCenterForm extends StatefulWidget {
  final bool isEditing;

  const EducationalCenterForm({super.key, this.isEditing = false});

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
      nameController.text = "Universidad Nacional";
      addressController.text = "Medellín, Colombia";
      websiteController.text = "https://unal.edu.co";
      type = "Pública";
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.isEditing
            ? "Editar centro educativo"
            : "Agregar centro educativo",
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Nombre
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Nombre"),
            ),

            const SizedBox(height: 12),

            // Dirección
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: "Dirección"),
            ),

            const SizedBox(height: 12),

            // Tipo
            DropdownButtonFormField<String>(
              value: type,
              decoration: const InputDecoration(labelText: "Tipo"),
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
              decoration: const InputDecoration(labelText: "Sitio web"),
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
          child: const Text("Cancelar"),
        ),

        // Guardar
        ElevatedButton(
          onPressed: () {
            // luego irá el backend
          },
          child: const Text("Guardar"),
        ),
      ],
    );
  }
}
