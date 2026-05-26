import 'package:floor/floor.dart';

import '../../model/process/process_model.dart';

@dao
abstract class ProcessDao {
  @Query('SELECT * FROM processes ORDER BY rowid ASC')
  Future<List<ProcessModel>> findAll();

  @Query('SELECT COUNT(*) FROM processes')
  Future<int?> countProcesses();

  @insert
  Future<void> insertProcess(ProcessModel process);

  @insert
  Future<void> insertProcesses(List<ProcessModel> processes);

  @update
  Future<int> updateProcess(ProcessModel process);

  @Query('SELECT * FROM processes WHERE id = :id LIMIT 1')
  Future<ProcessModel?> findById(String id);

  @Query('DELETE FROM processes WHERE id = :id')
  Future<void> deleteById(String id);
}
