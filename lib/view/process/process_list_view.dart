import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/process/process_model.dart';
import '../../view_model/process_view_model.dart';
import '../../theme/app_colors.dart';
import '../../widgets/process/process_card.dart';
import '../../widgets/process/process_dialogs.dart';
import '../../widgets/process/process_empty_state.dart';

class ProcessListView extends StatelessWidget {
  const ProcessListView({
    super.key,
    this.educationalCenterId,
    this.educationalCenterName,
    this.subjectId,
    this.subjectName,
  });

  final String? educationalCenterId;
  final String? educationalCenterName;
  final String? subjectId;
  final String? subjectName;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProcessViewModel(
        educationalCenterId: educationalCenterId,
        educationalCenterName: educationalCenterName,
        subjectId: subjectId,
        subjectName: subjectName,
      ),
      child: Consumer<ProcessViewModel>(
        builder: (context, viewModel, _) => Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(
              educationalCenterName == null
                  ? (subjectName == null
                        ? 'Gestión de Procesos'
                        : 'Procesos de $subjectName')
                  : 'Procesos de $educationalCenterName',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            centerTitle: true,
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            elevation: 2,
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.filter_list),
                tooltip: 'Filtrar procesos',
                onSelected: viewModel.setFilter,
                itemBuilder: (context) => viewModel.filterOptions
                    .map(
                      (filter) => PopupMenuItem(
                        value: filter,
                        child: Row(
                          children: [
                            if (viewModel.selectedFilter == filter)
                              const Icon(
                                Icons.check,
                                size: 18,
                                color: AppColors.primary,
                              )
                            else
                              const SizedBox(width: 18),
                            const SizedBox(width: 8),
                            Text(filter),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
              IconButton(
                icon: const Icon(Icons.search),
                tooltip: 'Buscar proceso',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Funcionalidad de búsqueda próximamente'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
          body: viewModel.isLoading && viewModel.processes.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : viewModel.processes.isEmpty
              ? ProcessEmptyState(
                  message: educationalCenterName == null
                      ? (subjectName == null
                            ? 'No hay procesos'
                            : 'No hay procesos para $subjectName')
                      : 'No hay procesos para $educationalCenterName',
                )
              : _buildProcessList(context, viewModel),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _handleAddProcess(context, viewModel),
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            icon: const Icon(Icons.add),
            label: const Text(
              'Nuevo Proceso',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            elevation: 4,
          ),
        ),
      ),
    );
  }

  Widget _buildProcessList(BuildContext context, ProcessViewModel viewModel) {
    final processes = viewModel.processes;
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: processes.length,
      itemBuilder: (context, index) {
        final process = processes[index];
        return ProcessCard(
          process: process,
          onViewDetails: () => _handleViewDetails(context, process),
          onEdit: () => _handleEditProcess(context, viewModel, process),
          onDelete: () => _handleDeleteProcess(context, process, viewModel),
        );
      },
    );
  }

  void _handleAddProcess(BuildContext context, ProcessViewModel viewModel) {
    showProcessFormDialog(
      context: context,
      viewModel: viewModel,
      lockedType: viewModel.isEducationalCenterScoped
          ? ProcessType.educationalCenter
          : viewModel.isSubjectScoped
          ? ProcessType.subject
          : null,
      lockedRelatedId: viewModel.isEducationalCenterScoped
          ? viewModel.educationalCenterId
          : viewModel.subjectId,
      scopeLabel: viewModel.isEducationalCenterScoped
          ? viewModel.educationalCenterName
          : viewModel.subjectName,
    );
  }

  void _handleEditProcess(
    BuildContext context,
    ProcessViewModel viewModel,
    ProcessModel process,
  ) {
    showProcessFormDialog(
      context: context,
      viewModel: viewModel,
      process: process,
      lockedType: viewModel.isEducationalCenterScoped
          ? ProcessType.educationalCenter
          : viewModel.isSubjectScoped
          ? ProcessType.subject
          : null,
      lockedRelatedId: viewModel.isEducationalCenterScoped
          ? viewModel.educationalCenterId
          : viewModel.subjectId,
      scopeLabel: viewModel.isEducationalCenterScoped
          ? viewModel.educationalCenterName
          : viewModel.subjectName,
    );
  }

  void _handleViewDetails(BuildContext context, ProcessModel process) {
    showProcessDetailsDialog(context: context, process: process);
  }

  void _handleDeleteProcess(
    BuildContext context,
    ProcessModel process,
    ProcessViewModel viewModel,
  ) {
    showDeleteProcessDialog(
      context: context,
      process: process,
      viewModel: viewModel,
    );
  }
}
