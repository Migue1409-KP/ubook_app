import 'review_repository.dart';

class ReviewRepositoryProvider {
  static ReviewRepository? _instance;

  static Future<void> initialize() async {
    final repository = FloorReviewRepository();
    await repository.init();
    _instance = repository;
  }

  static ReviewRepository getInstance() {
    return _instance ?? _fallbackRepository();
  }

  static ReviewRepository _fallbackRepository() {
    throw StateError(
      'ReviewRepositoryProvider has not been initialized. '
      'Call ReviewRepositoryProvider.initialize() in main() first.',
    );
  }
}
