import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubook_app/model/subjectteacher/subjectteacher.dart';
import 'package:ubook_app/view/teacher_subject/assign_subject_teacher_page.dart';
import '../../model/teachers/teacher.dart';
import '../../model/subjects/subjects.dart';
import '../../view_model/teacher_subject/teacher_subjects_view_model.dart';
import '../../theme/app_colors.dart';
import '../../view/attachments/attachments_view.dart';

// ---------------------------------------------------------------------------
// Entry point — crea el ViewModel y lo inyecta con ChangeNotifierProvider
// ---------------------------------------------------------------------------
class TeacherSubjectsPage extends StatelessWidget {
  final Teacher? teacher;
  final Subject? subject;
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
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TeacherSubjectsViewModel(
        teacher: teacher,
        subject: subject,
        allSubjects: allSubjects,
        allTeachers: allTeachers,
      ),
      child: _TeacherSubjectsView(
        teacher: teacher,
        subject: subject,
        allSubjects: allSubjects,
        allTeachers: allTeachers,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Vista — consume el ViewModel via Provider, sin addListener ni setState manual
// ---------------------------------------------------------------------------
class _TeacherSubjectsView extends StatefulWidget {
  final Teacher? teacher;
  final Subject? subject;
  final List<Subject> allSubjects;
  final List<Teacher> allTeachers;

  const _TeacherSubjectsView({
    this.teacher,
    this.subject,
    this.allSubjects = const [],
    this.allTeachers = const [],
  });

  @override
  State<_TeacherSubjectsView> createState() => _TeacherSubjectsViewState();
}

class _TeacherSubjectsViewState extends State<_TeacherSubjectsView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchCtrl = TextEditingController();
  String? _busySubjectId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.teacher != null ? 2 : 1,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // context.watch reconstruye el widget cada vez que el VM notifica
    final vm = context.watch<TeacherSubjectsViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: Text(vm.pageTitle,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Recargar',
            onPressed: vm.isInitialLoading ? null : vm.refresh,
          ),
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
            ).then((_) => vm.refresh()),
          ),
        ],
        bottom: vm.isTeacherMode
            ? TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                tabs: [
                  Tab(
                    icon: const Icon(Icons.book),
                    text: 'Asignadas (${vm.assignedSubjects.length})',
                  ),
                  Tab(
                    icon: const Icon(Icons.add_box_outlined),
                    text: 'Disponibles (${vm.availableSubjects.length})',
                  ),
                ],
              )
            : null,
      ),
      body: vm.isInitialLoading
          ? _buildSkeleton()
          : vm.errorMessage != null &&
                  (vm.isTeacherMode
                      ? vm.assignedSubjects.isEmpty
                      : vm.subjectLinks.isEmpty)
              ? _buildError(vm)
              : vm.isTeacherMode
                  ? _buildTeacherBody(vm)
                  : _buildSubjectBody(vm),
    );
  }

  // ── Modo PROFESOR ─────────────────────────────────────────────────────────
  Widget _buildTeacherBody(TeacherSubjectsViewModel vm) {
    return Column(children: [
      _buildTeacherHeader(vm),
      _buildSearchBar(vm),
      const SizedBox(height: 4),
      if (vm.errorMessage != null) _buildErrorBanner(vm),
      Expanded(
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildSubjectList(vm, vm.filteredAssigned(), assigned: true),
            _buildSubjectList(vm, vm.filteredAvailable(), assigned: false),
          ],
        ),
      ),
    ]);
  }

  // ── Modo MATERIA ──────────────────────────────────────────────────────────
  Widget _buildSubjectBody(TeacherSubjectsViewModel vm) {
    final links = vm.subjectLinks;
    return Column(children: [
      _buildSubjectHeader(vm),
      if (vm.errorMessage != null) _buildErrorBanner(vm),
      links.isEmpty
          ? Expanded(child: _buildEmpty())
          : Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 24),
                itemCount: links.length,
                itemBuilder: (_, i) => _TeacherLinkCard(
                  link: links[i],
                  isBusy: vm.isBusy,
                  onRemove: () => _handleRemoveLink(links[i]),
                ),
              ),
            ),
    ]);
  }

  Widget _buildSubjectList(
      TeacherSubjectsViewModel vm, List<Subject> subjects,
      {required bool assigned}) {
    if (subjects.isEmpty) {
      return _EmptyState(
        icon: assigned ? Icons.book_outlined : Icons.check_circle_outline,
        message: vm.searchQuery.isEmpty
            ? assigned
                ? 'Este profesor no tiene materias asignadas.'
                : 'Todas las materias ya están asignadas.'
            : 'No hay resultados para "${vm.searchQuery}".',
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
          onAdjuntos: assigned ? () => _goToAdjuntos(vm, s.id) : null,
        );
      },
    );
  }

  // ── Headers ───────────────────────────────────────────────────────────────
  Widget _buildTeacherHeader(TeacherSubjectsViewModel vm) {
    final t = widget.teacher!;
    return _InfoHeader(
      initials: '${t.firstName[0]}${t.lastName[0]}',
      title: t.fullName,
      subtitle: t.email,
      tag: t.department,
      badge1Label: 'Materias',
      badge1Value: '${vm.assignedSubjects.length}',
      badge2Label: 'Créditos',
      badge2Value: '${vm.totalCredits}',
    );
  }

  Widget _buildSubjectHeader(TeacherSubjectsViewModel vm) {
    final s = widget.subject!;
    return _InfoHeader(
      initials: s.nombre.substring(0, 2).toUpperCase(),
      title: s.nombre,
      subtitle: s.contenido,
      tag: '${s.creditos} créditos  •  ${s.horas} h',
      badge1Label: 'Profesores',
      badge1Value: '${vm.subjectLinks.length}',
      badge2Label: '',
      badge2Value: '',
    );
  }

  // ── Acciones ──────────────────────────────────────────────────────────────
  Future<void> _handleAssign(Subject subject) async {
    // context.read accede al VM sin suscribirse (solo para llamar métodos)
    final vm = context.read<TeacherSubjectsViewModel>();
    setState(() => _busySubjectId = subject.id);
    final ok = await vm.assignSubject(subject);
    setState(() => _busySubjectId = null);
    if (!mounted) return;
    if (ok) {
      _snack('✅  ${subject.nombre} asignada correctamente');
      _tabController.animateTo(0);
    } else {
      _snack('❌  ${vm.errorMessage}', isError: true);
    }
  }

  Future<void> _handleRemove(Subject subject) async {
    final vm = context.read<TeacherSubjectsViewModel>();
    final confirmed = await _confirmDialog(subject.nombre);
    if (!confirmed || !mounted) return;
    setState(() => _busySubjectId = subject.id);
    final ok = await vm.removeSubject(subject);
    setState(() => _busySubjectId = null);
    if (!mounted) return;
    ok
        ? _snack('🗑  ${subject.nombre} quitada del profesor')
        : _snack('❌  ${vm.errorMessage}', isError: true);
  }

  Future<void> _handleRemoveLink(SubjectTeacher link) async {
    final vm = context.read<TeacherSubjectsViewModel>();
    final confirmed = await _confirmDialog(link.teacherName);
    if (!confirmed || !mounted) return;
    final ok = await vm.removeLink(link);
    if (!mounted) return;
    ok
        ? _snack('🗑  Asignación eliminada')
        : _snack('❌  ${vm.errorMessage}', isError: true);
  }

  void _goToAdjuntos(TeacherSubjectsViewModel vm, String subjectId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AttachmentsView(
          subjectId:    subjectId,
          teacherId:    widget.teacher?.id ?? '',
          uploadedById: widget.teacher?.id ?? '',
        ),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  Future<bool> _confirmDialog(String name) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            title: Text('Confirmar',
                style: TextStyle(color: AppColors.textPrimary)),
            content: Text('¿Quitar "$name" de esta asignación?',
                style: TextStyle(color: AppColors.textSecondary)),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text('Cancelar',
                      style: TextStyle(color: AppColors.textSecondary))),
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
      backgroundColor: isError ? Colors.redAccent : AppColors.primary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      duration: const Duration(seconds: 2),
    ));
  }

  Widget _buildSearchBar(TeacherSubjectsViewModel vm) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: TextField(
          controller: _searchCtrl,
          style: TextStyle(color: AppColors.textPrimary),
          onChanged: vm.setSearch,
          decoration: InputDecoration(
            hintText: 'Buscar materia...',
            hintStyle: TextStyle(color: AppColors.placeholder),
            prefixIcon: Icon(Icons.search, color: AppColors.placeholder),
            filled: true,
            fillColor: AppColors.inputFill,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            border: _border(AppColors.divider),
            enabledBorder: _border(AppColors.divider),
            focusedBorder: _border(AppColors.primary),
            suffixIcon: vm.searchQuery.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, color: AppColors.placeholder),
                    onPressed: () {
                      _searchCtrl.clear();
                      vm.setSearch('');
                    },
                  )
                : null,
          ),
        ),
      );

  OutlineInputBorder _border(Color c) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: c));

  Widget _buildSkeleton() => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (_, __) => Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          height: 72,
          decoration: BoxDecoration(
              color: AppColors.inputFill,
              borderRadius: BorderRadius.circular(10)),
          child: Row(children: [
            const SizedBox(width: 16),
            Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: AppColors.divider, shape: BoxShape.circle)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 14, width: 140, color: AppColors.divider),
                    const SizedBox(height: 8),
                    Container(height: 10, width: 90, color: AppColors.divider),
                  ]),
            ),
            Container(
                margin: const EdgeInsets.only(right: 16),
                width: 70,
                height: 30,
                decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(6))),
          ]),
        ),
      );

  Widget _buildError(TeacherSubjectsViewModel vm) => Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.wifi_off_rounded,
              size: 60, color: AppColors.textSecondary),
          const SizedBox(height: 12),
          Text(vm.errorMessage!,
              style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
              onPressed: vm.refresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white)),
        ]),
      );

  Widget _buildEmpty() => Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.link_off_rounded,
              size: 60, color: AppColors.textSecondary),
          const SizedBox(height: 12),
          Text('No hay asignaciones aún.',
              style: TextStyle(color: AppColors.textSecondary)),
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
            ).then((_) => context.read<TeacherSubjectsViewModel>().refresh()),
            icon: const Icon(Icons.add_link_rounded),
            label: const Text('Asignar nueva relación'),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white),
          ),
        ]),
      );

  Widget _buildErrorBanner(TeacherSubjectsViewModel vm) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            color: Colors.redAccent.withOpacity(0.1),
            border: Border.all(color: Colors.redAccent.withOpacity(0.4)),
            borderRadius: BorderRadius.circular(8)),
        child: Row(children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 18),
          const SizedBox(width: 8),
          Expanded(
              child: Text(vm.errorMessage!,
                  style:
                      const TextStyle(color: Colors.redAccent, fontSize: 12))),
        ]),
      );
}

