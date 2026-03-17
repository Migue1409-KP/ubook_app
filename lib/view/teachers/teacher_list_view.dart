import 'package:flutter/material.dart';
import '../../model/teachers/teacher.dart';
import '../../view_model/teachers/teacher_list_view_model.dart';
import '../teacher_subject/teacher_subjects_page.dart';
import 'teacher_form_view.dart';

class TeacherListView extends StatefulWidget {
  const TeacherListView({super.key});

  @override
  State<TeacherListView> createState() => _TeacherListViewState();
}

class _TeacherListViewState extends State<TeacherListView> {
  final TeacherListViewModel _viewModel = TeacherListViewModel();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _searchController.dispose();
    super.dispose();
  }

   void _navigateToTeacherSubjects(Teacher teacher) {
     Navigator.push(
       context,
       MaterialPageRoute(
         builder: (_) => TeacherSubjectsPage(teacher: teacher),
       ),
     );
   }

  void _onDeleteTeacher(Teacher teacher) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF161B22),
        title: const Text('Eliminar profesor', style: TextStyle(color: Colors.white)),
        content: Text(
          '¿Estás seguro de que deseas eliminar a ${teacher.fullName}?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _viewModel.deleteTeacher(teacher.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        foregroundColor: Colors.white,
        title: const Text('Profesores', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchAndCreateRow(),
            const SizedBox(height: 16),
            Expanded(child: _buildTeacherTable()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndCreateRow() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            onChanged: _viewModel.search,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Buscar...',
              hintStyle: const TextStyle(color: Colors.white38),
              prefixIcon: const Icon(Icons.search, color: Colors.white54),
              filled: true,
              fillColor: const Color(0xFF161B22),
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF30363D)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF30363D)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF4A90D9), width: 2),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        FilledButton.icon(
          onPressed: () async {
            final result = await Navigator.of(context).push<Teacher>(
              MaterialPageRoute(builder: (_) => const TeacherFormView()),
            );
            if (result != null) {
              _viewModel.addTeacher(result);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profesor creado exitosamente')),
                );
              }
            }
          },
          icon: const Icon(Icons.add),
          label: const Text('Crear'),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF4A90D9),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget _buildTeacherTable() {
    final teachers = _viewModel.filteredTeachers;

    if (teachers.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.person_off_outlined, size: 64, color: Colors.white24),
            const SizedBox(height: 16),
            const Text(
              'No se encontraron profesores',
              style: TextStyle(fontSize: 16, color: Colors.white54),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF30363D)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(const Color(0xFF0D1117)),
            columnSpacing: 24,
            columns: const [
              DataColumn(label: Text('Nombre', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
              DataColumn(label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
              DataColumn(label: Text('Edad', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)), numeric: true),
              DataColumn(label: Text('Acciones', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
            ],
            rows: teachers.map((teacher) {
              return DataRow(
                cells: [
                  DataCell(Text(teacher.fullName, style: const TextStyle(color: Colors.white))),
                  DataCell(Text(teacher.id, style: const TextStyle(color: Colors.white70))),
                  DataCell(Text(teacher.age.toString(), style: const TextStyle(color: Colors.white70))),
                  DataCell(_buildActionButtons(teacher)),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(Teacher teacher) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
         TextButton(
           onPressed: () => _navigateToTeacherSubjects(teacher),
           child: const Text('Ver', style: TextStyle(color: Color(0xFF4A90D9), fontSize: 12)),
         ),
        TextButton(
          onPressed: () async {
            final result = await Navigator.of(context).push<Teacher>(
              MaterialPageRoute(
                builder: (_) => TeacherFormView(teacher: teacher),
              ),
            );
            if (result != null) {
              _viewModel.updateTeacher(result);
            }
          },
          child: const Text('Editar', style: TextStyle(color: Color(0xFF90CAF9), fontSize: 12)),
        ),
        TextButton(
          onPressed: () => _onDeleteTeacher(teacher),
          style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
          child: const Text('Eliminar', style: TextStyle(fontSize: 12)),
        ),
      ],
    );
  }
}
