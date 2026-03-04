import 'package:flutter/material.dart';
import '../../model/teachers/teacher.dart';
import '../../model/subject/subject.dart';
import '../../view_model/teacher_subjects_view_model.dart';
import '../../widgets/subject_card.dart';
import '../../widgets/teacher_header_card.dart';

class TeacherSubjectsPage extends StatefulWidget {
  final Teacher teacher;
  const TeacherSubjectsPage({super.key, required this.teacher});

  @override
  State<TeacherSubjectsPage> createState() => _TeacherSubjectsPageState();
}

class _TeacherSubjectsPageState extends State<TeacherSubjectsPage>
    with SingleTickerProviderStateMixin {
  late final TeacherSubjectsViewModel _vm;
  late final TabController _tabController;
  final TextEditingController _searchCtrl = TextEditingController();
  String? _busySubjectId; // id de la card con spinner activo

  @override
  void initState() {
    super.initState();
    _vm = TeacherSubjectsViewModel(teacher: widget.teacher);
    _tabController = TabController(length: 2, vsync: this);
    _vm.addListener(_onVmChange);
  }

  void _onVmChange() => setState(() {});

  @override
  void dispose() {
    _vm.removeListener(_onVmChange);
    _vm.dispose();
    _tabController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  // ── UI principal ──────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        foregroundColor: Colors.white,
        title: const Text('Materias del Profesor',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Recargar',
            onPressed: _vm.isInitialLoading ? null : _vm.refresh,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF4A90D9),
          labelColor: const Color(0xFF4A90D9),
          unselectedLabelColor: Colors.white54,
          tabs: [
            Tab(
              icon: const Icon(Icons.book),
              text: 'Asignadas (${_vm.assignedSubjects.length})',
            ),
            Tab(
              icon: const Icon(Icons.add_box_outlined),
              text: 'Disponibles (${_vm.availableSubjects.length})',
            ),
          ],
        ),
      ),
      body: _vm.isInitialLoading
          ? _buildSkeleton()
          : _vm.errorMessage != null && _vm.assignedSubjects.isEmpty
              ? _buildError()
              : Column(
                  children: [
                    TeacherHeaderCard(
                      teacher: widget.teacher,
                      assignedCount: _vm.assignedSubjects.length,
                      totalCredits: _vm.totalCredits,
                    ),
                    _buildSearchBar(),
                    const SizedBox(height: 4),
                    // banner de error no-fatal (ej: fallo en assign/remove)
                    if (_vm.errorMessage != null) _buildErrorBanner(),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildList(_vm.filteredAssigned(), assigned: true),
                          _buildList(_vm.filteredAvailable(), assigned: false),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }

  // ── Buscador ──────────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: TextField(
        controller: _searchCtrl,
        style: const TextStyle(color: Colors.white),
        onChanged: _vm.setSearch,
        decoration: InputDecoration(
          hintText: 'Buscar por nombre o código...',
          hintStyle: const TextStyle(color: Colors.white38),
          prefixIcon: const Icon(Icons.search, color: Colors.white38),
          filled: true,
          fillColor: const Color(0xFF1E1E1E),
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          border: _inputBorder(const Color(0xFF333333)),
          enabledBorder: _inputBorder(const Color(0xFF333333)),
          focusedBorder: _inputBorder(const Color(0xFF4A90D9)),
          suffixIcon: _vm.searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.white38),
                  onPressed: () {
                    _searchCtrl.clear();
                    _vm.setSearch('');
                  },
                )
              : null,
        ),
      ),
    );
  }

  OutlineInputBorder _inputBorder(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: color),
      );

  // ── Lista genérica ────────────────────────────────────────────────────────
  Widget _buildList(List<Subject> subjects, {required bool assigned}) {
    if (subjects.isEmpty) {
      return _EmptyState(
        icon: assigned ? Icons.book_outlined : Icons.check_circle_outline,
        message: _vm.searchQuery.isEmpty
            ? assigned
                ? 'Este profesor no tiene materias asignadas.'
                : 'Todas las materias ya están asignadas.'
            : 'No hay resultados para "${_vm.searchQuery}".',
        actionLabel: assigned ? 'Ver disponibles' : null,
        onAction: assigned ? () => _tabController.animateTo(1) : null,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: subjects.length,
      itemBuilder: (_, i) {
        final s = subjects[i];
        return SubjectCard(
          subject: s,
          isAssigned: assigned,
          isLoading: _busySubjectId == s.id,
          // bloquea todos los botones mientras alguno está ocupado
          onToggle: _busySubjectId != null
              ? null
              : assigned
                  ? () => _handleRemove(s)
                  : () => _handleAssign(s),
        );
      },
    );
  }

  // ── Acciones ──────────────────────────────────────────────────────────────
  Future<void> _handleAssign(Subject subject) async {
    setState(() => _busySubjectId = subject.id);
    final ok = await _vm.assignSubject(subject);
    setState(() => _busySubjectId = null);
    if (!mounted) return;
    if (ok) {
      _snack('✅  ${subject.name} asignada correctamente');
      _tabController.animateTo(0);
    } else {
      _snack('❌  ${_vm.errorMessage}', isError: true);
    }
  }

  Future<void> _handleRemove(Subject subject) async {
    final confirmed = await _confirmDialog(subject.name);
    if (!confirmed || !mounted) return;
    setState(() => _busySubjectId = subject.id);
    final ok = await _vm.removeSubject(subject);
    setState(() => _busySubjectId = null);
    if (!mounted) return;
    if (ok) {
      _snack('🗑  ${subject.name} quitada del profesor');
    } else {
      _snack('❌  ${_vm.errorMessage}', isError: true);
    }
  }

  // ── Diálogos / snackbars ──────────────────────────────────────────────────
  Future<bool> _confirmDialog(String name) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: const Text('Confirmar', style: TextStyle(color: Colors.white)),
            content: Text('¿Quitar "$name" de este profesor?',
                style: const TextStyle(color: Colors.white70)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancelar', style: TextStyle(color: Colors.white54)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Quitar'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _snack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? Colors.redAccent : const Color(0xFF1A2C42),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      duration: const Duration(seconds: 2),
    ));
  }

  // ── Estados especiales ────────────────────────────────────────────────────
  Widget _buildSkeleton() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (_, __) => _SkeletonCard(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off_rounded, size: 60, color: Colors.white24),
          const SizedBox(height: 12),
          Text(_vm.errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white54)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _vm.refresh,
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4A90D9)),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.15),
        border: Border.all(color: Colors.redAccent.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(_vm.errorMessage!,
                style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

// ── Skeleton card ─────────────────────────────────────────────────────────
class _SkeletonCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      height: 72,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Container(width: 40, height: 40, decoration: BoxDecoration(color: const Color(0xFF2E2E2E), shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 14, width: 140, color: const Color(0xFF2E2E2E)),
                const SizedBox(height: 8),
                Container(height: 10, width: 90, color: const Color(0xFF2E2E2E)),
              ],
            ),
          ),
          Container(margin: const EdgeInsets.only(right: 16), width: 70, height: 30, decoration: BoxDecoration(color: const Color(0xFF2E2E2E), borderRadius: BorderRadius.circular(6))),
        ],
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _EmptyState({required this.icon, required this.message, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 60, color: Colors.white24),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white38, fontSize: 14)),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 16),
            TextButton(onPressed: onAction, child: Text(actionLabel!, style: const TextStyle(color: Color(0xFF4A90D9)))),
          ],
        ],
      ),
    );
  }
}