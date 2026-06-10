import 'package:floor/floor.dart';
import '../../model/pqrs/pqrs_entity.dart';

@dao
abstract class PQRSDao {

  @Query('SELECT * FROM pqrs ORDER BY fechaMs DESC')
  Future<List<PQRSEntity>> findAll();

  @Query('SELECT * FROM pqrs WHERE id = :id')
  Future<PQRSEntity?> findById(String id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> savePQRS(PQRSEntity pqrs);

  @delete
  Future<int> deletePQRS(PQRSEntity pqrs);

  @Query('SELECT COUNT(*) FROM pqrs')
  Future<int?> countPQRS();
}