import 'package:get/get.dart';
import '../../../data/repositories/vote_repository.dart';
import '../../../data/repositories/course_repository.dart';
import '../../../data/models/vote.dart' as vote_model;
import '../../../data/models/course.dart';
import '../../../data/providers/storage_provider.dart';

class VoteController extends GetxController {
  final VoteRepository _voteRepository = Get.find<VoteRepository>();
  final CourseRepository _courseRepository = Get.find<CourseRepository>();
  final StorageProvider _storageProvider = Get.find<StorageProvider>();

  final RxBool isLoading = false.obs;
  final RxList<vote_model.Vote> myVotes = <vote_model.Vote>[].obs;
  final RxList<Course> availableCourses = <Course>[].obs;
  final RxList<String> selectedCourseIds = <String>[].obs;
  final Rx<vote_model.Vote?> currentVote = Rx<vote_model.Vote?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchMyVotes();
    fetchAvailableCourses();
  }

  Future<void> fetchMyVotes() async {
    isLoading.value = true;

    try {
      final votes = await _voteRepository.getMyVotes();
      myVotes.assignAll(votes);

      if (votes.isNotEmpty) {
        currentVote.value = votes.first;
        selectedCourseIds.assignAll(votes.first.courseIds);
      }
    } catch (e) {
      Get.snackbar('error'.tr, 'failed_load_votes'.tr, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAvailableCourses() async {
    isLoading.value = true;

    try {
      final student = _storageProvider.getUser();
      if (student != null) {
        final courses = await _courseRepository.getOpenCoursesByYear(student.year);
        availableCourses.assignAll(courses);
      }
    } catch (e) {
      Get.snackbar('error'.tr, 'failed_load_available_courses'.tr, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void toggleCourseSelection(String courseId) {
    if (selectedCourseIds.contains(courseId)) {
      selectedCourseIds.remove(courseId);
    } else {
      if (selectedCourseIds.length < 6) {
        selectedCourseIds.add(courseId);
      } else {
        Get.snackbar('max_reached'.tr, 'max_6_courses'.tr, snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  Future<bool> submitVote() async {
    if (selectedCourseIds.length < 4) {
      Get.snackbar('too_few_courses'.tr, 'min_4_courses'.tr, snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    isLoading.value = true;

    try {
      bool success;

      if (currentVote.value != null) {
        success = await _voteRepository.updateVote(currentVote.value!.id!, selectedCourseIds);
      } else {
        success = await _voteRepository.createVote(selectedCourseIds);
      }

      if (success) {
        Get.snackbar('success'.tr, 'vote_submitted'.tr, snackPosition: SnackPosition.BOTTOM);
        await fetchMyVotes();
      } else {
        Get.snackbar('error'.tr, 'failed_submit_vote'.tr, snackPosition: SnackPosition.BOTTOM);
      }

      return success;
    } catch (e) {
      Get.snackbar('error'.tr, 'error_submit_vote'.tr, snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteVote(String id) async {
    isLoading.value = true;

    try {
      final success = await _voteRepository.deleteVote(id);

      if (success) {
        Get.snackbar('success'.tr, 'vote_deleted'.tr, snackPosition: SnackPosition.BOTTOM);
        await fetchMyVotes();
      } else {
        Get.snackbar('error'.tr, 'failed_delete_vote'.tr, snackPosition: SnackPosition.BOTTOM);
      }

      return success;
    } catch (e) {
      Get.snackbar('error'.tr, 'error_delete_vote'.tr, snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
