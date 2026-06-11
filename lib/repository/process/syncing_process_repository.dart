import 'package:flutter/foundation.dart';
import '../../model/process/process_model.dart';
import 'floor_process_repository.dart';
import 'firestore_process_repository.dart';
import 'process_repository.dart';

class SyncingProcessRepository implements ProcessRepository {
  SyncingProcessRepository._(this._local, this._remote);

  static late final SyncingProcessRepository instance;

  static SyncingProcessRepository initialize(
    FloorProcessRepository local,
    FirestoreProcessRepository remote,
  ) {
    instance = SyncingProcessRepository._(local, remote);
    return instance;
  }

  final FloorProcessRepository _local;
  final FirestoreProcessRepository _remote;

  Future<void> ensureInitialized() async {
    await _local.ensureInitialized();
  }

  @override
  Future<List<ProcessModel>> getProcesses() async {
    await _local.ensureInitialized();
    try {
      final remoteProcesses = await _remote.getProcesses();
      if (remoteProcesses.isNotEmpty) {
        for (final remote in remoteProcesses) {
          await _upsertLocal(remote);
        }
      } else {
        // Cold start: if remote has no processes, populate it with the local seed data
        final localProcesses = await _local.getProcesses();
        for (final local in localProcesses) {
          _pushToRemote(() => _remote.addProcess(local));
        }
      }
      return await _local.getProcesses();
    } catch (e) {
      debugPrint('[SyncingProcessRepository] remote fetch failed, falling back to local: $e');
      return await _local.getProcesses();
    }
  }

  @override
  Future<void> addProcess(ProcessModel process) async {
    await _local.addProcess(process);
    _pushToRemote(() => _remote.addProcess(process));
  }

  @override
  Future<void> updateProcess(ProcessModel process) async {
    await _local.updateProcess(process);
    _pushToRemote(() => _remote.updateProcess(process));
  }

  @override
  Future<void> deleteProcess(String processId) async {
    await _local.deleteProcess(processId);
    _pushToRemote(() => _remote.deleteProcess(processId));
  }

  @override
  Future<ProcessModel?> getProcessById(String processId) async {
    try {
      final remote = await _remote.getProcessById(processId);
      if (remote != null) {
        await _upsertLocal(remote);
        return remote;
      }
      return await _local.getProcessById(processId);
    } catch (e) {
      debugPrint('[SyncingProcessRepository] remote getById failed, falling back to local: $e');
      return await _local.getProcessById(processId);
    }
  }

  void _pushToRemote(Future<dynamic> Function() fn) {
    fn().catchError((Object e) {
      debugPrint('[SyncingProcessRepository] remote write failed: $e');
    });
  }

  Future<void> _upsertLocal(ProcessModel remote) async {
    final existing = await _local.getProcessById(remote.id);
    if (existing == null) {
      await _local.addProcess(remote);
    } else {
      final remoteTime = remote.updatedAt ?? remote.createdAt;
      final localTime = existing.updatedAt ?? existing.createdAt;
      if (remoteTime == null ||
          localTime == null ||
          remoteTime.isAfter(localTime) ||
          remoteTime.isAtSameMomentAs(localTime)) {
        await _local.updateProcess(remote);
      }
    }
  }
}
