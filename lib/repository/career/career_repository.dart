import 'package:ubook_app/database/app_database.dart';
import 'package:ubook_app/model/career/career_entity.dart';
import 'package:ubook_app/model/career/career_model.dart';

abstract class CareerRepository {
  Future<void> ensureInitialized();
  Future<List<Career>> getAll();
  Future<Career?> getById(String id);
  Future<Career> save(Career career);
  Future<void> delete(Career career);
}

class FloorCareerRepository implements CareerRepository {
  FloorCareerRepository._(this._database);

  static FloorCareerRepository? _instance;

  static FloorCareerRepository initialize(AppDatabase database) {
    _instance ??= FloorCareerRepository._(database);
    return _instance!;
  }

  final AppDatabase _database;

  final List<Career> _seedCareers = [
    Career(
      id: 'CAR-001',
      name: 'Ingeniería de Sistemas',
      educationalCenterId: 'EDU-001',
      semesters: 10,
      credits: 180,
      subjects: ['SUB-001', 'SUB-002'],
      reviews: ['REV-CAR-001'],
    ),
    Career(
      id: 'CAR-002',
      name: 'Administración de Empresas',
      educationalCenterId: 'EDU-001',
      semesters: 8,
      credits: 160,
      subjects: ['SUB-003'],
      reviews: ['REV-CAR-002'],
    ),
    Career(
      id: 'CAR-003',
      name: 'Diseño Gráfico',
      educationalCenterId: 'EDU-002',
      semesters: 8,
      credits: 150,
      reviews: ['REV-CAR-003'],
    ),
  ];

  @override
  Future<void> ensureInitialized() async {
    final count = await _database.careerDao.countCareers() ?? 0;
    if (count == 0) {
      await _database.careerDao.upsertCareers(
        _seedCareers.map(CareerEntity.fromCareer).toList(),
      );
    }
  }

  @override
  Future<List<Career>> getAll() async {
    final entities = await _database.careerDao.findAll();
    return entities.map((e) => e.toCareer()).toList();
  }

  @override
  Future<Career?> getById(String id) async {
    final entity = await _database.careerDao.findById(id);
    return entity?.toCareer();
  }

  @override
  Future<Career> save(Career career) async {
    await _database.careerDao.upsertCareer(CareerEntity.fromCareer(career));
    return career;
  }

  @override
  Future<void> delete(Career career) async {
    await _database.careerDao.deleteCareer(CareerEntity.fromCareer(career));
  }
}