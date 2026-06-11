import 'package:flutter/material.dart';
import '../model/subjects/subjects.dart';

class SubjectCard extends StatelessWidget {
  final Subject subject;
  final bool isAssigned;
  final bool isLoading;
  final VoidCallback? onToggle;
  final VoidCallback? onAdjuntos; // opcional — solo en materias asignadas

  const SubjectCard({
    super.key,
    required this.subject,
    required this.isAssigned,
    this.isLoading = false,
    this.onToggle,
    this.onAdjuntos,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isAssigned ? const Color(0xFF1E3A5F) : const Color(0xFF1E1E1E),
        border: Border.all(
          color: isAssigned ? const Color(0xFF4A90D9) : const Color(0xFF333333),
          width: 1.2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            leading: CircleAvatar(
              backgroundColor: isAssigned
                  ? const Color(0xFF4A90D9)
                  : const Color(0xFF333333),
              child: Text(
                subject.nombre.substring(0, 2).toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              subject.nombre,
              style: TextStyle(
                color: isAssigned ? Colors.white : Colors.white70,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              '${subject.creditos} créditos  •  ${subject.horas} h',
              style: TextStyle(
                color: isAssigned
                    ? const Color(0xFF90CAF9)
                    : Colors.white38,
                fontSize: 12,
              ),
            ),
            trailing: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : _ToggleButton(isAssigned: isAssigned, onPressed: onToggle),
          ),
          // Botón adjuntos — solo visible cuando está asignada
          if (isAssigned && onAdjuntos != null)
            Padding(
              padding:
                  const EdgeInsets.only(left: 16, right: 16, bottom: 10),
              child: OutlinedButton.icon(
                onPressed: isLoading ? null : onAdjuntos,
                icon: const Icon(Icons.attach_file_rounded, size: 15),
                label: const Text('Adjuntos',
                    style: TextStyle(fontSize: 12)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF90CAF9),
                  side: const BorderSide(color: Color(0xFF4A90D9)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final bool isAssigned;
  final VoidCallback? onPressed;

  const _ToggleButton({required this.isAssigned, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor:
            isAssigned ? Colors.redAccent : const Color(0xFF4A90D9),
        side: BorderSide(
          color: isAssigned ? Colors.redAccent : const Color(0xFF4A90D9),
        ),
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6)),
        minimumSize: const Size(80, 32),
      ),
      child: Text(
        isAssigned ? 'Quitar' : 'Asignar',
        style: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}