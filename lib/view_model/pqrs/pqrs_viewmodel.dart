import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../model/pqrs/pqrs.dart';
import '../../repository/auth/user_repository.dart';
import '../../repository/pqrs/pqrs_repository.dart';

class PQRSViewModel extends ChangeNotifier {
  final PQRSRepository _pqrsRepository;
  final UserRepository _userRepository;

  PQRSViewModel(
    this._pqrsRepository,
    this._userRepository,
  );

  List<PQRS> _items = [];

  List<PQRS> get items => List.unmodifiable(_items);

  Future<void> loadPQRS() async {
    _items = await _pqrsRepository.getAll();
    notifyListeners();
  }

  Future<void> addPQRS({
    required String tipo,
    required String descripcion,
    String estado = 'Abierta',
  }) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      throw Exception('No hay usuario autenticado');
    }

    final user =
        await _userRepository.findById(firebaseUser.uid);

    if (user == null) {
      throw Exception('Usuario no encontrado');
    }

    final pqrs = PQRS(
      userId: user.id,
      userName: user.name,
      tipo: tipo,
      descripcion: descripcion,
      fecha: DateTime.now(),
      estado: estado,
    );

    final saved = await _pqrsRepository.save(pqrs);

    _items.insert(0, saved);

    notifyListeners();
  }

  Future<void> updatePQRS({
    required int index,
    required String tipo,
    required String descripcion,
    required String estado,
  }) async {
    if (index < 0 || index >= _items.length) return;

    final current = _items[index];

    final updated = PQRS(
      id: current.id,
      userId: current.userId,
      userName: current.userName,
      tipo: tipo,
      descripcion: descripcion,
      fecha: current.fecha,
      estado: estado,
    );

    await _pqrsRepository.save(updated);

    _items[index] = updated;

    notifyListeners();
  }

  Future<void> updateEstado(
    int index,
    String estado,
  ) async {
    if (index < 0 || index >= _items.length) return;

    final current = _items[index];

    final updated = PQRS(
      id: current.id,
      userId: current.userId,
      userName: current.userName,
      tipo: current.tipo,
      descripcion: current.descripcion,
      fecha: current.fecha,
      estado: estado,
    );

    await _pqrsRepository.save(updated);

    _items[index] = updated;

    notifyListeners();
  }

  Future<void> deletePQRS(
    int index,
  ) async {
    if (index < 0 || index >= _items.length) return;

    final item = _items[index];

    await _pqrsRepository.delete(item);

    _items.removeAt(index);

    notifyListeners();
  }
}