// lib/app/data/providers/storage_provider.dart
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/student.dart';

class StorageProvider extends GetxService {
  late final GetStorage _box;

  final _tokenKey = 'auth_token';
  final _userKey = 'user_data';

  Future<StorageProvider> init() async {
    _box = GetStorage();
    return this;
  }

  // Token Management
  String? getToken() => _box.read<String>(_tokenKey);

  Future<void> saveToken(String token) async {
    await _box.write(_tokenKey, token);
  }

  Future<void> removeToken() async {
    await _box.remove(_tokenKey);
  }

  // User Data Management
  Student? getUser() {
    final userData = _box.read(_userKey);
    if (userData != null) {
      return Student.fromJson(Map<String, dynamic>.from(userData));
    }
    return null;
  }

  Future<void> saveUser(Student user) async {
    await _box.write(_userKey, user.toJson());
  }

  Future<void> removeUser() async {
    await _box.remove(_userKey);
  }

  // Check if user is logged in
  bool isLoggedIn() {
    final token = getToken();
    return token != null && token.isNotEmpty;
  }

  // Clear all data (for logout)
  Future<void> clearAll() async {
    await _box.erase();
  }
}
