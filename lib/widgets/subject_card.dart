import 'package:flutter/material.dart';
import '../model/subject/subject.dart';

class SubjectCard extends StatelessWidget {
  final Subject subject;
  final bool isAssigned;
  final bool isLoading;
  final VoidCallback? onToggle;

  const SubjectCard({
    super.key,
    required this.subject,
    required this.isAssigned,
    this.isLoading = false,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final color = isAssigned
        ? const Color(0xFF1E3A5F)
        : const Color(0xFF1E1E1E);

    final borderColor = isAssigned
        ? const Color(0xFF4A90D9)
        : const Color(0xFF333333);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: borderColor, width: 1.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: isAssigned
              ? const Color(0xFF4A90D9)
              : const Color(0xFF333333),
          child: Text(
            subject.code.substring(0, 2),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          subject.name,
          style: TextStyle(
            color: isAssigned ? Colors.white : Colors.white70,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '${subject.code}  •  ${subject.credits} créditos',
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
        foregroundColor: isAssigned ? Colors.redAccent : const Color(0xFF4A90D9),
        side: BorderSide(
          color: isAssigned ? Colors.redAccent : const Color(0xFF4A90D9),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        minimumSize: const Size(80, 32),
      ),
      child: Text(
        isAssigned ? 'Quitar' : 'Asignar',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}