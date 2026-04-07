import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../view/notification/notification_view.dart';
import '../../view_model/notification/notification_view_model.dart';

/// Campanita de notificaciones con badge de no leídas.
/// Se usa como reemplazo del IconButton de notificaciones en el AppBar.
class NotificationBell extends StatelessWidget {
  const NotificationBell({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotificationViewModel(),
      child: const _NotificationBellContent(),
    );
  }
}

class _NotificationBellContent extends StatelessWidget {
  const _NotificationBellContent();

  @override
  Widget build(BuildContext context) {
    final unreadCount = context
        .select<NotificationViewModel, int>((vm) => vm.unreadCount);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: const Icon(
            Icons.notifications_outlined,
            color: AppColors.textPrimary,
          ),
          onPressed: () => _showNotificationsPanel(context),
        ),
        if (unreadCount > 0)
          Positioned(
            top: 6,
            right: 6,
            child: IgnorePointer(
              child: Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  unreadCount > 9 ? '9+' : '$unreadCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _showNotificationsPanel(BuildContext context) {
    final viewModel = context.read<NotificationViewModel>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => ChangeNotifierProvider.value(
        value: viewModel,
        child: const NotificationView(),
      ),
    );
  }
}
