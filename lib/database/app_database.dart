import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:ubook_app/model/auth/user_model.dart';
import 'package:ubook_app/repository/auth/floor_converters.dart';
import 'package:ubook_app/repository/auth/user_dao.dart';

part 'app_database.g.dart';

@TypeConverters([AuthProviderConverter])
@Database(version: 1, entities: [UserModel])
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;
}
