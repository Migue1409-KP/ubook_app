import '../../model/process/process_model.dart';

abstract class ProcessRepository {
  static ProcessRepository? _instance;

  static ProcessRepository get instance {
    final i = _instance;
    if (i == null) {
      throw StateError(
        'ProcessRepository.instance no fue inicializado. '
        'Llámalo en main.dart antes de usar el repositorio.',
      );
    }
    return i;
  }

  static void setInstance(ProcessRepository repo) {
    _instance = repo;
  }

  Future<List<ProcessModel>> getProcesses();
  Future<void> addProcess(ProcessModel process);
  Future<void> updateProcess(ProcessModel process);
  Future<void> deleteProcess(String processId);
  Future<ProcessModel?> getProcessById(String processId);
}
