import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:ubook_app/database/app_database.dart';
import 'package:ubook_app/database/mock_app_database.dart';
import 'package:ubook_app/firebase_options.dart';
import 'package:ubook_app/view/subjects/subjects_view.dart';
import 'package:ubook_app/repository/attachments/attachment_repository.dart';
import 'package:ubook_app/repository/attachments/floor_attachment_repository.dart';
import 'package:ubook_app/repository/auth/firestore_user_repository.dart';
import 'package:ubook_app/repository/auth/floor_user_repository.dart';
import 'package:ubook_app/repository/auth/syncing_user_repository.dart';
import 'package:ubook_app/repository/auth/user_repository.dart';
import 'package:ubook_app/repository/notification/floor_notification_repository.dart';
import 'package:ubook_app/view_model/notification/notification_view_model.dart';
import 'package:ubook_app/repository/process/floor_process_repository.dart';
import 'package:ubook_app/repository/process/firestore_process_repository.dart';
import 'package:ubook_app/repository/process/syncing_process_repository.dart';
import 'package:ubook_app/repository/process/process_repository.dart';
import 'package:ubook_app/repository/reviews/review_repository_provider.dart';
import 'package:ubook_app/repository/teacher_subject/floor_subject_teacher_repository.dart';
import 'package:ubook_app/repository/teachers/floor_teacher_repository.dart';
import 'view/dashboard/dashboard_view.dart';
import 'view/auth/login_view.dart';
import 'view/auth/profile_view.dart';
import 'view/auth/register_view.dart';
import 'view/notification/notification_admin_view.dart';
import 'view/pqrs/pqrs_page.dart';
import 'view_model/pqrs/pqrs_viewmodel.dart';
import 'view_model/auth/user_count_provider.dart';
import 'view_model/dashboard/dashboard_view_model.dart';
import 'view_model/educational_center/educational_center_count_provider.dart';
import 'view_model/teachers/teacher_count_provider.dart';
import 'view/admin_user/admin_users_view.dart';
import 'package:ubook_app/repository/career/career_repository_provider.dart';
import 'package:ubook_app/view/sql_demo/sql_demo_view.dart';
import 'package:ubook_app/view_model/sql_demo/sql_demo_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final AppDatabase database;
    if (kIsWeb) {
      database = MockAppDatabase();
    } else {
      database = await $FloorAppDatabase.databaseBuilder('ubook_app.db').addMigrations([
        migration1to2,
        migration2to3,
        migration3to4,
        migration4to5,
        migration5to6,
        migration6to7,
        migration7to8,
        migration8to9,
      ]).build();
    }
    final localUserRepository = FloorUserRepository.initialize(database);
    final remoteUserRepository = FirestoreUserRepository.initialize();
    final userRepository = SyncingUserRepository.initialize(
      localUserRepository,
      remoteUserRepository,
    );
    await userRepository.ensureInitialized();
    final notificationRepository = FloorNotificationRepository.initialize(
      database,
    );
    await notificationRepository.ensureInitialized();
    await ReviewRepositoryProvider.initialize(database);

    // ── Repositorio de adjuntos ───────────────────────────────────────────────
    // Implementación activa: almacenamiento local (Floor + SQLite).
    //
    // TODO: cuando la cuenta de Firebase Storage esté disponible, reemplazar
    // estas dos líneas por la implementación Firebase:
    //
    //   import 'package:ubook_app/repository/attachments/firebase_attachment_repository.dart';
    //
    //   AttachmentRepository.setCurrent(
    //     FirebaseAttachmentRepository.initialize(database),
    //   );
    //
    // Firebase.initializeApp() ya se llama arriba, así que no se necesita
    // ningún cambio adicional fuera de este bloque.
    AttachmentRepository.setCurrent(
      FloorAttachmentRepository.initialize(database),
    );
    final localProcessRepository = FloorProcessRepository.initialize(database);
    final remoteProcessRepository = FirestoreProcessRepository.initialize();
    final processRepository = SyncingProcessRepository.initialize(
      localProcessRepository,
      remoteProcessRepository,
    );
    await processRepository.ensureInitialized();
    ProcessRepository.setInstance(processRepository);
    await CareerRepositoryProvider.initialize(database);
    FloorSubjectTeacherRepository.initialize(database);
    FloorTeacherRepository.initialize(database);

    runApp(MyApp(database: database, userRepository: userRepository));
  } catch (e, stack) {
    debugPrint('CRITICAL INITIALIZATION ERROR: $e\n$stack');
    runApp(MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFFB71C1C),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Icon(Icons.error_outline, size: 64, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      'UBook - Error de Inicialización',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Excepción:',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      e.toString(),
                      style: const TextStyle(
                        color: Colors.yellow,
                        fontFamily: 'monospace',
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Stack Trace:',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      stack.toString(),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontFamily: 'monospace',
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.database, this.userRepository});

  final AppDatabase? database;
  final UserRepository? userRepository;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        if (database != null) Provider<AppDatabase>.value(value: database!),
        if (userRepository != null)
          Provider<UserRepository>.value(value: userRepository!),
        ChangeNotifierProvider(create: (_) => NotificationViewModel()),
        ChangeNotifierProvider(create: (_) => UserCountProvider()),
        ChangeNotifierProvider(create: (_) => TeacherCountProvider()),
        ChangeNotifierProvider(create: (_) => EducationalCenterCountProvider()),
        ChangeNotifierProvider(create: (_) => DashboardViewModel()),
      ],
      child: MaterialApp(
        title: 'UBook',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        routes: {
          '/login': (context) => const LoginView(),
          '/register': (context) => const RegisterView(),
          '/profile': (context) => const ProfileView(),
          '/dashboard': (context) => const DashboardView(),
          '/admin_notifications': (context) => const NotificationAdminView(),
          '/pqrs': (context) => ChangeNotifierProvider(
            create: (_) => PQRSViewModel(),
            child: const PQRSPage(),
          ),
          '/admin_user': (context) => const AdminUsersView(),
          '/sql_demo': (context) => ChangeNotifierProvider(
            create: (_) => SqlDemoViewModel(),
            child: const SqlDemoView(),
          ),
          '/subjects': (context) => SubjectsView(),
        },
        home: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return snapshot.data != null ? const DashboardView() : const LoginView();
      },
    );
  }
}
