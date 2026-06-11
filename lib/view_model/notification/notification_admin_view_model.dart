import 'dart:async';

import 'package:flutter/material.dart';

import '../../model/notification/notification_model.dart';
import '../../repository/notification/floor_notification_repository.dart';
import '../../repository/notification/notification_admin_prefs.dart';
import '../../repository/notification/notification_repository.dart';

enum NotificationAdminStatusFilter { all, unread, read }

enum NotificationAdminDateFilter { all, today, week, month }

enum NotificationAdminSortOption { newest, oldest }

class NotificationAdminViewModel extends ChangeNotifier {
  NotificationAdminViewModel({NotificationRepository? repository})
    : _repository = repository ?? FloorNotificationRepository.instance,
      _notifications = [] {
    _loadSavedFilters();
    _loadNotifications();
  }

  final NotificationRepository _repository;
  final NotificationAdminPrefs _prefs = NotificationAdminPrefs();
  List<NotificationModel> _notifications;
  bool isLoading = true;
  String? errorMessage;

  String _searchQuery = '';
  NotificationAdminStatusFilter _statusFilter =
      NotificationAdminStatusFilter.all;
  NotificationType? _typeFilter;
  NotificationAdminDateFilter _dateFilter = NotificationAdminDateFilter.all;
  NotificationAdminSortOption _sortOption = NotificationAdminSortOption.newest;

  String get searchQuery => _searchQuery;
  NotificationAdminStatusFilter get statusFilter => _statusFilter;
  NotificationType? get typeFilter => _typeFilter;
  NotificationAdminDateFilter get dateFilter => _dateFilter;
  NotificationAdminSortOption get sortOption => _sortOption;

  List<NotificationModel> get allNotifications =>
      List.unmodifiable(_notifications);

  List<NotificationModel> get filteredNotifications {
    final query = _searchQuery.trim().toLowerCase();

    final result = _notifications.where((notification) {
      final matchesQuery =
          query.isEmpty ||
          notification.title.toLowerCase().contains(query) ||
          notification.message.toLowerCase().contains(query);

      final matchesStatus = switch (_statusFilter) {
        NotificationAdminStatusFilter.all => true,
        NotificationAdminStatusFilter.unread =>
          notification.status == NotificationStatus.initial,
        NotificationAdminStatusFilter.read =>
          notification.status == NotificationStatus.read,
      };

      final matchesType =
          _typeFilter == null || notification.type == _typeFilter;
      final matchesDate = switch (_dateFilter) {
        NotificationAdminDateFilter.all => true,
        NotificationAdminDateFilter.today => _isToday(notification.createdAt),
        NotificationAdminDateFilter.week =>
          DateTime.now().difference(notification.createdAt).inDays < 7,
        NotificationAdminDateFilter.month =>
          DateTime.now().difference(notification.createdAt).inDays < 30,
      };

      return matchesQuery && matchesStatus && matchesType && matchesDate;
    }).toList();

    result.sort((left, right) {
      final comparison = left.createdAt.compareTo(right.createdAt);
      return _sortOption == NotificationAdminSortOption.newest
          ? -comparison
          : comparison;
    });

    return result;
  }

  int get totalCount => _notifications.length;

  int get unreadCount => _notifications
      .where(
        (notification) => notification.status == NotificationStatus.initial,
      )
      .length;

  int get readCount => _notifications
      .where((notification) => notification.status == NotificationStatus.read)
      .length;

  int get todayCount => _notifications.where((notification) {
    return _isToday(notification.createdAt);
  }).length;

  bool get hasActiveFilters =>
      _searchQuery.trim().isNotEmpty ||
      _statusFilter != NotificationAdminStatusFilter.all ||
      _typeFilter != null ||
      _dateFilter != NotificationAdminDateFilter.all ||
      _sortOption != NotificationAdminSortOption.newest;

  bool get canClearReadNotifications => _notifications.any(
    (notification) => notification.status == NotificationStatus.read,
  );

  void setSearchQuery(String value) {
    _searchQuery = value;
    unawaited(_prefs.saveSearchQuery(value));
    notifyListeners();
  }

  void setStatusFilter(NotificationAdminStatusFilter value) {
    _statusFilter = value;
    unawaited(_prefs.saveStatusFilter(value.name));
    notifyListeners();
  }

  void setTypeFilter(NotificationType? value) {
    _typeFilter = value;
    unawaited(_prefs.saveTypeFilter(value?.name));
    notifyListeners();
  }

