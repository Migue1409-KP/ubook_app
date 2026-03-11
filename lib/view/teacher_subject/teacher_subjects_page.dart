import 'package:flutter/material.dart';
import 'package:ubook_app/model/subjectteacher/subjectteacher.dart';
import 'package:ubook_app/view/teacher_subject/assign_subject_teacher_page.dart';
import '../../model/teachers/teacher.dart';
import '../../model/subjects/subjects.dart';
import '../../view_model/teacher_subjects_view_model.dart';

class TeacherSubjectsPage extends StatefulWidget {
  final Teacher? teacher;
  final Subject? subject;

  // Listas que vienen del ViewModel del compañero — no se queman aquí
  final List<Subject> allSubjects;
  final List<Teacher> allTeachers;

  const TeacherSubjectsPage({
    super.key,
    this.teacher,
    this.subject,
    this.allSubjects = const [],
    this.allTeachers = const [],
  }) : assert(teacher != null || subject != null);

  @override
  State<TeacherSubjectsPage> createState() => _TeacherSubjectsPageState();
}

class _TeacherSubjectsPageState extends State<TeacherSubjectsPage>
    with SingleTickerProviderStateMixin {
  late final TeacherSubjectsViewModel _vm;
  late final TabController _tabController;
  final TextEditingController _searchCtrl = TextEditingController();
  String? _busySubjectId;

  @override
  void initState() {
    super.initState();
    _vm = TeacherSubjectsViewModel(
      teacher: widget.teacher,
      subject: widget.subject,
      allSubjects: widget.allSubjects,
      allTeachers: widget.allTeachers,
    );
    // Tabs solo en modo profesor (asignadas / disponibles)
    _tabController = TabController(
      length: widget.teacher != null ? 2 : 1,
      vsync: this,
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        foregroundColor: Colors.white,
        title: Text(_vm.pageTitle,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Recargar',
            onPressed: _vm.isInitialLoading ? null : _vm.refresh,
          ),
          // Botón asignar nueva relación → pasa las listas para no quemar datos
          IconButton(
            icon: const Icon(Icons.add_link_rounded),
            tooltip: 'Asignar nueva relación',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AssignSubjectTeacherPage(
                  allTeachers: widget.allTeachers,
                  allSubjects: widget.allSubjects,
                ),
              ),
            ).then((_) => _vm.refresh()),
          ),
        ],
        bottom: _vm.isTeacherMode
            ? TabBar(
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
              )
            : null,
      ),
      body: _vm.isInitialLoading
          ? _buildSkeleton()
          : _vm.errorMessage != null &&
                  (_vm.isTeacherMode
                      ? _vm.assignedSubjects.isEmpty
                      : _vm.subjectLinks.isEmpty)
              ? _buildError()
              : _vm.isTeacherMode
                  ? _buildTeacherBody()
                  : _buildSubjectBody(),
    );
  }

  // ── Modo PROFESOR: tabs asignadas / disponibles ───────────────────────────
  Widget _buildTeacherBody() {
    return Column(
      children: [
        _buildTeacherHeader(),
        _buildSearchBar(),
        const SizedBox(height: 4),
        if (_vm.errorMessage != null) _buildErrorBanner(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildSubjectList(_vm.filteredAssigned(), assigned: true),
              _buildSubjectList(_vm.filteredAvailable(), assigned: false),
            ],
          ),
        ),
      ],
    );
  }

  // ── Modo MATERIA: lista de profesores que la tienen ───────────────────────
  Widget _buildSubjectBody() {
    final links = _vm.subjectLinks;
    return Column(
      children: [
        _buildSubjectHeader(),
        if (_vm.errorMessage != null) _buildErrorBanner(),
        links.isEmpty
            ? Expanded(child: _buildEmpty())
            : Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: links.length,
                  itemBuilder: (_, i) => _TeacherLinkCard(
                    link: links[i],
                    isBusy: _vm.isBusy,
                    onRemove: () => _handleRemoveLink(links[i]),
                  ),
                ),
              ),
      ],
    );
  }

  // ── Lista materias (modo profesor) ────────────────────────────────────────
  Widget _buildSubjectList(List<Subject> subjects, {required bool assigned}) {
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
        return _SubjectCard(
          subject: s,
          isAssigned: assigned,
          isLoading: _busySubjectId == s.id,
          onToggle: _busySubjectId != null
              ? null
              : assigned
                  ? () => _handleRemove(s)
                  : () => _handleAssign(s),
          onAdjuntos: assigned ? () => _goToAdjuntos(s.id) : null,
        );
      },
    );
  }

  // ── Headers ───────────────────────────────────────────────────────────────
  Widget _buildTeacherHeader() {
    final t = widget.teacher!;
    return _InfoHeader(
      initials: '${t.firstName[0]}${t.lastName[0]}',
      title: t.fullName,
      subtitle: t.email,
      tag: t.department,
      badge1Label: 'Materias',
      badge1Value: '${_vm.assignedSubjects.length}',
      badge2Label: 'Créditos',
      badge2Value: '${_vm.totalCredits}',
    );
  }

  Widget _buildSubjectHeader() {
    final s = widget.subject!;
    return _InfoHeader(
      initials: s.nombre.substring(0, 2).toUpperCase(),
      title: s.nombre,
      subtitle: s.contenido,
      tag: '${s.creditos} créditos  •  ${s.horas} h',
      badge1Label: 'Profesores',
      badge1Value: '${_vm.subjectLinks.length}',
      badge2Label: '',
      badge2Value: '',
    );
  }

  // ── Acciones ──────────────────────────────────────────────────────────────
  Future<void> _handleAssign(Subject subject) async {
    setState(() => _busySubjectId = subject.id);
    final ok = await _vm.assignSubject(subject);
    setState(() => _busySubjectId = null);
    if (!mounted) return;
    if (ok) {
      _snack('✅  ${subject.nombre} asignada correctamente');
      _tabController.animateTo(0);
    } else {
      _snack('❌  ${_vm.errorMessage}', isError: true);
    }
  }

  Future<void> _handleRemove(Subject subject) async {
    final confirmed = await _confirmDialog(subject.nombre);
    if (!confirmed || !mounted) return;
    setState(() => _busySubjectId = subject.id);
    final ok = await _vm.removeSubject(subject);
    setState(() => _busySubjectId = null);
    if (!mounted) return;
    ok
        ? _snack('🗑  ${subject.nombre} quitada del profesor')
        : _snack('❌  ${_vm.errorMessage}', isError: true);
  }

  Future<void> _handleRemoveLink(SubjectTeacher link) async {
    final confirmed = await _confirmDialog(link.teacherName);
    if (!confirmed || !mounted) return;
    final ok = await _vm.removeLink(link);
    if (!mounted) return;
    ok
        ? _snack('🗑  Asignación eliminada')
        : _snack('❌  ${_vm.errorMessage}', isError: true);
  }

  void _goToAdjuntos(String subjectId) {
    // Obtiene el linkId real de la relación
    final link = _vm.subjectLinks.isEmpty
        ? null
        : _vm.subjectLinks
            .where((l) =>
                l.subjectId == subjectId &&
                l.teacherId == widget.teacher?.id)
            .firstOrNull;
    final linkId = link?.id ?? 'sin-link';
    // TODO: Navigator.push(context, MaterialPageRoute(builder: (_) => AdjuntosPage(linkId: linkId)));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('📎  Adjuntos — linkId: $linkId'),
      backgroundColor: const Color(0xFF1A2C42),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ));
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  Future<bool> _confirmDialog(String name) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: const Color(0xFF1E1E1E),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: const Text('Confirmar',
                style: TextStyle(color: Colors.white)),
            content: Text('¿Quitar "$name" de esta asignación?',
                style: const TextStyle(color: Colors.white70)),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Cancelar',
                      style: TextStyle(color: Colors.white54))),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent),
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('Quitar')),
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

  Widget _buildSearchBar() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: TextField(
          controller: _searchCtrl,
          style: const TextStyle(color: Colors.white),
          onChanged: _vm.setSearch,
          decoration: InputDecoration(
            hintText: 'Buscar materia...',
            hintStyle: const TextStyle(color: Colors.white38),
            prefixIcon: const Icon(Icons.search, color: Colors.white38),
            filled: true,
            fillColor: const Color(0xFF1E1E1E),
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            border: _border(const Color(0xFF333333)),
            enabledBorder: _border(const Color(0xFF333333)),
            focusedBorder: _border(const Color(0xFF4A90D9)),
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

  OutlineInputBorder _border(Color c) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: c));

  Widget _buildSkeleton() => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (_, __) => Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          height: 72,
          decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(10)),
          child: Row(children: [
            const SizedBox(width: 16),
            Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                    color: Color(0xFF2E2E2E), shape: BoxShape.circle)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 14, width: 140, color: const Color(0xFF2E2E2E)),
                    const SizedBox(height: 8),
                    Container(height: 10, width: 90, color: const Color(0xFF2E2E2E)),
                  ]),
            ),
            Container(
                margin: const EdgeInsets.only(right: 16),
                width: 70,
                height: 30,
                decoration: BoxDecoration(
                    color: const Color(0xFF2E2E2E),
                    borderRadius: BorderRadius.circular(6))),
          ]),
        ),
      );

  Widget _buildError() => Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.wifi_off_rounded, size: 60, color: Colors.white24),
          const SizedBox(height: 12),
          Text(_vm.errorMessage!,
              style: const TextStyle(color: Colors.white54)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
              onPressed: _vm.refresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A90D9))),
        ]),
      );

  Widget _buildEmpty() => Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.link_off_rounded, size: 60, color: Colors.white24),
          const SizedBox(height: 12),
          const Text('No hay asignaciones aún.',
              style: TextStyle(color: Colors.white38)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AssignSubjectTeacherPage(
                  allTeachers: widget.allTeachers,
                  allSubjects: widget.allSubjects,
                ),
              ),
            ).then((_) => _vm.refresh()),
            icon: const Icon(Icons.add_link_rounded),
            label: const Text('Asignar nueva relación'),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A90D9)),
          ),
        ]),
      );

  Widget _buildErrorBanner() => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            color: Colors.redAccent.withOpacity(0.15),
            border: Border.all(color: Colors.redAccent.withOpacity(0.4)),
            borderRadius: BorderRadius.circular(8)),
        child: Row(children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 18),
          const SizedBox(width: 8),
          Expanded(
              child: Text(_vm.errorMessage!,
                  style:
                      const TextStyle(color: Colors.redAccent, fontSize: 12))),
        ]),
      );
}

