import 'package:flutter/foundation.dart';
import 'package:ubook_app/model/auth/user_model.dart';

import 'firestore_user_repository.dart';
import 'floor_user_repository.dart';
import 'user_repository.dart';

/// Decorator that keeps SQLite and Firestore in sync transparently.
///
/// Reads hit Firestore first (SDK serves from cache when offline, so this
/// works without internet after the first fetch). Writes go to local first
/// then to Firestore — the SDK queues writes when offline and pushes them
/// automatically on reconnect. Existing local-only users are lazily uploaded
/// to Firestore on their first read.
class SyncingUserRepository implements UserRepository {
  SyncingUserRepository._(this._local, this._remote);

  static late final SyncingUserRepository instance;

  static SyncingUserRepository initialize(
    FloorUserRepository local,
    FirestoreUserRepository remote,
  ) {
    instance = SyncingUserRepository._(local, remote);
    return instance;
  }

  final FloorUserRepository _local;
  final FirestoreUserRepository _remote;

  static const _demoEmail = 'test@test.com';

  @override
  Future<void> ensureInitialized() async {
    await _local.ensureInitialized();
  }

  @override
  Future<List<UserModel>> findAll() async {
    try {
      final remoteList = await _remote.findAll();
      for (final user in remoteList) {
        await _upsertLocal(user);
      }
      return remoteList;
    } catch (_) {
      return _local.findAll();
    }
  }

  @override
  Future<UserModel?> findById(String id) async {
    try {
      final remote = await _remote.findById(id);
      if (remote != null) {
        await _upsertLocal(remote);
        return remote;
      }
      final local = await _local.findById(id);
      if (local != null && local.email != _demoEmail) {
        await _remote.insertUser(local);
      }
      return local;
    } catch (_) {
      return _local.findById(id);
    }
  }

  @override
  Future<UserModel?> findByEmail(String email) async {
    try {
      final remote = await _remote.findByEmail(email);
      if (remote != null) {
        await _upsertLocal(remote);
        return remote;
      }
      final local = await _local.findByEmail(email);
      if (local != null && local.email != _demoEmail) {
        await _remote.insertUser(local);
      }
      return local;
    } catch (_) {
      return _local.findByEmail(email);
    }
  }

  @override
  Future<UserModel?> findMostRecentUser() async {
    try {
      final remote = await _remote.findMostRecentUser();
      if (remote != null) {
        await _upsertLocal(remote);
        return remote;
      }
      final local = await _local.findMostRecentUser();
      if (local != null && local.email != _demoEmail) {
        await _remote.insertUser(local);
      }
      return local;
    } catch (_) {
      return _local.findMostRecentUser();
    }
  }

  @override
  Future<int> countUsers() async {
    try {
      return await _remote.countUsers();
    } catch (_) {
      return _local.countUsers();
    }
  }

  @override
  Future<void> insertUser(UserModel user) async {
    await _local.insertUser(user);
    _pushToRemote(() => _remote.insertUser(user));
  }

  @override
  Future<int> updateUser(UserModel user) async {
    final result = await _local.updateUser(user);
    _pushToRemote(() => _remote.updateUser(user));
    return result;
  }

  @override
  Future<int> deleteUser(UserModel user) async {
    final result = await _local.deleteUser(user);
    _pushToRemote(() => _remote.deleteUser(user));
    return result;
  }

  @override
  Future<void> deleteAllUsers() async {
    await _local.deleteAllUsers();
    _pushToRemote(() => _remote.deleteAllUsers());
  }

  // Fires the remote write without blocking the caller. If it fails (e.g. rules,
  // transient network error), logs to debug console. The Firestore SDK will have
  // already queued the write and will retry when connectivity is restored.
  void _pushToRemote(Future<dynamic> Function() fn) {
    fn().catchError((Object e) {
      debugPrint('[SyncingUserRepository] remote write failed: $e');
    });
  }

  Future<void> _upsertLocal(UserModel user) async {
    final existing = await _local.findById(user.id);
    if (existing == null) {
      await _local.insertUser(user);
    } else if (user.updatedAt >= existing.updatedAt) {
      await _local.updateUser(user);
    }
  }
}
