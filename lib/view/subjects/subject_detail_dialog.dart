import 'package:flutter/material.dart';
import '../../model/subjects/subjects.dart';

class SubjectDetailDialog extends StatelessWidget {
  final Subject subject;

  const SubjectDetailDialog({
    super.key,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        subject.nombre,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Horas
            Text(
              "Horas: ${subject.horas}",
              style: const TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 4),

            // Créditos
            Text(
              "Créditos: ${subject.creditos}",
              style: const TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 12),

            // Prerrequisitos
            const Text(
              "Prerrequisitos:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),

            if (subject.prerrequisitos.isEmpty)
              const Text("No tiene prerrequisitos")
            else
              ...subject.prerrequisitos.map(
                (p) => Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text("• $p"),
                ),
              ),

            const SizedBox(height: 12),

            // Contenido
            const Text(
              "Contenido:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),

            Text(subject.contenido),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cerrar"),
        ),
      ],
    );
  }
}