// ── Card materia (modo profesor) ──────────────────────────────────────────
class _SubjectCard extends StatelessWidget {
  final Subject subject;
  final bool isAssigned;
  final bool isLoading;
  final VoidCallback? onToggle;
  final VoidCallback? onAdjuntos;

  const _SubjectCard({
    required this.subject,
    required this.isAssigned,
    required this.isLoading,
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
            color: isAssigned
                ? const Color(0xFF4A90D9)
                : const Color(0xFF333333),
            width: 1.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: isAssigned
                ? const Color(0xFF4A90D9)
                : const Color(0xFF333333),
            child: Text(
              subject.nombre.substring(0, 2).toUpperCase(),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(subject.nombre,
              style: TextStyle(
                  color: isAssigned ? Colors.white : Colors.white70,
                  fontWeight: FontWeight.w600)),
          subtitle: Text(
              '${subject.creditos} créditos  •  ${subject.horas} h',
              style: TextStyle(
                  color: isAssigned
                      ? const Color(0xFF90CAF9)
                      : Colors.white38,
                  fontSize: 12)),
          trailing: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : OutlinedButton(
                  onPressed: onToggle,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isAssigned
                        ? Colors.redAccent
                        : const Color(0xFF4A90D9),
                    side: BorderSide(
                        color: isAssigned
                            ? Colors.redAccent
                            : const Color(0xFF4A90D9)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    minimumSize: const Size(76, 32),
                  ),
                  child: Text(
                    isAssigned ? 'Quitar' : 'Asignar',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
        ),
        // Botón adjuntos solo en materias asignadas
        if (isAssigned && onAdjuntos != null)
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
            child: OutlinedButton.icon(
              onPressed: isLoading ? null : onAdjuntos,
              icon: const Icon(Icons.attach_file_rounded, size: 16),
              label: const Text('Adjuntos', style: TextStyle(fontSize: 12)),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF90CAF9),
                side: const BorderSide(color: Color(0xFF4A90D9)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
              ),
            ),
          ),
      ]),
    );
  }
}

