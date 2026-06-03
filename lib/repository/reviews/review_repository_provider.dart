import 'package:ubook_app/database/app_database.dart';

import 'review_repository.dart';

class ReviewRepositoryProvider {
  static ReviewRepository? _instance;

  static Future<ReviewRepository> initialize(AppDatabase database) async {
    final repository = FloorReviewRepository.initialize(database);
    await repository.ensureInitialized();
    _instance = repository;
    return repository;
  }

  static ReviewRepository get instance {
    final repository = _instance;
    if (repository == null) {
      throw StateError(
        'ReviewRepositoryProvider.initialize() must be called before using reviews.',
      );
    }
    return repository;
  }
}
