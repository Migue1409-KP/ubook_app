import 'package:flutter/material.dart';
import '../../model/teachers/teacher.dart';
import '../../theme/app_colors.dart';
import '../../view_model/teachers/teacher_detail_view_model.dart';
import '../../widgets/teachers/teacher_info_card.dart';

class TeacherDetailView extends StatefulWidget {
  final Teacher teacher;

  const TeacherDetailView({super.key, required this.teacher});

  @override
  State<TeacherDetailView> createState() => _TeacherDetailViewState();
}

class _TeacherDetailViewState extends State<TeacherDetailView> {
  late final TeacherDetailViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = TeacherDetailViewModel(widget.teacher);
    _viewModel.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Profesor',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTeacherInfoCard(),
            const SizedBox(height: 24),
            _buildSubjectsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTeacherInfoCard() {
    return TeacherInfoCard(
      fullName: _viewModel.fullName,
      id: _viewModel.id,
      onEdit: _viewModel.onEdit,
    );
  }

  Widget _buildSubjectsSection() {
    final subjects = _viewModel.subjects;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Materias',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        if (subjects.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: const Center(
              child: Text(
                'No tiene materias asignadas',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                ),
              ),
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: subjects.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: AppColors.divider),
                itemBuilder: (context, index) {
                  final subject = subjects[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 4),
                    title: Text(
                      subject,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    trailing: TextButton(
                      onPressed: () => _viewModel.onViewSubject(subject),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                      ),
                      child: const Text('Ver'),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}
