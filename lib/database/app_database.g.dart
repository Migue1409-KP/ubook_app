// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  UserDao? _userDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `users` (`id` TEXT NOT NULL, `email` TEXT NOT NULL, `name` TEXT NOT NULL, `password` TEXT NOT NULL, `birthDate` INTEGER, `educationalCenter` TEXT NOT NULL, `career` TEXT NOT NULL, `city` TEXT NOT NULL, `profileImageUrl` TEXT, `authProvider` TEXT NOT NULL, `isActive` INTEGER NOT NULL, `createdAt` INTEGER NOT NULL, `updatedAt` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE UNIQUE INDEX `index_users_email` ON `users` (`email`)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  UserDao get userDao {
    return _userDaoInstance ??= _$UserDao(database, changeListener);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _userModelInsertionAdapter = InsertionAdapter(
            database,
            'users',
            (UserModel item) => <String, Object?>{
                  'id': item.id,
                  'email': item.email,
                  'name': item.name,
                  'password': item.password,
                  'birthDate': item.birthDate,
                  'educationalCenter': item.educationalCenter,
                  'career': item.career,
                  'city': item.city,
                  'profileImageUrl': item.profileImageUrl,
                  'authProvider':
                      _authProviderConverter.encode(item.authProvider),
                  'isActive': item.isActive ? 1 : 0,
                  'createdAt': item.createdAt,
                  'updatedAt': item.updatedAt
                }),
        _userModelUpdateAdapter = UpdateAdapter(
            database,
            'users',
            ['id'],
            (UserModel item) => <String, Object?>{
                  'id': item.id,
                  'email': item.email,
                  'name': item.name,
                  'password': item.password,
                  'birthDate': item.birthDate,
                  'educationalCenter': item.educationalCenter,
                  'career': item.career,
                  'city': item.city,
                  'profileImageUrl': item.profileImageUrl,
                  'authProvider':
                      _authProviderConverter.encode(item.authProvider),
                  'isActive': item.isActive ? 1 : 0,
                  'createdAt': item.createdAt,
                  'updatedAt': item.updatedAt
                }),
        _userModelDeletionAdapter = DeletionAdapter(
            database,
            'users',
            ['id'],
            (UserModel item) => <String, Object?>{
                  'id': item.id,
                  'email': item.email,
                  'name': item.name,
                  'password': item.password,
                  'birthDate': item.birthDate,
                  'educationalCenter': item.educationalCenter,
                  'career': item.career,
                  'city': item.city,
                  'profileImageUrl': item.profileImageUrl,
                  'authProvider':
                      _authProviderConverter.encode(item.authProvider),
                  'isActive': item.isActive ? 1 : 0,
                  'createdAt': item.createdAt,
                  'updatedAt': item.updatedAt
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UserModel> _userModelInsertionAdapter;

  final UpdateAdapter<UserModel> _userModelUpdateAdapter;

  final DeletionAdapter<UserModel> _userModelDeletionAdapter;

  @override
  Future<UserModel?> findById(String id) async {
    return _queryAdapter.query('SELECT * FROM users WHERE id = ?1 LIMIT 1',
        mapper: (Map<String, Object?> row) => UserModel(
            id: row['id'] as String,
            email: row['email'] as String,
            name: row['name'] as String,
            password: row['password'] as String,
            birthDate: row['birthDate'] as int?,
            educationalCenter: row['educationalCenter'] as String,
            career: row['career'] as String,
            city: row['city'] as String,
            profileImageUrl: row['profileImageUrl'] as String?,
            authProvider:
                _authProviderConverter.decode(row['authProvider'] as String),
            isActive: (row['isActive'] as int) != 0,
            createdAt: row['createdAt'] as int,
            updatedAt: row['updatedAt'] as int),
        arguments: [id]);
  }

  @override
  Future<UserModel?> findByEmail(String email) async {
    return _queryAdapter.query('SELECT * FROM users WHERE email = ?1 LIMIT 1',
        mapper: (Map<String, Object?> row) => UserModel(
            id: row['id'] as String,
            email: row['email'] as String,
            name: row['name'] as String,
            password: row['password'] as String,
            birthDate: row['birthDate'] as int?,
            educationalCenter: row['educationalCenter'] as String,
            career: row['career'] as String,
            city: row['city'] as String,
            profileImageUrl: row['profileImageUrl'] as String?,
            authProvider:
                _authProviderConverter.decode(row['authProvider'] as String),
            isActive: (row['isActive'] as int) != 0,
            createdAt: row['createdAt'] as int,
            updatedAt: row['updatedAt'] as int),
        arguments: [email]);
  }

  @override
  Future<UserModel?> findMostRecentUser() async {
    return _queryAdapter.query(
        'SELECT * FROM users ORDER BY updatedAt DESC LIMIT 1',
        mapper: (Map<String, Object?> row) => UserModel(
            id: row['id'] as String,
            email: row['email'] as String,
            name: row['name'] as String,
            password: row['password'] as String,
            birthDate: row['birthDate'] as int?,
            educationalCenter: row['educationalCenter'] as String,
            career: row['career'] as String,
            city: row['city'] as String,
            profileImageUrl: row['profileImageUrl'] as String?,
            authProvider:
                _authProviderConverter.decode(row['authProvider'] as String),
            isActive: (row['isActive'] as int) != 0,
            createdAt: row['createdAt'] as int,
            updatedAt: row['updatedAt'] as int));
  }

  @override
  Future<void> deleteAllUsers() async {
    await _queryAdapter.queryNoReturn('DELETE FROM users');
  }

  @override
  Future<int?> countUsers() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM users',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<void> insertUser(UserModel user) async {
    await _userModelInsertionAdapter.insert(user, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateUser(UserModel user) {
    return _userModelUpdateAdapter.updateAndReturnChangedRows(
        user, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteUser(UserModel user) {
    return _userModelDeletionAdapter.deleteAndReturnChangedRows(user);
  }
}

// ignore_for_file: unused_element
final _authProviderConverter = AuthProviderConverter();
