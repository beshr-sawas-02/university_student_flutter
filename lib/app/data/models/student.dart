// lib/app/data/models/student.dart
import 'package:get/get.dart';

class Student {
  String? id;
  String name;
  String major;
  int year;
  int universityId;

  Student({
    this.id,
    required this.name,
    required this.major,
    required this.year,
    required this.universityId,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    print(json);
    return Student(
      id: json['_id'],
      name: json['name'],
      major: json['major'],
      year: json['year'],
      universityId: json['universityId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'major': major,
      'year': year,
      'universityId': universityId,
    };
  }
}