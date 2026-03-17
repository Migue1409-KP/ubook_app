import 'package:flutter/material.dart';
import 'package:ubook_app/theme/app_colors.dart';
import 'package:ubook_app/view/career/career_list_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "University App",

      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
        ),
      ),

      home: const CareerListView(),
    );
  }
}