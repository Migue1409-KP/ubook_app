import 'package:flutter/material.dart';
import 'package:ubook_app/view/subjects/subjects_modal_demo_page.dart';

/// Entry-point aislado para ejecutar únicamente esta funcionalidad sin tocar main.dart.
///
/// Ejemplo:
/// flutter run -t lib/view/subjects/subjects_modal_demo_entry.dart
void main() {
  runApp(const SubjectsModalDemoApp());
}

class SubjectsModalDemoApp extends StatelessWidget {
  const SubjectsModalDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SubjectsModalDemoPage(),
    );
  }
}
