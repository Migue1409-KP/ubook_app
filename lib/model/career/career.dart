class CareerModel {
  final String id;
  final String name;
  final int numberOfSemesters;
  final int numberOfCredits;
  final String educationalCenterId;
  final List<String> processIds;
  final List<String> reviewIds;

  const CareerModel({
    required this.id,
    required this.name,
    required this.numberOfSemesters,
    required this.numberOfCredits,
    required this.educationalCenterId,
    required this.processIds,
    required this.reviewIds,
  });

  factory CareerModel.fromJson(Map<String, dynamic> json) {
    return CareerModel(
      id: json['id'] as String,
      name: json['name'] as String,
      numberOfSemesters: json['numberOfSemesters'] as int,
      numberOfCredits: json['numberOfCredits'] as int,
      educationalCenterId: json['educationalCenterId'] as String,
      processIds: List<String>.from(json['processIds'] ?? []),
      reviewIds: List<String>.from(json['reviewIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'numberOfSemesters': numberOfSemesters,
      'numberOfCredits': numberOfCredits,
      'educationalCenterId': educationalCenterId,
      'processIds': processIds,
      'reviewIds': reviewIds,
    };
  }

  CareerModel copyWith({
    String? id,
    String? name,
    int? numberOfSemesters,
    int? numberOfCredits,
    String? educationalCenterId,
    List<String>? processIds,
    List<String>? reviewIds,
  }) {
    return CareerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      numberOfSemesters:
          numberOfSemesters ?? this.numberOfSemesters,
      numberOfCredits:
          numberOfCredits ?? this.numberOfCredits,
      educationalCenterId:
          educationalCenterId ?? this.educationalCenterId,
      processIds: processIds ?? this.processIds,
      reviewIds: reviewIds ?? this.reviewIds,
    );
  }
}
