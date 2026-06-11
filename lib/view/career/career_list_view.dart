import 'package:flutter/material.dart';
import 'package:ubook_app/model/career/career_model.dart';
import 'package:ubook_app/repository/career/career_repository_provider.dart';
import 'package:ubook_app/theme/app_colors.dart';
import 'package:ubook_app/view_model/career/career_view_model.dart';
import 'package:ubook_app/widgets/career/career_card.dart';
import 'package:ubook_app/widgets/career/career_delete_dialog.dart';
import 'package:ubook_app/widgets/career/search_bar.dart';
import 'career_create_view.dart';
import 'career_detail_view.dart';
import 'career_edit_view.dart';

class CareerListView extends StatefulWidget {
  final String? educationalCenterId;

  const CareerListView({
    super.key,
    this.educationalCenterId,
  });

  @override
  State<CareerListView> createState() => _CareerListViewState();
}

class _CareerListViewState extends State<CareerListView> {
  final CareerViewModel vm =
      CareerViewModel(CareerRepositoryProvider.instance);

  @override
  void initState() {
    super.initState();
    vm.addListener(_onVmChanged);
  }

  void _onVmChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    vm.removeListener(_onVmChanged);
    vm.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await Future.wait([
      vm.loadCareers(),
      vm.loadModalities(),
    ]);
  }

  void _onAdd() {
    if (widget.educationalCenterId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Debes entrar desde un centro educativo para crear una carrera',
          ),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CareerCreateView(
          vm: vm,
          educationalCenterId: widget.educationalCenterId!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final careers = vm.getFilteredCareersByCenter(widget.educationalCenterId);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.onPrimary,
        foregroundColor: AppColors.textPrimary,
        title: const Text(
          'Carreras',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _refresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              sliver: SliverList.list(
                children: [
                  const Text(
                    'Gestión de Carreras',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Explora, busca y administra las carreras del centro',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _StatsCard(total: careers.length, onAdd: _onAdd),
                  const SizedBox(height: 16),
                  SearchBarWidget(onSearch: vm.setSearch),
                  const SizedBox(height: 12),
                  _SortBar(
                    current: vm.sortOrder,
                    onChanged: vm.setSortOrder,
                  ),
                  if (vm.modalitiesWarning != null) ...[
                    const SizedBox(height: 12),
                    _Banner(
                      icon: Icons.cloud_off_rounded,
                      color: Colors.orange,
                      message: vm.modalitiesWarning!,
                      onAction: vm.loadModalities,
                      actionLabel: 'Reintentar',
                    ),
                  ],
                  const SizedBox(height: 16),
                ],
              ),
            ),
            if (careers.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _EmptyState(
                  hasFilter: vm.careers.isNotEmpty,
                  onAdd: _onAdd,
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                sliver: SliverList.separated(
                  itemCount: careers.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) {
                    final career = careers[i];
                    return CareerCard(
                      career: career,
                      onView: () => _goToDetail(career),
                      onEdit: () => _goToEdit(career),
                      onDelete: () => _confirmDelete(career),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _goToDetail(Career career) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CareerDetailView(career: career)),
    );
  }

  void _goToEdit(Career career) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CareerEditView(career: career, vm: vm),
      ),
    );
  }

  void _confirmDelete(Career career) {
    showDialog(
      context: context,
      builder: (_) => CareerDeleteDialog(career: career, vm: vm),
    );
  }
}

// ── Widgets internos ──────────────────────────────────────────────────────

class _StatsCard extends StatelessWidget {
  final int total;
  final VoidCallback onAdd;

  const _StatsCard({required this.total, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.onPrimary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.school_rounded,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Carreras registradas',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$total en este centro',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: onAdd,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Añadir'),
          ),
        ],
      ),
    );
  }
}

class _SortBar extends StatelessWidget {
  final String current;
  final ValueChanged<String> onChanged;

  const _SortBar({required this.current, required this.onChanged});

  static const _options = [
    ('name', 'Nombre', Icons.sort_by_alpha_rounded),
    ('semesters', 'Semestres', Icons.calendar_month_rounded),
    ('credits', 'Créditos', Icons.workspace_premium_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const Text(
            'Ordenar por:',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 10),
          for (final opt in _options) ...[
            _SortChip(
              label: opt.$2,
              icon: opt.$3,
              selected: current == opt.$1,
              onTap: () => onChanged(opt.$1),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _SortChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.inputFill,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: selected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String message;
  final VoidCallback? onAction;
  final String? actionLabel;

  const _Banner({
    required this.icon,
    required this.color,
    required this.message,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        border: Border.all(color: color.withOpacity(0.35)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: color, fontSize: 12),
            ),
          ),
          if (onAction != null && actionLabel != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                foregroundColor: color,
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: const Size(0, 32),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(actionLabel!),
            ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool hasFilter;
  final VoidCallback onAdd;

  const _EmptyState({required this.hasFilter, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.menu_book_rounded,
              size: 44,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            hasFilter
                ? 'No hay coincidencias'
                : 'Aún no hay carreras',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            hasFilter
                ? 'Prueba con otro término o limpia la búsqueda.'
                : 'Crea la primera carrera para este centro educativo.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          if (!hasFilter) ...[
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onAdd,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Crear carrera'),
            ),
          ],
        ],
      ),
    );
  }
}
