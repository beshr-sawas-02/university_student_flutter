// lib/app/modules/votes/controllers/vote_controller.dart
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
      Get.snackbar(
        'Error',
        'Failed to load votes',
        snackPosition: SnackPosition.BOTTOM,
      );
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
      Get.snackbar(
        'Error',
        'Failed to load available courses',
        snackPosition: SnackPosition.BOTTOM,
      );
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
        Get.snackbar(
          'Maximum Reached',
          'You can only select up to 6 courses',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  Future<bool> submitVote() async {
    if (selectedCourseIds.length < 4) {
      Get.snackbar(
        'Too Few Courses',
        'You must select at least 4 courses',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    isLoading.value = true;

    try {
      bool success;

      if (currentVote.value != null) {
        // Update existing vote
        success = await _voteRepository.updateVote(
          currentVote.value!.id!,
          selectedCourseIds,
        );
      } else {
        // Create new vote
        success = await _voteRepository.createVote(selectedCourseIds);
      }

      if (success) {
        Get.snackbar(
          'Success',
          'Your vote has been submitted',
          snackPosition: SnackPosition.BOTTOM,
        );
        await fetchMyVotes();
      } else {
        Get.snackbar(
          'Error',
          'Failed to submit vote',
          snackPosition: SnackPosition.BOTTOM,
        );
      }

      return success;
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred while submitting your vote',
        snackPosition: SnackPosition.BOTTOM,
      );
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
        Get.snackbar(
          'Success',
          'Your vote has been deleted',
          snackPosition: SnackPosition.BOTTOM,
        );
        await fetchMyVotes();
      } else {
        Get.snackbar(
          'Error',
          'Failed to delete vote',
          snackPosition: SnackPosition.BOTTOM,
        );
      }

      return success;
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred while deleting your vote',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
