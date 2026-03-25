import 'package:flutter/foundation.dart';
import 'package:ubook_app/model/subjects/subject_dummy_data.dart';
import 'package:ubook_app/model/subjects/subjects.dart';

/// ViewModel aislado para la demo local del módulo de materias.
///
/// No hace integraciones reales y puede eliminarse sin afectar el resto del proyecto.
class SubjectsModalDemoViewModel extends ChangeNotifier {
  SubjectsModalDemoViewModel() : _subjects = List<Subject>.from(SubjectDummyData.build());

  final List<Subject> _subjects;
  String _search = '';

  List<Subject> get subjects {
    if (_search.trim().isEmpty) {
      return List<Subject>.unmodifiable(_subjects);
    }

    final query = _search.toLowerCase().trim();
    return List<Subject>.unmodifiable(
      _subjects.where((subject) {
        return subject.nombre.toLowerCase().contains(query) ||
            subject.contenido.toLowerCase().contains(query);
      }),
    );
  }

  void updateSearch(String value) {
    _search = value;
    notifyListeners();
  }

  void createSubject({
    required String nombre,
    required int horas,
    required int creditos,
    required String prerrequisitosText,
    required String contenido,
  }) {
    final subject = Subject(
      id: 'subject-${DateTime.now().microsecondsSinceEpoch}',
      nombre: nombre.trim(),
      horas: horas,
      creditos: creditos,
      prerrequisitos: _mapPrerequisites(prerrequisitosText),
      contenido: contenido.trim(),
    );

    _subjects.insert(0, subject);
    notifyListeners();
  }

  void updateSubject({
    required String id,
    required String nombre,
    required int horas,
    required int creditos,
    required String prerrequisitosText,
    required String contenido,
  }) {
    final index = _subjects.indexWhere((subject) => subject.id == id);
    if (index == -1) return;

    _subjects[index] = _subjects[index].copyWith(
      nombre: nombre.trim(),
      horas: horas,
      creditos: creditos,
      prerrequisitos: _mapPrerequisites(prerrequisitosText),
      contenido: contenido.trim(),
    );

    notifyListeners();
  }

  void deleteSubject(String id) {
    _subjects.removeWhere((subject) => subject.id == id);
    notifyListeners();
  }

  String serializePrerequisites(List<String> value) {
    if (value.isEmpty) return '';
    return value.join(', ');
  }

  List<String> _mapPrerequisites(String rawValue) {
    return rawValue
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }
}
