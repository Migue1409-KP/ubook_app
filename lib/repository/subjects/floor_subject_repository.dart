import 'package:flutter/foundation.dart';
import '../../database/app_database.dart';
import '../../model/subjects/subject_entity.dart';
import 'subject_repository.dart';

class FloorSubjectRepository implements SubjectRepository {
  FloorSubjectRepository._(this._database);

  static FloorSubjectRepository? _instance;

  static FloorSubjectRepository get instance {
    final repository = _instance;
    if (repository == null) {
      throw StateError('FloorSubjectRepository.initialize() no fue llamado');
    }
    return repository;
  }

  static FloorSubjectRepository initialize(AppDatabase database) {
    _instance ??= FloorSubjectRepository._(database);
    return _instance!;
  }

  final AppDatabase _database;
  bool _isInitialized = false;

  Future<void> ensureInitialized() async {
    if (_isInitialized) return;
    _isInitialized = true;
  }

  @override
  Future<List<SubjectEntity>> getSubjects() async {
    return await _database.subjectDao.findAllSubjects();
  }

  @override
  Future<SubjectEntity?> getSubjectById(String subjectId) async {
    return await _database.subjectDao.findSubjectById(subjectId);
  }

  @override
  Future<void> addSubject(SubjectEntity subject) async {
    await _database.subjectDao.insertSubject(subject);
  }

  @override
  Future<void> updateSubject(SubjectEntity subject) async {
    await _database.subjectDao.updateSubject(subject);
  }

  @override
  Future<void> deleteSubject(String subjectId) async {
    await _database.subjectDao.deleteSubjectById(subjectId);
  }
}
