import 'package:flutter/material.dart';

import '../../model/reviews/review.dart';
import '../../repository/reviews/review_repository.dart';

class ReviewsViewModel extends ChangeNotifier {
  ReviewsViewModel({ReviewRepository? repository})
    : _repository = repository ?? InMemoryReviewRepository.instance;

  final ReviewRepository _repository;

  List<Review> _reviews = <Review>[];
  bool _isLoading = false;
  String? _errorMessage;

  String? _lastEntityId;
  String? _lastEntityType;

  List<Review> get reviews => _reviews;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  double get averageRating {
    if (_reviews.isEmpty) return 0;
    final total = _reviews.fold<int>(0, (sum, review) => sum + review.rating);
    return total / _reviews.length;
  }

  Future<void> loadReviews({
    required String entityId,
    required String entityType,
  }) async {
    _lastEntityId = entityId;
    _lastEntityType = entityType;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _reviews = await _repository.getReviews(
        entityId: entityId,
        entityType: entityType,
      );
    } catch (_) {
      _errorMessage = 'No fue posible cargar las resenas.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    final entityId = _lastEntityId;
    final entityType = _lastEntityType;
    if (entityId == null || entityType == null) return;

    await loadReviews(entityId: entityId, entityType: entityType);
  }
}
