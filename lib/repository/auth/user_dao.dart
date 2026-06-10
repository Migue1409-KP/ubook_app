import 'package:floor/floor.dart';
import 'package:ubook_app/model/auth/user_model.dart';

@dao
abstract class UserDao {
  @Query('SELECT * FROM users ORDER BY updatedAt DESC')
  Future<List<UserModel>> findAll();

  @Query('SELECT * FROM users WHERE id = :id LIMIT 1')
  Future<UserModel?> findById(String id);

  @Query('SELECT * FROM users WHERE email = :email LIMIT 1')
  Future<UserModel?> findByEmail(String email);

  @Query('SELECT * FROM users ORDER BY updatedAt DESC LIMIT 1')
  Future<UserModel?> findMostRecentUser();

  @insert
  Future<void> insertUser(UserModel user);

  @update
  Future<int> updateUser(UserModel user);

  @delete
  Future<int> deleteUser(UserModel user);

  @Query('DELETE FROM users')
  Future<void> deleteAllUsers();

  @Query('SELECT COUNT(*) FROM users')
  Future<int?> countUsers();
}
