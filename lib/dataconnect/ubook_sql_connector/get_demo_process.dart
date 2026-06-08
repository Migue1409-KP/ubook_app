part of 'ubook_sql_connector.dart';

class GetDemoProcessVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  GetDemoProcessVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<GetDemoProcessData> dataDeserializer = (dynamic json)  => GetDemoProcessData.fromJson(jsonDecode(json));
  Serializer<GetDemoProcessVariables> varsSerializer = (GetDemoProcessVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetDemoProcessData, GetDemoProcessVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetDemoProcessData, GetDemoProcessVariables> ref() {
    GetDemoProcessVariables vars= GetDemoProcessVariables(id: id,);
    return _dataConnect.query("GetDemoProcess", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetDemoProcessDemoProcess {
  final String id;
  final String name;
  final String description;
  final String processType;
  final bool isActive;
  final Timestamp createdAt;
  final Timestamp? updatedAt;
  GetDemoProcessDemoProcess.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']),
  description = nativeFromJson<String>(json['description']),
  processType = nativeFromJson<String>(json['processType']),
  isActive = nativeFromJson<bool>(json['isActive']),
  createdAt = Timestamp.fromJson(json['createdAt']),
  updatedAt = json['updatedAt'] == null ? null : Timestamp.fromJson(json['updatedAt']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetDemoProcessDemoProcess otherTyped = other as GetDemoProcessDemoProcess;
    return id == otherTyped.id && 
    name == otherTyped.name && 
    description == otherTyped.description && 
    processType == otherTyped.processType && 
    isActive == otherTyped.isActive && 
    createdAt == otherTyped.createdAt && 
    updatedAt == otherTyped.updatedAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, description.hashCode, processType.hashCode, isActive.hashCode, createdAt.hashCode, updatedAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    json['description'] = nativeToJson<String>(description);
    json['processType'] = nativeToJson<String>(processType);
    json['isActive'] = nativeToJson<bool>(isActive);
    json['createdAt'] = createdAt.toJson();
    if (updatedAt != null) {
      json['updatedAt'] = updatedAt!.toJson();
    }
    return json;
  }

  GetDemoProcessDemoProcess({
    required this.id,
    required this.name,
    required this.description,
    required this.processType,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });
}

@immutable
class GetDemoProcessData {
  final GetDemoProcessDemoProcess? demoProcess;
  GetDemoProcessData.fromJson(dynamic json):
  
  demoProcess = json['demoProcess'] == null ? null : GetDemoProcessDemoProcess.fromJson(json['demoProcess']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetDemoProcessData otherTyped = other as GetDemoProcessData;
    return demoProcess == otherTyped.demoProcess;
    
  }
  @override
  int get hashCode => demoProcess.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (demoProcess != null) {
      json['demoProcess'] = demoProcess!.toJson();
    }
    return json;
  }

  GetDemoProcessData({
    this.demoProcess,
  });
}

@immutable
class GetDemoProcessVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetDemoProcessVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetDemoProcessVariables otherTyped = other as GetDemoProcessVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  GetDemoProcessVariables({
    required this.id,
  });
}

