import 'package:flutter/foundation.dart';
import 'package:ubook_app/model/subjectteacher/subjectteacher.dart';

import 'firestore_subject_teacher_repository.dart';
import 'floor_subject_teacher_repository.dart';
import 'subject_teacher_repository.dart';

/// Repositorio que coordina [FloorSubjectTeacherRepository] como caché local
/// y [FirestoreSubjectTeacherRepository] como fuente de verdad remota.
///
/// Estrategia (copiada del patrón de [SyncingProcessRepository]):
/// - **Lecturas:** intenta Firestore primero. Si responde, hace upsert en Floor
///   y devuelve los resultados frescos. Si falla (sin red, error), cae al
///   estado local.
/// - **Escrituras:** persisten primero en Floor (para que la UI responda al
///   instante) y luego se envían a Firestore como fire-and-forget. Errores
///   remotos se loguean pero no rompen la UI.
/// - **Cold start:** en [findAll], si Firestore está vacío pero Floor tiene
///   datos, los publica al remoto para que otros dispositivos los vean.
class SyncingSubjectTeacherRepository implements SubjectTeacherRepository {
  SyncingSubjectTeacherRepository._(this._local, this._remote);

  static late final SyncingSubjectTeacherRepository instance;

  static SyncingSubjectTeacherRepository initialize(
    FloorSubjectTeacherRepository local,
    FirestoreSubjectTeacherRepository remote,
  ) {
    instance = SyncingSubjectTeacherRepository._(local, remote);
    return instance;
  }

  final FloorSubjectTeacherRepository _local;
  final FirestoreSubjectTeacherRepository _remote;

  /// Sincronización inicial: trae del remoto y semilla local si remoto vacío.
  Future<void> ensureInitialized() async {
    try {
      final remoteLinks = await _remote.findAll();
      if (remoteLinks.isNotEmpty) {
        for (final link in remoteLinks) {
          await _upsertLocal(link);
        }
      } else {
        final localLinks = await _local.findAll();
        for (final link in localLinks) {
          _pushToRemote(() => _remote.insertSubjectTeacher(link));
        }
      }
    } catch (e) {
      debugPrint(
        '[SyncingSubjectTeacherRepository] ensureInitialized falló: $e',
      );
    }
  }

  @override
  Future<SubjectTeacher?> findById(String id) async {
    try {
      final remote = await _remote.findById(id);
      if (remote != null) {
        await _upsertLocal(remote);
        return remote;
      }
      return await _local.findById(id);
    } catch (e) {
      debugPrint(
        '[SyncingSubjectTeacherRepository] findById remoto falló: $e',
      );
      return await _local.findById(id);
    }
  }

  @override
  Future<List<SubjectTeacher>> findAll() async {
    try {
      final remote = await _remote.findAll();
      if (remote.isNotEmpty) {
        for (final link in remote) {
          await _upsertLocal(link);
        }
      } else {
        final localLinks = await _local.findAll();
        for (final link in localLinks) {
          _pushToRemote(() => _remote.insertSubjectTeacher(link));
        }
      }
      return await _local.findAll();
    } catch (e) {
      debugPrint(
        '[SyncingSubjectTeacherRepository] findAll remoto falló: $e',
      );
      return await _local.findAll();
    }
  }

  @override
  Future<List<SubjectTeacher>> findByTeacherId(String teacherId) async {
    try {
      final remote = await _remote.findByTeacherId(teacherId);
      for (final link in remote) {
        await _upsertLocal(link);
      }
      return await _local.findByTeacherId(teacherId);
    } catch (e) {
      debugPrint(
        '[SyncingSubjectTeacherRepository] findByTeacherId remoto falló: $e',
      );
      return await _local.findByTeacherId(teacherId);
    }
  }

  @override
  Future<List<SubjectTeacher>> findBySubjectId(String subjectId) async {
    try {
      final remote = await _remote.findBySubjectId(subjectId);
      for (final link in remote) {
        await _upsertLocal(link);
      }
      return await _local.findBySubjectId(subjectId);
    } catch (e) {
      debugPrint(
        '[SyncingSubjectTeacherRepository] findBySubjectId remoto falló: $e',
      );
      return await _local.findBySubjectId(subjectId);
    }
  }

  @override
  Future<List<SubjectTeacher>> findByTeacherIdAndPeriodo(
    String teacherId,
    String periodoId,
  ) async {
    try {
      final remote =
          await _remote.findByTeacherIdAndPeriodo(teacherId, periodoId);
      for (final link in remote) {
        await _upsertLocal(link);
      }
      return await _local.findByTeacherIdAndPeriodo(teacherId, periodoId);
    } catch (e) {
      debugPrint(
        '[SyncingSubjectTeacherRepository] findByTeacherIdAndPeriodo remoto falló: $e',
      );
      return await _local.findByTeacherIdAndPeriodo(teacherId, periodoId);
    }
  }

  @override
  Future<List<SubjectTeacher>> findByPeriodo(String periodoId) async {
    try {
      final remote = await _remote.findByPeriodo(periodoId);
      for (final link in remote) {
        await _upsertLocal(link);
      }
      return await _local.findByPeriodo(periodoId);
    } catch (e) {
      debugPrint(
        '[SyncingSubjectTeacherRepository] findByPeriodo remoto falló: $e',
      );
      return await _local.findByPeriodo(periodoId);
    }
  }

  @override
  Future<void> insertSubjectTeacher(SubjectTeacher subjectTeacher) async {
    await _local.insertSubjectTeacher(subjectTeacher);
    _pushToRemote(() => _remote.insertSubjectTeacher(subjectTeacher));
  }

  @override
  Future<int> updateSubjectTeacher(SubjectTeacher subjectTeacher) async {
    final result = await _local.updateSubjectTeacher(subjectTeacher);
    _pushToRemote(() => _remote.updateSubjectTeacher(subjectTeacher));
    return result;
  }

  @override
  Future<int> deleteSubjectTeacher(SubjectTeacher subjectTeacher) async {
    final result = await _local.deleteSubjectTeacher(subjectTeacher);
    _pushToRemote(() => _remote.deleteSubjectTeacher(subjectTeacher));
    return result;
  }

  @override
  Future<void> deleteById(String id) async {
    await _local.deleteById(id);
    _pushToRemote(() => _remote.deleteById(id));
  }

  @override
  Future<void> deleteAll() async {
    await _local.deleteAll();
    _pushToRemote(() => _remote.deleteAll());
  }

  @override
  Future<int> count() async {
    return _local.count();
  }

  void _pushToRemote(Future<dynamic> Function() fn) {
    fn().catchError((Object e) {
      debugPrint(
        '[SyncingSubjectTeacherRepository] escritura remota falló: $e',
      );
    });
  }

  Future<void> _upsertLocal(SubjectTeacher remote) async {
    final existing = await _local.findById(remote.id);
    if (existing == null) {
      await _local.insertSubjectTeacher(remote);
    } else if (remote.updatedAtMs >= existing.updatedAtMs) {
      await _local.updateSubjectTeacher(remote);
    }
  }
}
