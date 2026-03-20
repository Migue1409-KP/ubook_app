import 'package:flutter/foundation.dart';
import '../../model/pqrs/pqrs.dart';

class PQRSViewModel extends ChangeNotifier {
  final List<PQRS> _items = [
    PQRS(
      tipo: 'Peticion',
      descripcion: 'Solicitud de informacion',
      fecha: DateTime.now(),
      estado: 'Abierta',
    ),
    PQRS(
      tipo: 'Queja',
      descripcion: 'Problema con el servicio',
      fecha: DateTime.now(),
      estado: 'En proceso',
    ),
    PQRS(
      tipo: 'Reclamo',
      descripcion: 'Cobro incorrecto',
      fecha: DateTime.now(),
      estado: 'Cerrada',
    ),
  ];

  int _counter = 0;

  List<PQRS> get items => List.unmodifiable(_items);

  void addSample() {
    final types = ['Peticion', 'Queja', 'Reclamo'];
    final statuses = ['Abierta', 'En proceso', 'Cerrada'];
    final index = _counter % types.length;

    _items.insert(
      0,
      PQRS(
        tipo: types[index],
        descripcion: 'Nueva solicitud creada desde la app',
        fecha: DateTime.now(),
        estado: statuses[index],
      ),
    );

    _counter++;
    notifyListeners();
  }

  void addPQRS({
    required String tipo,
    required String descripcion,
    String estado = 'Abierta',
  }) {
    _items.insert(
      0,
      PQRS(
        tipo: tipo,
        descripcion: descripcion,
        fecha: DateTime.now(),
        estado: estado,
      ),
    );
    notifyListeners();
  }

  void updateEstado(int index, String estado) {
    if (index < 0 || index >= _items.length) return;
    final current = _items[index];
    _items[index] = PQRS(
      id: current.id,
      tipo: current.tipo,
      descripcion: current.descripcion,
      fecha: current.fecha,
      estado: estado,
    );
    notifyListeners();
  }
}
