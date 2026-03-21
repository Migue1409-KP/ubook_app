import 'package:flutter/material.dart';
import 'package:ubook_app/model/career/career_model.dart';
import 'package:ubook_app/view_model/career/career_view_model.dart';
import 'package:ubook_app/widgets/career/app_button.dart';
import 'package:ubook_app/widgets/career/app_text_file.dart';

class CareerCreateView extends StatelessWidget {

  final CareerViewModel vm;

  CareerCreateView({super.key, required this.vm});

  final nameController = TextEditingController();
  final semestersController = TextEditingController();
  final creditsController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Create Career"),
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
              text: "Save Career",

              onPressed: () {

                final career = Career(
                  id: DateTime.now().toString(),
                  educationalCenterId: "2",
                  name: nameController.text,
                  semesters: int.parse(semestersController.text),
                  credits: int.parse(creditsController.text),
                );

                vm.addCareer(career);

                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}