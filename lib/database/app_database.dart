import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:ubook_app/model/attachments/attachment_model.dart';
import 'package:ubook_app/model/auth/user_model.dart';
import 'package:ubook_app/model/career/career_entity.dart';
import 'package:ubook_app/model/reviews/review.dart';
import 'package:ubook_app/repository/attachments/attachment_dao.dart';
import 'package:ubook_app/repository/auth/floor_converters.dart';
import 'package:ubook_app/repository/auth/user_dao.dart';
import 'package:ubook_app/repository/career/career_dao.dart';
import 'package:ubook_app/repository/reviews/review_dao.dart';

part 'app_database.g.dart';

@TypeConverters([AuthProviderConverter])
final migration1to2 = Migration(1, 2, (database) async {
  await database.execute(
    'CREATE TABLE IF NOT EXISTS `reviews` (`id` TEXT NOT NULL, `entityId` TEXT NOT NULL, `entityType` TEXT NOT NULL, `userId` TEXT NOT NULL, `rating` INTEGER NOT NULL, `title` TEXT NOT NULL, `content` TEXT, `createdAtMs` INTEGER, `updatedAtMs` INTEGER, `metadataJson` TEXT, PRIMARY KEY (`id`))',
  );
});

final migration2to3 = Migration(2, 3, (database) async {
  await database.execute(
    'CREATE TABLE IF NOT EXISTS `attachments` ('
    '`id` TEXT, '
    '`file_name` TEXT NOT NULL, '
    '`file_type` TEXT NOT NULL, '
    '`uploaded_by_id` TEXT NOT NULL, '
    '`subject_id` TEXT NOT NULL, '
    '`teacher_id` TEXT NOT NULL, '
    '`file_path` TEXT, '
    '`file_size` INTEGER, '
    '`uploaded_at` INTEGER NOT NULL, '
    'PRIMARY KEY (`id`)'
    ')',
  );
});

final migration4to5 = Migration(4, 5, (database) async {
  await database.execute(
    'CREATE TABLE IF NOT EXISTS `careers` ('
    '`id` TEXT NOT NULL, '
    '`name` TEXT NOT NULL, '
    '`educationalCenterId` TEXT NOT NULL, '
    '`semesters` INTEGER NOT NULL, '
    '`credits` INTEGER NOT NULL, '
    '`subjects` TEXT NOT NULL, '
    '`processes` TEXT NOT NULL, '
    '`reviews` TEXT NOT NULL, '
    'PRIMARY KEY (`id`)'
    ')',
  );
});

@Database(version: 5, entities: [UserModel, Review, AttachmentModel, CareerEntity])
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;
  ReviewDao get reviewDao;
  AttachmentDao get attachmentDao;
  CareerDao get careerDao;
}
