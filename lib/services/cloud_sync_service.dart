import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../database/entity/subject_entity.dart';
import '../model/reviews/review.dart';

/// Estrategia de sincronización offline-first con Cloud Firestore
/// Persiste datos en SQLite local y luego intenta sincronizar a la nube
class CloudSyncService {
  CloudSyncService._internal();

  static final CloudSyncService _instance = CloudSyncService._internal();

  factory CloudSyncService() {
    return _instance;
  }

  static CloudSyncService get instance => _instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collections en Firestore
  static const String _subjectsCollection = 'subjects';
  static const String _reviewsCollection = 'reviews';

  /// Sincroniza un Subject a Firestore con estrategia de conflictos por timestamp.
  /// 
  /// La sincronización sigue la política: el registro con [last_update] más reciente gana.
  /// Si la versión en la nube es más nueva, no sincroniza la copia local.
  /// 
  /// Parámetros:
  ///   - subject: Entidad de materia a sincronizar
  /// 
  /// Retorna:
  ///   - true si la sincronización fue exitosa
  ///   - false si hubo conflicto o error
  Future<bool> syncSubject(SubjectEntity subject) async {
    try {
      final docRef = _firestore.collection(_subjectsCollection).doc(subject.id);
      final docSnapshot = await docRef.get();

      final now = DateTime.now().millisecondsSinceEpoch;
      final localLastUpdate = subject.lastUpdate;

      // Si el documento existe en la nube, comparar timestamps
      if (docSnapshot.exists) {
final cloudData = docSnapshot.data();
         final cloudLastUpdate = cloudData?['last_update'] as int? ?? 0;

        // El registro más reciente gana
        if (cloudLastUpdate > localLastUpdate) {
          debugPrint('Cloud version is newer for subject ${subject.id}');
          return false; // No sincronizar, usar versión cloud
        }
      }

      // Subir versión local a Firestore
      await docRef.set({
        'id': subject.id,
        'nombre': subject.nombre,
        'creditos': subject.creditos,
        'horas': subject.horas,
        'descripcion': subject.descripcion,
        'last_update': now,
      }, SetOptions(merge: true));

      return true;
    } catch (e) {
      debugPrint('Error syncing subject to Firestore: $e');
      return false;
    }
  }

  /// Sincroniza una Review a Firestore con estrategia de conflictos por timestamp.
  /// 
  /// La sincronización sigue la política: el registro con [updated_at_ms] más reciente gana.
  /// Si la versión en la nube es más nueva, no sincroniza la copia local.
  /// 
  /// Parámetros:
  ///   - review: Entidad de reseña a sincronizar
  /// 
  /// Retorna:
  ///   - true si la sincronización fue exitosa
  ///   - false si hubo conflicto o error
  Future<bool> syncReview(Review review) async {
    try {
      final docRef = _firestore.collection(_reviewsCollection).doc(review.id);
      final docSnapshot = await docRef.get();

      final now = DateTime.now().millisecondsSinceEpoch;
      final localLastUpdate = review.updatedAtMs ?? review.createdAtMs ?? now;

      // Si el documento existe en la nube, comparar timestamps
      if (docSnapshot.exists) {
final cloudData = docSnapshot.data();
         final cloudLastUpdate = cloudData?['updated_at_ms'] as int? ??
             (cloudData?['created_at_ms'] as int?) ??
             0;

        // El registro más reciente gana
        if (cloudLastUpdate > localLastUpdate) {
          debugPrint('Cloud version is newer for review ${review.id}');
          return false; // No sincronizar, usar versión cloud
        }
      }

      // Subir versión local a Firestore
      await docRef.set({
        'id': review.id,
        'entity_id': review.entityId,
        'entity_type': review.entityType,
        'user_id': review.userId,
        'rating': review.rating,
        'title': review.title,
        'content': review.content,
        'created_at_ms': review.createdAtMs,
        'updated_at_ms': localLastUpdate,
        'metadata_json': review.metadataJson,
        'synced': true,
        'updated_at': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      return true;
    } catch (e) {
      debugPrint('Error syncing review to Firestore: $e');
      return false;
    }
  }

  /// Obtiene un Subject desde Firestore
  Future<SubjectEntity?> fetchSubject(String subjectId) async {
    try {
      final docSnapshot = await _firestore
          .collection(_subjectsCollection)
          .doc(subjectId)
          .get();

      if (!docSnapshot.exists) return null;

      final data = docSnapshot.data() as Map<String, dynamic>;
      return SubjectEntity(
        id: data['id'] as String? ?? subjectId,
        nombre: data['nombre'] as String? ?? (data['name'] as String? ?? ''),
        creditos: data['creditos'] as int? ?? (data['credits'] as int? ?? 0),
        horas: data['horas'] as int? ?? (data['hours'] as int? ?? 0),
        descripcion: data['descripcion'] as String? ?? (data['description'] as String?),
        isSync: data['is_sync'] as bool? ?? true,
        lastUpdate: data['last_update'] as int? ?? 0,
      );
    } catch (e) {
      debugPrint('Error fetching subject from Firestore: $e');
      return null;
    }
  }

  /// Obtiene una Review desde Firestore
  Future<Review?> fetchReview(String reviewId) async {
    try {
      final docSnapshot = await _firestore
          .collection(_reviewsCollection)
          .doc(reviewId)
          .get();

      if (!docSnapshot.exists) return null;

      final data = docSnapshot.data() as Map<String, dynamic>;
      return Review(
        id: data['id'] as String,
        entityId: data['entity_id'] as String,
        entityType: data['entity_type'] as String,
        userId: data['user_id'] as String,
        rating: data['rating'] as int,
        title: data['title'] as String,
        content: data['content'] as String?,
        createdAtMs: data['created_at_ms'] as int?,
        updatedAtMs: data['updated_at_ms'] as int?,
        metadataJson: data['metadata_json'] as String?,
      );
    } catch (e) {
      debugPrint('Error fetching review from Firestore: $e');
      return null;
    }
  }

  /// Marca un documento como sincronizado en Firestore
  Future<void> markAsSynced(String collection, String docId) async {
    try {
      await _firestore
          .collection(collection)
          .doc(docId)
          .update({'is_sync': true});
    } catch (e) {
      debugPrint('Error marking as synced: $e');
    }
  }

  /// Limpia datos no sincronizados (si es necesario)
  Future<void> cleanup() async {
    try {
      // Implementar política de limpieza si es necesario
      debugPrint('CloudSyncService cleanup completed');
    } catch (e) {
      debugPrint('Error during cleanup: $e');
    }
  }
}
