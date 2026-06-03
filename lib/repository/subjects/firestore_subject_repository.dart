import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../model/subjects/subject_entity.dart';
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
        'name': subject.name,
        'credits': subject.credits,
        'hours': subject.hours,
        'description': subject.description,
        'is_sync': subject.isSync,
        'last_update': subject.lastUpdate,
      };

  SubjectEntity _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return SubjectEntity(
      id: data['id'] as String? ?? doc.id,
      name: data['name'] as String? ?? '',
      credits: data['credits'] as int? ?? 0,
      hours: data['hours'] as int? ?? 0,
      description: data['description'] as String?,
      isSync: data['is_sync'] as bool? ?? true,
      lastUpdate: data['last_update'] as int? ?? 0,
    );
  }

  @override
  Future<List<SubjectEntity>> getSubjects() async {
    final snap = await _subjects.get();
    return snap.docs.map(_fromDoc).toList();
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
