import 'package:floor/floor.dart';

import '../../model/notification/notification_model.dart';

@dao
abstract class NotificationDao {
  @Query('SELECT * FROM notifications ORDER BY created_at_ms DESC')
  Future<List<NotificationModel>> findAll();

  @Query('SELECT * FROM notifications ORDER BY created_at_ms DESC')
  Stream<List<NotificationModel>> watchAll();

  @Query('SELECT * FROM notifications WHERE id = :id LIMIT 1')
  Future<NotificationModel?> findById(String id);

  @Query('SELECT COUNT(*) FROM notifications')
  Future<int?> countNotifications();

  @insert
  Future<void> insertNotification(NotificationModel notification);

  @insert
  Future<void> insertNotifications(List<NotificationModel> notifications);

  @update
  Future<int> updateNotification(NotificationModel notification);

  @delete
  Future<int> deleteNotification(NotificationModel notification);

  @Query('DELETE FROM notifications WHERE id = :id')
  Future<void> deleteById(String id);

  @Query('DELETE FROM notifications WHERE status = :status')
  Future<void> deleteByStatus(String status);

  @Query('DELETE FROM notifications')
  Future<void> deleteAllNotifications();
}
