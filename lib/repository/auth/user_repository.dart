import 'package:ubook_app/model/auth/user_model.dart';

abstract class UserRepository {
  Future<void> ensureInitialized();

  Future<UserModel?> findById(String id);

  Future<UserModel?> findByEmail(String email);

  Future<UserModel?> findMostRecentUser();

  Future<void> insertUser(UserModel user);

  Future<int> updateUser(UserModel user);

  Future<int> deleteUser(UserModel user);

  Future<void> deleteAllUsers();

  Future<int> countUsers();
}
