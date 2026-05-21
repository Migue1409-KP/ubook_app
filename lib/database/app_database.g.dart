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

  ProcessDao? _processDaoInstance;

  CareerDao? _careerDaoInstance;

  SubjectTeacherDao? _subjectTeacherDaoInstance;

  NotificationDao? _notificationDaoInstance;
  TeacherDao? _teacherDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 9,
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
            'CREATE TABLE IF NOT EXISTS `subject_teachers` (`id` TEXT NOT NULL, `subject_id` TEXT NOT NULL, `subject_nombre` TEXT NOT NULL, `subject_creditos` INTEGER NOT NULL, `subject_horas` INTEGER NOT NULL, `teacher_id` TEXT NOT NULL, `teacher_name` TEXT NOT NULL, `teacher_email` TEXT NOT NULL, `is_active` INTEGER NOT NULL, `periodo_academico_id` TEXT, `periodo_etiqueta` TEXT, `created_at_ms` INTEGER NOT NULL, `updated_at_ms` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `careers` (`id` TEXT NOT NULL, `name` TEXT NOT NULL, `educationalCenterId` TEXT NOT NULL, `semesters` INTEGER NOT NULL, `credits` INTEGER NOT NULL, `subjects` TEXT NOT NULL, `processes` TEXT NOT NULL, `reviews` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `processes` (`id` TEXT NOT NULL, `name` TEXT NOT NULL, `description` TEXT NOT NULL, `required_documents_json` TEXT NOT NULL, `process_type` TEXT NOT NULL, `related_id` TEXT, `is_active` INTEGER NOT NULL, `created_at_ms` INTEGER, `updated_at_ms` INTEGER, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `notifications` (`id` TEXT NOT NULL, `title` TEXT NOT NULL, `message` TEXT NOT NULL, `notification_type` TEXT NOT NULL, `status` TEXT NOT NULL, `created_at_ms` INTEGER NOT NULL, PRIMARY KEY (`id`))');
            'CREATE TABLE IF NOT EXISTS `teachers` (`id` TEXT NOT NULL, `first_name` TEXT NOT NULL, `last_name` TEXT NOT NULL, `email` TEXT NOT NULL, `phone` TEXT NOT NULL, `age` INTEGER NOT NULL, `department` TEXT NOT NULL, `specialty` TEXT NOT NULL, `subjects` TEXT NOT NULL, `profile_image_url` TEXT NOT NULL, `is_active` INTEGER NOT NULL, `created_at` INTEGER NOT NULL, `updated_at` INTEGER NOT NULL, PRIMARY KEY (`id`))');
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
  ProcessDao get processDao {
    return _processDaoInstance ??= _$ProcessDao(database, changeListener);
  }

  @override
  CareerDao get careerDao {
    return _careerDaoInstance ??= _$CareerDao(database, changeListener);
  }

  @override
  SubjectTeacherDao get subjectTeacherDao {
    return _subjectTeacherDaoInstance ??=
        _$SubjectTeacherDao(database, changeListener);
  }

  @override
  NotificationDao get notificationDao {
    return _notificationDaoInstance ??=
        _$NotificationDao(database, changeListener);
  TeacherDao get teacherDao {
    return _teacherDaoInstance ??= _$TeacherDao(database, changeListener);
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

class _$ProcessDao extends ProcessDao {
  _$ProcessDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _processModelInsertionAdapter = InsertionAdapter(
            database,
            'processes',
            (ProcessModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'required_documents_json':
                      _stringListConverter.encode(item.requiredDocuments),
                  'process_type':
                      _processTypeConverter.encode(item.processType),
                  'related_id': item.relatedId,
                  'is_active': item.isActive ? 1 : 0,
                  'created_at_ms':
                      _nullableDateTimeConverter.encode(item.createdAt),
                  'updated_at_ms':
                      _nullableDateTimeConverter.encode(item.updatedAt)
                }),
        _processModelUpdateAdapter = UpdateAdapter(
            database,
            'processes',
            ['id'],
            (ProcessModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'required_documents_json':
                      _stringListConverter.encode(item.requiredDocuments),
                  'process_type':
                      _processTypeConverter.encode(item.processType),
                  'related_id': item.relatedId,
                  'is_active': item.isActive ? 1 : 0,
                  'created_at_ms':
                      _nullableDateTimeConverter.encode(item.createdAt),
                  'updated_at_ms':
                      _nullableDateTimeConverter.encode(item.updatedAt)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ProcessModel> _processModelInsertionAdapter;

  final UpdateAdapter<ProcessModel> _processModelUpdateAdapter;

  @override
  Future<List<ProcessModel>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM processes ORDER BY rowid ASC',
        mapper: (Map<String, Object?> row) => ProcessModel(
            id: row['id'] as String,
            name: row['name'] as String,
            description: row['description'] as String,
            requiredDocuments: _stringListConverter
                .decode(row['required_documents_json'] as String),
            processType:
                _processTypeConverter.decode(row['process_type'] as String),
            relatedId: row['related_id'] as String?,
            isActive: (row['is_active'] as int) != 0,
            createdAt:
                _nullableDateTimeConverter.decode(row['created_at_ms'] as int?),
            updatedAt: _nullableDateTimeConverter
                .decode(row['updated_at_ms'] as int?)));
  }

  @override
  Future<int?> countProcesses() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM processes',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<void> deleteById(String id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM processes WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> insertProcess(ProcessModel process) async {
    await _processModelInsertionAdapter.insert(
        process, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertProcesses(List<ProcessModel> processes) async {
    await _processModelInsertionAdapter.insertList(
        processes, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateProcess(ProcessModel process) {
    return _processModelUpdateAdapter.updateAndReturnChangedRows(
        process, OnConflictStrategy.abort);
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

class _$SubjectTeacherDao extends SubjectTeacherDao {
  _$SubjectTeacherDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _subjectTeacherInsertionAdapter = InsertionAdapter(
            database,
            'subject_teachers',
            (SubjectTeacher item) => <String, Object?>{
                  'id': item.id,
                  'subject_id': item.subjectId,
                  'subject_nombre': item.subjectNombre,
                  'subject_creditos': item.subjectCreditos,
                  'subject_horas': item.subjectHoras,
                  'teacher_id': item.teacherId,
                  'teacher_name': item.teacherName,
                  'teacher_email': item.teacherEmail,
                  'is_active': item.isActive ? 1 : 0,
                  'periodo_academico_id': item.periodoAcademicoId,
                  'periodo_etiqueta': item.periodoEtiqueta,
                  'created_at_ms': item.createdAtMs,
                  'updated_at_ms': item.updatedAtMs
                }),
        _subjectTeacherUpdateAdapter = UpdateAdapter(
            database,
            'subject_teachers',
            ['id'],
            (SubjectTeacher item) => <String, Object?>{
                  'id': item.id,
                  'subject_id': item.subjectId,
                  'subject_nombre': item.subjectNombre,
                  'subject_creditos': item.subjectCreditos,
                  'subject_horas': item.subjectHoras,
                  'teacher_id': item.teacherId,
                  'teacher_name': item.teacherName,
                  'teacher_email': item.teacherEmail,
                  'is_active': item.isActive ? 1 : 0,
                  'periodo_academico_id': item.periodoAcademicoId,
                  'periodo_etiqueta': item.periodoEtiqueta,
                  'created_at_ms': item.createdAtMs,
                  'updated_at_ms': item.updatedAtMs
                }),
        _subjectTeacherDeletionAdapter = DeletionAdapter(
            database,
            'subject_teachers',
            ['id'],
            (SubjectTeacher item) => <String, Object?>{
                  'id': item.id,
                  'subject_id': item.subjectId,
                  'subject_nombre': item.subjectNombre,
                  'subject_creditos': item.subjectCreditos,
                  'subject_horas': item.subjectHoras,
                  'teacher_id': item.teacherId,
                  'teacher_name': item.teacherName,
                  'teacher_email': item.teacherEmail,
                  'is_active': item.isActive ? 1 : 0,
                  'periodo_academico_id': item.periodoAcademicoId,
                  'periodo_etiqueta': item.periodoEtiqueta,
                  'created_at_ms': item.createdAtMs,
                  'updated_at_ms': item.updatedAtMs
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SubjectTeacher> _subjectTeacherInsertionAdapter;

  final UpdateAdapter<SubjectTeacher> _subjectTeacherUpdateAdapter;

  final DeletionAdapter<SubjectTeacher> _subjectTeacherDeletionAdapter;

  @override
  Future<SubjectTeacher?> findById(String id) async {
    return _queryAdapter.query(
        'SELECT * FROM subject_teachers WHERE id = ?1 LIMIT 1',
        mapper: (Map<String, Object?> row) => SubjectTeacher(
            id: row['id'] as String,
            subjectId: row['subject_id'] as String,
            subjectNombre: row['subject_nombre'] as String,
            subjectCreditos: row['subject_creditos'] as int,
            subjectHoras: row['subject_horas'] as int,
            teacherId: row['teacher_id'] as String,
            teacherName: row['teacher_name'] as String,
            teacherEmail: row['teacher_email'] as String,
            isActive: (row['is_active'] as int) != 0,
            periodoAcademicoId: row['periodo_academico_id'] as String?,
            periodoEtiqueta: row['periodo_etiqueta'] as String?,
            createdAtMs: row['created_at_ms'] as int?,
            updatedAtMs: row['updated_at_ms'] as int?),
        arguments: [id]);
  }

  @override
  Future<List<SubjectTeacher>> findAll() async {
    return _queryAdapter.queryList(
        'SELECT * FROM subject_teachers ORDER BY created_at_ms DESC',
        mapper: (Map<String, Object?> row) => SubjectTeacher(
            id: row['id'] as String,
            subjectId: row['subject_id'] as String,
            subjectNombre: row['subject_nombre'] as String,
            subjectCreditos: row['subject_creditos'] as int,
            subjectHoras: row['subject_horas'] as int,
            teacherId: row['teacher_id'] as String,
            teacherName: row['teacher_name'] as String,
            teacherEmail: row['teacher_email'] as String,
            isActive: (row['is_active'] as int) != 0,
            periodoAcademicoId: row['periodo_academico_id'] as String?,
            periodoEtiqueta: row['periodo_etiqueta'] as String?,
            createdAtMs: row['created_at_ms'] as int?,
            updatedAtMs: row['updated_at_ms'] as int?));
  }

  @override
  Future<List<SubjectTeacher>> findByTeacherId(String teacherId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM subject_teachers WHERE teacher_id = ?1',
        mapper: (Map<String, Object?> row) => SubjectTeacher(
            id: row['id'] as String,
            subjectId: row['subject_id'] as String,
            subjectNombre: row['subject_nombre'] as String,
            subjectCreditos: row['subject_creditos'] as int,
            subjectHoras: row['subject_horas'] as int,
            teacherId: row['teacher_id'] as String,
            teacherName: row['teacher_name'] as String,
            teacherEmail: row['teacher_email'] as String,
            isActive: (row['is_active'] as int) != 0,
            periodoAcademicoId: row['periodo_academico_id'] as String?,
            periodoEtiqueta: row['periodo_etiqueta'] as String?,
            createdAtMs: row['created_at_ms'] as int?,
            updatedAtMs: row['updated_at_ms'] as int?),
        arguments: [teacherId]);
  }

  @override
  Future<List<SubjectTeacher>> findBySubjectId(String subjectId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM subject_teachers WHERE subject_id = ?1',
        mapper: (Map<String, Object?> row) => SubjectTeacher(
            id: row['id'] as String,
            subjectId: row['subject_id'] as String,
            subjectNombre: row['subject_nombre'] as String,
            subjectCreditos: row['subject_creditos'] as int,
            subjectHoras: row['subject_horas'] as int,
            teacherId: row['teacher_id'] as String,
            teacherName: row['teacher_name'] as String,
            teacherEmail: row['teacher_email'] as String,
            isActive: (row['is_active'] as int) != 0,
            periodoAcademicoId: row['periodo_academico_id'] as String?,
            periodoEtiqueta: row['periodo_etiqueta'] as String?,
            createdAtMs: row['created_at_ms'] as int?,
            updatedAtMs: row['updated_at_ms'] as int?),
        arguments: [subjectId]);
  }

  @override
  Future<List<SubjectTeacher>> findByTeacherIdAndPeriodo(
    String teacherId,
    String periodoId,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM subject_teachers WHERE teacher_id = ?1 AND periodo_academico_id = ?2',
        mapper: (Map<String, Object?> row) => SubjectTeacher(id: row['id'] as String, subjectId: row['subject_id'] as String, subjectNombre: row['subject_nombre'] as String, subjectCreditos: row['subject_creditos'] as int, subjectHoras: row['subject_horas'] as int, teacherId: row['teacher_id'] as String, teacherName: row['teacher_name'] as String, teacherEmail: row['teacher_email'] as String, isActive: (row['is_active'] as int) != 0, periodoAcademicoId: row['periodo_academico_id'] as String?, periodoEtiqueta: row['periodo_etiqueta'] as String?, createdAtMs: row['created_at_ms'] as int?, updatedAtMs: row['updated_at_ms'] as int?),
        arguments: [teacherId, periodoId]);
  }

  @override
  Future<List<SubjectTeacher>> findByPeriodo(String periodoId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM subject_teachers WHERE periodo_academico_id = ?1',
        mapper: (Map<String, Object?> row) => SubjectTeacher(
            id: row['id'] as String,
            subjectId: row['subject_id'] as String,
            subjectNombre: row['subject_nombre'] as String,
            subjectCreditos: row['subject_creditos'] as int,
            subjectHoras: row['subject_horas'] as int,
            teacherId: row['teacher_id'] as String,
            teacherName: row['teacher_name'] as String,
            teacherEmail: row['teacher_email'] as String,
            isActive: (row['is_active'] as int) != 0,
            periodoAcademicoId: row['periodo_academico_id'] as String?,
            periodoEtiqueta: row['periodo_etiqueta'] as String?,
            createdAtMs: row['created_at_ms'] as int?,
            updatedAtMs: row['updated_at_ms'] as int?),
        arguments: [periodoId]);
  }

  @override
  Future<void> deleteById(String id) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM subject_teachers WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM subject_teachers');
  }

  @override
  Future<int?> count() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM subject_teachers',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<void> insertSubjectTeacher(SubjectTeacher subjectTeacher) async {
    await _subjectTeacherInsertionAdapter.insert(
        subjectTeacher, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateSubjectTeacher(SubjectTeacher subjectTeacher) {
    return _subjectTeacherUpdateAdapter.updateAndReturnChangedRows(
        subjectTeacher, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteSubjectTeacher(SubjectTeacher subjectTeacher) {
    return _subjectTeacherDeletionAdapter
        .deleteAndReturnChangedRows(subjectTeacher);
  }
}

class _$NotificationDao extends NotificationDao {
  _$NotificationDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _notificationModelInsertionAdapter = InsertionAdapter(
            database,
            'notifications',
            (NotificationModel item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'message': item.message,
                  'notification_type':
                      _notificationTypeConverter.encode(item.type),
                  'status': _notificationStatusConverter.encode(item.status),
                  'created_at_ms': _dateTimeConverter.encode(item.createdAt)
                },
            changeListener),
        _notificationModelUpdateAdapter = UpdateAdapter(
            database,
            'notifications',
            ['id'],
            (NotificationModel item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'message': item.message,
                  'notification_type':
                      _notificationTypeConverter.encode(item.type),
                  'status': _notificationStatusConverter.encode(item.status),
                  'created_at_ms': _dateTimeConverter.encode(item.createdAt)
                },
            changeListener),
        _notificationModelDeletionAdapter = DeletionAdapter(
            database,
            'notifications',
            ['id'],
            (NotificationModel item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'message': item.message,
                  'notification_type':
                      _notificationTypeConverter.encode(item.type),
                  'status': _notificationStatusConverter.encode(item.status),
                  'created_at_ms': _dateTimeConverter.encode(item.createdAt)
                },
            changeListener);
class _$TeacherDao extends TeacherDao {
  _$TeacherDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _teacherInsertionAdapter = InsertionAdapter(
            database,
            'teachers',
            (Teacher item) => <String, Object?>{
                  'id': item.id,
                  'first_name': item.firstName,
                  'last_name': item.lastName,
                  'email': item.email,
                  'phone': item.phone,
                  'age': item.age,
                  'department': item.department,
                  'specialty': item.specialty,
                  'subjects': _stringListConverter.encode(item.subjects),
                  'profile_image_url': item.profileImageUrl,
                  'is_active': item.isActive ? 1 : 0,
                  'created_at': _dateTimeConverter.encode(item.createdAt),
                  'updated_at': _dateTimeConverter.encode(item.updatedAt)
                }),
        _teacherUpdateAdapter = UpdateAdapter(
            database,
            'teachers',
            ['id'],
            (Teacher item) => <String, Object?>{
                  'id': item.id,
                  'first_name': item.firstName,
                  'last_name': item.lastName,
                  'email': item.email,
                  'phone': item.phone,
                  'age': item.age,
                  'department': item.department,
                  'specialty': item.specialty,
                  'subjects': _stringListConverter.encode(item.subjects),
                  'profile_image_url': item.profileImageUrl,
                  'is_active': item.isActive ? 1 : 0,
                  'created_at': _dateTimeConverter.encode(item.createdAt),
                  'updated_at': _dateTimeConverter.encode(item.updatedAt)
                }),
        _teacherDeletionAdapter = DeletionAdapter(
            database,
            'teachers',
            ['id'],
            (Teacher item) => <String, Object?>{
                  'id': item.id,
                  'first_name': item.firstName,
                  'last_name': item.lastName,
                  'email': item.email,
                  'phone': item.phone,
                  'age': item.age,
                  'department': item.department,
                  'specialty': item.specialty,
                  'subjects': _stringListConverter.encode(item.subjects),
                  'profile_image_url': item.profileImageUrl,
                  'is_active': item.isActive ? 1 : 0,
                  'created_at': _dateTimeConverter.encode(item.createdAt),
                  'updated_at': _dateTimeConverter.encode(item.updatedAt)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<NotificationModel> _notificationModelInsertionAdapter;

  final UpdateAdapter<NotificationModel> _notificationModelUpdateAdapter;

  final DeletionAdapter<NotificationModel> _notificationModelDeletionAdapter;

  @override
  Future<List<NotificationModel>> findAll() async {
    return _queryAdapter.queryList(
        'SELECT * FROM notifications ORDER BY created_at_ms DESC',
        mapper: (Map<String, Object?> row) => NotificationModel(
            id: row['id'] as String,
            title: row['title'] as String,
            message: row['message'] as String,
            type: _notificationTypeConverter
                .decode(row['notification_type'] as String),
            status:
                _notificationStatusConverter.decode(row['status'] as String),
            createdAt: _dateTimeConverter.decode(row['created_at_ms'] as int)));
  }

  @override
  Stream<List<NotificationModel>> watchAll() {
    return _queryAdapter.queryListStream(
        'SELECT * FROM notifications ORDER BY created_at_ms DESC',
        mapper: (Map<String, Object?> row) => NotificationModel(
            id: row['id'] as String,
            title: row['title'] as String,
            message: row['message'] as String,
            type: _notificationTypeConverter
                .decode(row['notification_type'] as String),
            status:
                _notificationStatusConverter.decode(row['status'] as String),
            createdAt: _dateTimeConverter.decode(row['created_at_ms'] as int)),
        queryableName: 'notifications',
        isView: false);
  }

  @override
  Future<NotificationModel?> findById(String id) async {
    return _queryAdapter.query(
        'SELECT * FROM notifications WHERE id = ?1 LIMIT 1',
        mapper: (Map<String, Object?> row) => NotificationModel(
            id: row['id'] as String,
            title: row['title'] as String,
            message: row['message'] as String,
            type: _notificationTypeConverter
                .decode(row['notification_type'] as String),
            status:
                _notificationStatusConverter.decode(row['status'] as String),
            createdAt: _dateTimeConverter.decode(row['created_at_ms'] as int)),
        arguments: [id]);
  }

  @override
  Future<int?> countNotifications() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM notifications',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<void> deleteById(String id) async {
    await _queryAdapter.queryNoReturn('DELETE FROM notifications WHERE id = ?1',
  final InsertionAdapter<Teacher> _teacherInsertionAdapter;

  final UpdateAdapter<Teacher> _teacherUpdateAdapter;

  final DeletionAdapter<Teacher> _teacherDeletionAdapter;

  @override
  Future<List<Teacher>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM teachers',
        mapper: (Map<String, Object?> row) => Teacher(
            id: row['id'] as String,
            firstName: row['first_name'] as String,
            lastName: row['last_name'] as String,
            email: row['email'] as String,
            phone: row['phone'] as String,
            age: row['age'] as int,
            department: row['department'] as String,
            specialty: row['specialty'] as String,
            subjects: _stringListConverter.decode(row['subjects'] as String),
            profileImageUrl: row['profile_image_url'] as String,
            isActive: (row['is_active'] as int) != 0,
            createdAt: _dateTimeConverter.decode(row['created_at'] as int),
            updatedAt: _dateTimeConverter.decode(row['updated_at'] as int)));
  }

  @override
  Future<Teacher?> findById(String id) async {
    return _queryAdapter.query('SELECT * FROM teachers WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Teacher(
            id: row['id'] as String,
            firstName: row['first_name'] as String,
            lastName: row['last_name'] as String,
            email: row['email'] as String,
            phone: row['phone'] as String,
            age: row['age'] as int,
            department: row['department'] as String,
            specialty: row['specialty'] as String,
            subjects: _stringListConverter.decode(row['subjects'] as String),
            profileImageUrl: row['profile_image_url'] as String,
            isActive: (row['is_active'] as int) != 0,
            createdAt: _dateTimeConverter.decode(row['created_at'] as int),
            updatedAt: _dateTimeConverter.decode(row['updated_at'] as int)),
        arguments: [id]);
  }

  @override
  Future<void> deleteByStatus(String status) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM notifications WHERE status = ?1',
        arguments: [status]);
  }

  @override
  Future<void> deleteAllNotifications() async {
    await _queryAdapter.queryNoReturn('DELETE FROM notifications');
  }

  @override
  Future<void> insertNotification(NotificationModel notification) async {
    await _notificationModelInsertionAdapter.insert(
        notification, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertNotifications(
      List<NotificationModel> notifications) async {
    await _notificationModelInsertionAdapter.insertList(
        notifications, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateNotification(NotificationModel notification) {
    return _notificationModelUpdateAdapter.updateAndReturnChangedRows(
        notification, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteNotification(NotificationModel notification) {
    return _notificationModelDeletionAdapter
        .deleteAndReturnChangedRows(notification);
  Future<void> insertTeacher(Teacher teacher) async {
    await _teacherInsertionAdapter.insert(teacher, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateTeacher(Teacher teacher) async {
    await _teacherUpdateAdapter.update(teacher, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteTeacher(Teacher teacher) async {
    await _teacherDeletionAdapter.delete(teacher);
  }
}

// ignore_for_file: unused_element
final _authProviderConverter = AuthProviderConverter();
final _processTypeConverter = ProcessTypeConverter();
final _stringListConverter = StringListConverter();
final _dateTimeConverter = DateTimeConverter();
final _nullableDateTimeConverter = NullableDateTimeConverter();
final _notificationTypeConverter = NotificationTypeConverter();
final _notificationStatusConverter = NotificationStatusConverter();
