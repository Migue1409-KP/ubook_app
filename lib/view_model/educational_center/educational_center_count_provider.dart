import 'package:flutter/foundation.dart';

class EducationalCenterCountProvider extends ChangeNotifier {
  int _total = 0;

  int get total => _total;

  void initialize({required int total}) {
    _total = total;
    notifyListeners();
  }

  void increment() {
    _total++;
    notifyListeners();
  }

  void decrement() {
    if (_total > 0) {
      _total--;
      notifyListeners();
    }
  }

  void reset() {
    _total = 0;
    notifyListeners();
  }
}
