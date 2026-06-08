part of 'ubook_sql_connector.dart';

class CreateDemoProcessVariablesBuilder {
  String name;
  String description;
  String processType;
  bool isActive;

  final FirebaseDataConnect _dataConnect;
  CreateDemoProcessVariablesBuilder(this._dataConnect, {required  this.name,required  this.description,required  this.processType, this.isActive = true,});
  Deserializer<CreateDemoProcessData> dataDeserializer = (dynamic json)  => CreateDemoProcessData.fromJson(jsonDecode(json));
  Serializer<CreateDemoProcessVariables> varsSerializer = (CreateDemoProcessVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateDemoProcessData, CreateDemoProcessVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateDemoProcessData, CreateDemoProcessVariables> ref() {
    CreateDemoProcessVariables vars= CreateDemoProcessVariables(name: name,description: description,processType: processType,isActive: isActive,);
    return _dataConnect.mutation("CreateDemoProcess", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateDemoProcessDemoProcessInsert {
  final String id;
  CreateDemoProcessDemoProcessInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateDemoProcessDemoProcessInsert otherTyped = other as CreateDemoProcessDemoProcessInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateDemoProcessDemoProcessInsert({
    required this.id,
  });
}

@immutable
class CreateDemoProcessData {
  final CreateDemoProcessDemoProcessInsert demoProcess_insert;
  CreateDemoProcessData.fromJson(dynamic json):
  
  demoProcess_insert = CreateDemoProcessDemoProcessInsert.fromJson(json['demoProcess_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateDemoProcessData otherTyped = other as CreateDemoProcessData;
    return demoProcess_insert == otherTyped.demoProcess_insert;
    
  }
  @override
  int get hashCode => demoProcess_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['demoProcess_insert'] = demoProcess_insert.toJson();
    return json;
  }

  CreateDemoProcessData({
    required this.demoProcess_insert,
  });
}

@immutable
class CreateDemoProcessVariables {
  final String name;
  final String description;
  final String processType;
  final bool isActive;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateDemoProcessVariables.fromJson(Map<String, dynamic> json):
  
  name = nativeFromJson<String>(json['name']),
  description = nativeFromJson<String>(json['description']),
  processType = nativeFromJson<String>(json['processType']),
  isActive = json['isActive'] as bool? ?? true;
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateDemoProcessVariables otherTyped = other as CreateDemoProcessVariables;
    return name == otherTyped.name && 
    description == otherTyped.description && 
    processType == otherTyped.processType &&
    isActive == otherTyped.isActive;
    
  }
  @override
  int get hashCode => Object.hashAll([name.hashCode, description.hashCode, processType.hashCode, isActive.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['name'] = nativeToJson<String>(name);
    json['description'] = nativeToJson<String>(description);
    json['processType'] = nativeToJson<String>(processType);
    json['isActive'] = nativeToJson<bool>(isActive);
    return json;
  }

  CreateDemoProcessVariables({
    required this.name,
    required this.description,
    required this.processType,
    this.isActive = true,
  });
}

