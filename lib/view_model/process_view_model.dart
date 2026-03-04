import 'package:flutter/material.dart';
import '../model/process/process_model.dart';

class ProcessViewModel extends ChangeNotifier {
  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  // Dummy data for Processes
  final List<ProcessModel> _processes = [
    // ===== PROCESOS DE CARRERA =====
    ProcessModel(
      id: 'proc_001',
      name: 'Inscripción de Carrera',
      description:
          'Proceso para inscribir una nueva carrera universitaria. Permite a los estudiantes registrarse oficialmente en el programa académico.',
      requiredDocuments: [
        'Documento de identidad',
        'Certificado de bachillerato',
        'Formulario de inscripción',
        'Foto 3x4',
      ],
      processType: ProcessType.career,
      relatedId: 'career_001',
      isActive: true,
    ),
    ProcessModel(
      id: 'proc_002',
      name: 'Solicitud de Certificado Académico',
      description:
          'Solicitud de certificado oficial que acredita estar cursando una carrera o haber completado semestres.',
      requiredDocuments: [
        'Documento de identidad',
        'Recibo de pago',
        'Formulario de solicitud',
      ],
      processType: ProcessType.career,
      relatedId: 'career_001',
      isActive: true,
    ),
    ProcessModel(
      id: 'proc_003',
      name: 'Retiro de Carrera',
      description:
          'Proceso para retirarse formalmente de una carrera universitaria. Incluye cancelación de matrícula.',
      requiredDocuments: [
        'Documento de identidad',
        'Carta de retiro',
        'Paz y salvo académico',
        'Paz y salvo financiero',
      ],
      processType: ProcessType.career,
      isActive: true,
    ),
    // ===== PROCESOS DE MATERIA =====
    ProcessModel(
      id: 'proc_004',
      name: 'Cancelación de Materia',
      description:
          'Permite cancelar una materia antes de la fecha límite sin afectar el promedio académico.',
      requiredDocuments: [
        'Documento de identidad',
        'Formulario de cancelación',
        'Justificación escrita',
      ],
      processType: ProcessType.subject,
      relatedId: 'subject_001',
      isActive: true,
    ),
    ProcessModel(
      id: 'proc_005',
      name: 'Solicitud de Examen Supletorio',
      description:
          'Proceso para solicitar un examen supletorio cuando se reprueba el examen final por primera vez.',
      requiredDocuments: [
        'Documento de identidad',
        'Solicitud formal',
        'Recibo de pago',
        'Justificación académica',
      ],
      processType: ProcessType.subject,
      relatedId: 'subject_002',
      isActive: true,
    ),
    ProcessModel(
      id: 'proc_006',
      name: 'Solicitud de Retroalimentación',
      description:
          'Permite solicitar retroalimentación detallada sobre calificaciones o evaluaciones de una materia.',
      requiredDocuments: ['Documento de identidad', 'Formato de solicitud'],
      processType: ProcessType.subject,
      relatedId: 'subject_003',
      isActive: true,
    ),
    ProcessModel(
      id: 'proc_007',
      name: 'Inscripción de Materia',
      description:
          'Proceso para inscribirse en una nueva materia durante el período de matrículas.',
      requiredDocuments: [
        'Documento de identidad',
        'Recibo de pago',
        'Formulario de inscripción',
      ],
      processType: ProcessType.subject,
      isActive: true,
    ),
    ProcessModel(
      id: 'proc_008',
      name: 'Revisión de Examen',
      description:
          'Solicitud para revisar un examen y verificar la calificación obtenida. Disponible 5 días después de publicadas las notas.',
      requiredDocuments: [
        'Documento de identidad',
        'Solicitud de revisión',
        'Copia del examen (si está disponible)',
      ],
      processType: ProcessType.subject,
      relatedId: 'subject_001',
      isActive: false,
    ),
  ];

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

    // Simulación de carga
    await Future.delayed(const Duration(seconds: 1));
    if (_disposed) return;

    _processes.add(process);
    _isLoading = false;
    notifyListeners();
  }

  // Update process (mockup)
  Future<void> updateProcess(ProcessModel process) async {
    _isLoading = true;
    notifyListeners();

    // Simulación de carga
    await Future.delayed(const Duration(seconds: 1));
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

    // Simulación de carga
    await Future.delayed(const Duration(milliseconds: 500));
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
