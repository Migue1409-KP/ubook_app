// ignore_for_file: experimental_member_use

import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:ubook_app/model/attachments/attachment_model.dart';
import 'package:ubook_app/model/auth/user_model.dart';
import 'package:ubook_app/model/notification/notification_model.dart';
import 'package:ubook_app/model/process/process_model.dart';
import 'package:ubook_app/model/career/career_entity.dart';
import 'package:ubook_app/model/reviews/review.dart';
import 'package:ubook_app/model/subjectteacher/subjectteacher.dart';
import 'package:ubook_app/repository/attachments/attachment_dao.dart';
import 'package:ubook_app/repository/auth/floor_converters.dart';
import 'package:ubook_app/repository/auth/user_dao.dart';
import 'package:ubook_app/repository/career/career_dao.dart';
import 'package:ubook_app/repository/notification/notification_dao.dart';
import 'package:ubook_app/repository/notification/notification_floor_converters.dart';
import 'package:ubook_app/repository/process/process_dao.dart';
import 'package:ubook_app/repository/process/process_floor_converters.dart';
import 'package:ubook_app/repository/reviews/review_dao.dart';
import 'package:ubook_app/repository/teacher_subject/subject_teacher_dao.dart';
import 'package:ubook_app/model/teachers/teacher.dart';
import 'package:ubook_app/repository/teachers/teacher_dao.dart';
import 'package:ubook_app/database/entity/subject_entity.dart';
import 'package:ubook_app/database/dao/subject_dao.dart';

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
    'CREATE TABLE IF NOT EXISTS `subject_teachers` ('
    '`id` TEXT NOT NULL, '
    '`subject_id` TEXT NOT NULL, '
    '`subject_nombre` TEXT NOT NULL, '
    '`subject_creditos` INTEGER NOT NULL, '
    '`subject_horas` INTEGER NOT NULL, '
    '`teacher_id` TEXT NOT NULL, '
    '`teacher_name` TEXT NOT NULL, '
    '`teacher_email` TEXT NOT NULL, '
    '`is_active` INTEGER NOT NULL, '
    '`created_at_ms` INTEGER NOT NULL, '
    '`updated_at_ms` INTEGER NOT NULL, '
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

