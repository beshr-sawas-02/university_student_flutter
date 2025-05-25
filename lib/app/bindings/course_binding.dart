// lib/app/bindings/course_binding.dart
import 'package:get/get.dart';
import '../data/providers/api_provider.dart';
import '../data/repositories/course_repository.dart';
import '../modules/courses/controllers/course_controller.dart';

class CourseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiProvider>(() => ApiProvider(), fenix: true);
    Get.lazyPut<CourseRepository>(() => CourseRepository(), fenix: true);
    Get.lazyPut<CourseController>(() => CourseController(), fenix: true);
  }
}