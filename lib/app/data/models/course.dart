// lib/app/data/models/course.dart
class Course {
  String? id;
  String name;
  String teacher;
  String type;
  int year;
  String semester;
  String courseCode;
  List<String>? prerequisites;
  bool isOpen;

  Course({
    this.id,
    required this.name,
    required this.teacher,
    required this.type,
    required this.year,
    required this.semester,
    required this.courseCode,
    this.prerequisites,
    this.isOpen = false,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['_id'],
      name: json['name'],
      teacher: json['teacher'],
      type: json['type'],
      year: json['year'],
      semester: json['semester'],
      courseCode: json['courseCode'],
      prerequisites: json['prerequisites'] != null
          ? List<String>.from(json['prerequisites'])
          : [],
      isOpen: json['isOpen'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'teacher': teacher,
      'type': type,
      'year': year,
      'semester': semester,
      'courseCode': courseCode,
      'prerequisites': prerequisites,
      'isOpen': isOpen,
    };
  }
}