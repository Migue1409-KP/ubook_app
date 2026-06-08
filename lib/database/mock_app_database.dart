import 'dart:async';
import 'package:floor/floor.dart';
import 'package:ubook_app/database/app_database.dart';
import 'package:ubook_app/model/attachments/attachment_model.dart';
import 'package:ubook_app/model/auth/user_model.dart';
import 'package:ubook_app/model/notification/notification_model.dart';
import 'package:ubook_app/model/process/process_model.dart';
import 'package:ubook_app/model/career/career_entity.dart';
import 'package:ubook_app/model/reviews/review.dart';
import 'package:ubook_app/model/subjectteacher/subjectteacher.dart';
import 'package:ubook_app/model/teachers/teacher.dart';
import 'package:ubook_app/repository/attachments/attachment_dao.dart';
import 'package:ubook_app/repository/auth/user_dao.dart';
import 'package:ubook_app/repository/career/career_dao.dart';
import 'package:ubook_app/repository/notification/notification_dao.dart';
import 'package:ubook_app/repository/process/process_dao.dart';
import 'package:ubook_app/repository/reviews/review_dao.dart';
import 'package:ubook_app/repository/teacher_subject/subject_teacher_dao.dart';
import 'package:ubook_app/repository/notification/notification_floor_converters.dart';
import 'package:ubook_app/repository/teachers/teacher_dao.dart';

/// A mock implementation of [AppDatabase] for platforms that don't support
/// Floor's native sqflite backend (like Web).
class MockAppDatabase extends FloorDatabase implements AppDatabase {
  MockAppDatabase() {
    // Prevent Floor's internal initializer from running
  }

  @override
  final MockUserDao userDao = MockUserDao();

  @override
  final MockReviewDao reviewDao = MockReviewDao();

  @override
  final MockAttachmentDao attachmentDao = MockAttachmentDao();

  @override
  final MockProcessDao processDao = MockProcessDao();

  @override
  final MockCareerDao careerDao = MockCareerDao();

  @override
  final MockSubjectTeacherDao subjectTeacherDao = MockSubjectTeacherDao();

  @override
  final MockNotificationDao notificationDao = MockNotificationDao();

  @override
  final MockTeacherDao teacherDao = MockTeacherDao();

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return null;
  }
}

class MockUserDao implements UserDao {
  final Map<String, UserModel> _users = {};

  @override
  Future<UserModel?> findById(String id) async => _users[id];

  @override
  Future<UserModel?> findByEmail(String email) async {
    for (final u in _users.values) {
      if (u.email == email) return u;
    }
    return null;
  }

  @override
  Future<UserModel?> findMostRecentUser() async {
    if (_users.isEmpty) return null;
    final list = _users.values.toList();
    list.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return list.first;
  }

  @override
  Future<void> insertUser(UserModel user) async {
    _users[user.id] = user;
  }

  @override
  Future<int> updateUser(UserModel user) async {
    _users[user.id] = user;
    return 1;
  }

  @override
  Future<int> deleteUser(UserModel user) async {
    _users.remove(user.id);
    return 1;
  }

  @override
  Future<void> deleteAllUsers() async {
    _users.clear();
  }

