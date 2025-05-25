// lib/app/data/repositories/auth_repository.dart
import 'package:get/get.dart';
import '../providers/api_provider.dart';
import '../providers/storage_provider.dart';
import '../models/student.dart';
import '../../utils/constants.dart';

class AuthRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();
  final StorageProvider _storageProvider = Get.find<StorageProvider>();

  Future<bool> login(String universityId, String password) async {
    try {
      final response = await _apiProvider.post(
        ApiConstants.login,
        data: {
          'universityId': universityId,
          'password': password,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = response.data['access_token'];
        final userData = response.data['student'];
        await _storageProvider.saveToken(token);
        await _storageProvider.saveUser(Student.fromJson(userData));

        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String major,
    required int year,
    required String universityId,
    required String password,
  }) async {
    try {
      final response = await _apiProvider.post(
        ApiConstants.register,
        data: {
          'name': name,
          'major': major,
          'year': year,
          'universityId': int.parse(universityId),
          'password': password,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      }

      return false;
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }


  Future<void> logout() async {
    await _storageProvider.clearAll();
  }

  Future<Student?> getProfile() async {
    try {
      final studentId = _storageProvider.getUser()?.id;
      if (studentId == null) return null;

      final response = await _apiProvider.get('${ApiConstants.student}/get-ById/$studentId');

      if (response.statusCode == 200) {
        return Student.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('Get profile error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getSemesterGPA(String studentId, int year, int semester) async {
    try {
      final response = await _apiProvider.get(
        '${ApiConstants.student}/$studentId/gpa/semester',
        queryParameters: {
          'year': year,
          'semester': semester,
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    } catch (e) {
      print('Get semester GPA error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getCumulativeGPA(String studentId) async {
    try {
      final response = await _apiProvider.get('${ApiConstants.student}/$studentId/gpa/cumulative');
      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    } catch (e) {

      print('Get cumulative GPA error: $e');
      return null;
    }
  }
}