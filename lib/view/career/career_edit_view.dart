import 'package:flutter/material.dart';
import 'package:ubook_app/model/career/career_model.dart';
import 'package:ubook_app/model/career/modality.dart';
import 'package:ubook_app/view_model/career/career_view_model.dart';
import 'package:ubook_app/widgets/career/app_button.dart';
import 'package:ubook_app/widgets/career/app_text_file.dart';

class CareerEditView extends StatefulWidget {
  final Career career;
  final CareerViewModel vm;

  const CareerEditView({
    super.key,
    required this.career,
    required this.vm,
  });

  @override
  State<CareerEditView> createState() => _CareerEditViewState();
}

class _CareerEditViewState extends State<CareerEditView> {
  late final TextEditingController nameController =
      TextEditingController(text: widget.career.name);

  late final TextEditingController semestersController =
      TextEditingController(text: widget.career.semesters.toString());

  late final TextEditingController creditsController =
      TextEditingController(text: widget.career.credits.toString());

  Modality? _selectedModality;

  @override
  void initState() {
    super.initState();
    widget.vm.addListener(_onVmChanged);
    _syncSelectedFromVm();
  }

  void _onVmChanged() {
    if (!mounted) return;
    _syncSelectedFromVm();
    setState(() {});
  }

  /// Reconciliar la modalidad guardada en la carrera con el catálogo remoto.
  /// Si el id está en la lista usamos esa instancia (para que el Dropdown
  /// reconozca el valor); si no, sintetizamos uno con el nombre cacheado.
  void _syncSelectedFromVm() {
    final id = widget.career.modalityId;
    if (id == null) {
      _selectedModality = null;
      return;
    }
    final fromCatalog = widget.vm.findModalityById(id);
    if (fromCatalog != null) {
      _selectedModality = fromCatalog;
    } else if (widget.career.modalityName != null) {
      _selectedModality = Modality(id: id, nombre: widget.career.modalityName!);
    }
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

    final updated = widget.career.copyWith(
      name: name,
      semesters: semesters,
      credits: credits,
      modalityId: _selectedModality!.id,
      modalityName: _selectedModality!.nombre,
    );

    widget.vm.updateCareer(updated);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Carrera"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              label: "Nombre de la carrera",
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
              text: "Guardar carrera",
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

    // Combinar catálogo remoto con la modalidad guardada (si no estuviera
    // ya en el catálogo) para no perder el valor actual al editar.
    final items = <Modality>[...vm.modalities];
    if (_selectedModality != null &&
        !items.any((m) => m.id == _selectedModality!.id)) {
      items.add(_selectedModality!);
    }

    if (items.isEmpty) {
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
          items: items
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
