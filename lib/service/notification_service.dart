import 'dart:async';

import '../model/notification/notification_model.dart';
import '../repository/notification/floor_notification_repository.dart';

class NotificationService {
  NotificationService._();

  static Future<void> push({
    required String title,
    required String message,
    required NotificationType type,
  }) async {
    final now = DateTime.now();
    await FloorNotificationRepository.instance.insert(
      NotificationModel(
        id: 'notif-${now.microsecondsSinceEpoch}',
        title: title,
        message: message,
        type: type,
        status: NotificationStatus.initial,
        createdAt: now,
      ),
    );
  }
}
