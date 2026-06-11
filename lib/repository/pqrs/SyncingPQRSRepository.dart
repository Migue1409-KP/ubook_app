import '../../model/pqrs/pqrs.dart';
import 'pqrs_repository.dart';

class SyncingPQRSRepository implements PQRSRepository {

  SyncingPQRSRepository._(
    this._localRepository,
    this._remoteRepository,
  );

  static late final SyncingPQRSRepository instance;

  static SyncingPQRSRepository initialize(
    PQRSRepository localRepository,
    PQRSRepository remoteRepository,
  ) {

    instance = SyncingPQRSRepository._(
      localRepository,
      remoteRepository,
    );

    return instance;
  }

  final PQRSRepository _localRepository;
  final PQRSRepository _remoteRepository;

  @override
  Future<void> ensureInitialized() async {

    await _localRepository.ensureInitialized();
    await _remoteRepository.ensureInitialized();
  }

  @override
  Future<List<PQRS>> getAll() async {

    try {
      return await _remoteRepository.getAll();
    } catch (_) {
      return await _localRepository.getAll();
    }
  }

  @override
  Future<PQRS> save(PQRS pqrs) async {

    final saved =
        await _localRepository.save(pqrs);

    try {
      await _remoteRepository.save(saved);
    } catch (_) {}

    return saved;
  }

  @override
  Future<void> delete(PQRS pqrs) async {

    await _localRepository.delete(pqrs);

    try {
      await _remoteRepository.delete(pqrs);
    } catch (_) {}
  }
}