  void setDateFilter(NotificationAdminDateFilter value) {
    _dateFilter = value;
    unawaited(_prefs.saveDateFilter(value.name));
    notifyListeners();
  }

  void setSortOption(NotificationAdminSortOption value) {
    _sortOption = value;
    unawaited(_prefs.saveSortOption(value.name));
    notifyListeners();
  }

  void resetFilters() {
    _searchQuery = '';
    _statusFilter = NotificationAdminStatusFilter.all;
    _typeFilter = null;
    _dateFilter = NotificationAdminDateFilter.all;
    _sortOption = NotificationAdminSortOption.newest;
    unawaited(_prefs.clearFilters());
    notifyListeners();
  }

  Future<void> markAsRead(String id) async {
    final notification = _findById(id);
    if (notification == null ||
        notification.status == NotificationStatus.read) {
      return;
    }

    notification.status = NotificationStatus.read;
    await _repository.update(notification);
    notifyListeners();
  }

  Future<void> markAsUnread(String id) async {
    final notification = _findById(id);
    if (notification == null ||
        notification.status == NotificationStatus.initial) {
      return;
    }

    notification.status = NotificationStatus.initial;
    await _repository.update(notification);
    notifyListeners();
  }

  Future<void> markFilteredAsRead() async {
    var changed = false;
    for (final notification in filteredNotifications) {
      if (notification.status == NotificationStatus.initial) {
        final updated = notification.copyWith(status: NotificationStatus.read);
        await _repository.update(updated);
        changed = true;
      }
    }

    if (changed) {
      await _loadNotifications();
    }
  }

  Future<void> clearReadNotifications() async {
    await _repository.deleteReadNotifications();
    await _loadNotifications();
  }

  Future<void> deleteNotification(String id) async {
    final notification = _findById(id);
    if (notification == null) return;

    await _repository.delete(notification);
    await _loadNotifications();
  }

  Future<void> createNotification({
    required String title,
    required String message,
    required NotificationType type,
    NotificationStatus status = NotificationStatus.initial,
  }) async {
    final now = DateTime.now();
    await _repository.insert(
      NotificationModel(
        id: 'notif-${now.microsecondsSinceEpoch}',
        title: title,
        message: message,
        type: type,
        status: status,
        createdAt: now,
      ),
    );
    await _loadNotifications();
  }

  Future<void> restoreDemoData() async {
    await _repository.resetToSeedData();
    await _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      _notifications = await _repository.getAll();
    } catch (_) {
      errorMessage = 'No se pudieron cargar las notificaciones';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  NotificationModel? _findById(String id) {
    for (final notification in _notifications) {
      if (notification.id == id) {
        return notification;
      }
    }
    return null;
  }

  bool _isToday(DateTime value) {
    final now = DateTime.now();
    return value.year == now.year &&
        value.month == now.month &&
        value.day == now.day;
  }

  Future<void> _loadSavedFilters() async {
    final savedSearch = await _prefs.getSearchQuery();
    final savedStatus = await _prefs.getStatusFilter();
    final savedType = await _prefs.getTypeFilter();
    final savedDate = await _prefs.getDateFilter();
    final savedSort = await _prefs.getSortOption();

    _searchQuery = savedSearch ?? '';
    _statusFilter = _parseStatusFilter(savedStatus);
    _typeFilter = _parseTypeFilter(savedType);
    _dateFilter = _parseDateFilter(savedDate);
    _sortOption = _parseSortOption(savedSort);
    notifyListeners();
  }

  NotificationAdminStatusFilter _parseStatusFilter(String? value) {
    return switch (value) {
      'unread' => NotificationAdminStatusFilter.unread,
      'read' => NotificationAdminStatusFilter.read,
      _ => NotificationAdminStatusFilter.all,
    };
  }

  NotificationType? _parseTypeFilter(String? value) {
    return switch (value) {
      'subjectCreated' => NotificationType.subjectCreated,
      'reviewCreated' => NotificationType.reviewCreated,
      'other' => NotificationType.other,
      _ => null,
    };
  }

  NotificationAdminDateFilter _parseDateFilter(String? value) {
    return switch (value) {
      'today' => NotificationAdminDateFilter.today,
      'week' => NotificationAdminDateFilter.week,
      'month' => NotificationAdminDateFilter.month,
      _ => NotificationAdminDateFilter.all,
    };
  }

  NotificationAdminSortOption _parseSortOption(String? value) {
    return switch (value) {
      'oldest' => NotificationAdminSortOption.oldest,
      _ => NotificationAdminSortOption.newest,
    };
  }
}