final migration5to6 = Migration(5, 6, (database) async {
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

final migration6to7 = Migration(6, 7, (database) async {
  await database.execute(
    'ALTER TABLE `subject_teachers` ADD COLUMN `periodo_academico_id` TEXT',
  );
  await database.execute(
    'ALTER TABLE `subject_teachers` ADD COLUMN `periodo_etiqueta` TEXT',
  );
});

final migration7to8 = Migration(7, 8, (database) async {
  try {
    await database.execute(
      'ALTER TABLE `subject_teachers` RENAME COLUMN `subjectId` TO `subject_id`',
    );
  } catch (_) {}
  try {
    await database.execute(
      'ALTER TABLE `subject_teachers` RENAME COLUMN `teacherId` TO `teacher_id`',
    );
  } catch (_) {}
  await database.execute(
    'CREATE TABLE IF NOT EXISTS `notifications` ('
    '`id` TEXT NOT NULL, '
    '`title` TEXT NOT NULL, '
    '`message` TEXT NOT NULL, '
    '`notification_type` TEXT NOT NULL, '
    '`status` TEXT NOT NULL, '
    '`created_at_ms` INTEGER, '
    'PRIMARY KEY (`id`)'
    ')',
  );
  await database.execute('DELETE FROM notifications');
});

final migration8to9 = Migration(8, 9, (database) async {
  await database.execute(
    'CREATE TABLE IF NOT EXISTS `teachers` ('
    '`id` TEXT NOT NULL, '
    '`first_name` TEXT NOT NULL, '
    '`last_name` TEXT NOT NULL, '
    '`email` TEXT NOT NULL, '
    '`phone` TEXT NOT NULL, '
    '`age` INTEGER NOT NULL, '
    '`department` TEXT NOT NULL, '
    '`specialty` TEXT NOT NULL, '
    '`subjects` TEXT NOT NULL, '
    '`profile_image_url` TEXT NOT NULL, '
    '`is_active` INTEGER NOT NULL, '
    '`created_at` INTEGER NOT NULL, '
    '`updated_at` INTEGER NOT NULL, '
    'PRIMARY KEY (`id`)'
    ')',
  );
  await database.execute(
    'ALTER TABLE `careers` ADD COLUMN `modalityId` INTEGER',
  );
  await database.execute(
    'ALTER TABLE `careers` ADD COLUMN `modalityName` TEXT',
  );
});

final migration9to10 = Migration(9, 10, (database) async {
  await database.execute(
    'CREATE TABLE IF NOT EXISTS `subjects` ('
    '`id` TEXT NOT NULL, '
    '`nombre` TEXT NOT NULL, '
    '`creditos` INTEGER NOT NULL, '
    '`horas` INTEGER NOT NULL, '
    '`descripcion` TEXT, '
    '`is_sync` INTEGER NOT NULL DEFAULT 0, '
    '`last_update` INTEGER NOT NULL DEFAULT 0, '
    'PRIMARY KEY (`id`)'
    ')',
  );
});

final migration10to11 = Migration(10, 11, (database) async {
  await database.execute(
    'CREATE INDEX IF NOT EXISTS `idx_subjects_last_update` ON `subjects` (`last_update`)',
  );
});

final migration11to12 = Migration(11, 12, (database) async {
  // is_sync ya debería existir desde migration9to10
  // Esta migración solo crea el índice y maneja el caso edge
  try {
    await database.execute('ALTER TABLE `subjects` ADD COLUMN `is_sync` INTEGER NOT NULL DEFAULT 1');
  } catch (_) {
    // La columna ya existe o hay error de SQLite < 3.25.0
  }
});

final migration12to13 = Migration(12, 13, (database) async {
  final columns = await database.rawQuery("PRAGMA table_info(subjects)");
  final columnNames = columns.map((c) => c['name'] as String).toSet();
  
  // Si ya tiene el esquema correcto, no hacer nada
  if (columnNames.contains('nombre') && columnNames.contains('last_update')) {
    return;
  }
  
  // Obtener datos existentes
  final List<Map<String, dynamic>> existingData = 
      columnNames.contains('id') ? await database.query('subjects') : [];
  
  // Crear nueva tabla con esquema correcto
  await database.execute('DROP TABLE IF EXISTS subjects_new');
  await database.execute(
    'CREATE TABLE subjects_new ('
    '`id` TEXT NOT NULL, '
    '`nombre` TEXT NOT NULL, '
    '`creditos` INTEGER NOT NULL, '
    '`horas` INTEGER NOT NULL, '
    '`descripcion` TEXT, '
    '`is_sync` INTEGER NOT NULL DEFAULT 0, '
    '`last_update` INTEGER NOT NULL DEFAULT 0, '
    'PRIMARY KEY (`id`)'
    ')',
  );
  
  // Insertar datos migrados según el esquema detectado
  for (final row in existingData) {
    await database.execute(
      'INSERT OR REPLACE INTO subjects_new (id, nombre, creditos, horas, descripcion, is_sync, last_update) VALUES (?, ?, ?, ?, ?, ?, ?)',
      [
        row['id'],
        row['nombre'] ?? row['name'],
        row['creditos'] ?? row['credits'],
        row['horas'] ?? row['hours'],
        row['descripcion'] ?? row['description'],
        row['is_sync'] ?? row['isSync'] ?? 1,
        row['last_update'] ?? row['lastUpdate'] ?? 0,
      ],
    );
  }
  
  await database.execute('DROP TABLE subjects');
  await database.execute('ALTER TABLE subjects_new RENAME TO subjects');
  await database.execute('CREATE INDEX IF NOT EXISTS `idx_subjects_last_update` ON `subjects` (`last_update`)');
});

@TypeConverters([
  AuthProviderConverter,
  StringListConverter,
  NotificationDateTimeConverter,
  NullableDateTimeConverter,
  NotificationTypeConverter,
  NotificationStatusConverter,
])
@Database(
  version: 13,
  entities: [
    UserModel,
    Review,
    AttachmentModel,
    SubjectEntity,
    SubjectTeacher,
    CareerEntity,
    ProcessModel,
    Teacher,
    NotificationModel,
  ],
)
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;
  ReviewDao get reviewDao;
  AttachmentDao get attachmentDao;
  ProcessDao get processDao;
  CareerDao get careerDao;
  SubjectDao get subjectDao;
  SubjectTeacherDao get subjectTeacherDao;
  NotificationDao get notificationDao;
  TeacherDao get teacherDao;
}
