// lib/app/utils/constants.dart
class ApiConstants {
  static const String baseUrl = 'https://student-vote-backend.vercel.app'; // Use localhost for Android emulator
  // static const String baseUrl = 'http://localhost:3000'; // Use this for iOS simulator

  // Auth endpoints
  static const String login = '/auth/loginStudent';
  static const String register = '/auth/registerStudent';

  // Student endpoints
  static const String student = '/student';
  static const String studentProfile = '$student/profile';
  static const String semesterGPA = '$student/:id/gpa/semester';
  static const String cumulativeGPA = '$student/:id/gpa/cumulative';

  // Course endpoints
  static const String course = '/course';
  static const String allCourses = '$course/find-all-course';
  static const String courseById = '$course/find-one';
  static const String openCourses = '$course/open-course';

  // Mark endpoints
  static const String mark = '/mark';
  static const String myMarks = '$mark/get-my-marks';
  static const String allMarks = '$mark/get-all-marks';

  // Vote endpoints
  static const String vote = '/votes';
  static const String createVote = '$vote/create-vote';
  static const String myVotes = '$vote/find-my-voted';
  static const String updateVote = '$vote/update';
}

class AppConstants {
  // Year Values based on the enum in the backend
  static const int FIRST_YEAR = 1;
  static const int SECOND_YEAR = 2;
  static const int THIRD_YEAR = 3;
  static const int FOURTH_YEAR = 4;
  static const int FIFTH_YEAR = 5;
  static const int GRADUATES = 6;
  static const int GRADUATED = 7;

  // Mark Types
  static const String NORMAL = 'normal';
  static const String DEPRIVED = 'deprived';
  static const String WITHDRAW = 'with_draw';
  static const String PATCHY = 'patchy';
}