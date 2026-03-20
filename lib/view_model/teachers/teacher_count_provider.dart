import 'package:flutter/foundation.dart';

class TeacherCountProvider extends ChangeNotifier {
  int _total = 0;
  int _active = 0;

  int get total => _total;
  int get active => _active;
  int get inactive => _total - _active;

  void initialize({required int total, required int active}) {
    _total = total;
    _active = active;
    notifyListeners();
  }

  void addTeacher({required bool isActive}) {
    _total++;
    if (isActive) _active++;
    notifyListeners();
  }

  void removeTeacher({required bool wasActive}) {
    if (_total > 0) _total--;
    if (wasActive && _active > 0) _active--;
    notifyListeners();
  }

  void reset() {
    _total = 0;
    _active = 0;
    notifyListeners();
  }
}