// ── Card materia ──────────────────────────────────────────────────────────
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
        color: isAssigned ? AppColors.primary.withOpacity(0.08) : Colors.white,
        border: Border.all(
            color: isAssigned ? AppColors.primary : AppColors.divider,
            width: 1.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor:
                isAssigned ? AppColors.primary : AppColors.inputFill,
            child: Text(
              subject.nombre.substring(0, 2).toUpperCase(),
              style: TextStyle(
                  color: isAssigned ? Colors.white : AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(subject.nombre,
              style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600)),
          subtitle: Text(
              '${subject.creditos} créditos  •  ${subject.horas} h',
              style:
                  TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          trailing: isLoading
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: AppColors.primary))
              : OutlinedButton(
                  onPressed: onToggle,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isAssigned
                        ? Colors.redAccent
                        : AppColors.primary,
                    side: BorderSide(
                        color: isAssigned
                            ? Colors.redAccent
                            : AppColors.primary),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    minimumSize: const Size(76, 32),
                  ),
                  child: Text(isAssigned ? 'Quitar' : 'Asignar',
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600)),
                ),
        ),
        if (isAssigned && onAdjuntos != null)
          Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, bottom: 10),
            child: OutlinedButton.icon(
              onPressed: isLoading ? null : onAdjuntos,
              icon: const Icon(Icons.attach_file_rounded, size: 16),
              label: const Text('adjuntos', style: TextStyle(fontSize: 12)),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 6),
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
        color: Colors.white,
        border: Border.all(color: AppColors.divider, width: 1.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary,
          child: Text(initials,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        title: Text(link.teacherName,
            style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600)),
        subtitle: Text(link.teacherEmail,
            style:
                TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        trailing: isBusy
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: AppColors.primary))
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
          color: Colors.white,
          border: Border.all(color: AppColors.divider),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2))
          ],
        ),
        child: Row(children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.primary,
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
                      style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                  if (subtitle.isNotEmpty)
                    Text(subtitle,
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 11)),
                  if (tag.isNotEmpty)
                    Text(tag,
                        style: TextStyle(
                            color: AppColors.primary, fontSize: 11)),
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
            color: AppColors.inputFill,
            borderRadius: BorderRadius.circular(20)),
        child: RichText(
          text: TextSpan(children: [
            TextSpan(
                text: '$value ',
                style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
            TextSpan(
                text: label,
                style: TextStyle(
                    color: AppColors.textSecondary, fontSize: 11)),
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
          Icon(icon, size: 60, color: AppColors.textSecondary),
          const SizedBox(height: 12),
          Text(message,
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 16),
            TextButton(
                onPressed: onAction,
                child: Text(actionLabel!,
                    style: TextStyle(color: AppColors.primary))),
          ],
        ]),
      );
}