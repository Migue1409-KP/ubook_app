import 'package:uuid/uuid.dart';

import '../../database/app_database.dart';
import '../../model/pqrs/pqrs.dart';
import '../../model/pqrs/pqrs_entity.dart';

abstract class PQRSRepository {

  Future<void> ensureInitialized();

  Future<List<PQRS>> getAll();

  Future<PQRS> save(PQRS pqrs);

  Future<void> delete(PQRS pqrs);
}
class FloorPQRSRepository implements PQRSRepository {

  FloorPQRSRepository._(this._database);

  final AppDatabase _database;

  static late final FloorPQRSRepository instance;

  static FloorPQRSRepository initialize(
    AppDatabase database,
  ) {
    instance = FloorPQRSRepository._(database);
    return instance;
  }

  @override
  Future<void> ensureInitialized() async {}

  @override
  Future<List<PQRS>> getAll() async {
    final entities = await _database.pqrsDao.findAll();

    return entities.map((e) => e.toPQRS()).toList();
  }

  @override
  Future<PQRS> save(PQRS pqrs) async {

    final item = pqrs.id == null
        ? PQRS(
            id: const Uuid().v4(),
            userId: pqrs.userId,
            userName: pqrs.userName,
            tipo: pqrs.tipo,
            descripcion: pqrs.descripcion,
            fecha: pqrs.fecha,
            estado: pqrs.estado,
          )
        : pqrs;

    await _database.pqrsDao.savePQRS(
      PQRSEntity.fromPQRS(item),
    );

    return item;
  }

  @override
  Future<void> delete(PQRS pqrs) async {
    await _database.pqrsDao.deletePQRS(
      PQRSEntity.fromPQRS(pqrs),
    );
  }
}