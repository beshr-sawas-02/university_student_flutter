// lib/app/modules/auth/controllers/auth_controller.dart (updated version)
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
   Rx<int> selectedYear = 1.obs; // default year

  @override
  void onInit() {
    super.onInit();
    // We'll use onReady instead of onInit for navigation
    ever(currentStudent, (_) => _checkUser());
    _initializeUser();
  }

  @override
  void onReady() {
    super.onReady();
    // Check login status in onReady which is called after the widget is built
    if (_storageProvider.isLoggedIn() && currentStudent.value != null) {
      Future.delayed(Duration(milliseconds: 100), () {
        Get.offAllNamed(Routes.DASHBOARD);
      });
    }
  }

  @override
  void onClose() {
    // universityIdController.dispose();
    // passwordController.dispose();
    nameController.dispose();
    majorController.dispose();
    super.onClose();
  }

  void _initializeUser() {
    if (_storageProvider.isLoggedIn()) {
      currentStudent.value = _storageProvider.getUser();
    }
  }

  void _checkUser() {
    if (currentStudent.value != null) {
      // User data is available, but we'll navigate in onReady
    }
  }

  Future<void> login() async {
    isLoading.value = true;

    try {
      final universityId = universityIdController.text;
      if (universityId == null) {
        Get.snackbar(
          'Error',
          'Please enter a valid university ID',
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
        currentStudent.value = _storageProvider.getUser();
        Get.offAllNamed(Routes.DASHBOARD);
      } else {
        Get.snackbar(
          'Login Failed',
          'Please check your credentials and try again',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred during login',
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

      if (name.isEmpty || major.isEmpty  || universityId.isEmpty || password.isEmpty) {
        Get.snackbar(
          'Error',
          'Please fill all the fields',
          snackPosition: SnackPosition.BOTTOM,
        );
        isLoading.value = false;
        return;
      }

      final success = await _authRepository.register(
        name: nameController.text,
        major: majorController.text,
        year: selectedYear.value,
        universityId: universityIdController.text,
        password: passwordController.text,
      );

      if (success) {
        Get.snackbar(
          'Success',
          'Account created successfully! Please login.',
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offAllNamed(Routes.LOGIN);
      } else {
        Get.snackbar(
          'Registration Failed',
          'Please check your inputs and try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred during registration',
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
        'Error',
        'An error occurred during logout',
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
        'Error',
        'Failed to load profile',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Helper for GPA API calls
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
