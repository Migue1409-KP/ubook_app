# Database Architecture - UBook

## Propósito

`lib/database/` es la ubicación **central** de la definición de la base de datos SQLite (Floor ORM). Aquí se define el esquema, versión y todas las entidades que la aplicación persiste.

## Estructura

```
lib/database/
├── app_database.dart       ← Define AppDatabase (el schema)
└── app_database.g.dart     ← Auto-generado por Floor (NUNCA EDITAR)
```

## Cómo funciona

### 1. AppDatabase (app_database.dart)

Es la clase **abstracta** que define:
- **Versión** de la BD: `@Database(version: 1, ...)`
- **Entidades** que se persisten: `entities: [UserModel, ...]`
- **Converters** para tipos complejos: `@TypeConverters([AuthProviderConverter, ...])`
- **DAOs** (Data Access Objects): `UserDao get userDao;`

```dart
@TypeConverters([AuthProviderConverter])
@Database(version: 1, entities: [UserModel])
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;
}
```

**Importa explícitamente**:
```dart
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;
```

Esto es **crítico** para que Floor genere código con todas las importaciones necesarias.

### 2. app_database.g.dart (Generado)

Floor ejecuta `dart run build_runner build` y genera:
- `_$AppDatabase`: Implementación concreta de AppDatabase
- `_$UserDao`: Implementación concreta de UserDao (mapeos SQL)
- `$FloorAppDatabase`: Factory builder para instanciar la BD

**Nunca lo edites**. Si cambias el source (app_database.dart), solo regenera ejecutando:
```bash
dart run build_runner build --delete-conflicting-outputs
```

## Agregar un nuevo modelo

### Ejemplo: Agregar persistencia para "Career"

**1. Crear la entidad** (`lib/model/career/career_model.dart`):
```dart
@Entity(tableName: 'careers')
class CareerModel {
  @PrimaryKey(autoGenerate: false)
  final String id;
  final String name;
  final String description;
  
  CareerModel({required this.id, required this.name, required this.description});
}
```

**2. Crear el DAO** (`lib/repository/career/career_dao.dart`):
```dart
@dao
abstract class CareerDao {
  @Query('SELECT * FROM careers WHERE id = :id LIMIT 1')
  Future<CareerModel?> findById(String id);

  @insert
  Future<void> insertCareer(CareerModel career);

  @update
  Future<int> updateCareer(CareerModel career);

  @delete
  Future<int> deleteCareer(CareerModel career);
}
```

**3. Registrar en AppDatabase** (`lib/database/app_database.dart`):
```dart
import 'package:ubook_app/repository/career/career_dao.dart';

@Database(
  version: 1,
  entities: [UserModel, CareerModel],  // ← Agregar aquí
)
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;
  CareerDao get careerDao;  // ← Agregar aquí
}
```

**4. Agregar getter en AppDatabase**:
```dart
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;
  CareerDao get careerDao;  // ← Nueva línea
}
```

**5. Regenerar**:
```bash
dart run build_runner build --delete-conflicting-outputs
```

**6. Crear repositorio** (`lib/repository/career/floor_career_repository.dart`):
```dart
class FloorCareerRepository implements CareerRepository {
  FloorCareerRepository(this._database);

  final AppDatabase _database;

  @override
  Future<CareerModel?> findById(String id) async {
    return _database.careerDao.findById(id);
  }

  // ... más métodos
}
```

**7. Componer dependencias en `main.dart`**:
```dart
final database = await $FloorAppDatabase.databaseBuilder('ubook_app.db').build();
final userRepository = FloorUserRepository.initialize(database);
```

`main.dart` es el lugar correcto para crear la conexión local y pasarla al resto de la app. `app_database.dart` solo define el esquema y los DAOs, no instancia la base.

## Anotaciones Floor - Sintaxis Correcta

| Anotación | Uso | Ejemplo |
|-----------|-----|---------|
| `@dao` | Decorar clase DAO | `@dao abstract class UserDao` |
| `@query` | Consulta SQL SELECT | `@query('SELECT ...')` |
| `@insert` | Insertar entidad | `@insert Future<void> insertUser(...)` |
| `@update` | Actualizar entidad | `@update Future<int> updateUser(...)` |
| `@delete` | Eliminar entidad | `@delete Future<int> deleteUser(...)` |

**Todas en minúsculas, sin paréntesis**.

## Converters (Tipos complejos)

Si necesitas persistir un tipo que SQLite no entiende (Enum, DateTime, custom):

```dart
class AuthProviderConverter extends TypeConverter<AuthProvider, String> {
  @override
  AuthProvider decode(String databaseValue) {
    return AuthProvider.fromJson(databaseValue);
  }

  @override
  String encode(AuthProvider value) {
    return value.toJson();
  }
}
```

Luego registra en AppDatabase:
```dart
@TypeConverters([AuthProviderConverter])
@Database(version: 1, entities: [UserModel])
abstract class AppDatabase extends FloorDatabase { ... }
```

## Ciclo de vida

```
Usuario edita app_database.dart
        ↓
Ejecuta: dart run build_runner build --delete-conflicting-outputs
        ↓
Floor lee anotaciones @Database, @dao, @query, etc.
        ↓
Genera: app_database.g.dart (implementación concreta)
        ↓
Compilador verifica tipos y genera bytecode
        ↓
App puede instanciar DB y usar DAOs
```

## Troubleshooting

### Error: "Could not resolve annotation"
- Asegúrate que `@dao` sea minúscula, sin paréntesis.
- Verifica que el DAO esté correctamente referenciado en AppDatabase.

### Error: "Undefined class 'StreamController'" o "Undefined name 'sqflite'"
- Agrega estos imports a `app_database.dart`:
  ```dart
  import 'dart:async';
  import 'package:sqflite/sqflite.dart' as sqflite;
  ```

### app_database.g.dart no se actualiza
- Borra la carpeta `.dart_tool/build/` y ejecuta de nuevo:
  ```bash
  dart run build_runner clean
  dart run build_runner build
  ```

---

**Más info**: [Floor ORM Docs](https://pub.dev/packages/floor)
