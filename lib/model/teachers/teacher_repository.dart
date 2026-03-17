import 'teacher.dart';

/// Repository contract for Teachers.
abstract class TeacherRepository {
  Future<Teacher> save(Teacher teacher);
  Future<List<Teacher>> getAll();
}

/// Simple in-memory implementation.
class InMemoryTeacherRepository implements TeacherRepository {
  InMemoryTeacherRepository._internal();
  static final InMemoryTeacherRepository instance =
      InMemoryTeacherRepository._internal();

  final List<Teacher> _items = [];

  @override
  Future<Teacher> save(Teacher teacher) async {
    final index = _items.indexWhere((e) => e.id == teacher.id);
    if (index >= 0) {
      _items[index] = teacher;
    } else {
      _items.add(teacher);
    }
    return teacher;
  }

  @override
  Future<List<Teacher>> getAll() async => List.unmodifiable(_items);
}
