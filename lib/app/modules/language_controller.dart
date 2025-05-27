import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController {
  // لغة التطبيق الحالية (مراقبة Rx)
  final Rx<Locale> _locale = const Locale('en').obs;

  // تخزين البيانات المحلي
  final GetStorage _storage = GetStorage();

  // getter للوصول إلى اللغة الحالية
  Locale get locale => _locale.value;

  @override
  void onInit() {
    super.onInit();
    // استرجاع اللغة المخزنة أو تعيين الإنجليزية كافتراضي
    String? langCode = _storage.read('language');
    final initialLocale = Locale(langCode ?? 'en');
    _locale.value = initialLocale;
    // تحديث لغة GetX
    Get.updateLocale(initialLocale);
  }

  // تغيير اللغة مع تخزينها وتحديث واجهة المستخدم
  void changeLanguage(String langCode) {
    final newLocale = Locale(langCode);
    _locale.value = newLocale;
    _storage.write('language', langCode);
    Get.updateLocale(newLocale);
  }

  // تبديل اللغة بين الإنجليزية والعربية
  void toggleLanguage() {
    final newLang = _locale.value.languageCode == 'en' ? 'ar' : 'en';
    changeLanguage(newLang);
  }
}
