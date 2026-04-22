import 'app_database.dart';

class DatabaseService {
  DatabaseService._();

  static final DatabaseService instance = DatabaseService._();

  AppDatabase? _database;

  Future<AppDatabase> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await $FloorAppDatabase.databaseBuilder('ubook_app.db').build();
    return _database!;
  }
}
