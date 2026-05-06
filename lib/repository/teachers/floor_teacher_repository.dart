import '../../database/teacher_database.dart';
import '../../model/teachers/teacher.dart';
import 'teacher_repository.dart';

class FloorTeacherRepository implements TeacherRepository {
  TeacherDatabase? _database;

  FloorTeacherRepository();

  static final FloorTeacherRepository instance = FloorTeacherRepository();

  Future<TeacherDatabase> _getDatabase() async {
    if (_database != null) return _database!;
    _database = await $FloorTeacherDatabase
        .databaseBuilder('ubook_app.db')
        .build();
    return _database!;
  }

  @override
  Future<List<Teacher>> getTeachers() async {
    final db = await _getDatabase();
    return db.teacherDao.findAllTeachers();
  }

  @override
  Future<Teacher?> getTeacherById(String id) async {
    final db = await _getDatabase();
    return db.teacherDao.findTeacherById(id);
  }

  @override
  Future<void> saveTeacher(Teacher teacher) async {
    final db = await _getDatabase();
    await db.teacherDao.insertTeacher(teacher);
  }

  @override
  Future<void> updateTeacher(Teacher teacher) async {
    final db = await _getDatabase();
    await db.teacherDao.updateTeacher(teacher);
  }

  @override
  Future<void> deleteTeacher(Teacher teacher) async {
    final db = await _getDatabase();
    await db.teacherDao.deleteTeacher(teacher);
  }

  @override
  Future<void> ensureInitialized() async {
    final db = await _getDatabase();
    final count = await db.teacherDao.countTeachers() ?? 0;
    if (count == 0) {
      await db.teacherDao.insertTeachers(_seedTeachers);
    }
  }

  final List<Teacher> _seedTeachers = [
    Teacher(
      id: 'TCH-001',
      firstName: 'Juan',
      lastName: 'Pablo',
      email: 'juan.pablo@uco.edu',
      phone: '809-555-0101',
      age: 25,
      department: 'Ingeniería de Sistemas',
      specialty: 'Desarrollo Móvil',
      subjects: ['Ingeniería de Software 3', 'Ingeniería de Software Avanzada 2'],
      profileImageUrl: 'assets/images/auth/google.png',
      isActive: true,
      createdAt: DateTime(2024, 1, 15),
      updatedAt: DateTime(2024, 6, 10),
    ),
    Teacher(
      id: 'TCH-002',
      firstName: 'Maria',
      lastName: 'Lopez',
      email: 'maria.lopez@uco.edu',
      phone: '809-555-0102',
      age: 34,
      department: 'Ingeniería de Sistemas',
      specialty: 'Inteligencia Artificial',
      subjects: ['Fundamentos de IA', 'Aprendizaje Automático'],
      profileImageUrl: 'assets/images/auth/google.png',
      isActive: true,
      createdAt: DateTime(2023, 8, 20),
      updatedAt: DateTime(2024, 5, 5),
    ),
  ];
}
