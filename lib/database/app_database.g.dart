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

  ReviewDao? _reviewDaoInstance;

  AttachmentDao? _attachmentDaoInstance;

  CareerDao? _careerDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 4,
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
            'CREATE TABLE IF NOT EXISTS `reviews` (`id` TEXT NOT NULL, `entityId` TEXT NOT NULL, `entityType` TEXT NOT NULL, `userId` TEXT NOT NULL, `rating` INTEGER NOT NULL, `title` TEXT NOT NULL, `content` TEXT, `createdAtMs` INTEGER, `updatedAtMs` INTEGER, `metadataJson` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `attachments` (`id` TEXT, `file_name` TEXT NOT NULL, `file_type` TEXT NOT NULL, `uploaded_by_id` TEXT NOT NULL, `subject_id` TEXT NOT NULL, `teacher_id` TEXT NOT NULL, `file_path` TEXT, `file_size` INTEGER, `uploaded_at` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `careers` (`id` TEXT NOT NULL, `name` TEXT NOT NULL, `educationalCenterId` TEXT NOT NULL, `semesters` INTEGER NOT NULL, `credits` INTEGER NOT NULL, `subjects` TEXT NOT NULL, `processes` TEXT NOT NULL, `reviews` TEXT NOT NULL, PRIMARY KEY (`id`))');
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

  @override
  ReviewDao get reviewDao {
    return _reviewDaoInstance ??= _$ReviewDao(database, changeListener);
  }

  @override
  AttachmentDao get attachmentDao {
    return _attachmentDaoInstance ??= _$AttachmentDao(database, changeListener);
  }

  @override
  CareerDao get careerDao {
    return _careerDaoInstance ??= _$CareerDao(database, changeListener);
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

class _$ReviewDao extends ReviewDao {
  _$ReviewDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _reviewInsertionAdapter = InsertionAdapter(
            database,
            'reviews',
            (Review item) => <String, Object?>{
                  'id': item.id,
                  'entityId': item.entityId,
                  'entityType': item.entityType,
                  'userId': item.userId,
                  'rating': item.rating,
                  'title': item.title,
                  'content': item.content,
                  'createdAtMs': item.createdAtMs,
                  'updatedAtMs': item.updatedAtMs,
                  'metadataJson': item.metadataJson
                }),
        _reviewUpdateAdapter = UpdateAdapter(
            database,
            'reviews',
            ['id'],
            (Review item) => <String, Object?>{
                  'id': item.id,
                  'entityId': item.entityId,
                  'entityType': item.entityType,
                  'userId': item.userId,
                  'rating': item.rating,
                  'title': item.title,
                  'content': item.content,
                  'createdAtMs': item.createdAtMs,
                  'updatedAtMs': item.updatedAtMs,
                  'metadataJson': item.metadataJson
                }),
        _reviewDeletionAdapter = DeletionAdapter(
            database,
            'reviews',
            ['id'],
            (Review item) => <String, Object?>{
                  'id': item.id,
                  'entityId': item.entityId,
                  'entityType': item.entityType,
                  'userId': item.userId,
                  'rating': item.rating,
                  'title': item.title,
                  'content': item.content,
                  'createdAtMs': item.createdAtMs,
                  'updatedAtMs': item.updatedAtMs,
                  'metadataJson': item.metadataJson
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Review> _reviewInsertionAdapter;

  final UpdateAdapter<Review> _reviewUpdateAdapter;

  final DeletionAdapter<Review> _reviewDeletionAdapter;

  @override
  Future<List<Review>> findByEntity(
    String entityId,
    String entityType,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM reviews WHERE entityId = ?1 AND entityType = ?2 ORDER BY createdAtMs DESC',
        mapper: (Map<String, Object?> row) => Review(id: row['id'] as String, entityId: row['entityId'] as String, entityType: row['entityType'] as String, userId: row['userId'] as String, rating: row['rating'] as int, title: row['title'] as String, content: row['content'] as String?, createdAtMs: row['createdAtMs'] as int?, updatedAtMs: row['updatedAtMs'] as int?, metadataJson: row['metadataJson'] as String?),
        arguments: [entityId, entityType]);
  }

  @override
  Future<Review?> findById(String id) async {
    return _queryAdapter.query('SELECT * FROM reviews WHERE id = ?1 LIMIT 1',
        mapper: (Map<String, Object?> row) => Review(
            id: row['id'] as String,
            entityId: row['entityId'] as String,
            entityType: row['entityType'] as String,
            userId: row['userId'] as String,
            rating: row['rating'] as int,
            title: row['title'] as String,
            content: row['content'] as String?,
            createdAtMs: row['createdAtMs'] as int?,
            updatedAtMs: row['updatedAtMs'] as int?,
            metadataJson: row['metadataJson'] as String?),
        arguments: [id]);
  }

  @override
  Future<int?> countReviews() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM reviews',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<void> insertReview(Review review) async {
    await _reviewInsertionAdapter.insert(review, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertReviews(List<Review> reviews) async {
    await _reviewInsertionAdapter.insertList(reviews, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateReview(Review review) {
    return _reviewUpdateAdapter.updateAndReturnChangedRows(
        review, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteReview(Review review) {
    return _reviewDeletionAdapter.deleteAndReturnChangedRows(review);
  }
}

class _$AttachmentDao extends AttachmentDao {
  _$AttachmentDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _attachmentModelInsertionAdapter = InsertionAdapter(
            database,
            'attachments',
            (AttachmentModel item) => <String, Object?>{
                  'id': item.id,
                  'file_name': item.fileName,
                  'file_type': item.fileType,
                  'uploaded_by_id': item.uploadedById,
                  'subject_id': item.subjectId,
                  'teacher_id': item.teacherId,
                  'file_path': item.filePath,
                  'file_size': item.fileSize,
                  'uploaded_at': item.uploadedAtMs
                }),
        _attachmentModelUpdateAdapter = UpdateAdapter(
            database,
            'attachments',
            ['id'],
            (AttachmentModel item) => <String, Object?>{
                  'id': item.id,
                  'file_name': item.fileName,
                  'file_type': item.fileType,
                  'uploaded_by_id': item.uploadedById,
                  'subject_id': item.subjectId,
                  'teacher_id': item.teacherId,
                  'file_path': item.filePath,
                  'file_size': item.fileSize,
                  'uploaded_at': item.uploadedAtMs
                }),
        _attachmentModelDeletionAdapter = DeletionAdapter(
            database,
            'attachments',
            ['id'],
            (AttachmentModel item) => <String, Object?>{
                  'id': item.id,
                  'file_name': item.fileName,
                  'file_type': item.fileType,
                  'uploaded_by_id': item.uploadedById,
                  'subject_id': item.subjectId,
                  'teacher_id': item.teacherId,
                  'file_path': item.filePath,
                  'file_size': item.fileSize,
                  'uploaded_at': item.uploadedAtMs
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<AttachmentModel> _attachmentModelInsertionAdapter;

  final UpdateAdapter<AttachmentModel> _attachmentModelUpdateAdapter;

  final DeletionAdapter<AttachmentModel> _attachmentModelDeletionAdapter;

  @override
  Future<AttachmentModel?> findById(String id) async {
    return _queryAdapter.query(
        'SELECT * FROM attachments WHERE id = ?1 LIMIT 1',
        mapper: (Map<String, Object?> row) => AttachmentModel(
            id: row['id'] as String?,
            fileName: row['file_name'] as String,
            fileType: row['file_type'] as String,
            uploadedById: row['uploaded_by_id'] as String,
            subjectId: row['subject_id'] as String,
            teacherId: row['teacher_id'] as String,
            filePath: row['file_path'] as String?,
            fileSize: row['file_size'] as int?,
            uploadedAtMs: row['uploaded_at'] as int),
        arguments: [id]);
  }

  @override
  Future<List<AttachmentModel>> findBySubjectId(String subjectId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM attachments WHERE subject_id = ?1',
        mapper: (Map<String, Object?> row) => AttachmentModel(
            id: row['id'] as String?,
            fileName: row['file_name'] as String,
            fileType: row['file_type'] as String,
            uploadedById: row['uploaded_by_id'] as String,
            subjectId: row['subject_id'] as String,
            teacherId: row['teacher_id'] as String,
            filePath: row['file_path'] as String?,
            fileSize: row['file_size'] as int?,
            uploadedAtMs: row['uploaded_at'] as int),
        arguments: [subjectId]);
  }

  @override
  Future<List<AttachmentModel>> findByTeacherId(String teacherId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM attachments WHERE teacher_id = ?1',
        mapper: (Map<String, Object?> row) => AttachmentModel(
            id: row['id'] as String?,
            fileName: row['file_name'] as String,
            fileType: row['file_type'] as String,
            uploadedById: row['uploaded_by_id'] as String,
            subjectId: row['subject_id'] as String,
            teacherId: row['teacher_id'] as String,
            filePath: row['file_path'] as String?,
            fileSize: row['file_size'] as int?,
            uploadedAtMs: row['uploaded_at'] as int),
        arguments: [teacherId]);
  }

  @override
  Future<List<AttachmentModel>> findByUploadedById(String uploadedById) async {
    return _queryAdapter.queryList(
        'SELECT * FROM attachments WHERE uploaded_by_id = ?1',
        mapper: (Map<String, Object?> row) => AttachmentModel(
            id: row['id'] as String?,
            fileName: row['file_name'] as String,
            fileType: row['file_type'] as String,
            uploadedById: row['uploaded_by_id'] as String,
            subjectId: row['subject_id'] as String,
            teacherId: row['teacher_id'] as String,
            filePath: row['file_path'] as String?,
            fileSize: row['file_size'] as int?,
            uploadedAtMs: row['uploaded_at'] as int),
        arguments: [uploadedById]);
  }

  @override
  Future<List<AttachmentModel>> findAll() async {
    return _queryAdapter.queryList(
        'SELECT * FROM attachments ORDER BY uploaded_at DESC',
        mapper: (Map<String, Object?> row) => AttachmentModel(
            id: row['id'] as String?,
            fileName: row['file_name'] as String,
            fileType: row['file_type'] as String,
            uploadedById: row['uploaded_by_id'] as String,
            subjectId: row['subject_id'] as String,
            teacherId: row['teacher_id'] as String,
            filePath: row['file_path'] as String?,
            fileSize: row['file_size'] as int?,
            uploadedAtMs: row['uploaded_at'] as int));
  }

  @override
  Future<void> deleteById(String id) async {
    await _queryAdapter.queryNoReturn('DELETE FROM attachments WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM attachments');
  }

  @override
  Future<int?> count() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM attachments',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<void> insertAttachment(AttachmentModel AttachmentModel) async {
    await _attachmentModelInsertionAdapter.insert(
        AttachmentModel, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateAttachment(AttachmentModel AttachmentModel) {
    return _attachmentModelUpdateAdapter.updateAndReturnChangedRows(
        AttachmentModel, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteAttachment(AttachmentModel AttachmentModel) {
    return _attachmentModelDeletionAdapter
        .deleteAndReturnChangedRows(AttachmentModel);
  }
}

class _$CareerDao extends CareerDao {
  _$CareerDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _careerEntityInsertionAdapter = InsertionAdapter(
            database,
            'careers',
            (CareerEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'educationalCenterId': item.educationalCenterId,
                  'semesters': item.semesters,
                  'credits': item.credits,
                  'subjects': item.subjects,
                  'processes': item.processes,
                  'reviews': item.reviews
                }),
        _careerEntityUpdateAdapter = UpdateAdapter(
            database,
            'careers',
            ['id'],
            (CareerEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'educationalCenterId': item.educationalCenterId,
                  'semesters': item.semesters,
                  'credits': item.credits,
                  'subjects': item.subjects,
                  'processes': item.processes,
                  'reviews': item.reviews
                }),
        _careerEntityDeletionAdapter = DeletionAdapter(
            database,
            'careers',
            ['id'],
            (CareerEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'educationalCenterId': item.educationalCenterId,
                  'semesters': item.semesters,
                  'credits': item.credits,
                  'subjects': item.subjects,
                  'processes': item.processes,
                  'reviews': item.reviews
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CareerEntity> _careerEntityInsertionAdapter;

  final UpdateAdapter<CareerEntity> _careerEntityUpdateAdapter;

  final DeletionAdapter<CareerEntity> _careerEntityDeletionAdapter;

  @override
  Future<List<CareerEntity>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM careers ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => CareerEntity(
            id: row['id'] as String,
            name: row['name'] as String,
            educationalCenterId: row['educationalCenterId'] as String,
            semesters: row['semesters'] as int,
            credits: row['credits'] as int,
            subjects: row['subjects'] as String,
            processes: row['processes'] as String,
            reviews: row['reviews'] as String));
  }

  @override
  Future<CareerEntity?> findById(String id) async {
    return _queryAdapter.query('SELECT * FROM careers WHERE id = ?1 LIMIT 1',
        mapper: (Map<String, Object?> row) => CareerEntity(
            id: row['id'] as String,
            name: row['name'] as String,
            educationalCenterId: row['educationalCenterId'] as String,
            semesters: row['semesters'] as int,
            credits: row['credits'] as int,
            subjects: row['subjects'] as String,
            processes: row['processes'] as String,
            reviews: row['reviews'] as String),
        arguments: [id]);
  }

  @override
  Future<int?> countCareers() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM careers',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<void> upsertCareer(CareerEntity career) async {
    await _careerEntityInsertionAdapter.insert(
        career, OnConflictStrategy.replace);
  }

  @override
  Future<void> upsertCareers(List<CareerEntity> careers) async {
    await _careerEntityInsertionAdapter.insertList(
        careers, OnConflictStrategy.replace);
  }

  @override
  Future<int> updateCareer(CareerEntity career) {
    return _careerEntityUpdateAdapter.updateAndReturnChangedRows(
        career, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteCareer(CareerEntity career) {
    return _careerEntityDeletionAdapter.deleteAndReturnChangedRows(career);
  }
}

// ignore_for_file: unused_element
final _authProviderConverter = AuthProviderConverter();
