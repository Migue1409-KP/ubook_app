import '../model/educational_center/educational_center_model.dart';

class EducationalCenterViewModel {
  final List<EducationalCenter> centers = [
    EducationalCenter(id: '1', name: 'Universidad Nacional'),
    EducationalCenter(id: '2', name: 'Instituto Tecnológico de Medellín'),
  ];

  List<EducationalCenter> searchCenter(String query) {
    if (query.isEmpty) {
      return centers;
    }

    return centers
        .where(
          (center) => center.name.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }
}
