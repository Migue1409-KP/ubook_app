import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubook_app/database/app_database.dart';

import '../../model/process/process_model.dart';
import 'process_repository.dart';
import 'process_seed_data.dart';

class FloorProcessRepository implements ProcessRepository {
  FloorProcessRepository._(this._database);

  static const String _legacyStorageKey = 'processes_v1';
  static FloorProcessRepository? _instance;

  static FloorProcessRepository get instance {
    final repository = _instance;
    if (repository == null) {
      throw StateError('FloorProcessRepository.initialize() no fue llamado');
    }
    return repository;
  }

  static FloorProcessRepository initialize(AppDatabase database) {
    _instance = FloorProcessRepository._(database);
    return _instance!;
  }

  final AppDatabase _database;
  bool _isInitialized = false;

  Future<void> ensureInitialized() async {
    if (_isInitialized) return;

    final count = await _database.processDao.countProcesses() ?? 0;
    if (count > 0) {
      _isInitialized = true;
      return;
    }

    final migrated = await _migrateFromSharedPreferences();
    if (!migrated) {
      await _database.processDao.insertProcesses(buildDefaultProcessSeed());
    }

    _isInitialized = true;
  }

  Future<bool> _migrateFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_legacyStorageKey);
    if (stored == null || stored.trim().isEmpty) {
      return false;
    }

    try {
      final decoded = jsonDecode(stored);
      if (decoded is! List) return false;

      final processes = decoded
          .whereType<Map<String, dynamic>>()
          .map(ProcessModel.fromJson)
          .toList(growable: false);
      if (processes.isEmpty) return false;

      await _database.processDao.insertProcesses(processes);
      await prefs.remove(_legacyStorageKey);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<List<ProcessModel>> getProcesses() async {
    await ensureInitialized();
    return List<ProcessModel>.unmodifiable(await _database.processDao.findAll());
  }

  @override
  Future<void> addProcess(ProcessModel process) async {
    await ensureInitialized();
    await _database.processDao.insertProcess(process);
  }

  @override
  Future<void> updateProcess(ProcessModel process) async {
    await ensureInitialized();
    await _database.processDao.updateProcess(process);
  }

  @override
  Future<void> deleteProcess(String processId) async {
    await ensureInitialized();
    await _database.processDao.deleteById(processId);
  }
}
