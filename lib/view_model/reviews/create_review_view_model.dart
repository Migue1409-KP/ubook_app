import 'package:flutter/material.dart';

class CreateReviewViewModel extends ChangeNotifier {
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

    // TODO: Implementar el llamado al repositorio para guardar la reseña
    // Ej: await reviewRepository.createReview(Review(entityId: ..., rating: _rating ...))
    
    // Simulación de carga (solo visual)
    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();
  }
}
