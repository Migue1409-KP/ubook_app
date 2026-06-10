import '../../database/app_database.dart';
import 'pqrs_repository.dart';

class PQRSRepositoryProvider {

  static PQRSRepository? _instance;

  static Future<PQRSRepository> initialize(
    AppDatabase database,
  ) async {

    final repository =
        FloorPQRSRepository.initialize(database);

    await repository.ensureInitialized();

    _instance = repository;

    return repository;
  }

  static PQRSRepository get instance {

    final repository = _instance;

    if (repository == null) {
      throw StateError(
        'PQRSRepositoryProvider.initialize() must be called first'
      );
    }

    return repository;
  }
}
