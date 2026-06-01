import 'package:flutter/material.dart';
import '../../model/educational_center/educational_center_model.dart';
import '../../theme/app_colors.dart';

class EducationalCenterDetailScreen extends StatelessWidget {
  final EducationalCenter center;

  // Recibimos el centro seleccionado de la lista por el constructor
  const EducationalCenterDetailScreen({super.key, required this.center});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detalle del Centro',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ICONO Y NOMBRE
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF134E4A).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.school, color: Color(0xFF134E4A), size: 30),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      center.name, // 👈 DATO REAL
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 32, color: AppColors.divider),

              // DETALLE: DIRECCIÓN
              _buildDetailItem(
                icon: Icons.location_on,
                label: 'Dirección',
                value: center.address ?? 'No registrada', // 👈 DATO REAL (Maneja nulos)
              ),
              const SizedBox(height: 20),

              // DETALLE: TIPO (PÚBLICA / PRIVADA)
              _buildDetailItem(
                icon: Icons.business,
                label: 'Tipo de Institución',
                value: center.type ?? 'No especificado', // 👈 DATO REAL
              ),
              const SizedBox(height: 20),

              // DETALLE: SITIO WEB
              _buildDetailItem(
                icon: Icons.language,
                label: 'Sitio Web',
                value: center.website ?? 'No disponible', // 👈 DATO REAL
                isLink: center.website != null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget auxiliar para mantener el diseño limpio de tus compañeros
  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    bool isLink = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 22),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isLink ? const Color(0xFF134E4A) : AppColors.textPrimary,
                  decoration: isLink ? TextDecoration.underline : TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}