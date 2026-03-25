import 'subjects.dart';

class SubjectDummyData {
  SubjectDummyData._();

  static List<Subject> build() {
    return const [
      Subject(
        id: 'subject-1',
        nombre: 'Ing Software 4',
        horas: 4,
        creditos: 5,
        prerrequisitos: ['Ing Software 3'],
        contenido: 'No aplica',
      ),
      Subject(
        id: 'subject-2',
        nombre: 'Bases de Datos',
        horas: 4,
        creditos: 4,
        prerrequisitos: ['Programación 2'],
        contenido: 'Modelo relacional, SQL y normalización.',
      ),
      Subject(
        id: 'subject-3',
        nombre: 'Redes de Datos',
        horas: 3,
        creditos: 3,
        prerrequisitos: ['Telecomunicaciones 1'],
        contenido: 'Topologías, direccionamiento IP y switching.',
      ),
    ];
  }
}