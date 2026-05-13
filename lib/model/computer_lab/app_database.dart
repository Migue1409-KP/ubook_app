import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'computer_lab.dart';
import 'computer_lab_dao.dart';

part 'app_database.g.dart';

final migration1to2 = Migration(1, 2, (database) async {
  await database.execute(
    "ALTER TABLE computer_labs ADD COLUMN city TEXT NOT NULL DEFAULT ''",
  );
});

@Database(version: 2, entities: [ComputerLab])
abstract class AppDatabase extends FloorDatabase {
  ComputerLabDao get computerLabDao;
}
