import 'computer_lab.dart';
import 'computer_lab_dao.dart';

/// Repository contract for Computer Labs.
abstract class ComputerLabRepository {
  Future<ComputerLab> save(ComputerLab lab);
  Future<List<ComputerLab>> getAll();
}

class FloorComputerLabRepository implements ComputerLabRepository {
  FloorComputerLabRepository(this._dao);

  final ComputerLabDao _dao;

  @override
  Future<ComputerLab> save(ComputerLab lab) async {
    await _dao.upsertLab(lab);
    return lab;
  }

  @override
  Future<List<ComputerLab>> getAll() => _dao.findAllLabs();
}
