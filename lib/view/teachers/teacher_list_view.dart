import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/teachers/teacher.dart';
import '../../theme/app_colors.dart';
import '../../view_model/teachers/teacher_list_view_model.dart';
import '../../view_model/teachers/teacher_count_provider.dart';
import '../../widgets/teachers/teacher_row_card.dart';
import '../../widgets/teachers/teacher_delete_dialog.dart';
import '../teacher_subject/teacher_subjects_page.dart';
import 'teacher_form_view.dart';

class TeacherListView extends StatefulWidget {
  const TeacherListView({super.key});

  @override
  State<TeacherListView> createState() => _TeacherListViewState();
}

class _TeacherListViewState extends State<TeacherListView> {
  final TeacherListViewModel _viewModel = TeacherListViewModel();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(() {
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TeacherCountProvider>().initialize(
            total: _viewModel.totalCount,
            active: _viewModel.activeCount,
          );
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToTeacherSubjects(Teacher teacher) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TeacherSubjectsPage(teacher: teacher),
      ),
    );
  }

  void _onDeleteTeacher(Teacher teacher) {
    TeacherDeleteDialog.show(
      context: context,
      teacherName: teacher.fullName,
      onConfirm: () {
        _viewModel.deleteTeacher(teacher.id);
        context.read<TeacherCountProvider>().removeTeacher(
              wasActive: teacher.isActive,
            );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        title: const Text(
          'Profesores',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchAndCreateRow(),
            const SizedBox(height: 16),
            Expanded(child: _buildTeacherList()),
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
              prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.inputFill,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
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
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        FilledButton.icon(
          onPressed: () async {
            final result = await Navigator.of(context).push<Teacher>(
              MaterialPageRoute(builder: (_) => const TeacherFormView()),
            );
            if (result != null) {
              _viewModel.addTeacher(result);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profesor creado exitosamente'),
                  ),
                );
              }
            }
          },
          icon: const Icon(Icons.add),
          label: const Text('Crear'),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTeacherList() {
    final teachers = _viewModel.filteredTeachers;

    if (teachers.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.person_off_outlined,
                size: 64, color: AppColors.textSecondary),
            SizedBox(height: 16),
            Text(
              'No se encontraron profesores',
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: teachers.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final teacher = teachers[index];
        return TeacherRowCard(
          teacher: teacher,
          onView: () => _navigateToTeacherSubjects(teacher),
          onEdit: () async {
            final result = await Navigator.of(context).push<Teacher>(
              MaterialPageRoute(
                builder: (_) => TeacherFormView(teacher: teacher),
              ),
            );
            if (result != null) {
              _viewModel.updateTeacher(result);
            }
          },
          onDelete: () => _onDeleteTeacher(teacher),
        );
      },
    );
  }
}
