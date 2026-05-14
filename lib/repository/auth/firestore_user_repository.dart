import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ubook_app/model/auth/user_model.dart';

import 'user_repository.dart';

// Offline persistence is enabled by default on Android/iOS: the Firestore SDK
// queues pending writes locally and flushes them automatically on reconnect.
class FirestoreUserRepository implements UserRepository {
  FirestoreUserRepository._();

  static late final FirestoreUserRepository instance;

  static FirestoreUserRepository initialize() {
    instance = FirestoreUserRepository._();
    return instance;
  }

  CollectionReference<Map<String, dynamic>> get _users =>
      FirebaseFirestore.instance.collection('users');

  Map<String, dynamic> _toFirestore(UserModel user) =>
      user.toJson()..remove('password');

  UserModel? _fromData(Map<String, dynamic>? data) {
    if (data == null) return null;
    return UserModel.fromJson(data);
  }

  @override
  Future<void> ensureInitialized() async {}

  @override
  Future<UserModel?> findById(String id) async {
    final doc = await _users.doc(id).get();
    return _fromData(doc.data());
  }

  @override
  Future<UserModel?> findByEmail(String email) async {
    final snap = await _users
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    if (snap.docs.isEmpty) return null;
    return _fromData(snap.docs.first.data());
  }

  @override
  Future<UserModel?> findMostRecentUser() async {
    final snap = await _users
        .orderBy('updated_at', descending: true)
        .limit(1)
        .get();
    if (snap.docs.isEmpty) return null;
    return _fromData(snap.docs.first.data());
  }

  @override
  Future<void> insertUser(UserModel user) async {
    await _users.doc(user.id).set(_toFirestore(user));
  }

  @override
  Future<int> updateUser(UserModel user) async {
    await _users.doc(user.id).set(_toFirestore(user));
    return 1;
  }

  @override
  Future<int> deleteUser(UserModel user) async {
    await _users.doc(user.id).delete();
    return 1;
  }

  @override
  Future<void> deleteAllUsers() async {
    final snap = await _users.get();
    final batch = FirebaseFirestore.instance.batch();
    for (final doc in snap.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  @override
  Future<int> countUsers() async {
    final snap = await _users.count().get();
    return snap.count ?? 0;
  }
}
