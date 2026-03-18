import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_model/pqrs/pqrs_viewmodel.dart';

class PQRSFormSheet extends StatefulWidget {
  const PQRSFormSheet({super.key});

  @override
  State<PQRSFormSheet> createState() => _PQRSFormSheetState();
}

class _PQRSFormSheetState extends State<PQRSFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _descripcionController = TextEditingController();
  String _tipo = 'Peticion';

  @override
  void dispose() {
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottomInset),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nueva PQRS',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _tipo,
              decoration: const InputDecoration(
                labelText: 'Tipo',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Peticion', child: Text('Peticion')),
                DropdownMenuItem(value: 'Queja', child: Text('Queja')),
                DropdownMenuItem(value: 'Reclamo', child: Text('Reclamo')),
              ],
              onChanged: (value) {
                if (value == null) return;
                setState(() => _tipo = value);
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descripcionController,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Descripcion',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'La descripcion es requerida';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Crear'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<PQRSViewModel>().addPQRS(
          tipo: _tipo,
          descripcion: _descripcionController.text.trim(),
        );
    Navigator.pop(context);
  }
}
