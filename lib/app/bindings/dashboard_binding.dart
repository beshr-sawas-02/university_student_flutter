import 'package:get/get.dart';
import 'package:university_student_application/app/data/repositories/course_repository.dart';
import 'package:university_student_application/app/data/repositories/vote_repository.dart';
import '../data/providers/api_provider.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/mark_repository.dart';
import '../modules/dashboard/controllers/dashboard_controller.dart';
import '../modules/auth/controllers/auth_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiProvider>(() => ApiProvider(), fenix: true);
    Get.lazyPut<AuthRepository>(() => AuthRepository(), fenix: true);
    Get.lazyPut<MarkRepository>(() => MarkRepository(), fenix: true);
    Get.lazyPut<CourseRepository>(() => CourseRepository(), fenix: true);
    Get.lazyPut<VoteRepository>(() => VoteRepository(), fenix: true);
    Get.lazyPut<DashboardController>(() => DashboardController(), fenix: true);

    // Make sure AuthController is available
    if (!Get.isRegistered<AuthController>()) {
      Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    }
  }
}
