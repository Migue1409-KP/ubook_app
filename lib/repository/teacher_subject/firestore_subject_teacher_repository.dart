import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ubook_app/model/subjectteacher/subjectteacher.dart';

import 'subject_teacher_repository.dart';

/// Implementación de [SubjectTeacherRepository] contra Cloud Firestore.
///
/// Sigue el mismo patrón singleton de [FirestoreProcessRepository]: se
/// inicializa una sola vez desde `main.dart` después de
/// `Firebase.initializeApp(...)`.
///
/// Los documentos viven en la colección `subject_teachers` y usan el id de
/// [SubjectTeacher.id] como id de documento. La serialización reusa
/// [SubjectTeacher.toJson] / [SubjectTeacher.fromJson] para mantener una sola
/// fuente de verdad sobre los nombres de campo.
class FirestoreSubjectTeacherRepository implements SubjectTeacherRepository {
  FirestoreSubjectTeacherRepository._();

  static FirestoreSubjectTeacherRepository? _instance;

  static FirestoreSubjectTeacherRepository get instance {
    final i = _instance;
    if (i == null) {
      throw StateError(
        'FirestoreSubjectTeacherRepository.initialize() no fue llamado',
      );
    }
    return i;
  }

  static FirestoreSubjectTeacherRepository initialize() {
    _instance ??= FirestoreSubjectTeacherRepository._();
    return _instance!;
  }

  static const _collection = 'subject_teachers';

  CollectionReference<Map<String, dynamic>> get _col =>
      FirebaseFirestore.instance.collection(_collection);

  Map<String, dynamic> _toMap(SubjectTeacher st) => st.toJson();

  SubjectTeacher? _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) return null;
    // El doc id es la fuente de verdad para el id; si el map no lo trae,
    // lo inyectamos.
    final withId = {
      ...data,
      'id': data['id'] ?? doc.id,
    };
    return SubjectTeacher.fromJson(withId);
  }

  @override
  Future<SubjectTeacher?> findById(String id) async {
    final doc = await _col.doc(id).get();
    if (!doc.exists) return null;
    return _fromDoc(doc);
  }

  @override
  Future<List<SubjectTeacher>> findAll() async {
    final qs = await _col.get();
    return qs.docs
        .map(_fromDoc)
        .whereType<SubjectTeacher>()
        .toList();
  }

  @override
  Future<List<SubjectTeacher>> findByTeacherId(String teacherId) async {
    final qs = await _col.where('teacher_id', isEqualTo: teacherId).get();
    return qs.docs
        .map(_fromDoc)
        .whereType<SubjectTeacher>()
        .toList();
  }

  @override
  Future<List<SubjectTeacher>> findBySubjectId(String subjectId) async {
    final qs = await _col.where('subject_id', isEqualTo: subjectId).get();
    return qs.docs
        .map(_fromDoc)
        .whereType<SubjectTeacher>()
        .toList();
  }

  @override
  Future<List<SubjectTeacher>> findByTeacherIdAndPeriodo(
    String teacherId,
    String periodoId,
  ) async {
    final qs = await _col
        .where('teacher_id', isEqualTo: teacherId)
        .where('periodo_academico_id', isEqualTo: periodoId)
        .get();
    return qs.docs
        .map(_fromDoc)
        .whereType<SubjectTeacher>()
        .toList();
  }

  @override
  Future<List<SubjectTeacher>> findByPeriodo(String periodoId) async {
    final qs = await _col
        .where('periodo_academico_id', isEqualTo: periodoId)
        .get();
    return qs.docs
        .map(_fromDoc)
        .whereType<SubjectTeacher>()
        .toList();
  }

  @override
  Future<void> insertSubjectTeacher(SubjectTeacher subjectTeacher) async {
    await _col.doc(subjectTeacher.id).set(_toMap(subjectTeacher));
  }

  @override
  Future<int> updateSubjectTeacher(SubjectTeacher subjectTeacher) async {
    try {
      await _col.doc(subjectTeacher.id).update(_toMap(subjectTeacher));
      return 1;
    } on FirebaseException catch (e) {
      if (e.code == 'not-found') return 0;
      rethrow;
    }
  }

  @override
  Future<int> deleteSubjectTeacher(SubjectTeacher subjectTeacher) async {
    await _col.doc(subjectTeacher.id).delete();
    return 1;
  }

  @override
  Future<void> deleteById(String id) async {
    await _col.doc(id).delete();
  }

  @override
  Future<void> deleteAll() async {
    final qs = await _col.get();
    const batchLimit = 500;
    for (var i = 0; i < qs.docs.length; i += batchLimit) {
      final batch = FirebaseFirestore.instance.batch();
      final end = (i + batchLimit).clamp(0, qs.docs.length);
      for (final doc in qs.docs.sublist(i, end)) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    }
  }

  @override
  Future<int> count() async {
    final snap = await _col.count().get();
    return snap.count ?? 0;
  }
}
