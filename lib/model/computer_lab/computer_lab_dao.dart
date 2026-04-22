import 'package:floor/floor.dart';

import 'computer_lab.dart';

@dao
abstract class ComputerLabDao {
  @Query('SELECT * FROM computer_labs ORDER BY name ASC')
  Future<List<ComputerLab>> findAllLabs();

  @insert
  Future<void> insertLab(ComputerLab lab);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> upsertLab(ComputerLab lab);
}
