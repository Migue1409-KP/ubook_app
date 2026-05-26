import 'package:ubook_app/database/app_database.dart';
import 'career_repository.dart';

class CareerRepositoryProvider {
  static CareerRepository? _instance;

  static Future<CareerRepository> initialize(AppDatabase database) async {
    final repository = FloorCareerRepository.initialize(database);
    await repository.ensureInitialized();
    _instance = repository;
    return repository;
  }

  static CareerRepository get instance {
    final repository = _instance;
    if (repository == null) {
      throw StateError(
        'CareerRepositoryProvider.initialize() must be called before using careers.',
      );
    }
    return repository;
  }
}