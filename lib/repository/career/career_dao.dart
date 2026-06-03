import 'package:floor/floor.dart';
import 'package:ubook_app/model/career/career_entity.dart';

@dao
abstract class CareerDao {
  @Query('SELECT * FROM careers ORDER BY name ASC')
  Future<List<CareerEntity>> findAll();

  @Query('SELECT * FROM careers WHERE id = :id LIMIT 1')
  Future<CareerEntity?> findById(String id);

  @Query('SELECT COUNT(*) FROM careers')
  Future<int?> countCareers();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> upsertCareer(CareerEntity career);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> upsertCareers(List<CareerEntity> careers);

  @update
  Future<int> updateCareer(CareerEntity career);

  @delete
  Future<int> deleteCareer(CareerEntity career);
}