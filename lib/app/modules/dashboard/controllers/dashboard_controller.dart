// lib/app/modules/dashboard/controllers/dashboard_controller.dart
import 'package:get/get.dart';
import '../../../data/providers/storage_provider.dart';
import '../../../data/models/student.dart';
import '../../../data/repositories/mark_repository.dart';
import '../../../data/repositories/auth_repository.dart';

class DashboardController extends GetxController {
  final StorageProvider _storageProvider = Get.find<StorageProvider>();
  final MarkRepository _markRepository = Get.find<MarkRepository>();
  final AuthRepository _authRepository = Get.find<AuthRepository>();

  final RxBool isLoading = false.obs;
  final Rx<Student?> student = Rx<Student?>(null);
  final RxMap<String, dynamic> cumulativeGPA = <String, dynamic>{}.obs;
  final RxInt selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadStudentData();
    fetchCumulativeGPA();
  }

  void loadStudentData() {
    student.value = _storageProvider.getUser();
  }

  Future<void> fetchCumulativeGPA() async {
    isLoading.value = true;

    try {
      final studentId = student.value?.id;
      if (studentId != null) {
        final gpaData = await _authRepository.getCumulativeGPA(studentId);
        if (gpaData != null) {
          cumulativeGPA.value = gpaData;
        }
      }
    } catch (e) {
      print('Error fetching GPA: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  String getYearText(int year) {
    switch (year) {
      case 1:
        return 'first_year'.tr;
      case 2:
        return 'second_year'.tr;
      case 3:
        return 'third_year'.tr;
      case 4:
        return 'fourth_year'.tr;
      case 5:
        return 'fifth_year'.tr;
      default:
        return 'unknown_year'.tr;
    }
  }
}
