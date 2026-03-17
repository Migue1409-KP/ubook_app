class Career {

  final String id;
  final String name;
  final int semesters;
  final int credits;

  final List<String> subjects;
  final List<String> processes;
  final List<String> reviews;

  Career({
    required this.id,
    required this.name,
    required this.semesters,
    required this.credits,
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
      semesters: json['semesters'],
      credits: json['credits'],
      subjects: List<String>.from(json['subjects'] ?? []),
      processes: List<String>.from(json['processes'] ?? []),
      reviews: List<String>.from(json['reviews'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {

    return {
      "id": id,
      "name": name,
      "semesters": semesters,
      "credits": credits,
      "subjects": subjects,
      "processes": processes,
      "reviews": reviews,
    };
  }

  Career copyWith({
    String? name,
    int? semesters,
    int? credits,
    List<String>? subjects,
    List<String>? processes,
    List<String>? reviews,
  }) {

    return Career(
      id: id,
      name: name ?? this.name,
      semesters: semesters ?? this.semesters,
      credits: credits ?? this.credits,
      subjects: subjects ?? this.subjects,
      processes: processes ?? this.processes,
      reviews: reviews ?? this.reviews,
    );
  }
}