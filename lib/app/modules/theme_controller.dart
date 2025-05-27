import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

class ThemeController extends GetxController {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  RxBool _isDarkMode = false.obs;

  bool get isDarkMode => _isDarkMode.value;

  @override
  void onInit() {
    super.onInit();
    _isDarkMode.value = _loadThemeFromStorage();
    // Apply theme on init
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  bool _loadThemeFromStorage() {
    return _box.read(_key) ?? false;
  }

  void _saveThemeToStorage(bool isDarkMode) {
    _box.write(_key, isDarkMode);
  }

  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    _saveThemeToStorage(_isDarkMode.value);
  }
}
