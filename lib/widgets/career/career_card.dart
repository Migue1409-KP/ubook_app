import 'package:flutter/material.dart';
import 'package:ubook_app/model/career/career_model.dart';
import 'package:ubook_app/theme/app_colors.dart';

/// Tarjeta de presentación de una carrera dentro del listado.
///
/// Sigue el mismo lenguaje visual que [NavigationCard]: fondo blanco,
/// esquinas redondeadas 16, sombra suave y un avatar con icono tintado
/// usando el color primario. Las acciones (ver / editar / eliminar) se
/// agrupan en un menú contextual para no saturar la tarjeta.
class CareerCard extends StatelessWidget {
  final Career career;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CareerCard({
    super.key,
    required this.career,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 0,
      child: InkWell(
        onTap: onView,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.divider),
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Avatar(),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          career.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ID ${career.id}',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _ActionMenu(
                    onView: onView,
                    onEdit: onEdit,
                    onDelete: onDelete,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _MetaChip(
                    icon: Icons.calendar_month_rounded,
                    label: '${career.semesters} semestres',
                  ),
                  _MetaChip(
                    icon: Icons.workspace_premium_outlined,
                    label: '${career.credits} créditos',
                  ),
                  if (career.modalityName != null)
                    _MetaChip(
                      icon: Icons.school_outlined,
                      label: career.modalityName!,
                      highlighted: true,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.menu_book_rounded,
        color: AppColors.primary,
        size: 24,
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool highlighted;

  const _MetaChip({
    required this.icon,
    required this.label,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = highlighted
        ? AppColors.primary.withOpacity(0.10)
        : AppColors.inputFill;
    final fg = highlighted ? AppColors.primary : AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionMenu extends StatelessWidget {
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ActionMenu({
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_CareerAction>(
      tooltip: 'Acciones',
      icon: const Icon(
        Icons.more_vert_rounded,
        color: AppColors.textSecondary,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (action) {
        switch (action) {
          case _CareerAction.view:
            onView();
            break;
          case _CareerAction.edit:
            onEdit();
            break;
          case _CareerAction.delete:
            onDelete();
            break;
        }
      },
      itemBuilder: (_) => const [
        PopupMenuItem(
          value: _CareerAction.view,
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.visibility_outlined, color: AppColors.primary),
            title: Text('Ver detalle'),
          ),
        ),
        PopupMenuItem(
          value: _CareerAction.edit,
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.edit_outlined, color: AppColors.processSubject),
            title: Text('Editar'),
          ),
        ),
        PopupMenuItem(
          value: _CareerAction.delete,
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.delete_outline, color: AppColors.processDanger),
            title: Text('Eliminar'),
          ),
        ),
      ],
    );
  }
}

enum _CareerAction { view, edit, delete }
