import 'package:floor/floor.dart';

@Entity(tableName: 'subjects')
class SubjectEntity {
  @primaryKey
  final String id;
  final String name;
  final int credits;
  final int hours;
  final String? description;
  
  @ColumnInfo(name: 'is_sync')
  final bool isSync;
  
  @ColumnInfo(name: 'last_update')
  final int lastUpdate;

  SubjectEntity({
    required this.id,
    required this.name,
    required this.credits,
    required this.hours,
    this.description,
    required this.isSync,
    required this.lastUpdate,
  });
}
