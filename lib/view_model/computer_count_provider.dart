import 'package:flutter/foundation.dart';

class ComputerCountProvider extends ChangeNotifier {
  int _totalComputers = 0;

  int get totalComputers => _totalComputers;

  void addComputers(int count) {
    if (count <= 0) return;
    _totalComputers += count;
    notifyListeners();
  }

  void reset() {
    _totalComputers = 0;
    notifyListeners();
  }
}

