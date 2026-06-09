import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

/// Botón temporal para probar Firebase Crashlytics
/// Agregar en una vista de debug: CrashTestButton()
class CrashTestButton extends StatelessWidget {
  const CrashTestButton({super.key});

  void _testCrash() {
    FirebaseCrashlytics.instance.crash();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _testCrash,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
      ),
      child: const Text('Test Crash', style: TextStyle(color: Colors.white)),
    );
  }
}