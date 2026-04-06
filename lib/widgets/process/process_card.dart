import 'package:flutter/material.dart';
import '../../model/process/process_model.dart';
import '../../theme/app_colors.dart';

class ProcessCard extends StatelessWidget {
  const ProcessCard({
    super.key,
    required this.process,
    required this.onViewDetails,
    required this.onEdit,
    required this.onDelete,
  });

  final ProcessModel process;
  final VoidCallback onViewDetails;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final ({Color color, IconData icon, String label}) visual = _visualByType(
      process.processType,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onViewDetails,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: visual.color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(visual.icon, color: visual.color, size: 26),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          process.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          visual.label,
                          style: TextStyle(
                            fontSize: 12,
                            color: visual.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: process.isActive
                          ? AppColors.processActive.withOpacity(0.15)
                          : AppColors.processDanger.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      process.isActive ? 'Activo' : 'Inactivo',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: process.isActive
                            ? AppColors.processActive
                            : AppColors.processDanger,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                process.description,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.description,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${process.requiredDocuments.length} documentos requeridos',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: onViewDetails,
                    icon: const Icon(Icons.visibility, size: 18),
                    label: const Text('Ver detalles'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      textStyle: const TextStyle(fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Editar'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.processSubject,
                      textStyle: const TextStyle(fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete, size: 18),
                    label: const Text('Eliminar'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.processDanger,
                      textStyle: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ({Color color, IconData icon, String label}) _visualByType(ProcessType type) {
    switch (type) {
      case ProcessType.career:
        return (
          color: AppColors.primary,
          icon: Icons.school,
          label: 'Proceso de Carrera',
        );
      case ProcessType.subject:
        return (
          color: AppColors.processSubject,
          icon: Icons.book,
          label: 'Proceso de Materia',
        );
      case ProcessType.educationalCenter:
        return (
          color: Colors.teal,
          icon: Icons.account_balance,
          label: 'Proceso de Centro Educativo',
        );
    }
  }
}
