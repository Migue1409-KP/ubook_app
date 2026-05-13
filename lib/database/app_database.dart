// ignore_for_file: experimental_member_use

import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:ubook_app/model/attachments/attachment_model.dart';
import 'package:ubook_app/model/auth/user_model.dart';
import 'package:ubook_app/model/process/process_model.dart';
import 'package:ubook_app/model/reviews/review.dart';
import 'package:ubook_app/repository/attachments/attachment_dao.dart';
import 'package:ubook_app/repository/auth/floor_converters.dart';
import 'package:ubook_app/repository/auth/user_dao.dart';
import 'package:ubook_app/repository/process/process_dao.dart';
import 'package:ubook_app/repository/process/process_floor_converters.dart';
import 'package:ubook_app/repository/reviews/review_dao.dart';

part 'app_database.g.dart';

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

final migration3to4 = Migration(3, 4, (database) async {
  await database.execute(
    'CREATE TABLE IF NOT EXISTS `processes` ('
    '`id` TEXT NOT NULL, '
    '`name` TEXT NOT NULL, '
    '`description` TEXT NOT NULL, '
    '`required_documents_json` TEXT NOT NULL, '
    '`process_type` TEXT NOT NULL, '
    '`related_id` TEXT, '
    '`is_active` INTEGER NOT NULL, '
    '`created_at_ms` INTEGER, '
    '`updated_at_ms` INTEGER, '
    'PRIMARY KEY (`id`)'
    ')',
  );
});

@TypeConverters([
  AuthProviderConverter,
  ProcessTypeConverter,
  StringListConverter,
  NullableDateTimeConverter,
])
@Database(version: 4, entities: [UserModel, Review, AttachmentModel, ProcessModel])
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;
  ReviewDao get reviewDao;
  AttachmentDao get attachmentDao;
  ProcessDao get processDao;
}
