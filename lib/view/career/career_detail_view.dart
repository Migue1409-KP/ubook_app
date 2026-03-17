import 'package:flutter/material.dart';
import 'package:ubook_app/model/career/career_model.dart';
import 'package:ubook_app/theme/app_colors.dart';

class CareerDetailView extends StatelessWidget {

  final Career career;

  const CareerDetailView({
    super.key,
    required this.career,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text(career.name),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text(
              career.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Semesters: ${career.semesters}",
              style: const TextStyle(
                color: AppColors.textSecondary,
              ),
            ),

            Text(
              "Credits: ${career.credits}",
              style: const TextStyle(
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Subjects",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            Text("${career.subjects.length} subjects"),

            const SizedBox(height: 16),

            const Text(
              "Processes",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            Text("${career.processes.length} processes"),

            const SizedBox(height: 16),

            const Text(
              "Reviews",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            Text("${career.reviews.length} reviews"),
          ],
        ),
      ),
    );
  }
}