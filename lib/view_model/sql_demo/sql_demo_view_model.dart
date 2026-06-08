import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ubook_app/dataconnect/ubook_sql_connector/ubook_sql_connector.dart';

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
      final result = await _connector.listDemoProcesses().execute();
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
    } catch (e) {
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
  }) async {
    _setLoading(true);
    _error = null;
    _lastOperation =
        'INSERT INTO DemoProcess (name, description, processType) VALUES (...)';
    notifyListeners();

    try {
      await _connector.createDemoProcess(
        name: name,
        description: description,
        processType: processType,
      ).execute();

      _lastOperation = 'Proceso creado en Cloud SQL ✓';
      // Recargar lista después de crear para asegurar consistencia
      await loadProcesses();
    } catch (e) {
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

  /// Siembra los procesos de ejemplo en Cloud SQL.
  Future<void> seedExampleProcesses() async {
    _setLoading(true);
    _error = null;
    _lastOperation = 'Sembrando procesos de ejemplo en Cloud SQL...';
    notifyListeners();

    try {
      final examples = [
        {'name': 'Inscripción de Carrera', 'description': 'Proceso para inscribir una nueva carrera universitaria.', 'processType': 'career'},
        {'name': 'Solicitud de Certificado', 'description': 'Solicitud de certificado oficial que acredita estar cursando una carrera.', 'processType': 'career'},
        {'name': 'Cancelación de Materia', 'description': 'Permite cancelar una materia antes de la fecha límite.', 'processType': 'subject'},
        {'name': 'Examen Supletorio', 'description': 'Proceso para solicitar un examen supletorio.', 'processType': 'subject'},
        {'name': 'Homologación de Estudios', 'description': 'Validar y homologar estudios realizados en otra institución.', 'processType': 'educationalCenter'},
        {'name': 'Beca Institucional', 'description': 'Permite aplicar a becas internas por rendimiento.', 'processType': 'educationalCenter'},
      ];

      for (final ex in examples) {
        await _connector.createDemoProcess(
          name: ex['name']!,
          description: ex['description']!,
          processType: ex['processType']!,
        ).execute();
      }

      _lastOperation = '${examples.length} procesos de ejemplo creados en Cloud SQL ✓';
      await loadProcesses();
    } catch (e) {
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
