import 'package:flutter/material.dart';
import 'package:ubook_app/model/subjects/subjects.dart';
import 'package:ubook_app/view/subjects/widgets/subject_delete_modal.dart';
import 'package:ubook_app/view/subjects/widgets/subject_detail_modal.dart';
import 'package:ubook_app/view/subjects/widgets/subject_form_modal.dart';
import 'package:ubook_app/view_model/subjects/subjects_modal_demo_view_model.dart';

class SubjectsModalDemoPage extends StatefulWidget {
  const SubjectsModalDemoPage({super.key});

  @override
  State<SubjectsModalDemoPage> createState() => _SubjectsModalDemoPageState();
}

class _SubjectsModalDemoPageState extends State<SubjectsModalDemoPage> {
  final SubjectsModalDemoViewModel _viewModel = SubjectsModalDemoViewModel();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_refresh);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_refresh);
    _viewModel.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final subjects = _viewModel.subjects;

    return Scaffold(
      appBar: AppBar(title: const Text('Materias - Demo aislada')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 920),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Este módulo es aislado y no modifica navegación global ni archivos existentes.',
                  style: TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 16),
                _SubjectsShell(
                  searchController: _searchController,
                  onSearchChanged: _viewModel.updateSearch,
                  onCreatePressed: _openCreateModal,
                  subjects: subjects,
                  onViewPressed: _openDetailModal,
                  onEditPressed: _openEditModal,
                  onDeletePressed: _openDeleteModal,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openCreateModal() async {
    await showDialog<void>(
      context: context,
      builder: (_) => SubjectFormModal(
        title: 'Materias',
        buttonText: 'Guardar',
        onSave: (formData) {
          _viewModel.createSubject(
            nombre: formData.nombre,
            horas: formData.horas,
            creditos: formData.creditos,
            prerrequisitosText: formData.prerrequisitos,
            contenido: formData.contenido,
          );
        },
      ),
    );
  }

  Future<void> _openEditModal(Subject subject) async {
    await showDialog<void>(
      context: context,
      builder: (_) => SubjectFormModal(
        title: 'Materias',
        buttonText: 'Guardar',
        initialSubject: subject,
        onSave: (formData) {
          _viewModel.updateSubject(
            id: subject.id,
            nombre: formData.nombre,
            horas: formData.horas,
            creditos: formData.creditos,
            prerrequisitosText: formData.prerrequisitos,
            contenido: formData.contenido,
          );
        },
      ),
    );
  }

  Future<void> _openDetailModal(Subject subject) async {
    await showDialog<void>(
      context: context,
      builder: (_) => SubjectDetailModal(
        subject: subject,
        onEditNombre: () => _openEditModal(subject),
        onEditHoras: () => _openEditModal(subject),
      ),
    );
  }

  Future<void> _openDeleteModal(Subject subject) async {
    await showDialog<void>(
      context: context,
      builder: (_) => SubjectDeleteModal(
        onConfirm: () {
          _viewModel.deleteSubject(subject.id);
        },
      ),
    );
  }
}

class _SubjectsShell extends StatelessWidget {
  const _SubjectsShell({
    required this.searchController,
    required this.onSearchChanged,
    required this.onCreatePressed,
    required this.subjects,
    required this.onViewPressed,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onCreatePressed;
  final List<Subject> subjects;
  final ValueChanged<Subject> onViewPressed;
  final ValueChanged<Subject> onEditPressed;
  final ValueChanged<Subject> onDeletePressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black87),
        color: const Color(0xFFF3F3F3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(
            child: Text(
              'Materias',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: TextField(
                    controller: searchController,
                    onChanged: onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.black87),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 164,
                height: 42,
                child: OutlinedButton(
                  onPressed: onCreatePressed,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.black87),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Crear'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(3),
              1: FlexColumnWidth(1.2),
              2: FlexColumnWidth(2.4),
            },
            border: TableBorder.all(color: Colors.black87),
            children: const [
              TableRow(
                children: [
                  _HeaderCell(label: 'Nombre'),
                  _HeaderCell(label: 'Horas'),
                  SizedBox(height: 54),
                ],
              ),
            ],
          ),
          Container(
            constraints: const BoxConstraints(minHeight: 240),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black87),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(2),
                bottomRight: Radius.circular(2),
              ),
            ),
            child: subjects.isEmpty
                ? const Center(child: Text('No hay materias para mostrar'))
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: subjects.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final subject = subjects[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                subject.nombre,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                subject.horas.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 16,
                                children: [
                                  _ActionTextButton(
                                    label: 'Ver',
                                    onPressed: () => onViewPressed(subject),
                                  ),
                                  _ActionTextButton(
                                    label: 'Editar',
                                    onPressed: () => onEditPressed(subject),
                                  ),
                                  _ActionTextButton(
                                    label: 'Eliminar',
                                    onPressed: () => onDeletePressed(subject),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

class _ActionTextButton extends StatelessWidget {
  const _ActionTextButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF8BC34A),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
