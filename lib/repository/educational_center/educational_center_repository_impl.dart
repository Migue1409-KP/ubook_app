import 'package:ubook_app/database/app_database.dart';
import 'package:ubook_app/model/educational_center/educational_center_model.dart';
import 'package:ubook_app/model/educational_center/educational_center_model_repository.dart';
import 'package:ubook_app/repository/educational_center/educational_center_dao.dart';

class EducationalCenterRepositoryImpl implements EducationalCenterRepository {
  // Constructor privado
  EducationalCenterRepositoryImpl._(this._database);

  // Instancia única (Singleton)
  static late final EducationalCenterRepositoryImpl instance;

  // Método de inicialización idéntico al del equipo
  static EducationalCenterRepositoryImpl initialize(AppDatabase database) {
    instance = EducationalCenterRepositoryImpl._(database);
    return instance;
  }

  final AppDatabase _database;

  // Obtenemos el DAO directamente a través de la base de datos central
  EducationalCenterDao get _educationalCenterDao => _database.educationalCenterDao;

  @override
  Future<List<EducationalCenter>> getLocalEducationalCenters() {
    // Si tus compañeros los llamaron diferente, usualmente es sin el sufijo largo
    return _database.educationalCenterDao.findAll();
  }

  @override
  Future<void> saveLocalEducationalCenter(EducationalCenter center) {
    return _database.educationalCenterDao.insertCenter(center);
  }

  @override
  Future<void> deleteLocalEducationalCenter(String id) async {
    final center = await _database.educationalCenterDao.findById(id);
    if (center != null) {
      await _database.educationalCenterDao.deleteCenter(center);
    }
  }
}