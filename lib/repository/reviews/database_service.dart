import 'app_database.dart';

class DatabaseService {
  DatabaseService._();

  static final DatabaseService instance = DatabaseService._();

  AppDatabase? _database;

  Future<AppDatabase> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<AppDatabase> _initDatabase() async {
    return await $FloorAppDatabase.databaseBuilder('ubook_app.db').build();
  }
}
