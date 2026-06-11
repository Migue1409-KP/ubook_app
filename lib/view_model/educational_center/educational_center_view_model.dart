import 'package:flutter/foundation.dart';
import 'educational_center_count_provider.dart';
import '../../model/educational_center/educational_center_model.dart';
import '../../repository/educational_center/educational_center_repository_impl.dart';
import '../../repository/educational_center/firestore_educational_center_repository.dart';

class EducationalCenterViewModel extends ChangeNotifier {
  // Usamos la instancia Singleton que registramos en el main
  final _repository = EducationalCenterRepositoryImpl.instance;
  final _firebaseRepository = FirestoreEducationalCenterRepository.instance;

  List<EducationalCenter> _centers = [];
  List<EducationalCenter> _filteredCenters = [];
  bool _isLoading = false;

  List<EducationalCenter> get centers => _filteredCenters.isEmpty && _centers.isNotEmpty
      ? _centers
      : _filteredCenters;

  bool get isLoading => _isLoading;

  /// Carga los centros educativos desde la base de datos SQLite
  Future<void> loadCenters() async {
    _isLoading = true;
    notifyListeners();

    try {
      _centers = await _repository.getLocalEducationalCenters();
      _filteredCenters = List.from(_centers);
    } catch (e) {
      debugPrint('Error cargando centros educativos: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Filtra u organiza los centros educativos localmente según la búsqueda
  void searchCenter(String query) {
    if (query.isEmpty) {
      _filteredCenters = List.from(_centers);
    } else {
      _filteredCenters = _centers
          .where(
            (center) => center.name.toLowerCase().contains(query.toLowerCase()),
      )
          .toList();
    }
    notifyListeners();
  }

  /// Agrega un nuevo centro educativo y actualiza el contador global
  Future<void> addCenter(EducationalCenter center, EducationalCenterCountProvider countProvider) async {
    try {
      await _repository.saveLocalEducationalCenter(center);
      await loadCenters();
      countProvider.increment(); // 📈 Suma 1 al indicador del dashboard

      await _firebaseRepository.saveRemoteEducationalCenter(center).catchError((error) {
        debugPrint('Firebase no pudo guardar en background: $error');
      });
    } catch (e) {
      debugPrint('Error al guardar centro educativo: $e');
    }
  }

  /// Elimina un centro educativo y actualiza el contador global
  Future<void> removeCenter(String id, EducationalCenterCountProvider countProvider) async {
    try {
      await _repository.deleteLocalEducationalCenter(id);
      await loadCenters();
      countProvider.decrement(); // 📉 Resta 1 al indicador del dashboard
      await _firebaseRepository.deleteRemoteEducationalCenter(id).catchError((error) {
        debugPrint('Firebase no pudo eliminar en background: $error');
      });
    } catch (e) {
      debugPrint('Error al eliminar centro educativo: $e');
    }
  }
}