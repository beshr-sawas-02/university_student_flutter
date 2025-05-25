// lib/app/modules/marks/controllers/mark_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/mark_repository.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/models/mark.dart';
import '../../../data/providers/storage_provider.dart';

class MarkController extends GetxController {
  final MarkRepository _markRepository = Get.find<MarkRepository>();
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final StorageProvider _storageProvider = Get.find<StorageProvider>();

  final RxBool isLoading = false.obs;
  final RxList<Mark> myMarks = <Mark>[].obs;
  final RxMap<String, dynamic> semesterGPA = <String, dynamic>{}.obs;
  final RxMap<String, dynamic> cumulativeGPA = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyMarks();
  }

  Future<void> fetchMyMarks() async {
    isLoading.value = true;

    try {
      final marks = await _markRepository.getMyMarks();
      myMarks.assignAll(marks);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load marks',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSemesterGPA(int year, int semester) async {
    isLoading.value = true;

    try {
      final student = _storageProvider.getUser();
      if (student != null && student.id != null) {
        final gpaData = await _authRepository.getSemesterGPA(student.id!, year, semester);
        if (gpaData != null) {
          semesterGPA.value = gpaData;
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load semester GPA',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCumulativeGPA() async {
    isLoading.value = true;

    try {
      final student = _storageProvider.getUser();
      if (student != null && student.id != null) {
        final gpaData = await _authRepository.getCumulativeGPA(student.id!);
        if (gpaData != null) {
          cumulativeGPA.value = gpaData;
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load cumulative GPA',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Helper methods for grades
  String getLetterGrade(double mark) {
    return _markRepository.getLetterGradeText(mark);
  }

  Color getGradeColor(double mark) {
    if (mark >= 85) return Colors.green;
    else if (mark >= 70) return Colors.blue;
    else if (mark >= 50) return Colors.orange;
    else return Colors.red;
  }
}