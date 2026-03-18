import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_model/computer_lab_form_view_model.dart';
import '../../model/computer_lab/computer_lab.dart';
import '../../view_model/computer_count_provider.dart';

class ComputerLabFormView extends StatefulWidget {
  const ComputerLabFormView({super.key});

  @override
  State<ComputerLabFormView> createState() => _ComputerLabFormViewState();
}

class _ComputerLabFormViewState extends State<ComputerLabFormView> {
  late final ComputerLabFormViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = ComputerLabFormViewModel();
    _vm.addListener(() => setState(() {}));
    _vm.loadSavedLabs();
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Computer Lab Form'),
      ),
      body: Form(
        key: _vm.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Counter visible in the view using Provider
              Consumer<ComputerCountProvider>(
                builder: (context, counter, _) => Card(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        const Icon(Icons.computer),
                        const SizedBox(width: 8),
                        Text(
                          'Total computadoras: ${counter.totalComputers}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (_vm.isLoadingLabs)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (_vm.savedLabs.isNotEmpty) ...[
                Text(
                  'Computers almacenados',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 220,
                  child: ListView.separated(
                    itemCount: _vm.savedLabs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final lab = _vm.savedLabs[index];
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text('${index + 1}'),
                          ),
                          title: Text(lab.name),
                          subtitle: Text(
                            '${lab.building} - ${lab.roomNumber}\n${lab.capacity} computadoras',
                          ),
                          isThreeLine: true,
                          trailing: Icon(
                            lab.available ? Icons.check_circle : Icons.cancel,
                            color: lab.available ? Colors.green : Colors.red,
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              TextFormField(
                controller: _vm.nameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'e.g., Lab A',
                ),
                validator: (v) => _vm.validateRequired(v, field: 'Name'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _vm.buildingController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Building',
                  hintText: 'e.g., Main Building',
                ),
                validator: (v) => _vm.validateRequired(v, field: 'Building'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _vm.roomNumberController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Room Number',
                  hintText: 'e.g., 204B',
                ),
                validator: (v) => _vm.validateRequired(v, field: 'Room Number'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _vm.capacityController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Número de computadoras',
                  hintText: 'p. ej., 30',
                ),
                validator: (v) => _vm.validatePositiveInt(v, field: 'Número de computadoras'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Available'),
                  const SizedBox(width: 8),
                  Switch(
                    value: _vm.available,
                    onChanged: (val) {
                      setState(() => _vm.available = val);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _vm.equipmentController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Equipment (comma separated)',
                  hintText: 'Projector, 3D Printer, VR Headsets',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _vm.notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _vm.isSaving
                    ? null
                    : () async {
                        final ComputerLab? saved = await _vm.submit();
                        if (saved != null && mounted) {
                          // Add the number of computers to the counter
                          context.read<ComputerCountProvider>().addComputers(saved.capacity);
                          _vm.clearForm();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Computer Lab saved')),
                          );
                        }
                      },
                icon: _vm.isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: Text(_vm.isSaving ? 'Saving...' : 'Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
