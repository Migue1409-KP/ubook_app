library ubook_sql_connector;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

part 'create_demo_process.dart';

part 'update_demo_process.dart';

part 'delete_demo_process.dart';

part 'list_demo_processes.dart';

part 'get_demo_process.dart';







class UbookSqlConnectorConnector {
  
  
  CreateDemoProcessVariablesBuilder createDemoProcess ({required String name, required String description, required String processType, }) {
    return CreateDemoProcessVariablesBuilder(dataConnect, name: name,description: description,processType: processType,);
  }
  
  
  UpdateDemoProcessVariablesBuilder updateDemoProcess ({required String id, }) {
    return UpdateDemoProcessVariablesBuilder(dataConnect, id: id,);
  }
  
  
  DeleteDemoProcessVariablesBuilder deleteDemoProcess ({required String id, }) {
    return DeleteDemoProcessVariablesBuilder(dataConnect, id: id,);
  }
  
  
  ListDemoProcessesVariablesBuilder listDemoProcesses () {
    return ListDemoProcessesVariablesBuilder(dataConnect, );
  }
  
  
  GetDemoProcessVariablesBuilder getDemoProcess ({required String id, }) {
    return GetDemoProcessVariablesBuilder(dataConnect, id: id,);
  }
  

  static ConnectorConfig connectorConfig = ConnectorConfig(
    'us-central1',
    'ubook-sql-connector',
    'ubook-sql-service',
  );

  UbookSqlConnectorConnector({required this.dataConnect});
  static UbookSqlConnectorConnector get instance {
    
    return UbookSqlConnectorConnector(
        dataConnect: FirebaseDataConnect.instanceFor(
            connectorConfig: connectorConfig,
            
            sdkType: CallerSDKType.generated));
  }

  FirebaseDataConnect dataConnect;
}
