import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/pqrs/pqrs.dart';
import '../../view_model/pqrs/pqrs_viewmodel.dart';

class PQRSFormSheet extends StatefulWidget {
  final PQRS? initial;
  final int? index;

  const PQRSFormSheet({
    super.key,
    this.initial,
    this.index,
  });

  @override
  State<PQRSFormSheet> createState() => _PQRSFormSheetState();
}

class _PQRSFormSheetState extends State<PQRSFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _descripcionController = TextEditingController();
  String _tipo = 'Peticion';
  String _estado = 'Abierta';

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    if (initial != null) {
      _tipo = initial.tipo;
      _estado = initial.estado;
      _descripcionController.text = initial.descripcion;
    }
  }

  @override
  void dispose() {
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isEdit = widget.initial != null && widget.index != null;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottomInset),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEdit ? 'Editar PQRS' : 'Nueva PQRS',
              style: const TextStyle(
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
            if (isEdit) ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _estado,
                decoration: const InputDecoration(
                  labelText: 'Estado',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Abierta', child: Text('Abierta')),
                  DropdownMenuItem(
                    value: 'En proceso',
                    child: Text('En proceso'),
                  ),
                  DropdownMenuItem(value: 'Cerrada', child: Text('Cerrada')),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _estado = value);
                },
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                ),
                child: Text(isEdit ? 'Guardar' : 'Crear'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final viewModel = context.read<PQRSViewModel>();
    final isEdit = widget.initial != null && widget.index != null;
    if (isEdit) {
      viewModel.updatePQRS(
        index: widget.index!,
        tipo: _tipo,
        descripcion: _descripcionController.text.trim(),
        estado: _estado,
      );
    } else {
      viewModel.addPQRS(
        tipo: _tipo,
        descripcion: _descripcionController.text.trim(),
        estado: _estado,
      );
    }
    Navigator.pop(context);
  }
}
