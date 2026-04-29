import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:ubook_app/model/auth/user_model.dart';
import 'package:ubook_app/model/reviews/review.dart';
import 'package:ubook_app/repository/auth/floor_converters.dart';
import 'package:ubook_app/repository/auth/user_dao.dart';
import 'package:ubook_app/repository/reviews/review_dao.dart';

part 'app_database.g.dart';

@TypeConverters([AuthProviderConverter])
final migration1to2 = Migration(1, 2, (database) async {
  await database.execute(
    'CREATE TABLE IF NOT EXISTS `reviews` (`id` TEXT NOT NULL, `entityId` TEXT NOT NULL, `entityType` TEXT NOT NULL, `userId` TEXT NOT NULL, `rating` INTEGER NOT NULL, `title` TEXT NOT NULL, `content` TEXT, `createdAtMs` INTEGER, `updatedAtMs` INTEGER, `metadataJson` TEXT, PRIMARY KEY (`id`))',
  );
});

@Database(version: 2, entities: [UserModel, Review])
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;
  ReviewDao get reviewDao;
}
