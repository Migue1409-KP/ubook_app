import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TeacherDatabase {
  static final TeacherDatabase instance = TeacherDatabase._init();
  static Database? _database;

  TeacherDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('teacher_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const textNullableType = 'TEXT';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
      CREATE TABLE teachers (
        id $idType,
        first_name $textType,
        last_name $textType,
        email $textType,
        phone $textNullableType,
        age $integerType,
        department $textNullableType,
        specialty $textNullableType,
        subjects $textNullableType,
        profile_image_url $textNullableType,
        is_active $integerType,
        created_at $textType,
        updated_at $textType
      )
    ''');
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
