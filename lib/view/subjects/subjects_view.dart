import 'package:flutter/material.dart';
import '../../model/subjects/subjects.dart';
import '../../theme/app_colors.dart';
import '../../view_model/subjects/subjects_view_model.dart';
import 'subject_delete_dialog.dart';
import 'subject_detail_dialog.dart';
import 'subject_form_dialog.dart';

class SubjectsView extends StatefulWidget {
  const SubjectsView({super.key});

  @override
  State<SubjectsView> createState() => _SubjectsViewState();
}

class _SubjectsViewState extends State<SubjectsView> {
  final SubjectsViewModel _viewModel = SubjectsViewModel();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_refresh);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_refresh);
    _viewModel.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final subjects = _viewModel.filteredSubjects;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,
        title: const Text(
          'Materias',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSearchAndCreateRow(),
            const SizedBox(height: 16),
            Expanded(
              child: subjects.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      itemCount: subjects.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final subject = subjects[index];
                        return _SubjectRowCard(
                          subject: subject,
                          onView: () => _openDetail(subject),
                          onEdit: () => _openFormModal(subject: subject),
                          onDelete: () => _openDeleteModal(subject),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndCreateRow() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            onChanged: _viewModel.search,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Buscar...',
              hintStyle: const TextStyle(color: AppColors.placeholder),
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.textSecondary,
              ),
              filled: true,
              fillColor: AppColors.inputFill,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.divider),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.divider),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        FilledButton.icon(
          onPressed: _openFormModal,
          icon: const Icon(Icons.add),
          label: const Text('Crear'),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 14,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.menu_book_outlined,
            size: 64,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 16),
          Text(
            'No se encontraron materias',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openFormModal({Subject? subject}) async {
    await showDialog<void>(
      context: context,
      builder: (_) => SubjectFormDialog(
        subject: subject,
        onSave: ({
          required String nombre,
          required int horas,
          required int creditos,
          required String prerrequisitosText,
          required String contenido,
        }) {
          if (subject == null) {
            _viewModel.addSubject(
              nombre: nombre,
              horas: horas,
              creditos: creditos,
              prerrequisitosText: prerrequisitosText,
              contenido: contenido,
            );
          } else {
            _viewModel.updateSubject(
              id: subject.id,
              nombre: nombre,
              horas: horas,
              creditos: creditos,
              prerrequisitosText: prerrequisitosText,
              contenido: contenido,
            );
          }
        },
      ),
    );
  }

  Future<void> _openDetail(Subject subject) async {
  await showDialog<void>(
    context: context,
    builder: (_) => SubjectDetailDialog(
      subject: subject,
      onEdit: () => _openFormModal(subject: subject),
      onTeachersTap: () {},
      onReviewsTap: () {},
    ),
  );
}

  Future<void> _openDeleteModal(Subject subject) async {
    await showDialog<void>(
      context: context,
      builder: (_) => SubjectDeleteDialog(
        subjectName: subject.nombre,
        onConfirm: () => _viewModel.removeSubject(subject.id),
      ),
    );
  }
}

class _SubjectRowCard extends StatelessWidget {
  const _SubjectRowCard({
    required this.subject,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  final Subject subject;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final initials = subject.nombre.trim().isEmpty
        ? '?'
        : subject.nombre
            .trim()
            .split(' ')
            .take(2)
            .map((e) => e.isNotEmpty ? e[0] : '')
            .join()
            .toUpperCase();

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.divider),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.primary.withOpacity(0.10),
              child: Text(
                initials,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject.nombre,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${subject.horas} horas • ${subject.creditos} créditos',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onView,
              icon: const Icon(Icons.visibility_outlined),
              color: AppColors.primary,
              tooltip: 'Ver',
            ),
            IconButton(
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined),
              color: AppColors.processSubject,
              tooltip: 'Editar',
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
              color: AppColors.processDanger,
              tooltip: 'Eliminar',
            ),
          ],
        ),
      ),
    );
  }
}