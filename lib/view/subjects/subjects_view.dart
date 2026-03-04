import 'package:flutter/material.dart';
import '../../view_model/subjects/subjects_view_model.dart';

class SubjectsView extends StatefulWidget {
  const SubjectsView({super.key});

  @override
  State<SubjectsView> createState() => _SubjectsViewState();
}

class _SubjectsViewState extends State<SubjectsView> {
  final SubjectsViewModel _viewModel = SubjectsViewModel();

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
      appBar: AppBar(title: const Text("Materias")),
      body: ListView.builder(
        itemCount: _viewModel.subjects.length,
        itemBuilder: (context, index) {
          final subject = _viewModel.subjects[index];

          return ListTile(
            title: Text(subject.nombre),
            subtitle: Text("Créditos: ${subject.creditos}"),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _viewModel.removeSubject(subject.id);
              },
            ),
          );
        },
      ),
    );
  }
}