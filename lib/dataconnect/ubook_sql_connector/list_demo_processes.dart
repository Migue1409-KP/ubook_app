part of 'ubook_sql_connector.dart';

class ListDemoProcessesVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  ListDemoProcessesVariablesBuilder(this._dataConnect, );
  Deserializer<ListDemoProcessesData> dataDeserializer = (dynamic json)  => ListDemoProcessesData.fromJson(jsonDecode(json));
  
  Future<QueryResult<ListDemoProcessesData, void>> execute() {
    return ref().execute();
  }

  QueryRef<ListDemoProcessesData, void> ref() {
    
    return _dataConnect.query("ListDemoProcesses", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class ListDemoProcessesDemoProcesses {
  final String id;
  final String name;
  final String description;
  final String processType;
  final bool isActive;
  final Timestamp createdAt;
  final Timestamp? updatedAt;
  ListDemoProcessesDemoProcesses.fromJson(dynamic json):
  
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

    final ListDemoProcessesDemoProcesses otherTyped = other as ListDemoProcessesDemoProcesses;
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

  ListDemoProcessesDemoProcesses({
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
class ListDemoProcessesData {
  final List<ListDemoProcessesDemoProcesses> demoProcesses;
  ListDemoProcessesData.fromJson(dynamic json):
  
  demoProcesses = (json['demoProcesses'] as List<dynamic>)
        .map((e) => ListDemoProcessesDemoProcesses.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListDemoProcessesData otherTyped = other as ListDemoProcessesData;
    return demoProcesses == otherTyped.demoProcesses;
    
  }
  @override
  int get hashCode => demoProcesses.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['demoProcesses'] = demoProcesses.map((e) => e.toJson()).toList();
    return json;
  }

  ListDemoProcessesData({
    required this.demoProcesses,
  });
}

