import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:ubook_app/model/auth/user_model.dart';
import 'package:ubook_app/theme/app_colors.dart';
import 'package:ubook_app/widgets/auth/index.dart';
import 'package:ubook_app/view_model/admin_user/admin_users_view_model.dart';

class AdminUsersView extends StatefulWidget {
  const AdminUsersView({super.key});

  @override
  State<AdminUsersView> createState() => _AdminUsersViewState();
}

class _AdminUsersViewState extends State<AdminUsersView> {
  @override
  void initState() {
    super.initState();
    // Carga usuarios al abrir la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminUsersViewModel>().loadUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AdminUsersViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            AuthHeader(
              title: 'Administración de Usuarios',
              subtitle: 'UCOBOOT',
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // HEADER + BOTÓN CREAR
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Usuarios registrados',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _openCreateModal(context, vm),
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text(
                          'Crear',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // MENSAJE DE ERROR
                  if (vm.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        vm.errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ),

                  // ESTADO DE CARGA
                  if (vm.isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (vm.users.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Text(
                          'No hay usuarios registrados.',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    )
                  else
                    // LISTA DE USUARIOS
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: vm.users.length,
                      itemBuilder: (context, index) {
                        final user = vm.users[index];
                        return FadeInUp(
                          delay: Duration(milliseconds: index * 60),
                          child: Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                                child: Text(
                                  user.name.isNotEmpty
                                      ? user.name[0].toUpperCase()
                                      : '?',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                user.name,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(user.email),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    user.city.isNotEmpty ? user.city : '',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () => _openEditModal(context, vm, user),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _confirmDelete(context, vm, user),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✏️ EDITAR USUARIO
  void _openEditModal(BuildContext context, AdminUsersViewModel vm, UserModel user) {
    final nombreController = TextEditingController(text: user.name);
    final correoController = TextEditingController(text: user.email);
    final ciudadController = TextEditingController(text: user.city);
    final carreraController = TextEditingController(text: user.career);
    final centroController = TextEditingController(text: user.educationalCenter);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Usuario'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                TextField(
                  controller: correoController,
                  decoration: const InputDecoration(labelText: 'Correo'),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: ciudadController,
                  decoration: const InputDecoration(labelText: 'Ciudad'),
                ),
                TextField(
                  controller: carreraController,
                  decoration: const InputDecoration(labelText: 'Carrera'),
                ),
                TextField(
                  controller: centroController,
                  decoration: const InputDecoration(labelText: 'Centro educativo'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final success = await vm.updateUser(
                  user,
                  newName: nombreController.text,
                  newEmail: correoController.text,
                  newCity: ciudadController.text,
                  newCareer: carreraController.text,
                  newCenter: centroController.text,
                );
                if (success && context.mounted) Navigator.pop(context);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  // ➕ CREAR USUARIO
  void _openCreateModal(BuildContext context, AdminUsersViewModel vm) {
    showDialog(
      context: context,
      builder: (ctx) {
        return ChangeNotifierProvider.value(
          value: vm,
          child: Consumer<AdminUsersViewModel>(
            builder: (context, vm, _) {
              return AlertDialog(
                title: const Text('Crear Usuario'),
                content: SingleChildScrollView(
                  child: Form(
                    key: vm.formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: vm.name,
                          decoration: const InputDecoration(labelText: 'Nombre'),
                          validator: vm.validateName,
                        ),
                        TextFormField(
                          controller: vm.emailController,
                          decoration: const InputDecoration(labelText: 'Correo'),
                          keyboardType: TextInputType.emailAddress,
                          validator: vm.validateEmail,
                        ),
                        TextFormField(
                          controller: vm.city,
                          decoration: const InputDecoration(labelText: 'Ciudad'),
                        ),
                        TextFormField(
                          controller: vm.career,
                          decoration: const InputDecoration(labelText: 'Carrera'),
                        ),
                        TextFormField(
                          controller: vm.educationalCenter,
                          decoration: const InputDecoration(labelText: 'Centro educativo'),
                        ),
                        TextFormField(
                          controller: vm.passwordController,
                          decoration: const InputDecoration(labelText: 'Contraseña'),
                          obscureText: true,
                          validator: vm.validatePassword,
                        ),
                        TextFormField(
                          controller: vm.confirmPasswordController,
                          decoration: const InputDecoration(labelText: 'Confirmar contraseña'),
                          obscureText: true,
                          validator: vm.validateConfirmPassword,
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: vm.isSubmitting
                        ? null
                        : () async {
                            final success = await vm.createUser();
                            if (success && context.mounted) Navigator.pop(context);
                          },
                    child: vm.isSubmitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Crear'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  // 🗑️ CONFIRMAR ELIMINACIÓN
  void _confirmDelete(BuildContext context, AdminUsersViewModel vm, UserModel user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar usuario'),
        content: Text('¿Seguro que deseas eliminar a ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);
              await vm.deleteUser(user);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
