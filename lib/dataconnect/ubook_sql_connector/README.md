# ubook_sql_connector SDK

## Installation
```sh
flutter pub get firebase_data_connect
flutterfire configure
```
For more information, see [Flutter for Firebase installation documentation](https://firebase.google.com/docs/data-connect/flutter-sdk#use-core).

## Data Connect instance
Each connector creates a static class, with an instance of the `DataConnect` class that can be used to connect to your Data Connect backend and call operations.

### Connecting to the emulator

```dart
String host = 'localhost'; // or your host name
int port = 9399; // or your port number
UbookSqlConnectorConnector.instance.dataConnect.useDataConnectEmulator(host, port);
```

You can also call queries and mutations by using the connector class.
## Queries

### ListDemoProcesses
#### Required Arguments
```dart
// No required arguments
UbookSqlConnectorConnector.instance.listDemoProcesses().execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListDemoProcessesData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await UbookSqlConnectorConnector.instance.listDemoProcesses();
ListDemoProcessesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = UbookSqlConnectorConnector.instance.listDemoProcesses().ref();
ref.execute();

ref.subscribe(...);
```


### GetDemoProcess
#### Required Arguments
```dart
String id = ...;
UbookSqlConnectorConnector.instance.getDemoProcess(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetDemoProcessData, GetDemoProcessVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await UbookSqlConnectorConnector.instance.getDemoProcess(
  id: id,
);
GetDemoProcessData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = UbookSqlConnectorConnector.instance.getDemoProcess(
  id: id,
).ref();
ref.execute();

ref.subscribe(...);
```

## Mutations

### CreateDemoProcess
#### Required Arguments
```dart
String name = ...;
String description = ...;
String processType = ...;
UbookSqlConnectorConnector.instance.createDemoProcess(
  name: name,
  description: description,
  processType: processType,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CreateDemoProcessData, CreateDemoProcessVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await UbookSqlConnectorConnector.instance.createDemoProcess(
  name: name,
  description: description,
  processType: processType,
);
CreateDemoProcessData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String name = ...;
String description = ...;
String processType = ...;

final ref = UbookSqlConnectorConnector.instance.createDemoProcess(
  name: name,
  description: description,
  processType: processType,
).ref();
ref.execute();
```


### UpdateDemoProcess
#### Required Arguments
```dart
String id = ...;
UbookSqlConnectorConnector.instance.updateDemoProcess(
  id: id,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpdateDemoProcess, we created `UpdateDemoProcessBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpdateDemoProcessVariablesBuilder {
  ...
   UpdateDemoProcessVariablesBuilder name(String? t) {
   _name.value = t;
   return this;
  }
  UpdateDemoProcessVariablesBuilder isActive(bool? t) {
   _isActive.value = t;
   return this;
  }

  ...
}
UbookSqlConnectorConnector.instance.updateDemoProcess(
  id: id,
)
.name(name)
.isActive(isActive)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpdateDemoProcessData, UpdateDemoProcessVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await UbookSqlConnectorConnector.instance.updateDemoProcess(
  id: id,
);
UpdateDemoProcessData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = UbookSqlConnectorConnector.instance.updateDemoProcess(
  id: id,
).ref();
ref.execute();
```


### DeleteDemoProcess
#### Required Arguments
```dart
String id = ...;
UbookSqlConnectorConnector.instance.deleteDemoProcess(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteDemoProcessData, DeleteDemoProcessVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await UbookSqlConnectorConnector.instance.deleteDemoProcess(
  id: id,
);
DeleteDemoProcessData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = UbookSqlConnectorConnector.instance.deleteDemoProcess(
  id: id,
).ref();
ref.execute();
```

