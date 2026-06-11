import 'package:floor/floor.dart';


@Entity(tableName: 'educational_centers')
class EducationalCenter {


  @PrimaryKey()
  final String id;

  final String name;
  final String? address;
  final String? type;
  final String? website;


  final int createdAt;
  final int updatedAt;

  const EducationalCenter({
    required this.id,
    required this.name,
    this.address,
    this.type,
    this.website,
    required this.createdAt,
    required this.updatedAt,
  });

  EducationalCenter copyWith({
    String? id,
    String? name,
    String? address,
    String? type,
    String? website,
    int? createdAt,
    int? updatedAt,
  }) {
    return EducationalCenter(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      type: type ?? this.type,
      website: website ?? this.website,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }


  @override
  String toString() {
    return 'EducationalCenter(id: $id, name: $name, type: $type)';
  }

  factory EducationalCenter.fromJson(Map<String, dynamic> json) {
    return EducationalCenter(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String?,
      type: json['type'] as String?,
      website: json['website'] as String?,
      createdAt: json['createdAt'] as int,
      updatedAt: json['updatedAt'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'type': type,
      'website': website,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

}