import 'package:flutter/material.dart';
import '../../model/career/career_model.dart';
import '../process/process_list_view.dart';
import '../subjects/subjects_view.dart';
import 'package:ubook_app/widgets/career/navigation_card.dart';

// ⚠️ IMPORTANTE: Importar cuando el compañero tenga lista la vista de reviews
// import '../reviews/review_list_view.dart';

class CareerDetailView extends StatelessWidget {
  final Career career;

  const CareerDetailView({super.key, required this.career});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(career.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔷 HEADER
            Text(
              career.name,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: const [
                Icon(Icons.star, color: Colors.amber),
                SizedBox(width: 5),
                Text("4.5"), // 🔥 MOCK TEMPORAL
              ],
            ),

            const SizedBox(height: 30),

            /// 📚 SUBJECTS
            NavigationCard(
              title: "Subjects",
              subtitle: "View all subjects of this career",
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
                /// Aquí se debería enviar careerId cuando el view lo soporte
                /// Ej: SubjectsView(careerId: career.id)
              },
            ),

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
                /// Filtrar procesos por careerId usando:
                /// process.relatedId == career.id
              },
            ),

            /// 💬 REVIEWS
            NavigationCard(
              title: "Reviews",
              subtitle: "See student opinions",
              icon: Icons.rate_review,
              color: Colors.green,
              onTap: () {

                /// ⚠️ PENDIENTE:
                /// Falta vista de reviews del equipo
                /// Cuando exista:
                ///
                /// Navigator.push(
                ///   context,
                ///   MaterialPageRoute(
                ///     builder: (_) => ReviewListView(careerId: career.id),
                ///   ),
                /// );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Reviews module not ready yet"),
                  ),
                );
              },
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}