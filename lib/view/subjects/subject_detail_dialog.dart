import 'package:flutter/material.dart';
import '../../model/subjects/subjects.dart';
import '../../theme/app_colors.dart';

class SubjectDetailDialog extends StatelessWidget {
  final Subject subject;

  const SubjectDetailDialog({
    super.key,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        subject.nombre,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoRow(label: 'Horas', value: '${subject.horas}'),
            const SizedBox(height: 8),
            _InfoRow(label: 'Créditos', value: '${subject.creditos}'),
            const SizedBox(height: 16),
            const Text(
              'Prerrequisitos',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            if (subject.prerrequisitos.isEmpty)
              const Text(
                'No tiene prerrequisitos',
                style: TextStyle(color: AppColors.textSecondary),
              )
            else
              ...subject.prerrequisitos.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '• $item',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            const Text(
              'Contenido',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subject.contenido,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cerrar',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}