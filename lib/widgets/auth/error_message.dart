import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String message;
  final EdgeInsets padding;

  const ErrorMessage({
    super.key,
    required this.message,
    this.padding = const EdgeInsets.symmetric(horizontal: 0),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        message,
        style: const TextStyle(color: Colors.red, fontSize: 14),
        textAlign: TextAlign.center,
      ),
    );
  }
}
