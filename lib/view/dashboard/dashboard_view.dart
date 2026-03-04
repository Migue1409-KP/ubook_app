import 'package:flutter/material.dart';
import '../../view_model/dashboard_view_model.dart';
import '../../widgets/dashboard_app_bar.dart';
import '../../widgets/top_items_carousel.dart';

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
      backgroundColor: Colors.grey[50],
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
                  // TODO: Navigate to all centers
                },
                items: _viewModel.topCenters,
                itemBuilder: (item) => _buildCard(
                  title: item['name'],
                  subtitle: item['location'],
                  rating: item['rating'],
                  icon: Icons.account_balance,
                  color: Colors.blue,
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
                ),
              ),
              const SizedBox(height: 28),

              // Top Profesores
              TopItemsCarousel(
                title: 'Top 5 Profesores',
                onSeeAll: () {
                  // TODO: Navigate to all teachers
                },
                items: _viewModel.topTeachers,
                itemBuilder: (item) => _buildCard(
                  title: item['name'],
                  subtitle: item['subject'],
                  rating: item['rating'],
                  icon: Icons.person,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String subtitle,
    required double rating,
    required IconData icon,
    required MaterialColor color,
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
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
              ),
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
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
