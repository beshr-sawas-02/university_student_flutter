// lib/app/bindings/auth_binding.dart
import 'package:get/get.dart';
import '../data/providers/api_provider.dart';
import '../data/repositories/auth_repository.dart';
import '../modules/auth/controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiProvider>(() => ApiProvider(), fenix: true);
    Get.lazyPut<AuthRepository>(() => AuthRepository(), fenix: true);
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
  }
}