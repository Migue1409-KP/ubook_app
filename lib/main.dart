import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/computer_lab/database_service.dart';
import 'model/computer_lab/computer_lab_repository.dart';
import 'view/dashboard/dashboard_view.dart';
import 'view/computer_lab/computer_lab_form_view.dart';
import 'view_model/computer_count_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = await DatabaseService.instance.database;
  final repository = FloorComputerLabRepository(database.computerLabDao);

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.repository});

  final ComputerLabRepository repository;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ComputerLabRepository>.value(value: repository),
        ChangeNotifierProvider(create: (_) => ComputerCountProvider()),
      ],
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
