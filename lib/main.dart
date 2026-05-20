import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:ubook_app/database/app_database.dart';
import 'package:ubook_app/firebase_options.dart';
import 'package:ubook_app/view/subjects/subjects_view.dart';
import 'package:ubook_app/repository/attachments/floor_attachment_repository.dart';
import 'package:ubook_app/repository/auth/firestore_user_repository.dart';
import 'package:ubook_app/repository/auth/floor_user_repository.dart';
import 'package:ubook_app/repository/auth/syncing_user_repository.dart';
import 'package:ubook_app/repository/auth/user_repository.dart';
import 'package:ubook_app/repository/notification/floor_notification_repository.dart';
import 'package:ubook_app/view_model/notification/notification_view_model.dart';
import 'package:ubook_app/repository/process/floor_process_repository.dart';
import 'package:ubook_app/repository/reviews/review_repository_provider.dart';
import 'package:ubook_app/repository/teacher_subject/floor_subject_teacher_repository.dart';
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final database =
      await $FloorAppDatabase.databaseBuilder('ubook_app.db').addMigrations([
        migration1to2,
        migration2to3,
        migration3to4,
        migration4to5,
        migration5to6,
        migration6to7,
        migration7to8,
      ])
      .build();
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
  FloorAttachmentRepository.initialize(database);
  final processRepository = FloorProcessRepository.initialize(database);
  await processRepository.ensureInitialized();
  await CareerRepositoryProvider.initialize(database);
  FloorSubjectTeacherRepository.initialize(database);

  runApp(MyApp(database: database, userRepository: userRepository));
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
