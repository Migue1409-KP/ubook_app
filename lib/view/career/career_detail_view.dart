import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubook_app/widgets/career/navigation_card.dart';
import '../../model/career/career_model.dart';
import '../../theme/app_colors.dart';
import '../subjects/subjects_view.dart';
import '../process/process_list_view.dart';
import '../reviews/create_review_view.dart';
import '../../view_model/reviews/reviews_view_model.dart';


class CareerDetailView extends StatelessWidget {
  final Career career;

  const CareerDetailView({super.key, required this.career});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReviewsViewModel()
        ..loadReviews(
          entityId: career.id,
          entityType: "career",
        ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            career.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          centerTitle: true,
        ),
        body: const _CareerDetailContent(),
      ),
    );
  }
}

class _CareerDetailContent extends StatelessWidget {
  const _CareerDetailContent();

  @override
  Widget build(BuildContext context) {
    final career =
        (context.findAncestorWidgetOfExactType<CareerDetailView>()!).career;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔷 HEADER
          Text(
            career.name,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 12),

          Consumer<ReviewsViewModel>(
            builder: (context, vm, _) {
              if (vm.isLoading) {
                return const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                );
              }

              return Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 6),
                  Text(
                    vm.averageRating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "(${vm.reviews.length} reviews)",
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 30),


          NavigationCard(
            title: "Subjects",
            subtitle: "View subjects of this career",
            icon: Icons.menu_book,
            color: Colors.blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SubjectsView(),
                ),
              );

              /// ⚠️ PENDIENTE EQUIPO:
              /// Enviar careerId cuando lo soporten:
              /// SubjectsView(careerId: career.id)
            },
          ),

          const SizedBox(height: 16),

          /// 📄 PROCESSES
          NavigationCard(
            title: "Processes",
            subtitle: "Manage academic processes",
            icon: Icons.description,
            color: Colors.orange,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProcessListView(),
                ),
              );

              /// ⚠️ PENDIENTE EQUIPO:
              /// Filtrar por:
              /// process.relatedId == career.id
            },
          ),

          const SizedBox(height: 16),

          /// 💬 CREATE REVIEW
          NavigationCard(
            title: "Write Review",
            subtitle: "Share your experience",
            icon: Icons.rate_review,
            color: Colors.green,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CreateReviewView(
                    entityId: career.id,
                    entityType: "career",
                    userId: "1", // ⚠️ MOCK
                  ),
                ),
              );

              /// 🔥 REFRESH AUTOMÁTICO
              context.read<ReviewsViewModel>().refresh();
            },
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}