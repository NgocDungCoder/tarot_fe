import 'package:dio/dio.dart';
import 'dio_config.dart';

/// Base API service class
/// 
/// Cung cấp các method chung cho tất cả API services:
/// - GET, POST, PUT, DELETE requests
/// - Error handling
/// - Response parsing
abstract class ApiService {
  // Get Dio instance từ DioConfig
  Dio get dio => DioConfig().dio;

  /// GET request
  /// 
  /// [path] - API endpoint path (relative to base URL)
  /// [queryParameters] - Query parameters
  /// [options] - Additional request options
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// POST request
  /// 
  /// [path] - API endpoint path
  /// [data] - Request body data
  /// [queryParameters] - Query parameters
  /// [options] - Additional request options
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// PUT request
  /// 
  /// [path] - API endpoint path
  /// [data] - Request body data
  /// [queryParameters] - Query parameters
  /// [options] - Additional request options
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// DELETE request
  /// 
  /// [path] - API endpoint path
  /// [data] - Request body data
  /// [queryParameters] - Query parameters
  /// [options] - Additional request options
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Handle Dio error và convert thành custom exception hoặc rethrow
  dynamic _handleDioError(DioException error) {
    // Có thể customize error handling ở đây
    // Ví dụ: throw custom exception, show snackbar, etc.
    
    if (error.response != null) {
      // Server responded with error
      final statusCode = error.response?.statusCode;
      final errorData = error.response?.data;
      
      // Có thể parse error message từ response
      String errorMessage = 'Đã xảy ra lỗi';
      if (errorData is Map<String, dynamic>) {
        errorMessage = errorData['message'] ?? 
                      errorData['error'] ?? 
                      errorMessage;
      }
      
      throw ApiException(
        message: errorMessage,
        statusCode: statusCode,
        data: errorData,
      );
    } else {
      // Network error hoặc timeout
      throw ApiException(
        message: error.message ?? 'Lỗi kết nối mạng',
        statusCode: null,
        data: null,
      );
    }
  }
}

/// Custom API exception class
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() {
    return 'ApiException: $message (Status: $statusCode)';
  }
}

