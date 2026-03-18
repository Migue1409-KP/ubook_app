import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class ProcessEmptyState extends StatelessWidget {
  const ProcessEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 100, color: AppColors.divider),
          const SizedBox(height: 16),
          const Text(
            'No hay procesos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Agrega tu primer proceso usando el botón +',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}