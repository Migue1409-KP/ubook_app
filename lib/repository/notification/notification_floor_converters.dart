import 'package:floor/floor.dart';

import '../../model/notification/notification_model.dart';

class NotificationTypeConverter
    extends TypeConverter<NotificationType, String> {
  @override
  NotificationType decode(String databaseValue) {
    return NotificationType.values.firstWhere(
      (value) => value.name == databaseValue,
      orElse: () => NotificationType.other,
    );
  }

  @override
  String encode(NotificationType value) {
    return value.name;
  }
}

class NotificationStatusConverter
    extends TypeConverter<NotificationStatus, String> {
  @override
  NotificationStatus decode(String databaseValue) {
    return NotificationStatus.values.firstWhere(
      (value) => value.name == databaseValue,
      orElse: () => NotificationStatus.initial,
    );
  }

  @override
  String encode(NotificationStatus value) {
    return value.name;
  }
}

class DateTimeConverter extends TypeConverter<DateTime, int> {
  @override
  DateTime decode(int databaseValue) {
    return DateTime.fromMillisecondsSinceEpoch(databaseValue);
  }

  @override
  int encode(DateTime value) {
    return value.millisecondsSinceEpoch;
  }
}
