import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view/dashboard/dashboard_view.dart';
import 'view/auth/login_view.dart';
import 'view/auth/register_view.dart';
import 'view/pqrs/pqrs_page.dart';
import 'view_model/pqrs/pqrs_viewmodel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UBook',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const DashboardView(),
        '/login': (context) => const LoginView(),
        '/register': (context) => const RegisterView(),
        '/pqrs':
            (context) => ChangeNotifierProvider(
              create: (_) => PQRSViewModel(),
              child: const PQRSPage(),
            ),
      },
    );
  }
}
