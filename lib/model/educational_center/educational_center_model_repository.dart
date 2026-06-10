import 'package:ubook_app/model/educational_center/educational_center_model.dart';

abstract class EducationalCenterRepository {
  /// Obtiene la lista de todos los centros educativos guardados localmente
  Future<List<EducationalCenter>> getLocalEducationalCenters();

  /// Guarda o actualiza un centro educativo en la base de datos local
  Future<void> saveLocalEducationalCenter(EducationalCenter center);

  /// Elimina un centro educativo de la base de datos local por su ID
  Future<void> deleteLocalEducationalCenter(String id);
}