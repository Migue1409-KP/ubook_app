import 'package:flutter/material.dart';
import 'package:ubook_app/model/career/career_model.dart';
import 'package:ubook_app/view_model/career_view_model.dart';
import 'package:ubook_app/widgets/career/app_button.dart';
import 'package:ubook_app/widgets/career/app_text_file.dart';

class CareerEditView extends StatelessWidget {

  final Career career;
  final CareerViewModel vm;

  CareerEditView({
    super.key,
    required this.career,
    required this.vm,
  });

  late final TextEditingController nameController =
      TextEditingController(text: career.name);

  late final TextEditingController semestersController =
      TextEditingController(text: career.semesters.toString());

  late final TextEditingController creditsController =
      TextEditingController(text: career.credits.toString());

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Edit Career"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            AppTextField(
              label: "Career Name",
              controller: nameController,
            ),

            const SizedBox(height: 16),

            AppTextField(
              label: "Semesters",
              controller: semestersController,
            ),

            const SizedBox(height: 16),

            AppTextField(
              label: "Credits",
              controller: creditsController,
            ),

            const SizedBox(height: 30),

            AppButton(

              text: "Update Career",

              onPressed: () {

                final updated = career.copyWith(
                  name: nameController.text,
                  semesters: int.parse(semestersController.text),
                  credits: int.parse(creditsController.text),
                );

                vm.updateCareer(updated);

                Navigator.pop(context);
              },
            )

          ],
        ),
      ),
    );
  }
}