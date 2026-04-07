import 'package:flutter/foundation.dart';
import '../../model/educational_center/educational_center_model.dart';

class EducationalCenterViewModel extends ChangeNotifier {
  final List<EducationalCenter> _centers = const [
    EducationalCenter(id: '1', name: 'Universidad Nacional'),
    EducationalCenter(id: '2', name: 'Universidad de los Andes'),
    EducationalCenter(id: '3', name: 'Universidad de Antioquia'),
    EducationalCenter(id: '4', name: 'Universidad del Valle'),
    EducationalCenter(id: '5', name: 'Pontificia Universidad Javeriana'),
  ];

  List<EducationalCenter> get centers => _centers;

  List<EducationalCenter> searchCenter(String query) {
    if (query.isEmpty) {
      return _centers;
    }

    return _centers
        .where(
          (center) => center.name.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }
}
