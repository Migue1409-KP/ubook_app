import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Botón de acción estándar Edit con estilo azul
class EditActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final bool isFullWidth;

  const EditActionButton({
    super.key,
    required this.onPressed,
    this.label = 'Editar',
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final button = OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.edit_outlined),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    return isFullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}

/// Botón de acción estándar Delete con estilo rojo
class DeleteActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final bool isFullWidth;

  const DeleteActionButton({
    super.key,
    required this.onPressed,
    this.label = 'Eliminar',
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final button = OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.delete_outline),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.red,
        side: const BorderSide(color: Colors.red),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    return isFullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}

/// Botón de acción estándar Create con estilo verde
class CreateActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final bool isFullWidth;
  final IconData icon;

  const CreateActionButton({
    super.key,
    required this.onPressed,
    this.label = 'Crear',
    this.isFullWidth = false,
    this.icon = Icons.add,
  });

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    return isFullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}

/// Barra de botones de acción estándar con estilos consistentes
class ActionButtonsBar extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onCreate;
  final String? editLabel;
  final String? deleteLabel;
  final String? createLabel;

  const ActionButtonsBar({
    super.key,
    this.onEdit,
    this.onDelete,
    this.onCreate,
    this.editLabel,
    this.deleteLabel,
    this.createLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (onEdit != null || onDelete != null)
          Row(
            children: [
              if (onEdit != null)
                Expanded(
                  child: EditActionButton(
                    onPressed: onEdit!,
                    label: editLabel ?? 'Editar',
                  ),
                ),
              if (onEdit != null && onDelete != null) const SizedBox(width: 12),
              if (onDelete != null)
                Expanded(
                  child: DeleteActionButton(
                    onPressed: onDelete!,
                    label: deleteLabel ?? 'Eliminar',
                  ),
                ),
            ],
          ),
        if (onCreate != null && (onEdit != null || onDelete != null))
          const SizedBox(height: 12),
        if (onCreate != null)
          CreateActionButton(
            onPressed: onCreate!,
            label: createLabel ?? 'Crear',
            isFullWidth: true,
          ),
      ],
    );
  }
}
