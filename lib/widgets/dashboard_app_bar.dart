import 'package:flutter/material.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String selectedFilter;
  final List<String> filterOptions;
  final Function(String) onFilterChanged;

  const DashboardAppBar({
    super.key,
    required this.selectedFilter,
    required this.filterOptions,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      title: const Text(
        'UBook',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.indigo,
          fontSize: 24,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.black87),
          onPressed: () {
            // TODO: Show notifications
          },
        ),
        PopupMenuButton<String>(
          offset: const Offset(0, 45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          icon: const CircleAvatar(
            radius: 16,
            backgroundColor: Colors.indigo,
            child: Icon(Icons.person, size: 20, color: Colors.white),
          ),
          onSelected: (value) {
            // TODO: Handle action
          },
          itemBuilder: (BuildContext context) {
            return [
              const PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person_outline, color: Colors.indigo, size: 20),
                    SizedBox(width: 12),
                    Text('Mi Perfil'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'users',
                child: Row(
                  children: [
                    Icon(Icons.manage_accounts_outlined, color: Colors.indigo, size: 20),
                    SizedBox(width: 12),
                    Text('Administrar Usuarios'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'pqrs',
                child: Row(
                  children: [
                    Icon(Icons.support_agent_outlined, color: Colors.indigo, size: 20),
                    SizedBox(width: 12),
                    Text('PQRS'),
                  ],
                ),
              ),
            ];
          },
        ),
        const SizedBox(width: 12),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar en UBook...',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      prefixIcon: const Icon(Icons.search, color: Colors.indigo),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.indigo.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.tune, color: Colors.white),
                  onPressed: () {
                    _showFilterBottomSheet(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filtrar búsqueda por:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...filterOptions.map((option) {
                return RadioListTile<String>(
                  title: Text(
                    option,
                    style: const TextStyle(fontSize: 16),
                  ),
                  value: option,
                  groupValue: selectedFilter,
                  activeColor: Colors.indigo,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (value) {
                    if (value != null) {
                      onFilterChanged(value);
                      Navigator.pop(context);
                    }
                  },
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(140);
}
