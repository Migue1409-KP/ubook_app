import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/pqrs/pqrs.dart';
import '../../view_model/pqrs/pqrs_viewmodel.dart';
import '../../widgets/pqrs/pqrs_form_sheet.dart';

class PQRSPage extends StatelessWidget {
  const PQRSPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PQRSViewModel>();
    final items = viewModel.items;

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
              if (items.isEmpty)
                _buildEmptyState()
              else
                for (final entry in items.asMap().entries)
                  _buildPQRSCard(
                    context: context,
                    pqrs: entry.value,
                    index: entry.key,
                  ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openCreateModal(context),
        backgroundColor: Colors.blue.shade700,
        icon: const Icon(Icons.add),
        label: const Text('Nueva PQRS'),
      ),
    );
  }

  void _openCreateModal(BuildContext context) {
    final viewModel = context.read<PQRSViewModel>();
    showModalBottomSheet(
      context: context,
      useRootNavigator: false,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => ChangeNotifierProvider.value(
            value: viewModel,
            child: const PQRSFormSheet(),
          ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(20),
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
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.info_outline, color: Colors.blue),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              'Aun no tienes PQRS registradas.',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPQRSCard({
    required BuildContext context,
    required PQRS pqrs,
    required int index,
  }) {
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
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black45),
            onSelected: (value) =>
                context.read<PQRSViewModel>().updateEstado(index, value),
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'Abierta', child: Text('Abierta')),
              PopupMenuItem(value: 'En proceso', child: Text('En proceso')),
              PopupMenuItem(value: 'Cerrada', child: Text('Cerrada')),
            ],
          ),
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
