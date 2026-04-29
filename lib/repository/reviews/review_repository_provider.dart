import 'review_repository.dart';

/// Singleton para acceder al repositorio de reseñas desde cualquier parte de la app.
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
    // Fallback a InMemory si no se ha inicializado (para debugging)
    throw StateError(
      'ReviewRepositoryProvider has not been initialized. '
      'Call ReviewRepositoryProvider.initialize() in main() first.',
    );
  }
}
