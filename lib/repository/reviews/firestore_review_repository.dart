import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/reviews/review.dart';
import 'review_repository.dart';

class FirestoreReviewRepository implements ReviewRepository {
  FirestoreReviewRepository._();

  static late final FirestoreReviewRepository instance;

  static FirestoreReviewRepository initialize() {
    instance = FirestoreReviewRepository._();
    return instance;
  }

  CollectionReference<Map<String, dynamic>> get _reviews =>
      FirebaseFirestore.instance.collection('reviews');

  Review _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = <String, dynamic>{...?doc.data(), 'id': doc.id};
    return Review.fromJson(data);
  }

  @override
  Future<void> ensureInitialized() async {}

  @override
  Future<List<Review>> getReviews({
    required String entityId,
    required String entityType,
  }) async {
    final snapshot = await _reviews
        .where('entity_id', isEqualTo: entityId)
        .where('entity_type', isEqualTo: entityType)
        .get();

    final reviews = snapshot.docs.map(_fromDoc).toList(growable: false);
    reviews.sort(
      (a, b) => (b.createdAtMs ?? 0).compareTo(a.createdAtMs ?? 0),
    );
    return reviews;
  }

  @override
  Future<Review> createReview(Review review) async {
    await _reviews.doc(review.id).set(review.toJson());
    return review;
  }

  Future<bool> hasAnyReview() async {
    final snapshot = await _reviews.limit(1).get();
    return snapshot.docs.isNotEmpty;
  }
}