import 'package:flutter/material.dart';
import 'package:ubook_app/model/career/career_model.dart';
import 'package:ubook_app/view_model/career_view_model.dart';

class CareerDeleteDialog extends StatelessWidget {

  final Career career;
  final CareerViewModel vm;

  const CareerDeleteDialog({
    super.key,
    required this.career,
    required this.vm,
  });

  @override
  Widget build(BuildContext context) {

    return AlertDialog(

      title: const Text("Are you sure?"),

      content: Text("Delete ${career.name}?"),

      actions: [

        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),

        ElevatedButton(
          onPressed: () {

            vm.deleteCareer(career.id);

            Navigator.pop(context);
          },
          child: const Text("Delete"),
        )
      ],
    );
  }
}