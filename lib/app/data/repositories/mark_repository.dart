// lib/app/data/repositories/mark_repository.dart
import 'package:get/get.dart';
import '../providers/api_provider.dart';
import '../models/mark.dart';
import '../../utils/constants.dart';

class MarkRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  Future<List<Mark>> getMyMarks() async {
    try {
      final response = await _apiProvider.get(ApiConstants.myMarks);

      if (response.statusCode == 200) {
        final List<dynamic> marksData = response.data;
        return marksData.map((data) => Mark.fromJson(data)).toList();
      }
      return [];
    } catch (e) {
      print('Get my marks error: $e');
      return [];
    }
  }

  Future<List<Mark>> getAllMarks() async {
    try {
      final response = await _apiProvider.get(ApiConstants.allMarks);

      if (response.statusCode == 200) {
        final List<dynamic> marksData = response.data;
        return marksData.map((data) => Mark.fromJson(data)).toList();
      }
      return [];
    } catch (e) {
      print('Get all marks error: $e');
      return [];
    }
  }

  Future<Mark?> getMarkById(String id) async {
    try {
      final response = await _apiProvider.get('${ApiConstants.mark}/find-by-id/$id');

      if (response.statusCode == 200) {
        return Mark.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('Get mark by ID error: $e');
      return null;
    }
  }

  // Calculate GPA helpers
  double calculateLetterGrade(double mark) {
    if (mark >= 95) return 4.0;      // A+
    else if (mark >= 90) return 4.0;  // A
    else if (mark >= 85) return 3.7;  // A-
    else if (mark >= 80) return 3.3;  // B+
    else if (mark >= 75) return 3.0;  // B
    else if (mark >= 70) return 2.7;  // B-
    else if (mark >= 65) return 2.3;  // C+
    else if (mark >= 60) return 2.0;  // C
    else if (mark >= 56) return 1.7;  // C-
    else if (mark >= 53) return 1.3;  // D+
    else if (mark >= 50) return 1.0;  // D
    else return 0.0;                  // F
  }

  String getLetterGradeText(double mark) {
    if (mark >= 95) return 'A+';
    else if (mark >= 90) return 'A';
    else if (mark >= 85) return 'A-';
    else if (mark >= 80) return 'B+';
    else if (mark >= 75) return 'B';
    else if (mark >= 70) return 'B-';
    else if (mark >= 65) return 'C+';
    else if (mark >= 60) return 'C';
    else if (mark >= 56) return 'C-';
    else if (mark >= 53) return 'D+';
    else if (mark >= 50) return 'D';
    else return 'F';
  }
}