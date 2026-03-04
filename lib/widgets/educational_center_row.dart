import 'package:flutter/material.dart';
import '../model/educational_center/educational_center_model.dart';

class EducationalCenterRow extends StatelessWidget {
  final EducationalCenter center;

  const EducationalCenterRow({super.key, required this.center});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(center.name, style: const TextStyle(fontSize: 16)),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.visibility),
              tooltip: 'Ver',
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.edit),
              tooltip: 'Editar',
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.delete),
              tooltip: 'Eliminar',
            ),
          ],
        ),
      ),
    );
  }
}
