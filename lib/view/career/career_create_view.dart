import 'package:flutter/material.dart';
import 'package:ubook_app/model/career/career_model.dart';
import 'package:ubook_app/view_model/career/career_view_model.dart';
import 'package:ubook_app/widgets/career/app_button.dart';
import 'package:ubook_app/widgets/career/app_text_file.dart';

class CareerCreateView extends StatelessWidget {
  final CareerViewModel vm;
  final String educationalCenterId; 

  CareerCreateView({
    super.key,
    required this.vm,
    required this.educationalCenterId,
  });

  final nameController = TextEditingController();
  final semestersController = TextEditingController();
  final creditsController = TextEditingController();

  void _save(BuildContext context) {
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

    final career = Career(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      educationalCenterId: educationalCenterId, 
      semesters: semesters,
      credits: credits,
      subjects: [],  
      processes: [],
      reviews: [],
    );

    vm.addCareer(career);

    Navigator.pop(context);
  }

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
              label: "Nombre De La Carrera",
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
              text: "Guardar Carrera",
              onPressed: () => _save(context),
            ),
          ],
        ),
      ),
    );
  }
}