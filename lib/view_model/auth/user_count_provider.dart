import 'dart:async';
import 'package:flutter/foundation.dart';

class UserCountProvider extends ChangeNotifier {
  int _userCount = 0;
  Timer? _timer;

  UserCountProvider() {
    _startSimulation();
  }

  int get userCount => _userCount;

  void setUserCount(int count) {
    _userCount = count;
    notifyListeners();
  }

  // Simulación de actualización del contador (en una app real, esto vendría del backend)
  void _startSimulation() {
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      _userCount++;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
