import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubook_app/view_model/sql_demo/sql_demo_view_model.dart';

/// Demo de Firebase Data Connect (SQL Connect) — Procesos Académicos.
///
/// Accesible via ruta: /sql_demo
/// Conecta a Cloud SQL PostgreSQL a través del servicio ubook-sql-service.
class SqlDemoView extends StatefulWidget {
  const SqlDemoView({super.key});

  @override
  State<SqlDemoView> createState() => _SqlDemoViewState();
}

class _SqlDemoViewState extends State<SqlDemoView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SqlDemoViewModel>().loadProcesses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SqlDemoViewModel(),
      child: const _SqlDemoBody(),
    );
  }
}

class _SqlDemoBody extends StatefulWidget {
  const _SqlDemoBody();

  @override
  State<_SqlDemoBody> createState() => _SqlDemoBodyState();
}

class _SqlDemoBodyState extends State<_SqlDemoBody> {
  static const _primaryColor = Color(0xFF1A73E8);
  static const _sqlColor = Color(0xFF0D47A1);
  static const _successColor = Color(0xFF1B8A4A);
  static const _bgColor = Color(0xFF0F1923);
  static const _surfaceColor = Color(0xFF1A2535);
  static const _cardColor = Color(0xFF1E2D3D);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SqlDemoViewModel>().loadProcesses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: _buildAppBar(),
      body: Consumer<SqlDemoViewModel>(
        builder: (context, vm, _) {
          return Column(
            children: [
              _buildConnectionBanner(vm),
              _buildLastOperationBar(vm),
              Expanded(
                child: vm.isLoading && vm.processes.isEmpty
                    ? _buildLoadingState()
                    : vm.isEmpty
                        ? _buildEmptyState(vm)
                        : _buildProcessList(vm),
              ),
            ],
          );
        },
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: _surfaceColor,
      foregroundColor: Colors.white,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SQL Connect Demo',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Consumer<SqlDemoViewModel>(
            builder: (_, vm, __) => Text(
              vm.currentProjectInfo,
              style: TextStyle(
                fontSize: 10,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ),
        ],
      ),
      actions: [
        Consumer<SqlDemoViewModel>(
          builder: (_, vm, __) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton.icon(
                onPressed: vm.isLoading ? null : () => vm.seedExampleProcesses(),
                icon: const Icon(Icons.playlist_add, color: Colors.greenAccent, size: 16),
                label: const Text(
                  'Cargar Ejemplos',
                  style: TextStyle(color: Colors.greenAccent, fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Sincronizar con Cloud SQL',
                onPressed: vm.isLoading ? null : () => vm.loadProcesses(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConnectionBanner(SqlDemoViewModel vm) {
    final connected = vm.isConnected;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: connected
            ? _successColor.withOpacity(0.15)
            : Colors.orange.withOpacity(0.15),
        border: Border(
          bottom: BorderSide(
            color: connected ? _successColor : Colors.orange,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Cloud SQL badge
          _buildBadge(
            icon: Icons.storage,
            label: 'Cloud SQL PostgreSQL',
            sublabel: 'ubooksql · us-central1',
            color: _sqlColor,
            isActive: connected,
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward, size: 14, color: Colors.white38),
          const SizedBox(width: 8),
          // Data Connect badge
          _buildBadge(
            icon: Icons.cloud_outlined,
            label: 'Data Connect',
            sublabel: 'ubook-sql-service',
            color: _primaryColor,
            isActive: connected,
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: connected
                  ? _successColor.withOpacity(0.2)
                  : Colors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: connected ? _successColor : Colors.orange,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: connected ? _successColor : Colors.orange,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  connected ? 'Conectado' : 'Conectando...',
                  style: TextStyle(
                    fontSize: 11,
                    color: connected ? _successColor : Colors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge({
    required IconData icon,
    required String label,
    required String sublabel,
    required Color color,
    required bool isActive,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 14, color: color),
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              sublabel,
              style: TextStyle(
                fontSize: 9,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLastOperationBar(SqlDemoViewModel vm) {
    if (vm.lastOperation.isEmpty) return const SizedBox.shrink();
    final isError = vm.error != null;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      color: _surfaceColor,
      child: Row(
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.terminal,
            size: 13,
            color: isError ? Colors.redAccent : Colors.greenAccent,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isError ? (vm.error ?? '') : vm.lastOperation,
              style: TextStyle(
                fontSize: 11,
                fontFamily: 'monospace',
                color: isError
                    ? Colors.redAccent
                    : Colors.greenAccent.withOpacity(0.9),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (vm.isLoading)
            const SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white38,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: _primaryColor),
          const SizedBox(height: 16),
          Text(
            'Conectando con Cloud SQL...',
            style: TextStyle(color: Colors.white.withOpacity(0.6)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(SqlDemoViewModel vm) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _surfaceColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.table_chart_outlined,
              size: 48,
              color: _primaryColor.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Tabla DemoProcess vacía',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Cloud SQL PostgreSQL conectado.\nAgrega el primer proceso con el botón +',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white12),
            ),
            child: const Text(
              'SELECT * FROM "DemoProcess" → 0 rows',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: Colors.greenAccent,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B8A4A),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: vm.isLoading ? null : () => vm.seedExampleProcesses(),
            icon: const Icon(Icons.playlist_add),
            label: const Text('Sembrar Procesos de Ejemplo'),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessList(SqlDemoViewModel vm) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: vm.processes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final process = vm.processes[index];
        return _ProcessCard(
          process: process,
          onDelete: () => vm.deleteProcess(process.id),
          onToggle: () => vm.toggleActive(process.id, process.isActive),
        );
      },
    );
  }

  Widget _buildFAB() {
    return Consumer<SqlDemoViewModel>(
      builder: (_, vm, __) => FloatingActionButton.extended(
        onPressed: vm.isLoading ? null : () => _showCreateDialog(vm),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Agregar Proceso'),
      ),
    );
  }

  void _showCreateDialog(SqlDemoViewModel vm) {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String selectedType = 'career';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: _cardColor,
          title: const Text(
            'Nuevo Proceso',
            style: TextStyle(color: Colors.white),
          ),
          content: SizedBox(
            width: 340,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _bgColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'INSERT INTO "DemoProcess"\n(name, description, processType)\nVALUES (?, ?, ?)',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: Colors.greenAccent,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Nombre del proceso'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Descripción'),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  dropdownColor: _cardColor,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Tipo de proceso'),
                  items: const [
                    DropdownMenuItem(value: 'career', child: Text('Carrera')),
                    DropdownMenuItem(
                        value: 'subject', child: Text('Materia')),
                    DropdownMenuItem(
                        value: 'educationalCenter',
                        child: Text('Centro educativo')),
                  ],
                  onChanged: (v) => setDialogState(
                      () => selectedType = v ?? selectedType),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Cancelar',
                style: TextStyle(color: Colors.white.withOpacity(0.5)),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white),
              onPressed: () {
                if (nameCtrl.text.trim().isEmpty) return;
                Navigator.pop(ctx);
                vm.createProcess(
                  name: nameCtrl.text.trim(),
                  description: descCtrl.text.trim().isEmpty
                      ? 'Proceso académico demo'
                      : descCtrl.text.trim(),
                  processType: selectedType,
                );
              },
              child: const Text('Crear en Cloud SQL'),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white24),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: _primaryColor),
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      fillColor: _bgColor,
    );
  }
}

class _ProcessCard extends StatelessWidget {
  const _ProcessCard({
    required this.process,
    required this.onDelete,
    required this.onToggle,
  });

  final DemoProcessItem process;
  final VoidCallback onDelete;
  final VoidCallback onToggle;

  static const _cardColor = Color(0xFF1E2D3D);
  static const _primaryColor = Color(0xFF1A73E8);

  @override
  Widget build(BuildContext context) {
    final typeColors = {
      'career': const Color(0xFF7C4DFF),
      'subject': const Color(0xFF00BCD4),
      'educationalCenter': const Color(0xFFFF6D00),
    };
    final typeColor = typeColors[process.processType] ?? _primaryColor;

    return Container(
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: process.isActive ? Colors.white12 : Colors.white.withOpacity(0.05),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: typeColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                process.processType == 'career'
                    ? Icons.school
                    : process.processType == 'subject'
                        ? Icons.book
                        : Icons.apartment,
                color: typeColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    process.name,
                    style: TextStyle(
                      color: process.isActive
                          ? Colors.white
                          : Colors.white.withOpacity(0.4),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _chip(process.processTypeLabel, typeColor),
                      const SizedBox(width: 6),
                      _chip(
                        process.isActive ? 'activo' : 'inactivo',
                        process.isActive ? Colors.green : Colors.grey,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'id: ${process.id.substring(0, process.id.length.clamp(0, 12))}...',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 10,
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: Icon(
                    process.isActive
                        ? Icons.toggle_on
                        : Icons.toggle_off,
                    color: process.isActive ? Colors.green : Colors.white38,
                    size: 28,
                  ),
                  tooltip: process.isActive ? 'Desactivar' : 'Activar',
                  onPressed: onToggle,
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                  tooltip: 'Eliminar',
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
