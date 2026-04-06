import 'package:flutter/material.dart';
import '../model/process/process_model.dart';
import '../repository/process/process_repository.dart';

class ProcessViewModel extends ChangeNotifier {
  ProcessViewModel({
    ProcessRepository? repository,
    this.educationalCenterId,
    this.educationalCenterName,
    this.subjectId,
    this.subjectName,
  }) : _repository = repository ?? InMemoryProcessRepository() {
    loadProcesses();
  }

  final ProcessRepository _repository;
  final String? educationalCenterId;
  final String? educationalCenterName;
  final String? subjectId;
  final String? subjectName;
  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  List<ProcessModel> _processes = [];

  // Filter state
  String _selectedFilter = 'Todos';

  // Loading state
  bool _isLoading = false;

  // Getters
  List<ProcessModel> get processes => _getFilteredProcesses();
  String get selectedFilter => _selectedFilter;
  bool get isLoading => _isLoading;
  bool get isEducationalCenterScoped => educationalCenterId != null;
  bool get isSubjectScoped => subjectId != null;
  List<String> get filterOptions {
    if (isEducationalCenterScoped) {
      return const ['Todos', 'Centro educativo', 'Activos', 'Inactivos'];
    }
    if (isSubjectScoped) {
      return const ['Todos', 'Materia', 'Activos', 'Inactivos'];
    }
    return const [
      'Todos',
      'Carrera',
      'Materia',
      'Centro educativo',
      'Activos',
      'Inactivos',
    ];
  }

  Future<void> loadProcesses() async {
    _isLoading = true;
    notifyListeners();

    final processes = await _repository.getProcesses();
    if (_disposed) return;

    if (isEducationalCenterScoped) {
      _processes = processes
          .where(
            (p) =>
                p.processType == ProcessType.educationalCenter &&
                p.relatedId == educationalCenterId,
          )
          .toList();
    } else if (isSubjectScoped) {
      _processes = processes
          .where(
            (p) =>
                p.processType == ProcessType.subject &&
                p.relatedId == subjectId,
          )
          .toList();
    } else {
      _processes = processes;
    }
    _isLoading = false;
    notifyListeners();
  }

  // Get filtered processes based on selected filter
  List<ProcessModel> _getFilteredProcesses() {
    switch (_selectedFilter) {
      case 'Carrera':
        return List.unmodifiable(
          _processes.where((p) => p.processType == ProcessType.career),
        );
      case 'Materia':
        return List.unmodifiable(
          _processes.where((p) => p.processType == ProcessType.subject),
        );
      case 'Centro educativo':
        return List.unmodifiable(
          _processes.where(
            (p) => p.processType == ProcessType.educationalCenter,
          ),
        );
      case 'Activos':
        return List.unmodifiable(_processes.where((p) => p.isActive));
      case 'Inactivos':
        return List.unmodifiable(_processes.where((p) => !p.isActive));
      default:
        return List.unmodifiable(_processes);
    }
  }

  // Set filter
  void setFilter(String filter) {
    if (!filterOptions.contains(filter)) return;
    _selectedFilter = filter;
    notifyListeners();
  }

  // Add process (mockup)
  Future<void> addProcess(ProcessModel process) async {
    _isLoading = true;
    notifyListeners();

    final processToSave = isEducationalCenterScoped
        ? process.copyWith(
            processType: ProcessType.educationalCenter,
            relatedId: educationalCenterId,
          )
        : isSubjectScoped
        ? process.copyWith(
            processType: ProcessType.subject,
            relatedId: subjectId,
          )
        : process;

    await _repository.addProcess(processToSave);
    if (_disposed) return;

    _processes.add(processToSave);
    _isLoading = false;
    notifyListeners();
  }

  // Update process (mockup)
  Future<void> updateProcess(ProcessModel process) async {
    _isLoading = true;
    notifyListeners();

    final processToSave = isEducationalCenterScoped
        ? process.copyWith(
            processType: ProcessType.educationalCenter,
            relatedId: educationalCenterId,
          )
        : isSubjectScoped
        ? process.copyWith(
            processType: ProcessType.subject,
            relatedId: subjectId,
          )
        : process;

    await _repository.updateProcess(processToSave);
    if (_disposed) return;

    final index = _processes.indexWhere((p) => p.id == processToSave.id);
    if (index != -1) {
      _processes[index] = processToSave;
    }
    _isLoading = false;
    notifyListeners();
  }

  // Delete process (mockup)
  Future<void> deleteProcess(String processId) async {
    _isLoading = true;
    notifyListeners();

    await _repository.deleteProcess(processId);
    if (_disposed) return;

    _processes.removeWhere((p) => p.id == processId);
    _isLoading = false;
    notifyListeners();
  }

  // Restore a previously deleted process at a specific index
  void restoreProcess(ProcessModel process, int index) {
    if (_disposed) return;
    if (index >= 0 && index <= _processes.length) {
      _processes.insert(index, process);
    } else {
      _processes.add(process);
    }
    _repository.addProcess(process);
    notifyListeners();
  }

  // Get the raw index of a process in the internal list
  int indexOfProcess(ProcessModel process) {
    return _processes.indexOf(process);
  }

  // Get process by ID
  ProcessModel? getProcessById(String id) {
    try {
      return _processes.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
}
