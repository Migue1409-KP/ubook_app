import 'database_service.dart';
import '../../model/reviews/review.dart';

abstract class ReviewRepository {
  Future<List<Review>> getReviews({
    required String entityId,
    required String entityType,
  });

  Future<Review> createReview(Review review);
}

class FloorReviewRepository implements ReviewRepository {
  FloorReviewRepository();

  bool _isHydrated = false;

  static final _demoReviews = <Review>[];

  /// Inicializa el repositorio cargando datos demo si la BD está vacía.
  Future<void> init() async {
    if (_isHydrated) return;

    final database = await DatabaseService.instance.database;
    final allReviews = await database.reviewDao.getAllReviews();
    if (allReviews.isEmpty) {
      await database.reviewDao.insertReviews(_demoReviews);
    }
    _isHydrated = true;
  }

  @override
  Future<List<Review>> getReviews({
    required String entityId,
    required String entityType,
  }) async {
    await init();

    final database = await DatabaseService.instance.database;
    final reviews = await database.reviewDao
        .getReviewsByEntity(entityId, entityType);

    // Sort by createdAt descending
    reviews.sort((a, b) {
      final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bDate.compareTo(aDate);
    });

    return List<Review>.unmodifiable(reviews);
  }

  @override
  Future<Review> createReview(Review review) async {
    await init();
    final database = await DatabaseService.instance.database;
    await database.reviewDao.insertReview(review);
    return review;
  }
}
