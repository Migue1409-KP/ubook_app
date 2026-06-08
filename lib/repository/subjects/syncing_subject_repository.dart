import 'package:flutter/foundation.dart';
import '../../database/entity/subject_entity.dart';
import 'floor_subject_repository.dart';
import 'firestore_subject_repository.dart';
import 'subject_repository.dart';

class SyncingSubjectRepository implements SubjectRepository {
  SyncingSubjectRepository._(this._local, this._remote);

  static late final SyncingSubjectRepository instance;

  static SyncingSubjectRepository initialize(
    FloorSubjectRepository local,
    FirestoreSubjectRepository remote,
  ) {
    instance = SyncingSubjectRepository._(local, remote);
    return instance;
  }

  final FloorSubjectRepository _local;
  final FirestoreSubjectRepository _remote;

  Future<void> ensureInitialized() async {
    await _local.ensureInitialized();
  }

  @override
  Future<List<SubjectEntity>> getSubjects() async {
    debugPrint('[SyncingSubjectRepository] consultando remoto...');
    List<SubjectEntity> subjects = <SubjectEntity>[];
    try {
      subjects = await _remote.getSubjects();
      debugPrint('[SyncingSubjectRepository] remote ${subjects.length}');
      for (final entity in subjects) {
        await _upsertLocal(entity);
      }
    } catch (e) {
      debugPrint('[SyncingSubjectRepository] remote failed: $e');
      subjects = <SubjectEntity>[];
    }
    final local = await _local.getSubjects();
    debugPrint('[SyncingSubjectRepository] local ${local.length}');
    return local;
  }

  @override
  Future<SubjectEntity?> getSubjectById(String subjectId) async {
    try {
      final remote = await _remote.getSubjectById(subjectId);
      if (remote != null) {
        await _upsertLocal(remote);
        return remote;
      }
      return await _local.getSubjectById(subjectId);
    } catch (e) {
      debugPrint('[SyncingSubjectRepository] remote fetch by id failed: $e');
      return await _local.getSubjectById(subjectId);
    }
  }

  @override
  Future<void> addSubject(SubjectEntity subject) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final entity = SubjectEntity(
      id: subject.id,
      nombre: subject.nombre,
      creditos: subject.creditos,
      horas: subject.horas,
      descripcion: subject.descripcion,
      isSync: false,
      lastUpdate: now,
    );
    await _local.addSubject(entity);
    _pushToRemote(() => _remote.addSubject(entity));
  }

  @override
  Future<void> updateSubject(SubjectEntity subject) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final entity = SubjectEntity(
      id: subject.id,
      nombre: subject.nombre,
      creditos: subject.creditos,
      horas: subject.horas,
      descripcion: subject.descripcion,
      isSync: false,
      lastUpdate: now,
    );
    await _local.updateSubject(entity);
    _pushToRemote(() => _remote.updateSubject(entity));
  }

  @override
  Future<void> deleteSubject(String subjectId) async {
    await _local.deleteSubject(subjectId);
    _pushToRemote(() => _remote.deleteSubject(subjectId));
  }

  void _pushToRemote(Future<dynamic> Function() fn) {
    fn().catchError((Object e) {
      debugPrint('[SyncingSubjectRepository] remote write failed: $e');
    });
  }

  Future<void> _upsertLocal(SubjectEntity remote) async {
    final existing = await _local.getSubjectById(remote.id);
    if (existing == null) {
      await _local.addSubject(remote);
      return;
    }

    final localTime = existing.lastUpdate;
    final remoteTime = remote.lastUpdate;
    if (remoteTime >= localTime) {
      await _local.updateSubject(remote);
    }
  }
}
