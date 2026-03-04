import 'computer_lab.dart';

/// Repository contract for Computer Labs.
abstract class ComputerLabRepository {
  Future<ComputerLab> save(ComputerLab lab);
  Future<List<ComputerLab>> getAll();
}

/// Simple in-memory implementation.
class InMemoryComputerLabRepository implements ComputerLabRepository {
  InMemoryComputerLabRepository._internal();
  static final InMemoryComputerLabRepository instance =
      InMemoryComputerLabRepository._internal();

  final List<ComputerLab> _items = [];

  @override
  Future<ComputerLab> save(ComputerLab lab) async {
    final index = _items.indexWhere((e) => e.id == lab.id);
    if (index >= 0) {
      _items[index] = lab;
    } else {
      _items.add(lab);
    }
    return lab;
  }

  @override
  Future<List<ComputerLab>> getAll() async => List.unmodifiable(_items);
}
