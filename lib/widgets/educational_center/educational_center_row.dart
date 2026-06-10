import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/educational_center/educational_center_model.dart';
import '../../theme/app_colors.dart';
import '../../view_model/educational_center/educational_center_view_model.dart';
import '../../view_model/educational_center/educational_center_count_provider.dart';
import 'educational_center_form.dart';

class EducationalCenterRow extends StatelessWidget {
  final EducationalCenter center;
  final VoidCallback onView;

  const EducationalCenterRow({
    super.key,
    required this.center,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    // Leemos de forma segura los providers creados por la pantalla padre
    final viewModel = Provider.of<EducationalCenterViewModel>(context, listen: false);
    final countProvider = Provider.of<EducationalCenterCountProvider>(context, listen: false);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      color: AppColors.onPrimary,
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                center.name,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            IconButton(
              onPressed: onView,
              icon: const Icon(Icons.visibility, color: AppColors.primary),
              tooltip: 'Ver',
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) {
                    return MultiProvider(
                      providers: [
                        ChangeNotifierProvider<EducationalCenterViewModel>.value(value: viewModel),
                        ChangeNotifierProvider<EducationalCenterCountProvider>.value(value: countProvider),
                      ],
                      child: EducationalCenterForm(
                        isEditing: true,
                        center: center,
                      ),
                    );
                  },
                );
              },
              icon: const Icon(Icons.edit, color: AppColors.processSubject),
              tooltip: 'Editar',
            ),
            IconButton(
              onPressed: () async {
                await viewModel.removeCenter(center.id, countProvider);
              },
              icon: const Icon(Icons.delete, color: AppColors.processDanger),
              tooltip: 'Eliminar',
            ),
          ],
        ),
      ),
    );
  }
}