  @override
  Future<int?> countUsers() async => _users.length;

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class MockReviewDao implements ReviewDao {
  final Map<String, Review> _reviews = {};

  @override
  Future<List<Review>> findByEntity(String entityId, String entityType) async {
    final results = _reviews.values
        .where((r) => r.entityId == entityId && r.entityType == entityType)
        .toList();
    results.sort((a, b) {
      final aMs = a.createdAtMs ?? 0;
      final bMs = b.createdAtMs ?? 0;
      return bMs.compareTo(aMs);
    });
    return results;
  }

  @override
  Future<Review?> findById(String id) async => _reviews[id];

  @override
  Future<int?> countReviews() async => _reviews.length;

  @override
  Future<void> insertReview(Review review) async {
    _reviews[review.id] = review;
  }

  @override
  Future<void> insertReviews(List<Review> reviews) async {
    for (final r in reviews) {
      _reviews[r.id] = r;
    }
  }

  @override
  Future<int> updateReview(Review review) async {
    _reviews[review.id] = review;
    return 1;
  }

  @override
  Future<int> deleteReview(Review review) async {
    _reviews.remove(review.id);
    return 1;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class MockAttachmentDao implements AttachmentDao {
  final Map<String, AttachmentModel> _attachments = {};

  @override
  Future<AttachmentModel?> findById(String id) async => _attachments[id];

  @override
  Future<List<AttachmentModel>> findBySubjectId(String subjectId) async {
    return _attachments.values.where((a) => a.subjectId == subjectId).toList();
  }

  @override
  Future<List<AttachmentModel>> findByTeacherId(String teacherId) async {
    return _attachments.values.where((a) => a.teacherId == teacherId).toList();
  }

  @override
  Future<List<AttachmentModel>> findByUploadedById(String uploadedById) async {
    return _attachments.values.where((a) => a.uploadedById == uploadedById).toList();
  }

  @override
  Future<List<AttachmentModel>> findAll() async {
    final list = _attachments.values.toList();
    list.sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));
    return list;
  }

  @override
  Future<void> insertAttachment(AttachmentModel attachment) async {
    _attachments[attachment.id ?? ''] = attachment;
  }

  @override
  Future<int> updateAttachment(AttachmentModel attachment) async {
    _attachments[attachment.id ?? ''] = attachment;
    return 1;
  }

  @override
  Future<int> deleteAttachment(AttachmentModel attachment) async {
    _attachments.remove(attachment.id);
    return 1;
  }

  @override
  Future<void> deleteById(String id) async {
    _attachments.remove(id);
  }

  @override
  Future<void> deleteAll() async {
    _attachments.clear();
  }

  @override
  Future<int?> count() async => _attachments.length;

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class MockProcessDao implements ProcessDao {
  final Map<String, ProcessModel> _processes = {};

  @override
  Future<List<ProcessModel>> findAll() async => _processes.values.toList();

  @override
  Future<int?> countProcesses() async => _processes.length;

  @override
  Future<void> insertProcess(ProcessModel process) async {
    _processes[process.id] = process;
  }

  @override
  Future<void> insertProcesses(List<ProcessModel> processes) async {
    for (final p in processes) {
      _processes[p.id] = p;
    }
  }

  @override
  Future<int> updateProcess(ProcessModel process) async {
    _processes[process.id] = process;
    return 1;
  }

  @override
  Future<ProcessModel?> findById(String id) async => _processes[id];

  @override
  Future<void> deleteById(String id) async {
    _processes.remove(id);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class MockCareerDao implements CareerDao {
  final Map<String, CareerEntity> _careers = {};

  @override
  Future<List<CareerEntity>> findAll() async {
    final list = _careers.values.toList();
    list.sort((a, b) => a.name.compareTo(b.name));
    return list;
  }

  @override
  Future<CareerEntity?> findById(String id) async => _careers[id];

  @override
  Future<int?> countCareers() async => _careers.length;

  @override
  Future<void> upsertCareer(CareerEntity career) async {
    _careers[career.id] = career;
  }

  @override
  Future<void> upsertCareers(List<CareerEntity> careers) async {
    for (final c in careers) {
      _careers[c.id] = c;
    }
  }

  @override
  Future<int> updateCareer(CareerEntity career) async {
    _careers[career.id] = career;
    return 1;
  }

  @override
  Future<int> deleteCareer(CareerEntity career) async {
    _careers.remove(career.id);
    return 1;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class MockSubjectTeacherDao implements SubjectTeacherDao {
  final Map<String, SubjectTeacher> _subjectTeachers = {};

  @override
  Future<SubjectTeacher?> findById(String id) async => _subjectTeachers[id];

  @override
  Future<List<SubjectTeacher>> findAll() async {
    final list = _subjectTeachers.values.toList();
    list.sort((a, b) => b.createdAtMs.compareTo(a.createdAtMs));
    return list;
  }

  @override
  Future<List<SubjectTeacher>> findByTeacherId(String teacherId) async {
    return _subjectTeachers.values.where((st) => st.teacherId == teacherId).toList();
  }

  @override
  Future<List<SubjectTeacher>> findBySubjectId(String subjectId) async {
    return _subjectTeachers.values.where((st) => st.subjectId == subjectId).toList();
  }

  @override
  Future<List<SubjectTeacher>> findByTeacherIdAndPeriodo(String teacherId, String periodoId) async {
    return _subjectTeachers.values
        .where((st) => st.teacherId == teacherId && st.periodoAcademicoId == periodoId)
        .toList();
  }

  @override
  Future<List<SubjectTeacher>> findByPeriodo(String periodoId) async {
    return _subjectTeachers.values.where((st) => st.periodoAcademicoId == periodoId).toList();
  }

  @override
  Future<void> insertSubjectTeacher(SubjectTeacher subjectTeacher) async {
    _subjectTeachers[subjectTeacher.id] = subjectTeacher;
  }

  @override
  Future<int> updateSubjectTeacher(SubjectTeacher subjectTeacher) async {
    _subjectTeachers[subjectTeacher.id] = subjectTeacher;
    return 1;
  }

  @override
  Future<int> deleteSubjectTeacher(SubjectTeacher subjectTeacher) async {
    _subjectTeachers.remove(subjectTeacher.id);
    return 1;
  }

  @override
  Future<void> deleteById(String id) async {
    _subjectTeachers.remove(id);
  }

  @override
  Future<void> deleteAll() async {
    _subjectTeachers.clear();
  }

  @override
  Future<int?> count() async => _subjectTeachers.length;

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class MockNotificationDao implements NotificationDao {
  final Map<String, NotificationModel> _notifications = {};
  final StreamController<List<NotificationModel>> _controller = StreamController<List<NotificationModel>>.broadcast();

  void _emit() {
    _controller.add(findAllSync());
  }

  List<NotificationModel> findAllSync() {
    final list = _notifications.values.toList();
    list.sort((a, b) {
      final aMs = a.createdAt.millisecondsSinceEpoch;
      final bMs = b.createdAt.millisecondsSinceEpoch;
      return bMs.compareTo(aMs);
    });
    return list;
  }

  @override
  Future<List<NotificationModel>> findAll() async => findAllSync();

  @override
  Stream<List<NotificationModel>> watchAll() {
    _emit();
    return _controller.stream;
  }

  @override
  Future<NotificationModel?> findById(String id) async => _notifications[id];

  @override
  Future<int?> countNotifications() async => _notifications.length;

  @override
  Future<void> insertNotification(NotificationModel notification) async {
    _notifications[notification.id] = notification;
    _emit();
  }

  @override
  Future<void> insertNotifications(List<NotificationModel> notifications) async {
    for (final n in notifications) {
      _notifications[n.id] = n;
    }
    _emit();
  }

  @override
  Future<int> updateNotification(NotificationModel notification) async {
    _notifications[notification.id] = notification;
    _emit();
    return 1;
  }

  @override
  Future<int> deleteNotification(NotificationModel notification) async {
    _notifications.remove(notification.id);
    _emit();
    return 1;
  }

  @override
  Future<void> deleteById(String id) async {
    _notifications.remove(id);
    _emit();
  }

  @override
  Future<void> deleteByStatus(String status) async {
    _notifications.removeWhere((key, value) => value.status.name == status);
    _emit();
  }

  @override
  Future<void> deleteAllNotifications() async {
    _notifications.clear();
    _emit();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class MockTeacherDao implements TeacherDao {
  final Map<String, Teacher> _teachers = {};

  @override
  Future<List<Teacher>> findAll() async => _teachers.values.toList();

  @override
  Future<Teacher?> findById(String id) async => _teachers[id];

  @override
  Future<void> insertTeacher(Teacher teacher) async {
    _teachers[teacher.id] = teacher;
  }

  @override
  Future<void> updateTeacher(Teacher teacher) async {
    _teachers[teacher.id] = teacher;
  }

  @override
  Future<void> deleteTeacher(Teacher teacher) async {
    _teachers.remove(teacher.id);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}
