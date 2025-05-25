// lib/app/utils/helpers.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'theme.dart';

class AppHelpers {
  static void showSnackBar({
    required String title,
    required String message,
    SnackPosition position = SnackPosition.BOTTOM,
    bool isError = false,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: position,
      backgroundColor: isError ? Colors.red.shade700 : AppTheme.secondaryColor,
      colorText: Colors.white,
      borderRadius: 10,
      margin: EdgeInsets.all(10),
      duration: Duration(seconds: 3),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
    );
  }

  static void showErrorSnackBar({required String message}) {
    showSnackBar(
      title: 'Error',
      message: message,
      isError: true,
    );
  }

  static void showSuccessSnackBar({required String message}) {
    showSnackBar(
      title: 'Success',
      message: message,
      isError: false,
    );
  }

  static Future<bool?> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = 'CONFIRM',
    String cancelText = 'CANCEL',
    bool isDestructive = false,
  }) async {
    return await Get.dialog<bool>(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isDestructive ? Colors.red : AppTheme.secondaryColor,
            ),
            onPressed: () => Get.back(result: true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  static Future<void> showLoadingDialog() async {
    await Get.dialog(
      Center(
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(
              color: AppTheme.secondaryColor,
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void hideLoadingDialog() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  static String formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  static String getYearText(int year) {
    switch (year) {
      case 1:
        return 'First Year';
      case 2:
        return 'Second Year';
      case 3:
        return 'Third Year';
      case 4:
        return 'Fourth Year';
      case 5:
        return 'Fifth Year';
      case 6:
        return 'Of Graduates';
      case 7:
        return 'Graduated';
      default:
        return 'Unknown';
    }
  }

  static Color getGradeColor(double mark) {
    if (mark >= 85) return Colors.green;
    else if (mark >= 70) return Colors.blue;
    else if (mark >= 50) return Colors.orange;
    else return Colors.red;
  }

  static String getLetterGrade(double mark) {
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

  static double getGpaValue(double mark) {
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

  static String getMarkStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'normal':
        return 'Normal';
      case 'deprived':
        return 'Deprived';
      case 'with_draw':
        return 'Withdrawn';
      case 'patchy':
        return 'Incomplete';
      default:
        return 'Unknown';
    }
  }

  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
}