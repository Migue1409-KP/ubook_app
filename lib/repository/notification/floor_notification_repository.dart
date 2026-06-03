import 'package:ubook_app/database/app_database.dart';

import '../../model/notification/notification_model.dart';
import 'notification_repository.dart';
import 'notification_seed_data.dart';

class FloorNotificationRepository implements NotificationRepository {
  FloorNotificationRepository._(this._database);

  static late final FloorNotificationRepository instance;

  static FloorNotificationRepository initialize(AppDatabase database) {
    instance = FloorNotificationRepository._(database);
    return instance;
  }

  final AppDatabase _database;
  bool _isInitialized = false;

  @override
  Future<void> ensureInitialized() async {
    if (_isInitialized) return;

    final count = await _database.notificationDao.countNotifications() ?? 0;
    if (count == 0) {
      await _database.notificationDao.insertNotifications(
        buildDefaultNotificationSeed(),
      );
    }

    _isInitialized = true;
  }

  @override
  Future<List<NotificationModel>> getAll() async {
    await ensureInitialized();
    return List<NotificationModel>.unmodifiable(
      await _database.notificationDao.findAll(),
    );
  }

  @override
  Stream<List<NotificationModel>> watchAll() {
    return _database.notificationDao.watchAll();
  }

  @override
  Future<NotificationModel?> getById(String id) async {
    await ensureInitialized();
    return _database.notificationDao.findById(id);
  }

  @override
  Future<void> insert(NotificationModel notification) async {
    await ensureInitialized();
    await _database.notificationDao.insertNotification(notification);
  }

  @override
  Future<void> update(NotificationModel notification) async {
    await ensureInitialized();
    await _database.notificationDao.updateNotification(notification);
  }

  @override
  Future<void> delete(NotificationModel notification) async {
    await ensureInitialized();
    await _database.notificationDao.deleteNotification(notification);
  }

  @override
  Future<void> deleteById(String id) async {
    await ensureInitialized();
    final notification = await _database.notificationDao.findById(id);
    if (notification != null) {
      await _database.notificationDao.deleteNotification(notification);
    }
  }

  @override
  Future<void> deleteReadNotifications() async {
    await ensureInitialized();
    final all = await _database.notificationDao.findAll();
    final read = all.where((n) => n.status == NotificationStatus.read).toList();
    for (final n in read) {
      await _database.notificationDao.deleteNotification(n);
    }
  }

  @override
  Future<void> deleteAll() async {
    await ensureInitialized();
    final all = await _database.notificationDao.findAll();
    for (final n in all) {
      await _database.notificationDao.deleteNotification(n);
    }
  }

  @override
  Future<int> count() async {
    await ensureInitialized();
    return (await _database.notificationDao.countNotifications()) ?? 0;
  }

  @override
  Future<void> resetToSeedData() async {
    await ensureInitialized();
    final all = await _database.notificationDao.findAll();
    for (final n in all) {
      await _database.notificationDao.deleteNotification(n);
    }
    await _database.notificationDao.insertNotifications(
      buildDefaultNotificationSeed(),
    );
  }
}
