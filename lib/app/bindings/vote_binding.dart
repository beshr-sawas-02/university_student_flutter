// lib/app/bindings/vote_binding.dart
import 'package:get/get.dart';
import '../data/providers/api_provider.dart';
import '../data/repositories/vote_repository.dart';
import '../modules/votes/controllers/vote_controller.dart';

class VoteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiProvider>(() => ApiProvider(), fenix: true);
    Get.lazyPut<VoteRepository>(() => VoteRepository(), fenix: true);
    Get.lazyPut<VoteController>(() => VoteController(), fenix: true);
  }
}