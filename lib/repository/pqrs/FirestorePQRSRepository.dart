import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/pqrs/pqrs.dart';
import 'pqrs_repository.dart';

class FirestorePQRSRepository implements PQRSRepository {

  FirestorePQRSRepository._();

  static late final FirestorePQRSRepository instance;

  static FirestorePQRSRepository initialize() {
    instance = FirestorePQRSRepository._();
    return instance;
  }

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('pqrs');

  @override
  Future<void> ensureInitialized() async {}

  @override
  Future<List<PQRS>> getAll() async {

    final snapshot = await _collection
        .orderBy('fechaMs', descending: true)
        .get();

    return snapshot.docs.map((doc) {

      final data = doc.data();

      return PQRS(
        id: data['id'],
        userId: data['userId'],
        userName: data['userName'],
        tipo: data['tipo'],
        descripcion: data['descripcion'],
        fecha: DateTime.fromMillisecondsSinceEpoch(
          data['fechaMs'],
        ),
        estado: data['estado'],
      );

    }).toList();
  }

 @override
Future<PQRS> save(PQRS pqrs) async {

  print('ENTRANDO A FIRESTORE SAVE');

  try {

    await _collection.doc(pqrs.id).set({
      'id': pqrs.id,
      'userId': pqrs.userId,
      'userName': pqrs.userName,
      'tipo': pqrs.tipo,
      'descripcion': pqrs.descripcion,
      'fechaMs': pqrs.fecha.millisecondsSinceEpoch,
      'estado': pqrs.estado,
    }).timeout(
      const Duration(seconds: 10),
    );

    print('GUARDADO EN FIRESTORE');

  } catch (e, s) {

    print('ERROR FIRESTORE');
    print(e);
    print(s);

    rethrow;
  }

  return pqrs;
}

  @override
  Future<void> delete(PQRS pqrs) async {
    await _collection.doc(pqrs.id).delete();
  }
}