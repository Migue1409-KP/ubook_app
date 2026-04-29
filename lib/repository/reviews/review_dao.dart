import 'package:floor/floor.dart';

import '../../model/reviews/review.dart';

@dao
abstract class ReviewDao {
  @Query('SELECT * FROM reviews WHERE entityId = :entityId AND entityType = :entityType')
  Future<List<Review>> getReviewsByEntity(String entityId, String entityType);

  @Query('SELECT * FROM reviews WHERE id = :id')
  Future<Review?> getReviewById(String id);

  @Query('SELECT * FROM reviews')
  Future<List<Review>> getAllReviews();

  @insert
  Future<void> insertReview(Review review);

  @insert
  Future<void> insertReviews(List<Review> reviews);

  @update
  Future<void> updateReview(Review review);

  @delete
  Future<void> deleteReview(Review review);

  @Query('DELETE FROM reviews WHERE id = :id')
  Future<void> deleteReviewById(String id);

  @Query('DELETE FROM reviews')
  Future<void> clearAllReviews();
}

