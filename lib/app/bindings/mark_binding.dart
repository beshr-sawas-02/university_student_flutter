// lib/app/bindings/mark_binding.dart
import 'package:get/get.dart';
import '../data/providers/api_provider.dart';
import '../data/repositories/mark_repository.dart';
import '../modules/marks/controllers/mark_controller.dart';

class MarkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiProvider>(() => ApiProvider(), fenix: true);
    Get.lazyPut<MarkRepository>(() => MarkRepository(), fenix: true);
    Get.lazyPut<MarkController>(() => MarkController(), fenix: true);
  }
}