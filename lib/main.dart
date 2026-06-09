import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Supabase;
import 'package:ubook_app/config/supabase_config.dart';
import 'package:ubook_app/database/app_database.dart';
import 'package:ubook_app/firebase_options.dart';
import 'package:ubook_app/view/subjects/subjects_view.dart';
import 'package:ubook_app/repository/attachments/attachment_repository.dart';
import 'package:ubook_app/repository/attachments/firebase_attachment_repository.dart';
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
import 'package:ubook_app/service/analytics_service.dart';
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
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  unawaited(
    AnalyticsService.instance.setCurrentUser(FirebaseAuth.instance.currentUser),
  );
  FirebaseAuth.instance.authStateChanges().listen((user) {
    unawaited(AnalyticsService.instance.setCurrentUser(user));
  });
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
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
        migration8to9,
        migration9to10,
      ]).build();
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
  // Metadata (nombre, tipo, fechas, relaciones) → Cloud Firestore.
  // Archivos binarios → Supabase Storage (bucket 'attachments').
  AttachmentRepository.setCurrent(SupabaseAttachmentRepository.initialize());
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
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.database, this.userRepository});

  final AppDatabase? database;
  final UserRepository? userRepository;

  @override
  Widget build(BuildContext context) {
    final analyticsObserver = AnalyticsService.instance.observer;

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
        navigatorObservers: analyticsObserver == null
            ? const []
            : [analyticsObserver],
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

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  String? _lastScreenName;

  void _trackScreen(String screenName) {
    if (_lastScreenName == screenName) return;
    _lastScreenName = screenName;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(AnalyticsService.instance.logScreen(screenName));
    });
  }

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
        final screenName = snapshot.data != null ? 'dashboard' : 'login';
        _trackScreen(screenName);
        return snapshot.data != null
            ? const DashboardView()
            : const LoginView();
      },
    );
  }
}
