import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../database/entity/subject_entity.dart';
import 'subject_repository.dart';

class FirestoreSubjectRepository implements SubjectRepository {
  FirestoreSubjectRepository._();

  static late final FirestoreSubjectRepository instance;

  static FirestoreSubjectRepository initialize() {
    instance = FirestoreSubjectRepository._();
    return instance;
  }

  CollectionReference<Map<String, dynamic>> get _subjects =>
      FirebaseFirestore.instance.collection('subjects');

  Map<String, dynamic> _toFirestore(SubjectEntity subject) => {
        'id': subject.id,
        'nombre': subject.nombre,
        'creditos': subject.creditos,
        'horas': subject.horas,
        'descripcion': subject.descripcion,
        'is_sync': subject.isSync,
        'last_update': subject.lastUpdate,
      };

  SubjectEntity _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    final id = data['id'] as String? ?? doc.id;
    final nombre = (data['nombre'] as String?)?.trim() ??
        (data['name'] as String?)?.trim() ??
        'Sin nombre';
    final creditos = _asInt(data['creditos'] ?? data['credits']);
    final horas = _asInt(data['horas'] ?? data['hours']);
    final descripcion = (data['descripcion'] as String?)?.trim() ??
        (data['description'] as String?)?.trim();
    final lastUpdate = _asInt(data['last_update'] ??
        data['lastUpdate'] ??
        data['updated_at'] ??
        data['updatedAt']);

    return SubjectEntity(
      id: id,
      nombre: nombre,
      creditos: creditos,
      horas: horas,
      descripcion: descripcion,
      isSync: data['is_sync'] as bool? ?? true,
      lastUpdate: lastUpdate,
    );
  }

  int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  @override
  Future<List<SubjectEntity>> getSubjects() async {
    final snap = await _subjects.get();
    final list = snap.docs.map(_fromDoc).toList();
    log('[FirestoreSubjectRepository] getSubjects docs=${snap.docs.length}');
    for (final d in snap.docs) {
      log('[FirestoreSubjectRepository] doc=${d.id} data=${d.data()}');
    }
    return list;
  }

  @override
  Future<void> addSubject(SubjectEntity subject) async {
    await _subjects.doc(subject.id).set(_toFirestore(subject));
  }

  @override
  Future<void> updateSubject(SubjectEntity subject) async {
    await _subjects.doc(subject.id).set(_toFirestore(subject));
  }

  @override
  Future<void> deleteSubject(String subjectId) async {
    await _subjects.doc(subjectId).delete();
  }

  @override
  Future<SubjectEntity?> getSubjectById(String subjectId) async {
    final doc = await _subjects.doc(subjectId).get();
    if (!doc.exists) return null;
    return _fromDoc(doc);
  }
}
