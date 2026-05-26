import 'package:flutter/material.dart';
import 'package:ubook_app/model/career/career_model.dart';
import 'package:ubook_app/model/career/modality.dart';
import 'package:ubook_app/view_model/career/career_view_model.dart';
import 'package:ubook_app/widgets/career/app_button.dart';
import 'package:ubook_app/widgets/career/app_text_file.dart';

class CareerCreateView extends StatefulWidget {
  final CareerViewModel vm;
  final String educationalCenterId;

  const CareerCreateView({
    super.key,
    required this.vm,
    required this.educationalCenterId,
  });

  @override
  State<CareerCreateView> createState() => _CareerCreateViewState();
}

class _CareerCreateViewState extends State<CareerCreateView> {
  final nameController = TextEditingController();
  final semestersController = TextEditingController();
  final creditsController = TextEditingController();
  Modality? _selectedModality;

  @override
  void initState() {
    super.initState();
    widget.vm.addListener(_onVmChanged);
  }

  void _onVmChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.vm.removeListener(_onVmChanged);
    nameController.dispose();
    semestersController.dispose();
    creditsController.dispose();
    super.dispose();
  }

  void _save(BuildContext context) {
    final name = nameController.text.trim();
    final semesters = int.tryParse(semestersController.text);
    final credits = int.tryParse(creditsController.text);

    if (name.isEmpty || semesters == null || credits == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor ingrese los campos correctamente"),
        ),
      );
      return;
    }

    if (_selectedModality == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecciona una modalidad")),
      );
      return;
    }

    final career = Career(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      educationalCenterId: widget.educationalCenterId,
      semesters: semesters,
      credits: credits,
      modalityId: _selectedModality!.id,
      modalityName: _selectedModality!.nombre,
      subjects: [],
      processes: [],
      reviews: [],
    );

    widget.vm.addCareer(career);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear Carrera"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              label: "Nombre De La Carrera",
              controller: nameController,
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: "Semestres",
              controller: semestersController,
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: "Creditos",
              controller: creditsController,
            ),
            const SizedBox(height: 16),
            _buildModalityDropdown(),
            const SizedBox(height: 30),
            AppButton(
              text: "Guardar Carrera",
              onPressed: () => _save(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModalityDropdown() {
    final vm = widget.vm;

    if (vm.modalitiesLoading) {
      return const Row(
        children: [
          SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 12),
          Text("Cargando modalidades..."),
        ],
      );
    }

    if (vm.modalities.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            vm.modalitiesWarning ?? "No hay modalidades disponibles",
            style: const TextStyle(color: Colors.redAccent, fontSize: 12),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: vm.loadModalities,
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text("Reintentar"),
          ),
        ],
      );
    }

    return InputDecorator(
      decoration: const InputDecoration(
        labelText: "Modalidad",
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Modality>(
          isExpanded: true,
          value: _selectedModality,
          hint: const Text("Selecciona una modalidad"),
          items: vm.modalities
              .map((m) => DropdownMenuItem(
                    value: m,
                    child: Text(m.nombre),
                  ))
              .toList(),
          onChanged: (m) => setState(() => _selectedModality = m),
        ),
      ),
    );
  }
}
