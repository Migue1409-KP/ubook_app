import '../../database/app_database.dart';
import 'pqrs_repository.dart';
import 'FirestorePQRSRepository.dart';
import 'SyncingPQRSRepository.dart';

class PQRSRepositoryProvider {

  static PQRSRepository? _instance;

  static Future<PQRSRepository> initialize(
    AppDatabase database,
  ) async {

    final localRepository =
    FloorPQRSRepository.initialize(database);

    final remoteRepository =
        FirestorePQRSRepository.initialize();

    final repository =
        SyncingPQRSRepository.initialize(
          localRepository,
          remoteRepository,
        );

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
