// lib/app/modules/courses/controllers/course_controller.dart
import 'package:get/get.dart';
import '../../../data/repositories/course_repository.dart';
import '../../../data/models/course.dart';
import '../../../data/providers/storage_provider.dart';
import '../../../utils/constants.dart';

class CourseController extends GetxController {
  final CourseRepository _courseRepository = Get.find<CourseRepository>();
  final StorageProvider _storageProvider = Get.find<StorageProvider>();

  final RxBool isLoading = false.obs;
  final RxList<Course> allCourses = <Course>[].obs;
  final RxList<Course> openCourses = <Course>[].obs;
  final Rx<Course?> selectedCourse = Rx<Course?>(null);
  final RxList<Course> prerequisites = <Course>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOpenCourses();
  }

  Future<void> fetchAllCourses() async {
    isLoading.value = true;

    try {
      final courses = await _courseRepository.getAllCourses();
      allCourses.assignAll(courses);
    } catch (e) {
      Get.snackbar(
        'error_title'.tr,
        'load_courses_failed'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchOpenCourses() async {
    isLoading.value = true;

    try {
      final student = _storageProvider.getUser();
      if (student != null) {
        final courses = await _courseRepository.getOpenCoursesByYear(student.year);
        openCourses.assignAll(courses);
      }
    } catch (e) {
      Get.snackbar(
        'error_title'.tr,
        'load_open_courses_failed'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCourseById(String id) async {
    isLoading.value = true;

    try {
      final course = await _courseRepository.getCourseById(id);
      if (course != null) {
        selectedCourse.value = course;

        if (course.prerequisites != null && course.prerequisites!.isNotEmpty) {
          await fetchPrerequisites(course.courseCode);
        } else {
          prerequisites.clear();
        }
      }
    } catch (e) {
      Get.snackbar(
        'error_title'.tr,
        'load_course_details_failed'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPrerequisites(String courseCode) async {
    try {
      final prereqs = await _courseRepository.getPrerequisites(courseCode);
      prerequisites.assignAll(prereqs);
    } catch (e) {
      Get.snackbar(
        'error_title'.tr,
        'load_prerequisites_failed'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  String getYearText(int year) {
    switch (year) {
      case AppConstants.FIRST_YEAR:
        return 'first_year'.tr;
      case AppConstants.SECOND_YEAR:
        return 'second_year'.tr;
      case AppConstants.THIRD_YEAR:
        return 'third_year'.tr;
      case AppConstants.FOURTH_YEAR:
        return 'fourth_year'.tr;
      case AppConstants.FIFTH_YEAR:
        return 'fifth_year'.tr;
      default:
        return 'unknown_year'.tr;
    }
  }
}
