import 'package:flutter/material.dart';

import '../../model/reviews/review.dart';
import '../../repository/reviews/review_repository.dart';
import '../../repository/reviews/review_repository_provider.dart';

class CreateReviewViewModel extends ChangeNotifier {
  CreateReviewViewModel({ReviewRepository? repository})
    : _repository = repository ?? ReviewRepositoryProvider.instance;

  final ReviewRepository _repository;

  int _rating = 0;
  bool _isLoading = false;

  int get rating => _rating;
  bool get isLoading => _isLoading;

  void updateRating(int newRating) {
    _rating = newRating;
    notifyListeners();
  }

  // Método preparado para usarse después con lógica real
  Future<void> submitReview({
    required String entityId,
    required String entityType,
    required String userId,
    required String title,
    required String content,
  }) async {
    _isLoading = true;
    notifyListeners();

    final now = DateTime.now();

    try {
      final review = Review(
        id: 'REV-${now.microsecondsSinceEpoch}',
        entityId: entityId,
        entityType: entityType,
        userId: userId,
        rating: _rating,
        title: title,
        content: content.isEmpty ? null : content,
        createdAt: now,
        updatedAt: now,
      );

      await _repository.createReview(review);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
