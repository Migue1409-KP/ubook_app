import 'dart:convert';
import 'package:floor/floor.dart';
import 'career_model.dart';

/// Entidad Floor — solo para persistencia. El resto del app usa Career.
@Entity(tableName: 'careers')
class CareerEntity {
  @primaryKey
  final String id;
  final String name;
  final String educationalCenterId;
  final int semesters;
  final int credits;
  final int? modalityId;
  final String? modalityName;
  final String subjects;   // JSON string
  final String processes;  // JSON string
  final String reviews;    // JSON string

  const CareerEntity({
    required this.id,
    required this.name,
    required this.educationalCenterId,
    required this.semesters,
    required this.credits,
    this.modalityId,
    this.modalityName,
    required this.subjects,
    required this.processes,
    required this.reviews,
  });

  factory CareerEntity.fromCareer(Career career) => CareerEntity(
        id: career.id,
        name: career.name,
        educationalCenterId: career.educationalCenterId,
        semesters: career.semesters,
        credits: career.credits,
        modalityId: career.modalityId,
        modalityName: career.modalityName,
        subjects: jsonEncode(career.subjects),
        processes: jsonEncode(career.processes),
        reviews: jsonEncode(career.reviews),
      );

  Career toCareer() => Career(
        id: id,
        name: name,
        educationalCenterId: educationalCenterId,
        semesters: semesters,
        credits: credits,
        modalityId: modalityId,
        modalityName: modalityName,
        subjects: List<String>.from(jsonDecode(subjects) as List),
        processes: List<String>.from(jsonDecode(processes) as List),
        reviews: List<String>.from(jsonDecode(reviews) as List),
      );
}
