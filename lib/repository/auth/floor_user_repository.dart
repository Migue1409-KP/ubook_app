import 'package:floor/floor.dart';
import 'package:ubook_app/model/auth/auth_provider.dart';
import 'package:ubook_app/model/auth/user_model.dart';
import 'package:ubook_app/database/app_database.dart';

import 'user_repository.dart';

class FloorUserRepository implements UserRepository {
  FloorUserRepository._();

  static final FloorUserRepository instance = FloorUserRepository._();

  static const String _databaseName = 'ubook_app.db';

  AppDatabase? _database;

  Future<AppDatabase> _getDatabase() async {
    if (_database != null) {
      return _database!;
    }

    _database = await $FloorAppDatabase.databaseBuilder(_databaseName).build();
    return _database!;
  }

  UserModel _demoUser() {
    final now = DateTime.now();
    return UserModel(
      id: '1',
      email: 'test@test.com',
      name: 'test pepito',
      password: 'test1234',
      birthDate: null,
      educationalCenter: 'Universidad Católica del Oriente',
      career: 'Ingeniería de Sistemas',
      city: 'Rionegro',
      profileImageUrl: null,
      authProvider: AuthProvider.emailPassword,
      isActive: true,
      createdAt: now.millisecondsSinceEpoch,
      updatedAt: now.millisecondsSinceEpoch,
    );
  }

  @override
  Future<void> ensureInitialized() async {
    final database = await _getDatabase();
    final userDao = database.userDao;

    final demoUser = _demoUser();
    final existingUser = await userDao.findByEmail(demoUser.email);
    if (existingUser == null) {
      await userDao.insertUser(demoUser);
    }
  }

  @override
  Future<UserModel?> findById(String id) async {
    final database = await _getDatabase();
    return database.userDao.findById(id);
  }

  @override
  Future<UserModel?> findByEmail(String email) async {
    final database = await _getDatabase();
    return database.userDao.findByEmail(email);
  }

  @override
  Future<UserModel?> findMostRecentUser() async {
    final database = await _getDatabase();
    return database.userDao.findMostRecentUser();
  }

  @override
  Future<void> insertUser(UserModel user) async {
    final database = await _getDatabase();
    await database.userDao.insertUser(user);
  }

  @override
  Future<int> updateUser(UserModel user) async {
    final database = await _getDatabase();
    return database.userDao.updateUser(user);
  }

  @override
  Future<int> deleteUser(UserModel user) async {
    final database = await _getDatabase();
    return database.userDao.deleteUser(user);
  }

  @override
  Future<void> deleteAllUsers() async {
    final database = await _getDatabase();
    await database.userDao.deleteAllUsers();
  }

  @override
  Future<int> countUsers() async {
    final database = await _getDatabase();
    return (await database.userDao.countUsers()) ?? 0;
  }
}
