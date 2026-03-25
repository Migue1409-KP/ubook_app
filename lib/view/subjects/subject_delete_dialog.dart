import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class SubjectDeleteDialog extends StatelessWidget {
  const SubjectDeleteDialog({
    super.key,
    required this.subjectName,
    required this.onConfirm,
  });

  final String subjectName;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Text(
        'Eliminar materia',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
      content: RichText(
        text: TextSpan(
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
          children: [
            const TextSpan(text: '¿Estás seguro de eliminar la materia '),
            TextSpan(
              text: '"$subjectName"',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const TextSpan(text: '?'),
          ],
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
          onPressed: () {
            onConfirm();
            Navigator.of(context).pop();
          },
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.processDanger,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Eliminar'),
        ),
      ],
    );
  }
}