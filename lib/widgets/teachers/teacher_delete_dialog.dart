import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class TeacherDeleteDialog extends StatelessWidget {
  final String teacherName;
  final VoidCallback onConfirm;

  const TeacherDeleteDialog({
    super.key,
    required this.teacherName,
    required this.onConfirm,
  });

  static Future<void> show({
    required BuildContext context,
    required String teacherName,
    required VoidCallback onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (_) => TeacherDeleteDialog(
        teacherName: teacherName,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text(
        'Eliminar profesor',
        style: TextStyle(color: AppColors.textPrimary),
      ),
      content: Text(
        '¿Estás seguro de que deseas eliminar a $teacherName?',
        style: const TextStyle(color: AppColors.textSecondary),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancelar',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
          child: const Text('Eliminar'),
        ),
      ],
    );
  }
}
