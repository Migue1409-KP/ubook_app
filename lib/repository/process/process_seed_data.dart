import '../../model/process/process_model.dart';

List<ProcessModel> buildDefaultProcessSeed() {
  return const [
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
    ProcessModel(
      id: 'proc_ec_001',
      name: 'Homologación de Estudios Externos',
      description:
          'Proceso institucional para validar y homologar estudios realizados en otra institución educativa.',
      requiredDocuments: [
        'Documento de identidad',
        'Certificados de notas originales',
        'Syllabus oficial de asignaturas',
        'Formulario de homologación',
      ],
      processType: ProcessType.educationalCenter,
      relatedId: '1',
      isActive: true,
    ),
    ProcessModel(
      id: 'proc_ec_002',
      name: 'Solicitud de Beca Institucional',
      description:
          'Permite aplicar a becas internas para estudiantes de alto rendimiento o con necesidad económica.',
      requiredDocuments: [
        'Documento de identidad',
        'Certificado de ingresos familiares',
        'Historial académico',
        'Carta de motivación',
      ],
      processType: ProcessType.educationalCenter,
      relatedId: '1',
      isActive: true,
    ),
    ProcessModel(
      id: 'proc_ec_003',
      name: 'Reingreso Estudiantil',
      description:
          'Proceso para que estudiantes retirados puedan reactivar su matrícula en periodos posteriores.',
      requiredDocuments: [
        'Documento de identidad',
        'Solicitud de reingreso',
        'Paz y salvo financiero',
      ],
      processType: ProcessType.educationalCenter,
      relatedId: '2',
      isActive: true,
    ),
    ProcessModel(
      id: 'proc_ec_004',
      name: 'Actualización de Datos Institucionales',
      description:
          'Trámite para actualizar información personal y académica en el sistema del centro educativo.',
      requiredDocuments: [
        'Documento de identidad',
        'Formulario de actualización',
      ],
      processType: ProcessType.educationalCenter,
      relatedId: '2',
      isActive: true,
    ),
    ProcessModel(
      id: 'proc_ec_005',
      name: 'Certificado de Matrícula Vigente',
      description:
          'Expedición de constancia oficial de matrícula activa para trámites externos.',
      requiredDocuments: [
        'Documento de identidad',
        'Comprobante de pago del semestre',
      ],
      processType: ProcessType.educationalCenter,
      relatedId: '3',
      isActive: true,
    ),
    ProcessModel(
      id: 'proc_ec_006',
      name: 'Cambio de Jornada Académica',
      description:
          'Solicitud para cambiar de jornada (diurna/nocturna) según disponibilidad institucional.',
      requiredDocuments: [
        'Documento de identidad',
        'Carta de solicitud',
        'Soportes laborales o personales',
      ],
      processType: ProcessType.educationalCenter,
      relatedId: '3',
      isActive: false,
    ),
    ProcessModel(
      id: 'proc_sub_001',
      name: 'Validación de Prerrequisitos',
      description:
          'Verifica cumplimiento de prerrequisitos antes de habilitar matrícula en Ing Software 4.',
      requiredDocuments: ['Historial académico', 'Solicitud de validación'],
      processType: ProcessType.subject,
      relatedId: 'subject-1',
      isActive: true,
    ),
    ProcessModel(
      id: 'proc_sub_002',
      name: 'Inscripción de Proyecto de Curso',
      description:
          'Registra el proyecto semestral y asigna docente guía para la materia Ing Software 4.',
      requiredDocuments: ['Formato de propuesta', 'Cronograma de trabajo'],
      processType: ProcessType.subject,
      relatedId: 'subject-1',
      isActive: true,
    ),
    ProcessModel(
      id: 'proc_sub_003',
      name: 'Solicitud de Habilitación',
      description:
          'Permite solicitar evaluación de habilitación para Bases de Datos según reglamento.',
      requiredDocuments: [
        'Documento de identidad',
        'Comprobante de pago',
        'Formulario de solicitud',
      ],
      processType: ProcessType.subject,
      relatedId: 'subject-2',
      isActive: true,
    ),
    ProcessModel(
      id: 'proc_sub_004',
      name: 'Revisión de Nota Final',
      description:
          'Proceso para revisión formal de nota final en Bases de Datos.',
      requiredDocuments: ['Solicitud firmada', 'Soporte de evaluación'],
      processType: ProcessType.subject,
      relatedId: 'subject-2',
      isActive: false,
    ),
    ProcessModel(
      id: 'proc_sub_005',
      name: 'Cambio de Grupo',
      description:
          'Solicitud de cambio de grupo para Redes de Datos por cruce de horario.',
      requiredDocuments: ['Carta de solicitud', 'Horario actual'],
      processType: ProcessType.subject,
      relatedId: 'subject-3',
      isActive: true,
    ),
    ProcessModel(
      id: 'proc_sub_006',
      name: 'Tutoría Académica',
      description:
          'Permite solicitar acompañamiento adicional en temas críticos de Redes de Datos.',
      requiredDocuments: ['Formato de tutoría'],
      processType: ProcessType.subject,
      relatedId: 'subject-3',
      isActive: true,
    ),
    ProcessModel(
      id: 'proc_car_001',
      name: 'Inscripción Inicial de Carrera',
      description:
          'Proceso para formalizar el ingreso a Ingeniería de Sistemas.',
      requiredDocuments: [
        'Documento de identidad',
        'Acta de grado',
        'Formulario de inscripción',
      ],
      processType: ProcessType.career,
      relatedId: 'DUMMY-Ingeniería de Sistemas',
      isActive: true,
    ),
    ProcessModel(
      id: 'proc_car_002',
      name: 'Homologación de Asignaturas',
      description:
          'Permite homologar asignaturas previas para Ingeniería de Sistemas.',
      requiredDocuments: ['Certificados de notas', 'Contenidos programáticos'],
      processType: ProcessType.career,
      relatedId: 'DUMMY-Ingeniería de Sistemas',
      isActive: true,
    ),
    ProcessModel(
      id: 'proc_car_003',
      name: 'Internado Rotatorio',
      description:
          'Asignación y gestión de internado para estudiantes de Medicina.',
      requiredDocuments: ['Historial académico', 'Póliza vigente'],
      processType: ProcessType.career,
      relatedId: 'DUMMY-Medicina',
      isActive: true,
    ),
    ProcessModel(
      id: 'proc_car_004',
      name: 'Práctica Jurídica',
      description: 'Proceso para inscripción de práctica jurídica en Derecho.',
      requiredDocuments: ['Solicitud de práctica', 'Carta de aceptación'],
      processType: ProcessType.career,
      relatedId: 'DUMMY-Derecho',
      isActive: true,
    ),
    ProcessModel(
      id: 'proc_car_005',
      name: 'Proyecto de Grado',
      description:
          'Registro y seguimiento del proyecto de grado de Administración de Empresas.',
      requiredDocuments: ['Anteproyecto', 'Cronograma'],
      processType: ProcessType.career,
      relatedId: 'DUMMY-Administración de Empresas',
      isActive: true,
    ),
    ProcessModel(
      id: 'proc_car_006',
      name: 'Práctica Profesional Supervisada',
      description: 'Trámite para práctica profesional de Psicología.',
      requiredDocuments: ['Carta de solicitud', 'Afiliación a ARL'],
      processType: ProcessType.career,
      relatedId: 'DUMMY-Psicología',
      isActive: true,
    ),
  ];
}
