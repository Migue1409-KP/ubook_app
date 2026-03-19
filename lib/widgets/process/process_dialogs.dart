import 'package:flutter/material.dart';
import '../../model/process/process_model.dart';
import '../../theme/app_colors.dart';
import '../../view_model/process_view_model.dart';

Future<void> showProcessFormDialog({
  required BuildContext context,
  required ProcessViewModel viewModel,
  ProcessModel? process,
}) async {
  final isEditing = process != null;
  final nameController = TextEditingController(text: process?.name ?? '');
  final descriptionController = TextEditingController(
    text: process?.description ?? '',
  );
  final documentsController = TextEditingController(
    text: process?.requiredDocuments.join(', ') ?? '',
  );
  ProcessType selectedType = process?.processType ?? ProcessType.career;
  bool isActive = process?.isActive ?? true;

  await showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setDialogState) => AlertDialog(
        title: Text(isEditing ? 'Editar Proceso' : 'Nuevo Proceso'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                textCapitalization: TextCapitalization.sentences,
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: documentsController,
                decoration: const InputDecoration(
                  labelText: 'Documentos requeridos',
                  hintText: 'Separar con comas',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              const Text(
                'Tipo:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  Radio<ProcessType>(
                    value: ProcessType.career,
                    groupValue: selectedType,
                    onChanged: (v) => setDialogState(() => selectedType = v!),
                  ),
                  const Text('Carrera'),
                  const SizedBox(width: 16),
                  Radio<ProcessType>(
                    value: ProcessType.subject,
                    groupValue: selectedType,
                    onChanged: (v) => setDialogState(() => selectedType = v!),
                  ),
                  const Text('Materia'),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: isActive,
                    onChanged: (v) =>
                        setDialogState(() => isActive = v ?? true),
                  ),
                  const Text('Activo'),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isEmpty) return;

              final docs = documentsController.text
                  .split(',')
                  .map((d) => d.trim())
                  .where((d) => d.isNotEmpty)
                  .toList();

              Navigator.pop(context);

              if (isEditing) {
                viewModel.updateProcess(
                  process.copyWith(
                    name: name,
                    description: descriptionController.text.trim(),
                    requiredDocuments: docs,
                    processType: selectedType,
                    isActive: isActive,
                  ),
                );
              } else {
                viewModel.addProcess(
                  ProcessModel(
                    id: 'proc_${DateTime.now().millisecondsSinceEpoch}',
                    name: name,
                    description: descriptionController.text.trim(),
                    requiredDocuments: docs,
                    processType: selectedType,
                    isActive: isActive,
                  ),
                );
              }
            },
            child: Text(isEditing ? 'Guardar' : 'Agregar'),
          ),
        ],
      ),
    ),
  );
}

Future<void> showProcessDetailsDialog({
  required BuildContext context,
  required ProcessModel process,
}) async {
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(process.name),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Descripción:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(process.description),
            const SizedBox(height: 16),
            const Text(
              'Documentos requeridos:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...process.requiredDocuments.map(
              (doc) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(fontSize: 16)),
                    Expanded(child: Text(doc)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Tipo: ${process.processType == ProcessType.career ? "Carrera" : "Materia"}',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 4),
            Text(
              'Estado: ${process.isActive ? "Activo" : "Inactivo"}',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cerrar'),
        ),
      ],
    ),
  );
}

Future<void> showDeleteProcessDialog({
  required BuildContext context,
  required ProcessModel process,
  required ProcessViewModel viewModel,
}) async {
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Confirmar eliminación'),
      content: Text('¿Estás seguro de que deseas eliminar "${process.name}"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            final originalIndex = viewModel.indexOfProcess(process);
            Navigator.pop(context);
            viewModel.deleteProcess(process.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Proceso "${process.name}" eliminado'),
                duration: const Duration(seconds: 4),
                behavior: SnackBarBehavior.floating,
                action: SnackBarAction(
                  label: 'Deshacer',
                  onPressed: () {
                    viewModel.restoreProcess(process, originalIndex);
                  },
                ),
              ),
            );
          },
          style: TextButton.styleFrom(
            foregroundColor: AppColors.processDanger,
          ),
          child: const Text('Eliminar'),
        ),
      ],
    ),
  );
}
