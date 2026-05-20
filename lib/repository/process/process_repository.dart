import '../../model/process/process_model.dart';

abstract class ProcessRepository {
  Future<List<ProcessModel>> getProcesses();
  Future<void> addProcess(ProcessModel process);
  Future<void> updateProcess(ProcessModel process);
  Future<void> deleteProcess(String processId);
}
