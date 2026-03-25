import 'package:flutter/material.dart';
import 'package:ubook_app/model/subjects/subjects.dart';

class SubjectDetailModal extends StatelessWidget {
  const SubjectDetailModal({
    super.key,
    required this.subject,
    required this.onEditNombre,
    required this.onEditHoras,
  });

  final Subject subject;
  final VoidCallback onEditNombre;
  final VoidCallback onEditHoras;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 560,
        padding: const EdgeInsets.all(24),
        color: const Color(0xFFF3F3F3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DetailRow(
              label: 'Nombre',
              value: subject.nombre,
              onEdit: () {
                Navigator.of(context).pop();
                onEditNombre();
              },
            ),
            const SizedBox(height: 18),
            _DetailRow(
              label: 'Horas',
              value: subject.horas.toString(),
              onEdit: () {
                Navigator.of(context).pop();
                onEditHoras();
              },
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: _buttonStyle(),
                    child: const Text('Profesores'),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: _buttonStyle(),
                    child: const Text('Reseñas'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return OutlinedButton.styleFrom(
      foregroundColor: Colors.black,
      side: const BorderSide(color: Colors.black87),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(vertical: 18),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    required this.onEdit,
  });

  final String label;
  final String value;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF8BC34A),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        TextButton(
          onPressed: onEdit,
          child: const Text(
            'Editar',
            style: TextStyle(
              color: Color(0xFF8BC34A),
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
