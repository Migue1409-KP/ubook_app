import 'package:flutter/material.dart';
import 'package:ubook_app/model/subjects/subjects.dart';
import 'package:ubook_app/model/teachers/teacher.dart';
import 'package:ubook_app/view_model/assign_subject_teacher_view_model.dart';

class AssignSubjectTeacherPage extends StatefulWidget {
  // Listas que vienen de afuera — no se queman aquí
  final List<Teacher> allTeachers;
  final List<Subject> allSubjects;

  const AssignSubjectTeacherPage({
    super.key,
    required this.allTeachers,
    required this.allSubjects,
  });

  @override
  State<AssignSubjectTeacherPage> createState() =>
      _AssignSubjectTeacherPageState();
}

class _AssignSubjectTeacherPageState
    extends State<AssignSubjectTeacherPage> {
  late final AssignSubjectTeacherViewModel _vm;
  final TextEditingController _teacherSearch = TextEditingController();
  final TextEditingController _subjectSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    _vm = AssignSubjectTeacherViewModel(
      allTeachers: widget.allTeachers,
      allSubjects: widget.allSubjects,
    );
    _vm.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _vm.dispose();
    _teacherSearch.dispose();
    _subjectSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        foregroundColor: Colors.white,
        title: const Text('Asignar Profesor ↔ Materia',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: _vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(children: [
              if (_vm.errorMessage != null) _buildBanner(),
              Expanded(child: _buildBody()),
            ]),
    );
  }

  Widget _buildBody() {
    return LayoutBuilder(builder: (ctx, constraints) {
      if (constraints.maxWidth >= 700) {
        return Row(children: [
          SizedBox(width: 280, child: _buildTeacherPanel()),
          const VerticalDivider(color: Color(0xFF30363D), width: 1),
          Expanded(child: _buildSubjectPanel()),
        ]);
      }
      return Column(children: [
        SizedBox(height: 220, child: _buildTeacherPanel()),
        const Divider(color: Color(0xFF30363D), height: 1),
        Expanded(child: _buildSubjectPanel()),
      ]);
    });
  }

  Widget _buildTeacherPanel() {
    return Column(children: [
      _SectionHeader(title: 'Profesores', count: widget.allTeachers.length),
      _SearchField(
          controller: _teacherSearch,
          hint: 'Buscar profesor...',
          onChanged: _vm.setSearchTeacher),
      Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 8),
          itemCount: _vm.filteredTeachers.length,
          itemBuilder: (_, i) {
            final t = _vm.filteredTeachers[i];
            final selected = _vm.selectedTeacherId == t.id;
            return ListTile(
              dense: true,
              selected: selected,
              selectedTileColor: const Color(0xFF1A2C42),
              leading: CircleAvatar(
                radius: 18,
                backgroundColor:
                    selected ? const Color(0xFF4A90D9) : const Color(0xFF2E2E2E),
                child: Text('${t.firstName[0]}${t.lastName[0]}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
              ),
              title: Text(t.fullName,
                  style: TextStyle(
                      color: selected ? Colors.white : Colors.white70,
                      fontSize: 13,
                      fontWeight: selected
                          ? FontWeight.bold
                          : FontWeight.normal)),
              subtitle: Text(t.department,
                  style: const TextStyle(
                      color: Colors.white38, fontSize: 11)),
              onTap: () => _vm.selectTeacher(t.id),
            );
          },
        ),
      ),
    ]);
  }

  Widget _buildSubjectPanel() {
    final teacherId = _vm.selectedTeacherId;
    if (teacherId == null) {
      return const Center(
          child: Text('Selecciona un profesor',
              style: TextStyle(color: Colors.white38)));
    }

    final assigned = _vm.filteredSubjects
        .where((s) => _vm.isAssigned(teacherId, s.id))
        .toList();
    final available = _vm.filteredSubjects
        .where((s) => !_vm.isAssigned(teacherId, s.id))
        .toList();

    return Column(children: [
      _SectionHeader(
        title: 'Materias de ${_vm.selectedTeacher?.firstName ?? ''}',
        count: widget.allSubjects.length,
        extra: '${assigned.length} asignadas',
      ),
      _SearchField(
          controller: _subjectSearch,
          hint: 'Buscar materia...',
          onChanged: _vm.setSearchSubject),
      Expanded(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 16),
          children: [
            if (assigned.isNotEmpty) ...[
              _ListLabel(text: 'ASIGNADAS (${assigned.length})'),
              ...assigned.map((s) => _SubjectToggleItem(
                    subject: s,
                    isAssigned: true,
                    isBusy: _vm.busyKey == '${teacherId}_${s.id}',
                    onTap: () => _toggle(teacherId, s.id, s.nombre),
                  )),
            ],
            if (available.isNotEmpty) ...[
              _ListLabel(text: 'DISPONIBLES (${available.length})'),
              ...available.map((s) => _SubjectToggleItem(
                    subject: s,
                    isAssigned: false,
                    isBusy: _vm.busyKey == '${teacherId}_${s.id}',
                    onTap: () => _toggle(teacherId, s.id, s.nombre),
                  )),
            ],
          ],
        ),
      ),
    ]);
  }

  Future<void> _toggle(
      String teacherId, String subjectId, String nombre) async {
    final wasAssigned = _vm.isAssigned(teacherId, subjectId);
    final ok = await _vm.toggle(teacherId, subjectId);
    if (!mounted) return;
    _snack(
      ok
          ? wasAssigned ? '🗑  $nombre quitada' : '✅  $nombre asignada'
          : '❌  ${_vm.errorMessage}',
      isError: !ok,
    );
  }

  void _snack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor:
          isError ? Colors.redAccent : const Color(0xFF1A2C42),
      behavior: SnackBarBehavior.floating,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      duration: const Duration(seconds: 2),
    ));
  }

  Widget _buildBanner() => Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            color: Colors.redAccent.withOpacity(0.15),
            border:
                Border.all(color: Colors.redAccent.withOpacity(0.4)),
            borderRadius: BorderRadius.circular(8)),
        child: Row(children: [
          const Icon(Icons.error_outline,
              color: Colors.redAccent, size: 18),
          const SizedBox(width: 8),
          Expanded(
              child: Text(_vm.errorMessage!,
                  style: const TextStyle(
                      color: Colors.redAccent, fontSize: 12))),
        ]),
      );
}