// ── Card profesor (modo materia) ──────────────────────────────────────────
class _TeacherLinkCard extends StatelessWidget {
  final SubjectTeacher link;
  final bool isBusy;
  final VoidCallback onRemove;

  const _TeacherLinkCard(
      {required this.link,
      required this.isBusy,
      required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final parts = link.teacherName.trim().split(' ');
    final initials = parts.length >= 2
        ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
        : link.teacherName.substring(0, 2).toUpperCase();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2C42),
        border: Border.all(color: const Color(0xFF4A90D9), width: 1.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF4A90D9),
          child: Text(initials,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        title: Text(link.teacherName,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600)),
        subtitle: Text(link.teacherEmail,
            style:
                const TextStyle(color: Color(0xFF90CAF9), fontSize: 12)),
        trailing: isBusy
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2))
            : IconButton(
                icon: const Icon(Icons.link_off_rounded,
                    color: Colors.redAccent),
                tooltip: 'Quitar asignación',
                onPressed: onRemove,
              ),
      ),
    );
  }
}

// ── Info header ───────────────────────────────────────────────────────────
class _InfoHeader extends StatelessWidget {
  final String initials, title, subtitle, tag;
  final String badge1Label, badge1Value, badge2Label, badge2Value;

  const _InfoHeader({
    required this.initials,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.badge1Label,
    required this.badge1Value,
    required this.badge2Label,
    required this.badge2Value,
  });

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A2C42),
          border: Border.all(color: const Color(0xFF4A90D9)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: const Color(0xFF4A90D9),
            child: Text(initials,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                  if (subtitle.isNotEmpty)
                    Text(subtitle,
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 11)),
                  if (tag.isNotEmpty)
                    Text(tag,
                        style: const TextStyle(
                            color: Color(0xFF90CAF9), fontSize: 11)),
                ]),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            _Badge(label: badge1Label, value: badge1Value),
            if (badge2Label.isNotEmpty) ...[
              const SizedBox(height: 4),
              _Badge(label: badge2Label, value: badge2Value),
            ],
          ]),
        ]),
      );
}

class _Badge extends StatelessWidget {
  final String label, value;
  const _Badge({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
            color: const Color(0xFF0D1B2A),
            borderRadius: BorderRadius.circular(20)),
        child: RichText(
          text: TextSpan(children: [
            TextSpan(
                text: '$value ',
                style: const TextStyle(
                    color: Color(0xFF4A90D9),
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
            TextSpan(
                text: label,
                style:
                    const TextStyle(color: Colors.white54, fontSize: 11)),
          ]),
        ),
      );
}

// ── Empty state ───────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _EmptyState(
      {required this.icon,
      required this.message,
      this.actionLabel,
      this.onAction});

  @override
  Widget build(BuildContext context) => Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 60, color: Colors.white24),
          const SizedBox(height: 12),
          Text(message,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(color: Colors.white38, fontSize: 14)),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 16),
            TextButton(
                onPressed: onAction,
                child: Text(actionLabel!,
                    style: const TextStyle(
                        color: Color(0xFF4A90D9)))),
          ],
        ]),
      );
}