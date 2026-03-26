import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:ubook_app/theme/app_colors.dart';
import 'package:ubook_app/widgets/auth/index.dart';
import 'package:ubook_app/view_model/admin_user/admin_users_view_model.dart';

class AdminUsersView extends StatefulWidget {
  const AdminUsersView({super.key});

  @override
  State<AdminUsersView> createState() => _AdminUsersViewState();
}

class _AdminUsersViewState extends State<AdminUsersView> {
  late final AdminUsersViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = AdminUsersViewModel();
    _vm.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              child: Form(
                key: _vm.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // 🔥 HEADER + BOTÓN CREAR
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
                          onPressed: () {
                            _openCreateModal(context);
                          },
                          icon: const Icon(Icons.add, color: Colors.white), // 👈 icono blanco
                          label: const Text(
                            "Crear",
                            style: TextStyle(color: Colors.white), // 👈 texto blanco
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white, // 👈 🔥 ESTA ES LA CLAVE
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // 📋 LISTA
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _vm.users.length,
                      itemBuilder: (context, index) {
                        final user = _vm.users[index];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.person),
                            title: Text(user["name"]!),
                            subtitle: Text(user["email"]!),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(user["city"] ?? ''),
                                const SizedBox(width: 8),

                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    _openEditModal(context, index);
                                  },
                                ),

                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    _vm.deleteUser(index);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✏️ EDITAR USUARIO
  void _openEditModal(BuildContext context, int index) {
    final user = _vm.users[index];

    final nombreController = TextEditingController(text: user["name"]);
    final correoController = TextEditingController(text: user["email"]);
    final ciudadController = TextEditingController(text: user["city"]);
    final carreraController = TextEditingController(text: user["career"]);
    final centroController = TextEditingController(text: user["center"]);
    final passwordController = TextEditingController(text: user["password"]);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Editar Usuario"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: nombreController, decoration: const InputDecoration(labelText: "Nombre")),
                TextField(controller: correoController, decoration: const InputDecoration(labelText: "Correo")),
                TextField(controller: ciudadController, decoration: const InputDecoration(labelText: "Ciudad")),
                TextField(controller: carreraController, decoration: const InputDecoration(labelText: "Carrera")),
                TextField(controller: centroController, decoration: const InputDecoration(labelText: "Centro educativo")),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: "Contraseña"),
                  obscureText: true,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                _vm.updateUser(
                  index,
                  name: nombreController.text,
                  email: correoController.text,
                  city: ciudadController.text,
                  career: carreraController.text,
                  center: centroController.text,
                  password: passwordController.text,
                );

                Navigator.pop(context);
              },
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }

  // ➕ CREAR USUARIO
  void _openCreateModal(BuildContext context) {
    final nombreController = TextEditingController();
    final correoController = TextEditingController();
    final ciudadController = TextEditingController();
    final carreraController = TextEditingController();
    final centroController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Crear Usuario"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: nombreController, decoration: const InputDecoration(labelText: "Nombre")),
                TextField(controller: correoController, decoration: const InputDecoration(labelText: "Correo")),
                TextField(controller: ciudadController, decoration: const InputDecoration(labelText: "Ciudad")),
                TextField(controller: carreraController, decoration: const InputDecoration(labelText: "Carrera")),
                TextField(controller: centroController, decoration: const InputDecoration(labelText: "Centro educativo")),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: "Contraseña"),
                  obscureText: true,
                ),
                TextField(
                  controller: confirmPasswordController,
                  decoration: const InputDecoration(labelText: "Confirmar contraseña"),
                  obscureText: true,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                _vm.name.text = nombreController.text;
                _vm.emailController.text = correoController.text;
                _vm.city.text = ciudadController.text;
                _vm.career.text = carreraController.text;
                _vm.educationalCenter.text = centroController.text;
                _vm.passwordController.text = passwordController.text;
                _vm.confirmPasswordController.text = confirmPasswordController.text;

                final success = await _vm.createUser();

                if (success) {
                  Navigator.pop(context);
                }
              },
              child: const Text("Crear"),
            ),
          ],
        );
      },
    );
  }
}