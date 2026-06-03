import 'package:flutter/foundation.dart';
import '../../model/subjects/subject_entity.dart';
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
    try {
      final remoteSubjects = await _remote.getSubjects();
      if (remoteSubjects.isNotEmpty) {
        for (final remote in remoteSubjects) {
          await _upsertLocal(remote);
        }
      }
      return await _local.getSubjects();
    } catch (e) {
      debugPrint(
          '[SyncingSubjectRepository] remote fetch failed, fallback local: $e');
      return await _local.getSubjects();
    }
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
      debugPrint(
          '[SyncingSubjectRepository] remote fetch by id failed: $e');
      return await _local.getSubjectById(subjectId);
    }
  }

  @override
  Future<void> addSubject(SubjectEntity subject) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final entity = SubjectEntity(
      id: subject.id,
      name: subject.name,
      credits: subject.credits,
      hours: subject.hours,
      description: subject.description,
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
      name: subject.name,
      credits: subject.credits,
      hours: subject.hours,
      description: subject.description,
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
