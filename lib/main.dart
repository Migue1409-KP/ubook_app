import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view/dashboard/dashboard_view.dart';
import 'view/auth/login_view.dart';
import 'view/auth/profile_view.dart';
import 'view/auth/register_view.dart';
import 'view/pqrs/pqrs_page.dart';
import 'view_model/pqrs/pqrs_viewmodel.dart';
import 'view_model/auth/user_count_provider.dart';
import 'view_model/teachers/teacher_count_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserCountProvider()),
        ChangeNotifierProvider(create: (_) => TeacherCountProvider()),
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
          '/pqrs': (context) => ChangeNotifierProvider(
            create: (_) => PQRSViewModel(),
            child: const PQRSPage(),
          ),
        },
        home: const DashboardView(),
      ),
    );
  }
}