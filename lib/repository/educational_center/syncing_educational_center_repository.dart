import 'package:flutter/foundation.dart';
import '../../model/educational_center/educational_center_model.dart';
import 'educational_center_repository_impl.dart'; // Tu repositorio SQLite actual
import 'firestore_educational_center_repository.dart';

class SyncingEducationalCenterRepository {
  SyncingEducationalCenterRepository._(this._local, this._remote);

  static late final SyncingEducationalCenterRepository instance;

  static SyncingEducationalCenterRepository initialize(
      EducationalCenterRepositoryImpl local,
      FirestoreEducationalCenterRepository remote,
      ) {
    instance = SyncingEducationalCenterRepository._(local, remote);
    return instance;
  }

  final EducationalCenterRepositoryImpl _local;
  final FirestoreEducationalCenterRepository _remote;

  /// Obtiene los datos locales (Y de manera óptima podría sincronizar cambios remotos)
  Future<List<EducationalCenter>> getEducationalCenters() async {
    try {
      // Intentamos traer los datos frescos de la nube por si hay nuevos de otros compañeros
      final remoteList = await _remote.getRemoteEducationalCenters();
      if (remoteList.isNotEmpty) {
        for (final center in remoteList) {
          await _upsertLocal(center);
        }
        return remoteList;
      }
    } catch (_) {
      // Si falla o no hay internet, el SDK de Firebase respondería de caché o usamos el SQLite local seguro[cite: 4, 7]
    }
    return _local.getLocalEducationalCenters();
  }

  /// Guarda localmente y dispara la subida asíncrona a Firebase[cite: 7]
  Future<void> saveEducationalCenter(EducationalCenter center) async {
    await _local.saveLocalEducationalCenter(center); // Escritura local inmediata
    _pushToRemote(() => _remote.saveRemoteEducationalCenter(center)); // Espejo a la nube[cite: 7]
  }

  /// Elimina localmente y dispara el borrado en Firebase[cite: 7]
  Future<void> deleteEducationalCenter(String id) async {
    await _local.deleteLocalEducationalCenter(id); // Borrado local inmediato
    _pushToRemote(() => _remote.deleteRemoteEducationalCenter(id)); // Espejo a la nube[cite: 7]
  }

  // Dispara la escritura remota en segundo plano sin congelar la app al usuario[cite: 7]
  void _pushToRemote(Future<dynamic> Function() fn) {
    fn().catchError((Object e) {
      debugPrint('[SyncingEducationalCenterRepository] Error en escritura remota: $e');
    });
  }

  Future<void> _upsertLocal(EducationalCenter center) async {
    // Aquí puedes reusar la lógica que ya tienes implementada en tu repositorio local para actualizar o insertar
    await _local.saveLocalEducationalCenter(center);
  }
}