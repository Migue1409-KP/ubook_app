import 'package:floor/floor.dart';
import '../../model/educational_center/educational_center_model.dart';


@dao
abstract class EducationalCenterDao {


  @Query('SELECT * FROM educational_centers ORDER BY name ASC')
  Future<List<EducationalCenter>> findAll();


  @Query('SELECT * FROM educational_centers WHERE id = :id LIMIT 1')
  Future<EducationalCenter?> findById(String id);


  @Query('SELECT * FROM educational_centers WHERE name LIKE :query ORDER BY name ASC')
  Future<List<EducationalCenter>> searchCenters(String query);


  @insert
  Future<void> insertCenter(EducationalCenter center);


  @update
  Future<int> updateCenter(EducationalCenter center);


  @delete
  Future<int> deleteCenter(EducationalCenter center);


  @Query('SELECT COUNT(*) FROM educational_centers')
  Future<int?> countCenters();
}