import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_model/computer_lab_form_view_model.dart';
import '../../model/computer_lab/computer_lab.dart';
import '../../model/computer_lab/computer_lab_repository.dart';
import '../../view_model/computer_count_provider.dart';

class ComputerLabFormView extends StatefulWidget {
  const ComputerLabFormView({super.key});

  @override
  State<ComputerLabFormView> createState() => _ComputerLabFormViewState();
}

class _ComputerLabFormViewState extends State<ComputerLabFormView> {
  ComputerLabFormViewModel? _vm;
  bool _didInitialize = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInitialize) {
      return;
    }

    final repository = context.read<ComputerLabRepository>();
    final viewModel = ComputerLabFormViewModel(repository: repository);
    viewModel.addListener(_handleViewModelChange);
    _vm = viewModel;
    _didInitialize = true;
    _loadSavedLabs();
  }

  Future<void> _loadSavedLabs() async {
    final viewModel = _vm;
    if (viewModel == null) {
      return;
    }

    await viewModel.loadSavedLabs();
    if (!mounted) {
      return;
    }

    final totalComputers = viewModel.savedLabs.fold<int>(
      0,
      (sum, lab) => sum + lab.capacity,
    );
    context.read<ComputerCountProvider>().setTotalComputers(totalComputers);
  }

  void _handleViewModelChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _vm?.removeListener(_handleViewModelChange);
    _vm?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = _vm;
    if (vm == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Computer Lab Form')),
      body: Form(
        key: vm.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.meeting_room),
                      const SizedBox(width: 8),
                      Text(
                        'Total laboratorios: ${vm.storedLabCount}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
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
              if (vm.isLoadingLabs)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (vm.savedLabs.isNotEmpty) ...[
                Text(
                  'Computers almacenados',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 220,
                  child: ListView.separated(
                    itemCount: vm.savedLabs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final lab = vm.savedLabs[index];
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(child: Text('${index + 1}')),
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
                    separatorBuilder: (_, index) => const SizedBox(height: 8),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              TextFormField(
                controller: vm.nameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'e.g., Lab A',
                ),
                validator: (v) => vm.validateRequired(v, field: 'Name'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: vm.buildingController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Building',
                  hintText: 'e.g., Main Building',
                ),
                validator: (v) => vm.validateRequired(v, field: 'Building'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: vm.roomNumberController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Room Number',
                  hintText: 'e.g., 204B',
                ),
                validator: (v) => vm.validateRequired(v, field: 'Room Number'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: vm.capacityController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Número de computadoras',
                  hintText: 'p. ej., 30',
                ),
                validator: (v) =>
                    vm.validatePositiveInt(v, field: 'Número de computadoras'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Available'),
                  const SizedBox(width: 8),
                  Switch(
                    value: vm.available,
                    onChanged: (val) {
                      setState(() => vm.available = val);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: vm.equipmentController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Equipment (comma separated)',
                  hintText: 'Projector, 3D Printer, VR Headsets',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: vm.notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: vm.isSaving
                    ? null
                    : () async {
                        final counter = context.read<ComputerCountProvider>();
                        final messenger = ScaffoldMessenger.of(context);
                        final ComputerLab? saved = await vm.submit();
                        if (saved != null && mounted) {
                          // Add the number of computers to the counter
                          counter.addComputers(saved.capacity);
                          vm.clearForm();
                          messenger.showSnackBar(
                            const SnackBar(content: Text('Computer Lab saved')),
                          );
                        }
                      },
                icon: vm.isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: Text(vm.isSaving ? 'Saving...' : 'Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
