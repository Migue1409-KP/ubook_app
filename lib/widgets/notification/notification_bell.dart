import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../view/notification/notification_view.dart';
import '../../view_model/notification/notification_view_model.dart';

/// Campanita de notificaciones con badge de no leídas.
/// Al presionarla despliega un panel flotante justo debajo del ícono (estilo Facebook).
/// Usa el NotificationViewModel registrado a nivel app en main.dart.
class NotificationBell extends StatefulWidget {
  const NotificationBell({super.key});

  @override
  State<NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends State<NotificationBell> {
  final GlobalKey _bellKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _removePanel();
    super.dispose();
  }

  void _removePanel() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _togglePanel() {
    if (_overlayEntry != null) {
      _removePanel();
      return;
    }

    final renderBox =
        _bellKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final offset = renderBox.localToGlobal(Offset.zero);
    final bellSize = renderBox.size;
    final screenWidth = MediaQuery.of(context).size.width;
    final viewModel = context.read<NotificationViewModel>();

    const panelMaxWidth = 360.0;
    const horizontalMargin = 8.0;
    final panelWidth = (screenWidth - horizontalMargin * 2).clamp(0.0, panelMaxWidth);
    final rawRight = screenWidth - offset.dx - bellSize.width;
    final panelRight = rawRight.clamp(horizontalMargin, screenWidth - panelWidth - horizontalMargin);

    _overlayEntry = OverlayEntry(
      builder: (overlayContext) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _removePanel,
              behavior: HitTestBehavior.translucent,
              child: const ColoredBox(color: Colors.transparent),
            ),
          ),
          Positioned(
            top: offset.dy + bellSize.height,
            right: panelRight,
            width: panelWidth,
            child: Material(
              color: Colors.transparent,
              child: ChangeNotifierProvider.value(
                value: viewModel,
                child: NotificationView(onClose: _removePanel),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount =
        context.select<NotificationViewModel, int>((vm) => vm.unreadCount);

    return Stack(
      key: _bellKey,
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: const Icon(
            Icons.notifications_outlined,
            color: AppColors.textPrimary,
          ),
          onPressed: _togglePanel,
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
}
