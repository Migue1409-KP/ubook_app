import 'package:flutter/foundation.dart';

@immutable
class Career {
  final String id;
  final String name;
  final String educationalCenterId;
  final int semesters;
  final int credits;
  final int? modalityId;
  final String? modalityName;
  final List<String> subjects;
  final List<String> processes;
  final List<String> reviews;

  Career({
    required this.id,
    required this.name,
    required this.educationalCenterId,
    required this.semesters,
    required this.credits,
    this.modalityId,
    this.modalityName,
    List<String>? subjects,
    List<String>? processes,
    List<String>? reviews,
  })  : subjects = subjects ?? [],
        processes = processes ?? [],
        reviews = reviews ?? [];

  factory Career.fromJson(Map<String, dynamic> json) {
    return Career(
      id: json['id'],
      name: json['name'],
      educationalCenterId: json['educationalCenterId'],
      semesters: json['semesters'],
      credits: json['credits'],
      modalityId: json['modalityId'] as int?,
      modalityName: json['modalityName'] as String?,
      subjects: List<String>.from(json['subjects'] ?? []),
      processes: List<String>.from(json['processes'] ?? []),
      reviews: List<String>.from(json['reviews'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "educationalCenterId": educationalCenterId,
      "semesters": semesters,
      "credits": credits,
      "modalityId": modalityId,
      "modalityName": modalityName,
      "subjects": subjects,
      "processes": processes,
      "reviews": reviews,
    };
  }

  Career copyWith({
    String? name,
    String? educationalCenterId,
    int? semesters,
    int? credits,
    int? modalityId,
    String? modalityName,
    List<String>? subjects,
    List<String>? processes,
    List<String>? reviews,
  }) {
    return Career(
      id: id,
      name: name ?? this.name,
      educationalCenterId: educationalCenterId ?? this.educationalCenterId,
      semesters: semesters ?? this.semesters,
      credits: credits ?? this.credits,
      modalityId: modalityId ?? this.modalityId,
      modalityName: modalityName ?? this.modalityName,
      subjects: subjects ?? this.subjects,
      processes: processes ?? this.processes,
      reviews: reviews ?? this.reviews,
    );
  }
}
