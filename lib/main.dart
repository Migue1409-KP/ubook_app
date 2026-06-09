import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Supabase;
import 'package:ubook_app/config/supabase_config.dart';
import 'package:ubook_app/database/app_database.dart';
import 'package:ubook_app/firebase_options.dart';
import 'package:ubook_app/view/dashboard/dashboard_view.dart';
import 'package:ubook_app/view_model/dashboard/dashboard_view_model.dart';
import 'package:ubook_app/view_model/notification/notification_view_model.dart';
import 'package:ubook_app/view_model/auth/user_count_provider.dart';
import 'package:ubook_app/view_model/reviews/reviews_view_model.dart';
import 'package:ubook_app/view_model/reviews/create_review_view_model.dart';
import 'package:ubook_app/view_model/process_view_model.dart';
import 'package:ubook_app/view_model/teachers/teacher_count_provider.dart';
import 'package:ubook_app/view_model/educational_center/educational_center_view_model.dart';
import 'package:ubook_app/view_model/educational_center/educational_center_count_provider.dart';
import 'package:ubook_app/view_model/notification/notification_admin_view_model.dart';
import 'package:ubook_app/view/auth/login_view.dart';
import 'package:ubook_app/view/auth/register_view.dart';
import 'package:ubook_app/view/auth/profile_view.dart';
import 'package:ubook_app/view/notification/notification_admin_view.dart';
import 'package:ubook_app/view_model/notification/notification_view_model.dart';
import 'package:ubook_app/view_model/auth/user_count_provider.dart';
import 'package:ubook_app/view/pqrs/pqrs_page.dart';
import 'package:ubook_app/view_model/pqrs/pqrs_viewmodel.dart';
import 'package:ubook_app/view/admin_user/admin_users_view.dart';
import 'package:ubook_app/view/subjects/subjects_view.dart';
import 'package:ubook_app/utils/session_manager.dart';
import 'package:ubook_app/repository/subjects/floor_subject_repository.dart';
import 'package:ubook_app/repository/subjects/subject_repository.dart';
import 'package:ubook_app/repository/subjects/firestore_subject_repository.dart';
import 'package:ubook_app/repository/subjects/syncing_subject_repository.dart';
import 'package:ubook_app/repository/notification/floor_notification_repository.dart';
import 'package:ubook_app/repository/process/floor_process_repository.dart';
import 'package:ubook_app/repository/process/process_repository.dart';
import 'package:ubook_app/repository/auth/floor_user_repository.dart';
import 'package:ubook_app/repository/auth/firebase_auth_service.dart';
import 'package:ubook_app/repository/auth/syncing_user_repository.dart';
import 'package:ubook_app/repository/teachers/floor_teacher_repository.dart';
import 'package:ubook_app/repository/teacher_subject/floor_subject_teacher_repository.dart';
import 'package:ubook_app/repository/career/career_repository_provider.dart';
import 'package:ubook_app/repository/reviews/review_repository_provider.dart';
import 'package:ubook_app/repository/auth/firestore_user_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configurar Crashlytics para capturar errores
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  // Prueba de Crashlytics (quitar después de verificar)
  // FirebaseCrashlytics.instance.crash();


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
         migration10to11,
         migration11to12,
         migration12to13,
       ])
      .build();
  FloorSubjectRepository.initialize(database);
  FirestoreSubjectRepository.initialize();
  SyncingSubjectRepository.initialize(FloorSubjectRepository.instance, FirestoreSubjectRepository.instance);
  SubjectRepository.setInstance(SyncingSubjectRepository.instance);
  FloorNotificationRepository.initialize(database);
  FloorProcessRepository.initialize(database);
  ProcessRepository.setInstance(FloorProcessRepository.instance);
  FloorUserRepository.initialize(database);
  FirestoreUserRepository.initialize();
  SyncingUserRepository.initialize(FloorUserRepository.instance, FirestoreUserRepository.instance);
  FloorTeacherRepository.initialize(database);
  FloorSubjectTeacherRepository.initialize(database);
  await CareerRepositoryProvider.initialize(database);
  await ReviewRepositoryProvider.initialize(database);
  await SessionManager().initialize();
  debugPrint('MAIN: SessionManager inicializado. userId=${SessionManager().currentUserId}');
  await Future.delayed(const Duration(milliseconds: 400));
  debugPrint('MAIN: lanzando runApp');
  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.database});

  final AppDatabase? database;

  @override
  Widget build(BuildContext context) {
return MultiProvider(
       providers: [
         if (database != null) Provider<AppDatabase>.value(value: database!),
         ChangeNotifierProvider(create: (_) => NotificationViewModel()),
         ChangeNotifierProvider(create: (_) => UserCountProvider()),
         ChangeNotifierProvider(create: (_) => DashboardViewModel()),
         ChangeNotifierProvider(create: (_) => ReviewsViewModel()),
         ChangeNotifierProvider(create: (_) => ProcessViewModel()),
         ChangeNotifierProvider(create: (_) => NotificationAdminViewModel()),
         ChangeNotifierProvider(create: (_) => TeacherCountProvider()),
         ChangeNotifierProvider(create: (_) => EducationalCenterCountProvider()),
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
          '/subjects': (context) => const SubjectsView(),
        },
        home: const _AuthGate(),
      ),
    );
  }
}

class _AuthGate extends StatefulWidget {
  const _AuthGate();

  @override
  State<_AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<_AuthGate> {
  static const _timeout = Duration(seconds: 2);
  late final Future<User?> _initialization;

  @override
  void initState() {
    super.initState();
    final Stream<User?> _stream = FirebaseAuth.instance.authStateChanges();
    _initialization = _stream.first.timeout(_timeout, onTimeout: () => null);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final user = snapshot.data;
        if (user != null) {
          return const DashboardView();
        }
        return const LoginView();
      },
    );
  }
}
