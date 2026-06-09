import 'dart:async';

import 'package:flutter/material.dart';

import '../../model/notification/notification_model.dart';
import '../../repository/notification/floor_notification_repository.dart';
import '../../repository/notification/notification_repository.dart';
import '../../service/analytics_service.dart';

class NotificationViewModel extends ChangeNotifier {
  NotificationViewModel({NotificationRepository? repository})
    : _repository = repository ?? FloorNotificationRepository.instance {
    _init();
  }

  final NotificationRepository _repository;
  List<NotificationModel> _notifications = [];
  StreamSubscription<List<NotificationModel>>? _subscription;

  List<NotificationModel> get allNotifications =>
      List.unmodifiable(_notifications);

  List<NotificationModel> get unreadNotifications => _notifications
      .where((n) => n.status == NotificationStatus.initial)
      .toList();

  int get unreadCount => unreadNotifications.length;

  Future<void> _init() async {
    await _repository.ensureInitialized();
    _subscription = _repository.watchAll().listen((notifications) {
      _notifications = notifications;
      notifyListeners();
    });
  }

  Future<void> markAsRead(String id) async {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index == -1) return;
    final n = _notifications[index];
    if (n.status == NotificationStatus.read) return;
    await _repository.update(n.copyWith(status: NotificationStatus.read));
    unawaited(AnalyticsService.instance.logNotificationRead(type: n.type.name));
  }

  Future<void> markAllAsRead() async {
    final unread = unreadNotifications;
    for (final n in unread) {
      await _repository.update(n.copyWith(status: NotificationStatus.read));
    }
    if (unread.isNotEmpty) {
      unawaited(
        AnalyticsService.instance.logNotificationsMarkedRead(
          count: unread.length,
        ),
      );
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
