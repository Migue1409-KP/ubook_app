part of 'ubook_sql_connector.dart';

class UpdateDemoProcessVariablesBuilder {
  String id;
  Optional<String> _name = Optional.optional(nativeFromJson, nativeToJson);
  Optional<bool> _isActive = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  UpdateDemoProcessVariablesBuilder name(String? t) {
   _name.value = t;
   return this;
  }
  UpdateDemoProcessVariablesBuilder isActive(bool? t) {
   _isActive.value = t;
   return this;
  }

  UpdateDemoProcessVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<UpdateDemoProcessData> dataDeserializer = (dynamic json)  => UpdateDemoProcessData.fromJson(jsonDecode(json));
  Serializer<UpdateDemoProcessVariables> varsSerializer = (UpdateDemoProcessVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateDemoProcessData, UpdateDemoProcessVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateDemoProcessData, UpdateDemoProcessVariables> ref() {
    UpdateDemoProcessVariables vars= UpdateDemoProcessVariables(id: id,name: _name,isActive: _isActive,);
    return _dataConnect.mutation("UpdateDemoProcess", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateDemoProcessDemoProcessUpdate {
  final String id;
  UpdateDemoProcessDemoProcessUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateDemoProcessDemoProcessUpdate otherTyped = other as UpdateDemoProcessDemoProcessUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateDemoProcessDemoProcessUpdate({
    required this.id,
  });
}

@immutable
class UpdateDemoProcessData {
  final UpdateDemoProcessDemoProcessUpdate? demoProcess_update;
  UpdateDemoProcessData.fromJson(dynamic json):
  
  demoProcess_update = json['demoProcess_update'] == null ? null : UpdateDemoProcessDemoProcessUpdate.fromJson(json['demoProcess_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateDemoProcessData otherTyped = other as UpdateDemoProcessData;
    return demoProcess_update == otherTyped.demoProcess_update;
    
  }
  @override
  int get hashCode => demoProcess_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (demoProcess_update != null) {
      json['demoProcess_update'] = demoProcess_update!.toJson();
    }
    return json;
  }

  UpdateDemoProcessData({
    this.demoProcess_update,
  });
}

@immutable
class UpdateDemoProcessVariables {
  final String id;
  late final Optional<String>name;
  late final Optional<bool>isActive;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateDemoProcessVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']) {
  
  
  
    name = Optional.optional(nativeFromJson, nativeToJson);
    name.value = json['name'] == null ? null : nativeFromJson<String>(json['name']);
  
  
    isActive = Optional.optional(nativeFromJson, nativeToJson);
    isActive.value = json['isActive'] == null ? null : nativeFromJson<bool>(json['isActive']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateDemoProcessVariables otherTyped = other as UpdateDemoProcessVariables;
    return id == otherTyped.id && 
    name == otherTyped.name && 
    isActive == otherTyped.isActive;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, isActive.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if(name.state == OptionalState.set) {
      json['name'] = name.toJson();
    }
    if(isActive.state == OptionalState.set) {
      json['isActive'] = isActive.toJson();
    }
    return json;
  }

  UpdateDemoProcessVariables({
    required this.id,
    required this.name,
    required this.isActive,
  });
}

