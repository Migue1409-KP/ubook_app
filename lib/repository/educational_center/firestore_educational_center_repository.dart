import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/educational_center/educational_center_model.dart';

class FirestoreEducationalCenterRepository {
  FirestoreEducationalCenterRepository._();

  static late final FirestoreEducationalCenterRepository instance;

  static FirestoreEducationalCenterRepository initialize() {
    instance = FirestoreEducationalCenterRepository._();
    return instance;
  }

  // Colección en la nube de Firebase Firestore
  CollectionReference<Map<String, dynamic>> get _centers =>
      FirebaseFirestore.instance.collection('educational_centers');

  Map<String, dynamic> _toFirestore(EducationalCenter center) => center.toJson();

  EducationalCenter? _fromData(Map<String, dynamic>? data) {
    if (data == null) return null;
    return EducationalCenter.fromJson(data);
  }

  Future<List<EducationalCenter>> getRemoteEducationalCenters() async {
    final snap = await _centers.get();
    return snap.docs
        .map((doc) => _fromData(doc.data()))
        .whereType<EducationalCenter>()
        .toList();
  }

  Future<void> saveRemoteEducationalCenter(EducationalCenter center) async {
    await _centers.doc(center.id).set(_toFirestore(center));
  }

  Future<void> deleteRemoteEducationalCenter(String id) async {
    await _centers.doc(id).delete();
  }
}