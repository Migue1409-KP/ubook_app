import 'package:flutter/material.dart';
import 'package:ubook_app/theme/app_colors.dart';


class AppButton extends StatelessWidget {

  final String text;
  final VoidCallback onPressed;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: double.infinity,

      child: ElevatedButton(

        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),

        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}