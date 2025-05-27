import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/providers/storage_provider.dart';
import '../../../data/models/student.dart';
import '../../../routes/app_pages.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final StorageProvider _storageProvider = Get.find<StorageProvider>();

  final RxBool isLoading = false.obs;
  final Rx<Student?> currentStudent = Rx<Student?>(null);

  final TextEditingController universityIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Register-only Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController majorController = TextEditingController();
  Rx<int> selectedYear = 1.obs;

  @override
  void onInit() {
    super.onInit();
    ever(currentStudent, (_) => _checkUser());
    _initializeUser();
  }

  @override
  void onReady() {
    super.onReady();

    // فقط إذا كنا في شاشة تسجيل الدخول نعيد التوجيه إلى لوحة التحكم
    if (Get.currentRoute == Routes.LOGIN) {
      if (_storageProvider.isLoggedIn() && currentStudent.value != null) {
        Future.delayed(Duration(milliseconds: 100), () {
          Get.offAllNamed(Routes.DASHBOARD);
        });
      }
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    majorController.dispose();
    universityIdController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void _initializeUser() {
    if (_storageProvider.isLoggedIn()) {
      currentStudent.value = _storageProvider.getUser();
    }
  }

  void _checkUser() {
    if (currentStudent.value != null) {
      // User data is available
    }
  }

  Future<void> login() async {
    isLoading.value = true;

    try {
      final universityId = universityIdController.text;
      if (universityId.isEmpty) {
        Get.snackbar(
          'error_title'.tr,
          'login_invalid_id'.tr,
          snackPosition: SnackPosition.BOTTOM,
        );
        isLoading.value = false;
        return;
      }

      final success = await _authRepository.login(
        universityId,
        passwordController.text,
      );

      if (success) {
        await getProfile();
        Get.offAllNamed(Routes.DASHBOARD);
      } else {
        Get.snackbar(
          'login_failed_title'.tr,
          'login_failed_message'.tr,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'error_title'.tr,
        'login_error'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    isLoading.value = true;

    try {
      final name = nameController.text.trim();
      final major = majorController.text.trim();
      final year = selectedYear.value;
      final universityId = universityIdController.text.trim();
      final password = passwordController.text.trim();

      if (name.isEmpty || major.isEmpty || universityId.isEmpty || password.isEmpty) {
        Get.snackbar(
          'error_title'.tr,
          'register_fill_fields'.tr,
          snackPosition: SnackPosition.BOTTOM,
        );
        isLoading.value = false;
        return;
      }

      final success = await _authRepository.register(
        name: name,
        major: major,
        year: year,
        universityId: universityId,
        password: password,
      );

      if (success) {
        Get.snackbar(
          'success_title'.tr,
          'register_success_message'.tr,
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offAllNamed(Routes.LOGIN);
      } else {
        Get.snackbar(
          'register_failed_title'.tr,
          'register_failed_message'.tr,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'error_title'.tr,
        'register_error'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    isLoading.value = true;

    try {
      await _authRepository.logout();
      currentStudent.value = null;
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      Get.snackbar(
        'error_title'.tr,
        'logout_error'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getProfile() async {
    isLoading.value = true;

    try {
      final profile = await _authRepository.getProfile();
      if (profile != null) {
        currentStudent.value = profile;
        await _storageProvider.saveUser(profile);
      }
    } catch (e) {
      Get.snackbar(
        'error_title'.tr,
        'profile_load_error'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>?> getSemesterGPA(int year, int semester) async {
    final studentId = currentStudent.value?.id;
    if (studentId == null) return null;
    return await _authRepository.getSemesterGPA(studentId, year, semester);
  }

  Future<Map<String, dynamic>?> getCumulativeGPA() async {
    final studentId = currentStudent.value?.id;
    if (studentId == null) return null;
    return await _authRepository.getCumulativeGPA(studentId);
  }
}
