part of 'ubook_sql_connector.dart';

class DeleteDemoProcessVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  DeleteDemoProcessVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<DeleteDemoProcessData> dataDeserializer = (dynamic json)  => DeleteDemoProcessData.fromJson(jsonDecode(json));
  Serializer<DeleteDemoProcessVariables> varsSerializer = (DeleteDemoProcessVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteDemoProcessData, DeleteDemoProcessVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeleteDemoProcessData, DeleteDemoProcessVariables> ref() {
    DeleteDemoProcessVariables vars= DeleteDemoProcessVariables(id: id,);
    return _dataConnect.mutation("DeleteDemoProcess", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeleteDemoProcessDemoProcessDelete {
  final String id;
  DeleteDemoProcessDemoProcessDelete.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteDemoProcessDemoProcessDelete otherTyped = other as DeleteDemoProcessDemoProcessDelete;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteDemoProcessDemoProcessDelete({
    required this.id,
  });
}

@immutable
class DeleteDemoProcessData {
  final DeleteDemoProcessDemoProcessDelete? demoProcess_delete;
  DeleteDemoProcessData.fromJson(dynamic json):
  
  demoProcess_delete = json['demoProcess_delete'] == null ? null : DeleteDemoProcessDemoProcessDelete.fromJson(json['demoProcess_delete']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteDemoProcessData otherTyped = other as DeleteDemoProcessData;
    return demoProcess_delete == otherTyped.demoProcess_delete;
    
  }
  @override
  int get hashCode => demoProcess_delete.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (demoProcess_delete != null) {
      json['demoProcess_delete'] = demoProcess_delete!.toJson();
    }
    return json;
  }

  DeleteDemoProcessData({
    this.demoProcess_delete,
  });
}

@immutable
class DeleteDemoProcessVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeleteDemoProcessVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteDemoProcessVariables otherTyped = other as DeleteDemoProcessVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteDemoProcessVariables({
    required this.id,
  });
}

