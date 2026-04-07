import 'package:flutter/material.dart';
import '../../model/notification/notification_model.dart';

class NotificationViewModel extends ChangeNotifier {
  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: '1',
      title: 'Nueva asignatura creada',
      message:
          'Se ha creado la asignatura "Cálculo Diferencial" en la facultad de Ingeniería de Sistemas.',
      type: NotificationType.subjectCreated,
      status: NotificationStatus.initial,
      createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    NotificationModel(
      id: '2',
      title: 'Nueva reseña de docente',
      message:
          'El docente Carlos Rodríguez ha recibido una nueva reseña de un estudiante.',
      type: NotificationType.reviewCreated,
      status: NotificationStatus.initial,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    NotificationModel(
      id: '3',
      title: 'Nueva asignatura creada',
      message:
          'Se ha creado la asignatura "Programación I" en la facultad de Sistemas.',
      type: NotificationType.subjectCreated,
      status: NotificationStatus.read,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  List<NotificationModel> get allNotifications =>
      List.unmodifiable(_notifications);

  List<NotificationModel> get unreadNotifications => _notifications
      .where((n) => n.status == NotificationStatus.initial)
      .toList();

  int get unreadCount => unreadNotifications.length;

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1 &&
        _notifications[index].status == NotificationStatus.initial) {
      _notifications[index].status = NotificationStatus.read;
      notifyListeners();
    }
  }

  void markAllAsRead() {
    bool changed = false;
    for (final notification in _notifications) {
      if (notification.status == NotificationStatus.initial) {
        notification.status = NotificationStatus.read;
        changed = true;
      }
    }
    if (changed) notifyListeners();
  }
}
