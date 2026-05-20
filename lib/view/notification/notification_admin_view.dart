import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:ubook_app/model/notification/notification_model.dart';
import 'package:ubook_app/theme/app_colors.dart';
import 'package:ubook_app/view_model/notification/notification_admin_view_model.dart';
import 'package:ubook_app/widgets/auth/index.dart';

class NotificationAdminView extends StatefulWidget {
  const NotificationAdminView({super.key});

  @override
  State<NotificationAdminView> createState() => _NotificationAdminViewState();
}

class _NotificationAdminViewState extends State<NotificationAdminView> {
  late final NotificationAdminViewModel _vm;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _vm = NotificationAdminViewModel();
    _searchController = TextEditingController(text: _vm.searchQuery);
    _vm.addListener(_syncFromViewModel);
  }

  void _syncFromViewModel() {
    if (_searchController.text != _vm.searchQuery) {
      _searchController.value = _searchController.value.copyWith(
        text: _vm.searchQuery,
        selection: TextSelection.collapsed(offset: _vm.searchQuery.length),
        composing: TextRange.empty,
      );
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Administración de notificaciones',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actions: [
          IconButton(
            tooltip: 'Restaurar demo',
            onPressed: _vm.restoreDemoData,
            icon: const Icon(Icons.restart_alt_outlined),
          ),
          IconButton(
            tooltip: 'Nueva notificación',
            onPressed: () => _openCreateDialog(context),
            icon: const Icon(Icons.add_alert_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AuthHeader(
              title: 'Historial y gestión',
              subtitle:
                  'Filtra, revisa y administra el flujo de notificaciones',
            ),
            const SizedBox(height: 20),
            _buildStatsGrid(),
            const SizedBox(height: 20),
            _buildSearchAndSort(),
            const SizedBox(height: 14),
            _buildFilters(),
            const SizedBox(height: 16),
            _buildActionsRow(),
            const SizedBox(height: 18),
            _buildHistorySection(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _StatCard(
          title: 'Total',
          value: _vm.totalCount.toString(),
          icon: Icons.notifications_active_outlined,
          color: AppColors.primary,
        ),
        _StatCard(
          title: 'No leídas',
          value: _vm.unreadCount.toString(),
          icon: Icons.markunread_outlined,
          color: Colors.orange,
        ),
        _StatCard(
          title: 'Leídas',
          value: _vm.readCount.toString(),
          icon: Icons.done_all_outlined,
          color: Colors.green,
        ),
        _StatCard(
          title: 'Hoy',
          value: _vm.todayCount.toString(),
          icon: Icons.today_outlined,
          color: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildSearchAndSort() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            onChanged: _vm.setSearchQuery,
            decoration: InputDecoration(
              hintText: 'Buscar por título o mensaje',
              prefixIcon: const Icon(Icons.search, color: AppColors.primary),
              filled: true,
              fillColor: AppColors.inputFill,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 170,
          child: DropdownButtonFormField<NotificationAdminSortOption>(
            value: _vm.sortOption,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.inputFill,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
            ),
            icon: const Icon(Icons.sort_outlined),
            items: const [
              DropdownMenuItem(
                value: NotificationAdminSortOption.newest,
                child: Text('Más recientes'),
              ),
              DropdownMenuItem(
                value: NotificationAdminSortOption.oldest,
                child: Text('Más antiguas'),
              ),
            ],
            onChanged: (value) {
              if (value == null) return;
              _vm.setSortOption(value);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Estado',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildStatusChip('Todas', NotificationAdminStatusFilter.all),
            _buildStatusChip('No leídas', NotificationAdminStatusFilter.unread),
            _buildStatusChip('Leídas', NotificationAdminStatusFilter.read),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Tipo',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildTypeChip('Todos', null),
            _buildTypeChip('Asignaturas', NotificationType.subjectCreated),
            _buildTypeChip('Reseñas', NotificationType.reviewCreated),
            _buildTypeChip('Otros', NotificationType.other),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Periodo',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildDateChip('Todo', NotificationAdminDateFilter.all),
            _buildDateChip('Hoy', NotificationAdminDateFilter.today),
            _buildDateChip('7 días', NotificationAdminDateFilter.week),
            _buildDateChip('30 días', NotificationAdminDateFilter.month),
          ],
        ),
      ],
    );
  }

  Widget _buildActionsRow() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        ElevatedButton.icon(
          onPressed: _vm.filteredNotifications.isEmpty
              ? null
              : _vm.markFilteredAsRead,
          icon: const Icon(Icons.done_all_outlined, color: Colors.white),
          label: const Text(
            'Marcar filtradas',
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
        OutlinedButton.icon(
          onPressed: _vm.canClearReadNotifications
              ? _vm.clearReadNotifications
              : null,
          icon: const Icon(Icons.delete_outline),
          label: const Text('Eliminar leídas'),
        ),
        OutlinedButton.icon(
          onPressed: _vm.hasActiveFilters
              ? () {
                  _searchController.clear();
                  _vm.resetFilters();
                }
              : null,
          icon: const Icon(Icons.filter_alt_off_outlined),
          label: const Text('Limpiar filtros'),
        ),
      ],
    );
  }

  Widget _buildHistorySection() {
    final notifications = _vm.filteredNotifications;

    if (notifications.isEmpty) {
      return _EmptyState(
        title: 'No hay notificaciones para mostrar',
        message:
            'Intenta con otros filtros o crea una nueva notificación para probar el flujo.',
        actionLabel: 'Crear notificación',
        onAction: () => _openCreateDialog(context),
      );
    }

    final grouped = _groupNotifications(notifications);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Historial',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        for (final entry in grouped.entries) ...[
          FadeInUp(
            duration: const Duration(milliseconds: 300),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      entry.key,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  ...entry.value.map(
                    (notification) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _NotificationHistoryCard(
                        notification: notification,
                        onMarkRead: () => _vm.markAsRead(notification.id),
                        onMarkUnread: () => _vm.markAsUnread(notification.id),
                        onDelete: () => _vm.deleteNotification(notification.id),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Map<String, List<NotificationModel>> _groupNotifications(
    List<NotificationModel> notifications,
  ) {
    final grouped = <String, List<NotificationModel>>{};
    for (final notification in notifications) {
      final key = _periodLabel(notification.createdAt);
      grouped.putIfAbsent(key, () => []).add(notification);
    }
    return grouped;
  }

  String _periodLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final current = DateTime(date.year, date.month, date.day);
    final diffDays = today.difference(current).inDays;

    if (diffDays == 0) return 'Hoy';
    if (diffDays == 1) return 'Ayer';
    if (diffDays <= 7) return 'Últimos 7 días';
    if (diffDays <= 30) return 'Últimos 30 días';
    return 'Más antiguas';
  }

  Future<void> _openCreateDialog(BuildContext context) async {
    final titleController = TextEditingController();
    final messageController = TextEditingController();
    NotificationType selectedType = NotificationType.other;
    NotificationStatus selectedStatus = NotificationStatus.initial;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Nueva notificación'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Título'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: messageController,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: 'Mensaje'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<NotificationType>(
                      value: selectedType,
                      decoration: const InputDecoration(labelText: 'Tipo'),
                      items: const [
                        DropdownMenuItem(
                          value: NotificationType.subjectCreated,
                          child: Text('Asignatura creada'),
                        ),
                        DropdownMenuItem(
                          value: NotificationType.reviewCreated,
                          child: Text('Reseña creada'),
                        ),
                        DropdownMenuItem(
                          value: NotificationType.other,
                          child: Text('Otro'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setStateDialog(() {
                          selectedType = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<NotificationStatus>(
                      value: selectedStatus,
                      decoration: const InputDecoration(labelText: 'Estado'),
                      items: const [
                        DropdownMenuItem(
                          value: NotificationStatus.initial,
                          child: Text('No leída'),
                        ),
                        DropdownMenuItem(
                          value: NotificationStatus.read,
                          child: Text('Leída'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setStateDialog(() {
                          selectedStatus = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final title = titleController.text.trim();
                    final message = messageController.text.trim();
                    if (title.isEmpty || message.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Título y mensaje son requeridos'),
                        ),
                      );
                      return;
                    }

                    _vm.createNotification(
                      title: title,
                      message: message,
                      type: selectedType,
                      status: selectedStatus,
                    );
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Crear'),
                ),
              ],
            );
          },
        );
      },
    );

    titleController.dispose();
    messageController.dispose();
  }

  Widget _buildStatusChip(String label, NotificationAdminStatusFilter value) {
    final isSelected = _vm.statusFilter == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => _vm.setStatusFilter(value),
      selectedColor: AppColors.primary.withValues(alpha: 0.15),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      side: BorderSide(
        color: isSelected ? AppColors.primary : AppColors.divider,
      ),
    );
  }

  Widget _buildTypeChip(String label, NotificationType? value) {
    final isSelected = _vm.typeFilter == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => _vm.setTypeFilter(value),
      selectedColor: AppColors.primary.withValues(alpha: 0.15),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      side: BorderSide(
        color: isSelected ? AppColors.primary : AppColors.divider,
      ),
    );
  }

  Widget _buildDateChip(String label, NotificationAdminDateFilter value) {
    final isSelected = _vm.dateFilter == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => _vm.setDateFilter(value),
      selectedColor: AppColors.primary.withValues(alpha: 0.15),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      side: BorderSide(
        color: isSelected ? AppColors.primary : AppColors.divider,
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationHistoryCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onMarkRead;
  final VoidCallback onMarkUnread;
  final VoidCallback onDelete;

  const _NotificationHistoryCard({
    required this.notification,
    required this.onMarkRead,
    required this.onMarkUnread,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isUnread = notification.status == NotificationStatus.initial;
    final (icon, color, label) = switch (notification.type) {
      NotificationType.subjectCreated => (
        Icons.menu_book_outlined,
        Colors.orange,
        'Asignatura',
      ),
      NotificationType.reviewCreated => (
        Icons.rate_review_outlined,
        Colors.blue,
        'Reseña',
      ),
      NotificationType.other => (
        Icons.notifications_outlined,
        AppColors.primary,
        'Otro',
      ),
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnread
              ? AppColors.primary.withValues(alpha: 0.22)
              : AppColors.divider,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: isUnread
                              ? FontWeight.bold
                              : FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    if (isUnread)
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  notification.message,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _SmallChip(label: label, color: color),
                    _SmallChip(
                      label: isUnread ? 'No leída' : 'Leída',
                      color: isUnread ? Colors.orange : Colors.green,
                    ),
                    Text(
                      _formatRelativeTime(notification.createdAt),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.placeholder,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'toggle':
                  isUnread ? onMarkRead() : onMarkUnread();
                  break;
                case 'delete':
                  onDelete();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'toggle',
                child: Text(
                  isUnread ? 'Marcar como leída' : 'Marcar como no leída',
                ),
              ),
              const PopupMenuItem(value: 'delete', child: Text('Eliminar')),
            ],
          ),
        ],
      ),
    );
  }

  String _formatRelativeTime(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Hace ${diff.inHours} h';
    return 'Hace ${diff.inDays} día${diff.inDays == 1 ? '' : 's'}';
  }
}

class _SmallChip extends StatelessWidget {
  final String label;
  final Color color;

  const _SmallChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  const _EmptyState({
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.notifications_off_outlined,
            size: 56,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            message,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onAction,
            icon: const Icon(Icons.add_alert_outlined, color: Colors.white),
            label: const Text(
              'Crear notificación',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
