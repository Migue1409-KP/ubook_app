import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../../model/reviews/review.dart';
import 'review_dao.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [Review])
abstract class AppDatabase extends FloorDatabase {
  ReviewDao get reviewDao;
}


