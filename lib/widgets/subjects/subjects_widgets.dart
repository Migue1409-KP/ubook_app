import 'package:flutter/material.dart';
import '../../model/subjects/subjects.dart';
import '../../view_model/subjects/subjects_view_model.dart';
import '../../view/subjects/subject_detail_dialog.dart';

class SubjectsView extends StatefulWidget {
  const SubjectsView({super.key});

  @override
  State<SubjectsView> createState() => _SubjectsViewState();
}

class _SubjectsViewState extends State<SubjectsView> {
  final SubjectsViewModel _viewModel = SubjectsViewModel();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Materias"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: "Buscar materia...",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      _viewModel.search(value);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
  
                  },
                  child: const Text("Crear"),
                ),
              ],
            ),

            const SizedBox(height: 20),

         
            Expanded(
              child: ListView.builder(
                itemCount: _viewModel.filteredSubjects.length,
                itemBuilder: (context, index) {
                  final subject =
                      _viewModel.filteredSubjects[index];

                  return Card(
                    child: ListTile(
                      title: Text(subject.nombre),
                      subtitle:
                          Text("Horas: ${subject.horas}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: () {
                              _openDetail(subject);
                            },
                            child: const Text("Ver"),
                          ),
                          TextButton(
                            onPressed: () {
                              // TODO: editar
                            },
                            child: const Text("Editar"),
                          ),
                          TextButton(
                            onPressed: () {
                              _viewModel.removeSubject(subject.id);
                            },
                            child: const Text(
                              "Eliminar",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDetail(Subject subject) {
    showDialog(
      context: context,
      builder: (_) => SubjectDetailDialog(subject: subject),
    );
  }
}