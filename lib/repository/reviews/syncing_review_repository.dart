import 'package:flutter/foundation.dart';

import '../../model/reviews/review.dart';
import 'firestore_review_repository.dart';
import 'review_repository.dart';

class SyncingReviewRepository implements ReviewRepository {
  SyncingReviewRepository._(this._local, this._remote);

  static late final SyncingReviewRepository instance;

  static SyncingReviewRepository initialize(
    FloorReviewRepository local,
    FirestoreReviewRepository remote,
  ) {
    instance = SyncingReviewRepository._(local, remote);
    return instance;
  }

  final FloorReviewRepository _local;
  final FirestoreReviewRepository _remote;

  @override
  Future<void> ensureInitialized() async {
    await _local.ensureInitialized();
  }

  @override
  Future<List<Review>> getReviews({
    required String entityId,
    required String entityType,
  }) async {
    await _local.ensureInitialized();

    try {
      final remoteReviews = await _remote.getReviews(
        entityId: entityId,
        entityType: entityType,
      );
      if (remoteReviews.isNotEmpty) {
        for (final review in remoteReviews) {
          await _local.saveOrUpdateReview(review);
        }
        return remoteReviews;
      }
    } catch (e) {
      debugPrint('[SyncingReviewRepository] remote fetch failed: $e');
    }

    return _local.getReviews(entityId: entityId, entityType: entityType);
  }

  @override
  Future<Review> createReview(Review review) async {
    await _local.createReview(review);
    _pushToRemote(() => _remote.createReview(review));
    return review;
  }

  void _pushToRemote(Future<dynamic> Function() operation) {
    operation().catchError((Object e) {
      debugPrint('[SyncingReviewRepository] remote write failed: $e');
    });
  }
}