class Vote {
  String? id;
  String studentId;
  List<String> courseIds;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Course>? courses; // For populating course data

  Vote({
    this.id,
    required this.studentId,
    required this.courseIds,
    this.createdAt,
    this.updatedAt,
    this.courses,
  });

  factory Vote.fromJson(Map<String, dynamic> json) {
    // Based on the logged data, it seems the vote object doesn't have a courseIds field
    // but has a courseId object instead. We need to handle this.

    List<String> extractedCourseIds = [];

    // Handle the case where there's a courseId object instead of courseIds array
    if (json['courseId'] != null && json['courseId'] is Map<String, dynamic>) {
      extractedCourseIds.add(json['courseId']['_id'].toString());
    }
    // If there's a courseIds array, use it
    else if (json['courseIds'] != null) {
      extractedCourseIds = List<String>.from(json['courseIds']);
    }

    // Handle single course object
    List<Course>? extractedCourses;
    if (json['courseId'] != null && json['courseId'] is Map<String, dynamic>) {
      extractedCourses = [Course.fromJson(json['courseId'])];
    }
    // Handle courses array
    else if (json['courses'] != null) {
      extractedCourses = List<Course>.from(
          json['courses'].map((x) => Course.fromJson(x)));
    }

    return Vote(
      id: json['_id'],
      studentId: json['studentId'],
      courseIds: extractedCourseIds,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      courses: extractedCourses,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'studentId': studentId,
      'courseIds': courseIds,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class Course {
  String id;
  String name;
  String courseCode;
  bool? isOpen;
  int? year;
  String? semester;
  String? teacher;
  String? type;
  int? creditHours;
  bool? isVotingOpen;
  DateTime? votingStart;
  DateTime? votingEnd;

  Course({
    required this.id,
    required this.name,
    required this.courseCode,
    this.isOpen,
    this.year,
    this.semester,
    this.teacher,
    this.type,
    this.creditHours,
    this.isVotingOpen,
    this.votingStart,
    this.votingEnd,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['_id'],
      name: json['name'],
      courseCode: json['courseCode'],
      isOpen: json['isOpen'],
      year: json['year'],
      semester: json['semester'].toString(),
      teacher: json['teacher'],
      type: json['type'],
      creditHours: json['creditHours'],
      isVotingOpen: json['isVotingOpen'],
      votingStart: json['votingStart'] != null ? DateTime.parse(json['votingStart']) : null,
      votingEnd: json['votingEnd'] != null ? DateTime.parse(json['votingEnd']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'courseCode': courseCode,
      'isOpen': isOpen,
      'year': year,
      'semester': semester,
      'teacher': teacher,
      'type': type,
      'creditHours': creditHours,
      'isVotingOpen': isVotingOpen,
      'votingStart': votingStart?.toIso8601String(),
      'votingEnd': votingEnd?.toIso8601String(),
    };
  }
}