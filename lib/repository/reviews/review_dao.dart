import 'package:floor/floor.dart';

import '../../model/reviews/review.dart';

@dao
abstract class ReviewDao {
  @Query(
    'SELECT * FROM reviews WHERE entityId = :entityId AND entityType = :entityType ORDER BY createdAtMs DESC',
  )
  Future<List<Review>> findByEntity(String entityId, String entityType);

  @Query('SELECT * FROM reviews WHERE id = :id LIMIT 1')
  Future<Review?> findById(String id);

  @Query('SELECT COUNT(*) FROM reviews')
  Future<int?> countReviews();

  @insert
  Future<void> insertReview(Review review);

  @insert
  Future<void> insertReviews(List<Review> reviews);

  @update
  Future<int> updateReview(Review review);

  @delete
  Future<int> deleteReview(Review review);
}
