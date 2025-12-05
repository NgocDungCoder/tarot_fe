import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import '../env.dart';

/// Dio configuration class với interceptors cho API calls
/// 
/// Cung cấp Dio instance được cấu hình sẵn với:
/// - Base URL từ environment
/// - Request/Response interceptors
/// - Error handling
/// - Logging
class DioConfig {
  // Singleton instance
  static DioConfig? _instance;
  late Dio _dio;

  // Private constructor
  DioConfig._internal() {
    _dio = Dio(_createBaseOptions());
    _setupInterceptors();
  }

  // Factory constructor
  factory DioConfig() {
    _instance ??= DioConfig._internal();
    return _instance!;
  }

  /// Get Dio instance
  Dio get dio => _dio;

  /// Get base URL phù hợp với platform
  /// - Android emulator: sử dụng 10.0.2.2 thay vì localhost
  /// - iOS simulator: sử dụng localhost
  /// - Web/Desktop: sử dụng localhost
  String _getBaseUrl() {
    final env = Env();
    
    // Nếu đã có API_URL từ environment, sử dụng nó
    if (env.apiUrl.isNotEmpty) {
      return env.apiUrl;
    }
    
    // Tự động detect platform và sử dụng URL phù hợp
    try {
      if (Platform.isAndroid) {
        // Android emulator cần sử dụng 10.0.2.2 để truy cập localhost của máy host
        final baseUrl = 'http://10.0.2.2:3000/api';
        print('📱 [DioConfig] Android detected - Using: $baseUrl');
        return baseUrl;
      } else if (Platform.isIOS) {
        // iOS simulator có thể sử dụng localhost
        final baseUrl = 'http://localhost:3000/api';
        print('🍎 [DioConfig] iOS detected - Using: $baseUrl');
        return baseUrl;
      } else {
        // Web, Desktop, hoặc platform khác
        final baseUrl = 'http://localhost:3000/api';
        print('💻 [DioConfig] Other platform detected - Using: $baseUrl');
        return baseUrl;
      }
    } catch (e) {
      // Fallback nếu không detect được platform
      print('⚠️ [DioConfig] Platform detection failed: $e - Using localhost');
      return 'http://localhost:3000/api';
    }
  }

  /// Create base options cho Dio
  BaseOptions _createBaseOptions() {
    final baseUrl = _getBaseUrl();
    
    print('🌐 [DioConfig] Base URL: $baseUrl');
    
    return BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      // Cho phép follow redirects
      followRedirects: true,
      validateStatus: (status) {
        // Chấp nhận status code từ 200 đến 500
        return status != null && status < 600;
      },
    );
  }

  /// Setup interceptors cho request/response và error handling
  void _setupInterceptors() {
    // Request interceptor - thêm headers, logging
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Log request
          print('🚀 [REQUEST] ${options.method} ${options.uri}');
          if (options.data != null) {
            print('📤 [REQUEST DATA] ${options.data}');
          }
          if (options.queryParameters.isNotEmpty) {
            print('🔍 [QUERY PARAMS] ${options.queryParameters}');
          }

          // Có thể thêm authentication token ở đây
          // final token = AuthService.getToken();
          // if (token != null) {
          //   options.headers['Authorization'] = 'Bearer $token';
          // }

          handler.next(options);
        },
        onResponse: (response, handler) {
          // Log response với thông tin chi tiết
          print('\n═══════════════════════════════════════════════════════════');
          print('✅ [RESPONSE SUCCESS]');
          print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
          print('📍 URL: ${response.requestOptions.method} ${response.requestOptions.uri}');
          print('📊 Status Code: ${response.statusCode}');
          print('⏱️  Response Time: ${DateTime.now()}');
          
          // Log response headers nếu có
          if (response.headers.map.isNotEmpty) {
            print('📋 Headers:');
            response.headers.map.forEach((key, value) {
              print('   $key: ${value.join(", ")}');
            });
          }
          
          // Log response data với format đẹp
          print('📥 Response Data:');
          try {
            if (response.data != null) {
              // Format JSON nếu là Map hoặc List
              if (response.data is Map || response.data is List) {
                // Sử dụng JsonEncoder để format JSON đẹp với indentation
                const encoder = JsonEncoder.withIndent('   ');
                final jsonString = encoder.convert(response.data);
                print(jsonString);
              } else if (response.data is String) {
                // Nếu là string, thử parse JSON trước
                try {
                  final decoded = jsonDecode(response.data as String);
                  const encoder = JsonEncoder.withIndent('   ');
                  print(encoder.convert(decoded));
                } catch (e) {
                  // Nếu không phải JSON string, in trực tiếp
                  print('   ${response.data}');
                }
              } else {
                print('   ${response.data}');
              }
            } else {
              print('   (null)');
            }
          } catch (e) {
            print('   ${response.data}');
          }
          
          // Log response size nếu có
          if (response.data != null) {
            try {
              final dataString = response.data.toString();
              final sizeInBytes = dataString.length;
              final sizeInKB = (sizeInBytes / 1024).toStringAsFixed(2);
              print('💾 Response Size: $sizeInKB KB ($sizeInBytes bytes)');
            } catch (e) {
              // Ignore size calculation errors
            }
          }
          
          print('═══════════════════════════════════════════════════════════\n');

          handler.next(response);
        },
        onError: (error, handler) {
          // Log error
          print('❌ [ERROR] ${error.requestOptions.method} ${error.requestOptions.uri}');
          print('💥 [ERROR MESSAGE] ${error.message}');
          
          if (error.response != null) {
            print('📥 [ERROR RESPONSE] ${error.response?.statusCode}');
            print('📥 [ERROR DATA] ${error.response?.data}');
          }

          // Handle specific error cases
          _handleError(error);

          handler.next(error);
        },
      ),
    );

    // Log interceptor (chỉ trong debug mode)
    if (const bool.fromEnvironment('dart.vm.product') == false) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        requestHeader: true,
        responseHeader: false,
      ));
    }
  }

  /// Handle error cases
  void _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        print('⏱️ Timeout error');
        break;
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 401) {
          print('🔒 Unauthorized - Token may be expired');
          // Có thể trigger logout hoặc refresh token ở đây
        } else if (statusCode == 404) {
          print('🔍 Not found');
        } else if (statusCode == 500) {
          print('🔥 Server error');
        }
        break;
      case DioExceptionType.cancel:
        print('🚫 Request cancelled');
        break;
      case DioExceptionType.unknown:
        print('❓ Unknown error: ${error.message}');
        break;
      default:
        print('⚠️ Other error: ${error.type}');
    }
  }

  /// Update base URL (useful for switching environments)
  void updateBaseUrl(String newBaseUrl) {
    _dio.options.baseUrl = newBaseUrl;
  }

  /// Add authorization token to headers
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Remove authorization token
  void removeAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  /// Clear all interceptors (useful for testing)
  void clearInterceptors() {
    _dio.interceptors.clear();
  }

}

