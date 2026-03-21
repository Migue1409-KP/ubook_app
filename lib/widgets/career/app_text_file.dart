import 'package:flutter/material.dart';
import 'package:ubook_app/theme/app_colors.dart';

class AppTextField extends StatelessWidget {

  final String label;
  final TextEditingController controller;

  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {

    return TextField(

      controller: controller,

      decoration: InputDecoration(

        labelText: label,

        filled: true,
        fillColor: AppColors.inputFill,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}