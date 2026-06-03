import '../../model/notification/notification_model.dart';

abstract class NotificationRepository {
  Future<void> ensureInitialized();
  Future<List<NotificationModel>> getAll();
  Stream<List<NotificationModel>> watchAll();
  Future<NotificationModel?> getById(String id);
  Future<void> insert(NotificationModel notification);
  Future<void> update(NotificationModel notification);
  Future<void> delete(NotificationModel notification);
  Future<void> deleteById(String id);
  Future<void> deleteReadNotifications();
  Future<void> deleteAll();
  Future<int> count();
  Future<void> resetToSeedData();
}
