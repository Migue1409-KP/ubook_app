import 'package:flutter/material.dart';
import 'view/pqrs_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const PQRSPage(),
        '/pqrs': (context) => const PQRSPage(),
      },
    );
  }
}
