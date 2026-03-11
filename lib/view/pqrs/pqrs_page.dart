import 'package:flutter/material.dart';
import '../../model/pqrs/pqrs.dart';

class PQRSPage extends StatelessWidget {
  const PQRSPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<PQRS> mockPQRS = [
      PQRS(
        tipo: 'Peticion',
        descripcion: 'Solicitud de informacion',
        fecha: DateTime.now(),
        estado: 'Abierta',
      ),
      PQRS(
        tipo: 'Queja',
        descripcion: 'Problema con el servicio',
        fecha: DateTime.now(),
        estado: 'En proceso',
      ),
      PQRS(
        tipo: 'Reclamo',
        descripcion: 'Cobro incorrecto',
        fecha: DateTime.now(),
        estado: 'Cerrada',
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'PQRS',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 90),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tus solicitudes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Revisa el estado y el historial de tus PQRS.',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              const SizedBox(height: 20),
              for (final pqrs in mockPQRS) _buildPQRSCard(pqrs),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: Colors.blue.shade700,
        icon: const Icon(Icons.add),
        label: const Text('Nueva PQRS'),
      ),
    );
  }

  Widget _buildPQRSCard(PQRS pqrs) {
    final typeColor = _typeColor(pqrs.tipo);
    final statusColor = _statusColor(pqrs.estado);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: typeColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_typeIcon(pqrs.tipo), color: typeColor, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pqrs.tipo,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  pqrs.descripcion,
                  style: TextStyle(color: Colors.grey[700], fontSize: 13),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _buildStatusChip(pqrs.estado, statusColor),
                    const SizedBox(width: 10),
                    Text(
                      _formatDate(pqrs.fecha),
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: Colors.black45),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Color _typeColor(String tipo) {
    switch (tipo) {
      case 'Peticion':
        return Colors.blue.shade700;
      case 'Queja':
        return Colors.orange.shade700;
      case 'Reclamo':
        return Colors.red.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  IconData _typeIcon(String tipo) {
    switch (tipo) {
      case 'Peticion':
        return Icons.assignment_outlined;
      case 'Queja':
        return Icons.report_outlined;
      case 'Reclamo':
        return Icons.receipt_long_outlined;
      default:
        return Icons.description_outlined;
    }
  }

  Color _statusColor(String estado) {
    switch (estado) {
      case 'Abierta':
        return Colors.blue.shade700;
      case 'En proceso':
        return Colors.orange.shade700;
      case 'Cerrada':
        return Colors.green.shade700;
      default:
        return Colors.grey.shade600;
    }
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }
}
