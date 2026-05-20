import 'dart:async';

import 'package:flutter/material.dart';

import '../../model/notification/notification_model.dart';
import '../../repository/notification/notification_admin_prefs.dart';

enum NotificationAdminStatusFilter { all, unread, read }

enum NotificationAdminDateFilter { all, today, week, month }

enum NotificationAdminSortOption { newest, oldest }

class NotificationAdminViewModel extends ChangeNotifier {
  NotificationAdminViewModel() : _notifications = _buildSeedNotifications() {
    _loadSavedFilters();
  }

  final NotificationAdminPrefs _prefs = NotificationAdminPrefs();
  List<NotificationModel> _notifications;

  String _searchQuery = '';
  NotificationAdminStatusFilter _statusFilter =
      NotificationAdminStatusFilter.all;
  NotificationType? _typeFilter;
  NotificationAdminDateFilter _dateFilter = NotificationAdminDateFilter.all;
  NotificationAdminSortOption _sortOption = NotificationAdminSortOption.newest;

  static List<NotificationModel> _buildSeedNotifications() {
    final now = DateTime.now();
    return [
      NotificationModel(
        id: 'notif-1',
        title: 'Nueva asignatura creada',
        message:
            'Se registró la asignatura Cálculo Diferencial en Ingeniería de Sistemas.',
        type: NotificationType.subjectCreated,
        status: NotificationStatus.initial,
        createdAt: now.subtract(const Duration(minutes: 12)),
      ),
      NotificationModel(
        id: 'notif-2',
        title: 'Nueva reseña aprobada',
        message:
            'La reseña de Carlos Rodríguez fue revisada y quedó visible para estudiantes.',
        type: NotificationType.reviewCreated,
        status: NotificationStatus.read,
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      NotificationModel(
        id: 'notif-3',
        title: 'Cambio de estado de notificación',
        message:
            'La notificación de matrícula fue marcada como leída por un administrador.',
        type: NotificationType.other,
        status: NotificationStatus.initial,
        createdAt: now.subtract(const Duration(hours: 5)),
      ),
      NotificationModel(
        id: 'notif-4',
        title: 'Nueva asignatura creada',
        message:
            'Programación I fue creada en la facultad de Sistemas con el plan vigente.',
        type: NotificationType.subjectCreated,
        status: NotificationStatus.read,
        createdAt: now.subtract(const Duration(days: 1, hours: 3)),
      ),
      NotificationModel(
        id: 'notif-5',
        title: 'Nueva reseña de docente',
        message:
            'El docente Carlos Rodríguez recibió una nueva reseña con puntaje alto.',
        type: NotificationType.reviewCreated,
        status: NotificationStatus.initial,
        createdAt: now.subtract(const Duration(days: 1, hours: 6)),
      ),
      NotificationModel(
        id: 'notif-6',
        title: 'Recordatorio académico',
        message:
            'Se publicó un recordatorio de cierre de proceso para revisión de materias.',
        type: NotificationType.other,
        status: NotificationStatus.read,
        createdAt: now.subtract(const Duration(days: 3)),
      ),
      NotificationModel(
        id: 'notif-7',
        title: 'Nueva asignatura creada',
        message:
            'Matemáticas Básicas fue registrada para la cohorte del semestre actual.',
        type: NotificationType.subjectCreated,
        status: NotificationStatus.initial,
        createdAt: now.subtract(const Duration(days: 5)),
      ),
      NotificationModel(
        id: 'notif-8',
        title: 'Nueva reseña de docente',
        message: 'Se recibió una nueva reseña para el profesor Jonathan Pérez.',
        type: NotificationType.reviewCreated,
        status: NotificationStatus.read,
        createdAt: now.subtract(const Duration(days: 8)),
      ),
      NotificationModel(
        id: 'notif-9',
        title: 'Actualización interna',
        message:
            'El equipo de administración dejó un comentario interno en PQRS.',
        type: NotificationType.other,
        status: NotificationStatus.initial,
        createdAt: now.subtract(const Duration(days: 12)),
      ),
      NotificationModel(
        id: 'notif-10',
        title: 'Nueva asignatura creada',
        message:
            'Arquitectura de Software quedó disponible para el siguiente ciclo.',
        type: NotificationType.subjectCreated,
        status: NotificationStatus.read,
        createdAt: now.subtract(const Duration(days: 18)),
      ),
    ];
  }

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

  void markAsRead(String id) {
    final notification = _findById(id);
    if (notification == null ||
        notification.status == NotificationStatus.read) {
      return;
    }

    notification.status = NotificationStatus.read;
    notifyListeners();
  }

  void markAsUnread(String id) {
    final notification = _findById(id);
    if (notification == null ||
        notification.status == NotificationStatus.initial) {
      return;
    }

    notification.status = NotificationStatus.initial;
    notifyListeners();
  }

  void markFilteredAsRead() {
    var changed = false;
    for (final notification in filteredNotifications) {
      if (notification.status == NotificationStatus.initial) {
        notification.status = NotificationStatus.read;
        changed = true;
      }
    }

    if (changed) {
      notifyListeners();
    }
  }

  void clearReadNotifications() {
    _notifications.removeWhere(
      (notification) => notification.status == NotificationStatus.read,
    );
    notifyListeners();
  }

  void deleteNotification(String id) {
    _notifications.removeWhere((notification) => notification.id == id);
    notifyListeners();
  }

  void createNotification({
    required String title,
    required String message,
    required NotificationType type,
    NotificationStatus status = NotificationStatus.initial,
  }) {
    final now = DateTime.now();
    _notifications.insert(
      0,
      NotificationModel(
        id: 'notif-${now.microsecondsSinceEpoch}',
        title: title,
        message: message,
        type: type,
        status: status,
        createdAt: now,
      ),
    );
    notifyListeners();
  }

  void restoreDemoData() {
    _notifications = _buildSeedNotifications();
    notifyListeners();
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
