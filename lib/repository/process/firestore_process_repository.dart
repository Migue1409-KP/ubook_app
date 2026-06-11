import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/process/process_model.dart';
import 'process_repository.dart';

class FirestoreProcessRepository implements ProcessRepository {
  FirestoreProcessRepository._();

  static late final FirestoreProcessRepository instance;

  static FirestoreProcessRepository initialize() {
    instance = FirestoreProcessRepository._();
    return instance;
  }

  CollectionReference<Map<String, dynamic>> get _processes =>
      FirebaseFirestore.instance.collection('processes');

  Map<String, dynamic> _toFirestore(ProcessModel process) => process.toJson();

  ProcessModel? _fromData(Map<String, dynamic>? data) {
    if (data == null) return null;
    return ProcessModel.fromJson(data);
  }

  @override
  Future<List<ProcessModel>> getProcesses() async {
    final snap = await _processes.get();
    return snap.docs
        .map((doc) => _fromData(doc.data()))
        .whereType<ProcessModel>()
        .toList();
  }

  @override
  Future<void> addProcess(ProcessModel process) async {
    await _processes.doc(process.id).set(_toFirestore(process));
  }

  @override
  Future<void> updateProcess(ProcessModel process) async {
    await _processes.doc(process.id).set(_toFirestore(process));
  }

  @override
  Future<void> deleteProcess(String processId) async {
    await _processes.doc(processId).delete();
  }

  @override
  Future<ProcessModel?> getProcessById(String processId) async {
    final doc = await _processes.doc(processId).get();
    return _fromData(doc.data());
  }
}
