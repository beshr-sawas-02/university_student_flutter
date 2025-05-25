// lib/app/data/providers/api_provider.dart
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import '../providers/storage_provider.dart';
import '../../utils/constants.dart';

class ApiProvider extends GetxService {
  late final dio.Dio _dio;
  final StorageProvider _storageProvider = Get.find<StorageProvider>();

  ApiProvider() {
    _dio = dio.Dio(
      dio.BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: Duration(seconds: 5),
        receiveTimeout: Duration(seconds: 5),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      dio.InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _storageProvider.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (dio.DioException error, handler) {
          // Handle authentication errors
          if (error.response?.statusCode == 401) {
            _storageProvider.removeToken();
            Get.offAllNamed('/login');
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<dio.Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } on dio.DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<dio.Response> post(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response;
    } on dio.DioException catch (e) {
      print(e);
      return _handleError(e);
    }
  }

  Future<dio.Response> patch(String path, {dynamic data}) async {
    try {
      final response = await _dio.patch(path, data: data);
      return response;
    } on dio.DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<dio.Response> delete(String path) async {
    try {
      final response = await _dio.delete(path);
      return response;
    } on dio.DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<dio.Response> _handleError(dio.DioException error) async {
    String errorMessage = 'An error occurred';

    if (error.response != null) {
      final message = error.response?.data['message'];
      if (message is List) {
        errorMessage = message.join('\n');
      } else if (message is String) {
        errorMessage = message;
      }
    } else if (error.type == dio.DioExceptionType.connectionTimeout) {
      errorMessage = 'Connection timeout';
    } else if (error.type == dio.DioExceptionType.receiveTimeout) {
      errorMessage = 'Receive timeout';
    } else if (error.type == dio.DioExceptionType.sendTimeout) {
      errorMessage = 'Send timeout';
    } else if (error.type == dio.DioExceptionType.unknown) {
      errorMessage = 'No internet connection';
    }

    Get.snackbar(
      'Error',
      errorMessage,
      snackPosition: SnackPosition.BOTTOM,
    );

    return dio.Response(
      statusCode: error.response?.statusCode ?? 400,
      requestOptions: error.requestOptions,
      data: {'message': errorMessage},
    );
  }
}
