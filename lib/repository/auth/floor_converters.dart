import 'package:floor/floor.dart';
import 'package:ubook_app/model/auth/user_model.dart';
import 'package:ubook_app/model/notification/notification_model.dart';
import 'package:ubook_app/model/process/process_model.dart';

class AuthProviderConverter extends TypeConverter<AuthProvider, String> {
  @override
  AuthProvider decode(String databaseValue) {
    return AuthProvider.values.firstWhere(
      (e) => e.toString() == 'AuthProvider.$databaseValue',
      orElse: () => AuthProvider.email,
    );
  }

  @override
  String encode(AuthProvider value) {
    return value.toString().split('.').last;
  }
}

class StringListConverter extends TypeConverter<List<String>, String> {
  @override
  List<String> decode(String databaseValue) {
    return databaseValue.split(',').where((e) => e.isNotEmpty).toList();
  }

  @override
  String encode(List<String> value) {
    return value.join(',');
  }
}

class NotificationDateTimeConverter extends TypeConverter<DateTime, int> {
  @override
  DateTime decode(int databaseValue) {
    return DateTime.fromMillisecondsSinceEpoch(databaseValue);
  }

  @override
  int encode(DateTime value) {
    return value.millisecondsSinceEpoch;
  }
}

class NullableDateTimeConverter extends TypeConverter<DateTime?, int?> {
  @override
  DateTime? decode(int? databaseValue) {
    return databaseValue == null ? null : DateTime.fromMillisecondsSinceEpoch(databaseValue);
  }

  @override
  int? encode(DateTime? value) {
    return value?.millisecondsSinceEpoch;
  }
}

class NotificationTypeConverter extends TypeConverter<NotificationType, String> {
  @override
  NotificationType decode(String databaseValue) {
    return NotificationType.values.firstWhere(
      (e) => e.toString() == 'NotificationType.$databaseValue',
      orElse: () => NotificationType.general,
    );
  }

  @override
  String encode(NotificationType value) {
    return value.toString().split('.').last;
  }
}

class NotificationStatusConverter extends TypeConverter<NotificationStatus, String> {
  @override
  NotificationStatus decode(String databaseValue) {
    return NotificationStatus.values.firstWhere(
      (e) => e.toString() == 'NotificationStatus.$databaseValue',
      orElse: () => NotificationStatus.unread,
    );
  }

  @override
  String encode(NotificationStatus value) {
    return value.toString().split('.').last;
  }
}