// ── Widgets internos ──────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  final String? extra;
  const _SectionHeader(
      {required this.title, required this.count, this.extra});

  @override
  Widget build(BuildContext context) => Container(
        color: const Color(0xFF161B22),
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(children: [
          Expanded(
              child: Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14))),
          if (extra != null)
            Text(extra!,
                style: const TextStyle(
                    color: Color(0xFF4A90D9), fontSize: 12)),
        ]),
      );
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  const _SearchField(
      {required this.controller,
      required this.hint,
      required this.onChanged});

  @override
  Widget build(BuildContext context) => Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: TextField(
          controller: controller,
          style:
              const TextStyle(color: Colors.white, fontSize: 13),
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                const TextStyle(color: Colors.white38, fontSize: 13),
            prefixIcon: const Icon(Icons.search,
                color: Colors.white38, size: 18),
            filled: true,
            fillColor: const Color(0xFF1E1E1E),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Color(0xFF333333))),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Color(0xFF333333))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Color(0xFF4A90D9))),
          ),
        ),
      );
}

class _ListLabel extends StatelessWidget {
  final String text;
  const _ListLabel({required this.text});

  @override
  Widget build(BuildContext context) => Padding(
        padding:
            const EdgeInsets.only(left: 16, top: 12, bottom: 4),
        child: Text(text,
            style: const TextStyle(
                color: Colors.white38,
                fontSize: 10,
                letterSpacing: 1.0)),
      );
}

class _SubjectToggleItem extends StatelessWidget {
  final Subject subject;
  final bool isAssigned;
  final bool isBusy;
  final VoidCallback onTap;

  const _SubjectToggleItem({
    required this.subject,
    required this.isAssigned,
    required this.isBusy,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      decoration: BoxDecoration(
        color: isAssigned
            ? const Color(0xFF1E3A5F)
            : const Color(0xFF1E1E1E),
        border: Border.all(
            color: isAssigned
                ? const Color(0xFF4A90D9)
                : const Color(0xFF333333)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        dense: true,
        title: Text(subject.nombre,
            style: TextStyle(
                color: isAssigned ? Colors.white : Colors.white70,
                fontSize: 13,
                fontWeight: isAssigned
                    ? FontWeight.w600
                    : FontWeight.normal)),
        subtitle: Text(
            '${subject.creditos} créditos  •  ${subject.horas} h',
            style: TextStyle(
                color: isAssigned
                    ? const Color(0xFF90CAF9)
                    : Colors.white38,
                fontSize: 11)),
        trailing: isBusy
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2))
            : Icon(
                isAssigned
                    ? Icons.check_circle_rounded
                    : Icons.add_circle_outline_rounded,
                color: isAssigned
                    ? const Color(0xFF4A90D9)
                    : Colors.white38,
                size: 22,
              ),
        onTap: isBusy ? null : onTap,
      ),
    );
  }
}