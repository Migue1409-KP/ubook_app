import 'package:flutter/material.dart';
import 'view/dashboard/dashboard_view.dart';
import 'view/computer_lab/computer_lab_form_view.dart';
import 'package:provider/provider.dart';
import 'view_model/computer_count_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ComputerCountProvider(),
      child: MaterialApp(
      title: 'UBook',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      routes: {
        '/computer-lab-form': (context) => const ComputerLabFormView(),
      },
      home: const DashboardView(),
      ),
    );
  }
}
