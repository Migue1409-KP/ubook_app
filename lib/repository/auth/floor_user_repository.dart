import 'package:ubook_app/model/auth/auth_provider.dart';
import 'package:ubook_app/model/auth/user_model.dart';
import 'package:ubook_app/database/app_database.dart';

import 'user_repository.dart';

class FloorUserRepository implements UserRepository {
  FloorUserRepository._(this._database);

  static late final FloorUserRepository instance;

  static FloorUserRepository initialize(AppDatabase database) {
    instance = FloorUserRepository._(database);
    return instance;
  }

  final AppDatabase _database;

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
    final userDao = _database.userDao;

    final demoUser = _demoUser();
    final existingUser = await userDao.findByEmail(demoUser.email);
    if (existingUser == null) {
      await userDao.insertUser(demoUser);
    }
  }

  @override
  Future<UserModel?> findById(String id) async {
    return _database.userDao.findById(id);
  }

  @override
  Future<UserModel?> findByEmail(String email) async {
    return _database.userDao.findByEmail(email);
  }

  @override
  Future<UserModel?> findMostRecentUser() async {
    return _database.userDao.findMostRecentUser();
  }

  @override
  Future<void> insertUser(UserModel user) async {
    await _database.userDao.insertUser(user);
  }

  @override
  Future<int> updateUser(UserModel user) async {
    return _database.userDao.updateUser(user);
  }

  @override
  Future<int> deleteUser(UserModel user) async {
    return _database.userDao.deleteUser(user);
  }

  @override
  Future<void> deleteAllUsers() async {
    await _database.userDao.deleteAllUsers();
  }

  @override
  Future<int> countUsers() async {
    return (await _database.userDao.countUsers()) ?? 0;
  }
}
