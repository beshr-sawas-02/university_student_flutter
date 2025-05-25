// lib/app/data/models/mark.dart
class Mark {
  String? id;
  String courseId;
  String studentId;
  double mark;
  String type;
  Course? course; // For populating course data

  Mark({
    this.id,
    required this.courseId,
    required this.studentId,
    required this.mark,
    required this.type,
    this.course,
  });

  factory Mark.fromJson(Map<String, dynamic> json) {
    return Mark(
      id: json['_id'],
      courseId: json['courseId'],
      studentId: json['studentId'],
      mark: json['mark']?.toDouble() ?? 0.0,
      type: json['type'],
      course: json['course'] != null ? Course.fromJson(json['course']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'courseId': courseId,
      'studentId': studentId,
      'mark': mark,
      'type': type,
    };
  }
}

class Course {
  String id;
  String name;
  String courseCode;

  Course({
    required this.id,
    required this.name,
    required this.courseCode,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['_id'],
      name: json['name'],
      courseCode: json['courseCode'],
    );
  }
}