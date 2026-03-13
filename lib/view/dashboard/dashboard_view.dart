import 'package:flutter/material.dart';
import '../../view_model/dashboard_view_model.dart';
import '../../widgets/dashboard_app_bar.dart';
import '../../widgets/top_items_carousel.dart';
import '../process/process_list_view.dart';
import '../teachers/teacher_list_view.dart';
import '../teachers/teacher_detail_view.dart';
import '../../model/teachers/teacher.dart';
import '../educational_center/educational_center_screen.dart';
import '../../theme/app_colors.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final DashboardViewModel _viewModel = DashboardViewModel();

  @override
  void initState() {
    super.initState();
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
      appBar: DashboardAppBar(
        selectedFilter: _viewModel.selectedFilter,
        filterOptions: _viewModel.filterOptions,
        onFilterChanged: _viewModel.setFilter,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Centros Educativos
              TopItemsCarousel(
                title: 'Top 5 Centros Educativos',
                onSeeAll: () {
                  _navigateToEducationalCenters();
                },
                items: _viewModel.topCenters,
                itemBuilder: (item) => _buildCard(
                  title: item['name'],
                  subtitle: item['location'],
                  rating: item['rating'],
                  icon: Icons.account_balance,
                  color: Colors.blue,
                  onTap: _navigateToEducationalCenters,
                ),
              ),
              const SizedBox(height: 28),

              // Top Carreras
              TopItemsCarousel(
                title: 'Top 5 Carreras',
                onSeeAll: () {
                  // TODO: Navigate to all careers
                },
                items: _viewModel.topCareers,
                itemBuilder: (item) => _buildCard(
                  title: item['name'],
                  subtitle: item['faculty'],
                  rating: item['rating'],
                  icon: Icons.school,
                  color: Colors.orange,
                  onTap: () {}, // TODO: Navigate to career detail
                ),
              ),
              const SizedBox(height: 28),

              // Top Profesores
              TopItemsCarousel(
                title: 'Top 5 Profesores',
                onSeeAll: () {
                  _navigateToTeacherList();
                },
                items: _viewModel.topTeachers,
                itemBuilder: (item) => _buildCard(
                  title: item['name'],
                  subtitle: item['subject'],
                  rating: item['rating'],
                  icon: Icons.person,
                  color: Colors.green,
                  onTap: () => _navigateToTeacherDetail(item),
                ),
              ),
              const SizedBox(height: 28),

              // Gestión de Procesos
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Gestión de Procesos',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: _navigateToProcessList,
                      child: const Text('Ver todos', style: TextStyle(color: AppColors.primary)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: InkWell(
                  onTap: _navigateToProcessList,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary.withOpacity(0.8), AppColors.primary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.description,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Procesos Académicos',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Gestiona procesos de carreras y materias',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToProcessList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProcessListView(),
      ),
    );
  }

  void _navigateToTeacherList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TeacherListView(),
      ),
    );
  }

  void _navigateToEducationalCenters() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EducationalCenterScreen(),
      ),
    );
  }

  void _navigateToTeacherDetail(Map<String, dynamic> item) {
    final parts = (item['name'] as String? ?? 'Profesor').split(' ');
    final firstName = parts.isNotEmpty ? parts[0] : 'Desconocido';
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    final dummyTeacher = Teacher(
      id: 'DUMMY-TCH',
      firstName: firstName,
      lastName: lastName,
      email: 'profesor@uco.edu',
      phone: '000-000-0000',
      age: 40,
      department: 'General',
      specialty: item['subject'] as String? ?? 'Desconocida',
      subjects: [item['subject'] as String? ?? 'Materia 1'],
      profileImageUrl: 'https://via.placeholder.com/150',
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeacherDetailView(teacher: dummyTeacher),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String subtitle,
    required double rating,
    required IconData icon,
    required MaterialColor color,
    VoidCallback? onTap,
  }) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color.shade700, size: 26),
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: AppColors.textPrimary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text(
                  rating.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    ),
    );
  }
}
