import '../../model/process/process_model.dart';

abstract class ProcessRepository {
  Future<List<ProcessModel>> getProcesses();
  Future<void> addProcess(ProcessModel process);
  Future<void> updateProcess(ProcessModel process);
  Future<void> deleteProcess(String processId);
}

class InMemoryProcessRepository implements ProcessRepository {
  final List<ProcessModel> _processes = [
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

  @override
  Future<List<ProcessModel>> getProcesses() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List<ProcessModel>.from(_processes);
  }

  @override
  Future<void> addProcess(ProcessModel process) async {
    await Future.delayed(const Duration(seconds: 1));
    _processes.add(process);
  }

  @override
  Future<void> updateProcess(ProcessModel process) async {
    await Future.delayed(const Duration(seconds: 1));
    final index = _processes.indexWhere((p) => p.id == process.id);
    if (index != -1) {
      _processes[index] = process;
    }
  }

  @override
  Future<void> deleteProcess(String processId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _processes.removeWhere((p) => p.id == processId);
  }
}
