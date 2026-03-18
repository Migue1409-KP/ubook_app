import 'package:flutter/material.dart';
import '../model/process/process_model.dart';
import '../repository/process/process_repository.dart';

class ProcessViewModel extends ChangeNotifier {
  ProcessViewModel({ProcessRepository? repository})
    : _repository = repository ?? InMemoryProcessRepository() {
    loadProcesses();
  }

  final ProcessRepository _repository;
  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  List<ProcessModel> _processes = [];

  // Filter state
  String _selectedFilter = 'Todos';
  final List<String> filterOptions = [
    'Todos',
    'Carrera',
    'Materia',
    'Activos',
    'Inactivos',
  ];

  // Loading state
  bool _isLoading = false;

  // Getters
  List<ProcessModel> get processes => _getFilteredProcesses();
  String get selectedFilter => _selectedFilter;
  bool get isLoading => _isLoading;

  Future<void> loadProcesses() async {
    _isLoading = true;
    notifyListeners();

    final processes = await _repository.getProcesses();
    if (_disposed) return;

    _processes = processes;
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
    _selectedFilter = filter;
    notifyListeners();
  }

  // Add process (mockup)
  Future<void> addProcess(ProcessModel process) async {
    _isLoading = true;
    notifyListeners();

    await _repository.addProcess(process);
    if (_disposed) return;

    _processes.add(process);
    _isLoading = false;
    notifyListeners();
  }

  // Update process (mockup)
  Future<void> updateProcess(ProcessModel process) async {
    _isLoading = true;
    notifyListeners();

    await _repository.updateProcess(process);
    if (_disposed) return;

    final index = _processes.indexWhere((p) => p.id == process.id);
    if (index != -1) {
      _processes[index] = process;
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
