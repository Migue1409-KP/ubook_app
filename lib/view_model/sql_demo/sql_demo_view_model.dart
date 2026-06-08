import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ubook_app/dataconnect/ubook_sql_connector/ubook_sql_connector.dart';
import 'package:ubook_app/repository/process/process_seed_data.dart';

/// Modelo local para representar un proceso del demo Data Connect.
class DemoProcessItem {
  final String id;
  final String name;
  final String description;
  final String processType;
  final bool isActive;
  final DateTime createdAt;

  const DemoProcessItem({
    required this.id,
    required this.name,
    required this.description,
    required this.processType,
    required this.isActive,
    required this.createdAt,
  });

  String get processTypeLabel {
    switch (processType) {
      case 'career':
        return 'Carrera';
      case 'subject':
        return 'Materia';
      case 'educationalCenter':
        return 'Centro educativo';
      default:
        return processType;
    }
  }
}

/// ViewModel para el demo de Firebase Data Connect (SQL Connect).
class SqlDemoViewModel extends ChangeNotifier {
  final _connector = UbookSqlConnectorConnector.instance;

  List<DemoProcessItem> _processes = [];
  bool _isLoading = false;
  bool _isConnected = false;
  String? _error;
  String _lastOperation = '';

  List<DemoProcessItem> get processes => List.unmodifiable(_processes);
  bool get isLoading => _isLoading;
  bool get isConnected => _isConnected;
  String? get error => _error;
  String get lastOperation => _lastOperation;
  bool get isEmpty => _processes.isEmpty && !_isLoading;

  String get currentProjectInfo {
    try {
      final app = Firebase.app();
      return 'Project: ${app.options.projectId} | AppID: ${app.options.appId}';
    } catch (e) {
      return 'Error: $e';
    }
  }

  /// Carga los procesos desde Cloud SQL vía Data Connect.
  Future<void> loadProcesses() async {
    _setLoading(true);
    _error = null;
    _lastOperation = 'Consultando Cloud SQL → SELECT * FROM DemoProcess...';
    notifyListeners();

    try {
      debugPrint('[SqlDemoViewModel] Executing listDemoProcesses()...');
      final result = await _connector.listDemoProcesses().execute();
      
      debugPrint('[SqlDemoViewModel] listDemoProcesses result data: ${result.data}');

      _processes = result.data.demoProcesses.map((p) => DemoProcessItem(
        id: p.id,
        name: p.name,
        description: p.description,
        processType: p.processType,
        isActive: p.isActive,
        createdAt: p.createdAt.toDateTime(),
      )).toList();

      _isConnected = true;
      _lastOperation = 'Conectado a Cloud SQL (ubooksql) ✓';
    } catch (e, stack) {
      debugPrint('[SqlDemoViewModel] Error loading processes: $e\n$stack');
      _error = 'Error al conectar con Data Connect: $e';
      _isConnected = false;
      _lastOperation = 'Error de conexión';
    } finally {
      _setLoading(false);
    }
  }

  /// Crea un nuevo proceso en Cloud SQL vía Data Connect.
  Future<void> createProcess({
    required String name,
    required String description,
    required String processType,
    bool isActive = true,
  }) async {
    _setLoading(true);
    _error = null;
    _lastOperation =
        'INSERT INTO DemoProcess (name, description, processType, isActive) VALUES (...)';
    notifyListeners();

    try {
      debugPrint('[SqlDemoViewModel] Executing createDemoProcess($name, $description, $processType, isActive=$isActive)...');
      final result = await _connector.createDemoProcess(
        name: name,
        description: description,
        processType: processType,
        isActive: isActive,
      ).execute();

      debugPrint('[SqlDemoViewModel] createDemoProcess result data: ${result.data}');

      _lastOperation = 'Proceso creado en Cloud SQL ✓';
      // Recargar lista después de crear para asegurar consistencia
      await loadProcesses();
    } catch (e, stack) {
      debugPrint('[SqlDemoViewModel] Error creating process: $e\n$stack');
      _error = 'Error al crear proceso: $e';
      _lastOperation = 'Error al insertar';
      _setLoading(false);
    }
  }

  /// Elimina un proceso de Cloud SQL vía Data Connect.
  Future<void> deleteProcess(String id) async {
    _error = null;
    _lastOperation = 'DELETE FROM DemoProcess WHERE id = \'$id\'';
    notifyListeners();

    try {
      await _connector.deleteDemoProcess(id: id).execute();
      _processes = _processes.where((p) => p.id != id).toList();
      _lastOperation = 'Proceso eliminado de Cloud SQL ✓';
    } catch (e) {
      _error = 'Error al eliminar: $e';
      _lastOperation = 'Error al eliminar';
    }

    notifyListeners();
  }

  /// Cambia el estado activo/inactivo de un proceso.
  Future<void> toggleActive(String id, bool currentValue) async {
    _error = null;
    final newValue = !currentValue;
    _lastOperation =
        'UPDATE DemoProcess SET isActive = $newValue WHERE id = \'$id\'';
    notifyListeners();

    try {
      await _connector.updateDemoProcess(id: id).isActive(newValue).execute();
      _processes = _processes.map((p) {
        if (p.id == id) {
          return DemoProcessItem(
            id: p.id,
            name: p.name,
            description: p.description,
            processType: p.processType,
            isActive: newValue,
            createdAt: p.createdAt,
          );
        }
        return p;
      }).toList();
      _lastOperation = 'Estado actualizado en Cloud SQL ✓';
    } catch (e) {
      _error = 'Error al actualizar: $e';
      _lastOperation = 'Error al actualizar';
    }

    notifyListeners();
  }

  /// Siembra los procesos de ejemplo reales en Cloud SQL.
  Future<void> seedExampleProcesses() async {
    _setLoading(true);
    _error = null;
    _lastOperation = 'Sembrando procesos de ejemplo reales en Cloud SQL...';
    notifyListeners();

    try {
      final defaultSeed = buildDefaultProcessSeed();
      debugPrint('[SqlDemoViewModel] Seeding ${defaultSeed.length} processes...');

      for (int i = 0; i < defaultSeed.length; i++) {
        final process = defaultSeed[i];
        _lastOperation = 'Sembrando (${i + 1}/${defaultSeed.length}): ${process.name}...';
        notifyListeners();

        debugPrint('[SqlDemoViewModel] Seeding process ${process.name} (isActive=${process.isActive})...');
        final result = await _connector.createDemoProcess(
          name: process.name,
          description: process.description,
          processType: process.processType,
          isActive: process.isActive,
        ).execute();

        debugPrint('[SqlDemoViewModel] Seed process ${process.name} result data: ${result.data}');
      }

      _lastOperation = '${defaultSeed.length} procesos académicos cargados en Cloud SQL ✓';
      await loadProcesses();
    } catch (e, stack) {
      debugPrint('[SqlDemoViewModel] Error seeding processes: $e\n$stack');
      _error = 'Error al sembrar procesos: $e';
      _lastOperation = 'Error al sembrar';
      _setLoading(false);
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
