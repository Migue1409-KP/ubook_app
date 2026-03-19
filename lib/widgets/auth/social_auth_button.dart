import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:ubook_app/theme/app_colors.dart';

class SocialAuthButton extends StatelessWidget {
  final String label;
  final String assetImage;
  final VoidCallback onPressed;
  final Duration animationDuration;

  const SocialAuthButton({
    super.key,
    required this.label,
    required this.assetImage,
    required this.onPressed,
    this.animationDuration = const Duration(milliseconds: 1700),
  });

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: animationDuration,
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.inputFill,
            foregroundColor: AppColors.textPrimary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(assetImage, width: 20, height: 20),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
