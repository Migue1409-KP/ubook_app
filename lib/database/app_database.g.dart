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

  SubjectDao? _subjectDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 11,
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
            'CREATE TABLE IF NOT EXISTS `users` (`id` TEXT NOT NULL, `email` TEXT NOT NULL, `name` TEXT NOT NULL, `password` TEXT NOT NULL, `birthDate` INTEGER, `educationalCenter` TEXT NOT NULL, `career` TEXT NOT NULL, `city` TEXT NOT NULL, `profileImageUrl` TEXT, `authProvider` INTEGER NOT NULL, `isActive` INTEGER NOT NULL, `createdAt` INTEGER NOT NULL, `updatedAt` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `reviews` (`id` TEXT NOT NULL, `entityId` TEXT NOT NULL, `entityType` TEXT NOT NULL, `userId` TEXT NOT NULL, `rating` INTEGER NOT NULL, `title` TEXT NOT NULL, `content` TEXT, `createdAtMs` INTEGER, `updatedAtMs` INTEGER, `metadataJson` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `attachments` (`id` TEXT, `file_name` TEXT NOT NULL, `file_type` TEXT NOT NULL, `uploaded_by_id` TEXT NOT NULL, `subject_id` TEXT NOT NULL, `teacher_id` TEXT NOT NULL, `file_path` TEXT, `file_size` INTEGER, `uploaded_at` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `subject_teachers` (`id` TEXT NOT NULL, `subject_id` TEXT NOT NULL, `subject_nombre` TEXT NOT NULL, `subject_creditos` INTEGER NOT NULL, `subject_horas` INTEGER NOT NULL, `teacher_id` TEXT NOT NULL, `teacher_name` TEXT NOT NULL, `teacher_email` TEXT NOT NULL, `is_active` INTEGER NOT NULL, `periodo_academico_id` TEXT, `periodo_etiqueta` TEXT, `created_at_ms` INTEGER NOT NULL, `updated_at_ms` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `careers` (`id` TEXT NOT NULL, `name` TEXT NOT NULL, `educationalCenterId` TEXT NOT NULL, `semesters` INTEGER NOT NULL, `credits` INTEGER NOT NULL, `modalityId` INTEGER, `modalityName` TEXT, `subjects` TEXT NOT NULL, `processes` TEXT NOT NULL, `reviews` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `processes` (`id` TEXT NOT NULL, `name` TEXT NOT NULL, `description` TEXT NOT NULL, `required_documents_json` TEXT NOT NULL, `process_type` TEXT NOT NULL, `related_id` TEXT, `is_active` INTEGER NOT NULL, `created_at_ms` INTEGER, `updated_at_ms` INTEGER, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `teachers` (`id` TEXT NOT NULL, `first_name` TEXT NOT NULL, `last_name` TEXT NOT NULL, `email` TEXT NOT NULL, `phone` TEXT NOT NULL, `age` INTEGER NOT NULL, `department` TEXT NOT NULL, `specialty` TEXT NOT NULL, `subjects` TEXT NOT NULL, `profile_image_url` TEXT NOT NULL, `is_active` INTEGER NOT NULL, `created_at` INTEGER NOT NULL, `updated_at` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `notifications` (`id` TEXT NOT NULL, `title` TEXT NOT NULL, `message` TEXT NOT NULL, `notification_type` TEXT NOT NULL, `status` TEXT NOT NULL, `created_at_ms` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `subjects` (`id` TEXT NOT NULL, `name` TEXT NOT NULL, `credits` INTEGER NOT NULL, `hours` INTEGER NOT NULL, `description` TEXT, `is_sync` INTEGER NOT NULL, `last_update` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE UNIQUE INDEX `index_users_email` ON `users` (`email`)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  SubjectDao get subjectDao {
    return _subjectDaoInstance ??= _$SubjectDao(database, changeListener);
  }
}

class _$SubjectDao extends SubjectDao {
  _$SubjectDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _subjectEntityInsertionAdapter = InsertionAdapter(
            database,
            'subjects',
            (SubjectEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'credits': item.credits,
                  'hours': item.hours,
                  'description': item.description,
                  'is_sync': item.isSync ? 1 : 0,
                  'last_update': item.lastUpdate
                }),
        _subjectEntityUpdateAdapter = UpdateAdapter(
            database,
            'subjects',
            ['id'],
            (SubjectEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'credits': item.credits,
                  'hours': item.hours,
                  'description': item.description,
                  'is_sync': item.isSync ? 1 : 0,
                  'last_update': item.lastUpdate
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SubjectEntity> _subjectEntityInsertionAdapter;

  final UpdateAdapter<SubjectEntity> _subjectEntityUpdateAdapter;

  @override
  Future<List<SubjectEntity>> findAllSubjects() async {
    return _queryAdapter.queryList('SELECT * FROM subjects',
        mapper: (Map<String, Object?> row) => SubjectEntity(
            id: row['id'] as String,
            name: row['name'] as String,
            credits: row['credits'] as int,
            hours: row['hours'] as int,
            description: row['description'] as String?,
            isSync: (row['is_sync'] as int) != 0,
            lastUpdate: row['last_update'] as int));
  }

  @override
  Future<SubjectEntity?> findSubjectById(String id) async {
    return _queryAdapter.query('SELECT * FROM subjects WHERE id = ?1',
        mapper: (Map<String, Object?> row) => SubjectEntity(
            id: row['id'] as String,
            name: row['name'] as String,
            credits: row['credits'] as int,
            hours: row['hours'] as int,
            description: row['description'] as String?,
            isSync: (row['is_sync'] as int) != 0,
            lastUpdate: row['last_update'] as int),
        arguments: [id]);
  }

  @override
  Future<void> deleteSubjectById(String id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM subjects WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> insertSubject(SubjectEntity subject) async {
    await _subjectEntityInsertionAdapter.insert(
        subject, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateSubject(SubjectEntity subject) async {
    await _subjectEntityUpdateAdapter.update(
        subject, OnConflictStrategy.replace);
  }
}

// ignore_for_file: unused_element
final _authProviderConverter = AuthProviderConverter();
final _stringListConverter = StringListConverter();
final _notificationDateTimeConverter = NotificationDateTimeConverter();
final _nullableDateTimeConverter = NullableDateTimeConverter();
final _notificationTypeConverter = NotificationTypeConverter();
final _notificationStatusConverter = NotificationStatusConverter();
