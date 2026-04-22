import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'computer_lab.dart';
import 'computer_lab_dao.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [ComputerLab])
abstract class AppDatabase extends FloorDatabase {
  ComputerLabDao get computerLabDao;
}
