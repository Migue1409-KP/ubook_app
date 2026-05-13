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
    database.database = await database.open(path, _migrations, _callback);
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ComputerLabDao? _computerLabDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 2,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
          database,
          startVersion,
          endVersion,
          migrations,
        );

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
          'CREATE TABLE IF NOT EXISTS `computer_labs` (`id` TEXT NOT NULL, `name` TEXT NOT NULL, `building` TEXT NOT NULL, `roomNumber` TEXT NOT NULL, `city` TEXT NOT NULL, `capacity` INTEGER NOT NULL, `available` INTEGER NOT NULL, `equipment` TEXT NOT NULL, `notes` TEXT NOT NULL, PRIMARY KEY (`id`))',
        );

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ComputerLabDao get computerLabDao {
    return _computerLabDaoInstance ??= _$ComputerLabDao(
      database,
      changeListener,
    );
  }
}

class _$ComputerLabDao extends ComputerLabDao {
  _$ComputerLabDao(this.database, this.changeListener)
    : _queryAdapter = QueryAdapter(database),
      _computerLabInsertionAdapter = InsertionAdapter(
        database,
        'computer_labs',
        (ComputerLab item) => <String, Object?>{
          'id': item.id,
          'name': item.name,
          'building': item.building,
          'roomNumber': item.roomNumber,
          'city': item.city,
          'capacity': item.capacity,
          'available': item.available ? 1 : 0,
          'equipment': _stringListConverter.encode(item.equipment),
          'notes': item.notes,
        },
      );

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ComputerLab> _computerLabInsertionAdapter;

  @override
  Future<List<ComputerLab>> findAllLabs() async {
    return _queryAdapter.queryList(
      'SELECT * FROM computer_labs ORDER BY name ASC',
      mapper: (Map<String, Object?> row) => ComputerLab(
        id: row['id'] as String,
        name: row['name'] as String,
        building: row['building'] as String,
        roomNumber: row['roomNumber'] as String,
        city: row['city'] as String,
        capacity: row['capacity'] as int,
        available: (row['available'] as int) != 0,
        equipment: _stringListConverter.decode(row['equipment'] as String),
        notes: row['notes'] as String,
      ),
    );
  }

  @override
  Future<void> insertLab(ComputerLab lab) async {
    await _computerLabInsertionAdapter.insert(lab, OnConflictStrategy.abort);
  }

  @override
  Future<void> upsertLab(ComputerLab lab) async {
    await _computerLabInsertionAdapter.insert(lab, OnConflictStrategy.replace);
  }
}

// ignore_for_file: unused_element
final _stringListConverter = StringListConverter();
