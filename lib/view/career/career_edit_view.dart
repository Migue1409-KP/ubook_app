import 'package:flutter/material.dart';
import 'package:ubook_app/model/career/career_model.dart';
import 'package:ubook_app/view_model/career/career_view_model.dart';
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
        title: const Text("Editar Carrera"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            AppTextField(
              label: "Nombre de la carrera",
              controller: nameController,
            ),

            const SizedBox(height: 16),

            AppTextField(
              label: "Semestres",
              controller: semestersController,
            ),

            const SizedBox(height: 16),

            AppTextField(
              label: "Creditos",
              controller: creditsController,
            ),

            const SizedBox(height: 30),

            AppButton(

              text: "Guardar carrera",

              onPressed: () {
                final name = nameController.text.trim();
                final semesters = int.tryParse(semestersController.text);
                final credits = int.tryParse(creditsController.text);

                if (name.isEmpty || semesters == null || credits == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Por favor ingrese los campos correctamente"),
                    ),
                  );
                  return;
                }

                final updated = career.copyWith(
                  name: name,
                  semesters: semesters,
                  credits: credits,
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