// dio_service.dart
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart'
    as Getx;

import '../env.dart';
import '../configs/interfaces/http_interface.dart'; // chứa IHttpClient và ApiMethod

class DioService extends Getx.GetxService implements IHttpClient {
  late final Dio _dio;

  // Khởi tạo Dio (gọi 1 lần khi app start)
  Future<DioService> init() async {
    _dio = Dio();
    _dio.options.baseUrl = Env().apiUrl; // Luôn set baseUrl ngay từ đầu
    print("base URL: ${_dio.options.baseUrl}");
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);

    return this;
  }

  @override
  Future<dynamic> request(
    ApiMethod method,
    String url, [
    dynamic data,
    Map<String, String>? headers,
  ]) async {
    // Tự động thêm baseUrl nếu url không có http/https
    final String fullUrl = url.startsWith('http') ? url : Env().apiUrl + url;

    try {
      final Response response = await _dio.request(
        fullUrl,
        data: data,
        options: Options(
          method: method.name.toUpperCase(), // GET, POST, PUT, DELETE
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            ...?headers,
          },
        ),
      );

      // LOG THÀNH CÔNG – dễ đọc
      if (kDebugMode) {
        developer.log(
          '''
          🟢🟢🟢 API RESPONSE SUCCESS 🟢🟢🟢
          ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
          🌐 URL     : $fullUrl
          📌 Method  : ${method.name.toUpperCase()}
          📟 Status  : ${response.statusCode} ${response.statusMessage}
          📦 Data    : ${response.data ?? 'No data'}
          ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
          ''',
          name: 'DioService',
        );
      }

      return response.data; // Trả về thẳng data (Map, List, String...)
    } on DioException catch (e) {
      // LOG LỖI CHI TIẾT
      final String errorMessage =
          e.response?.data?.toString() ?? e.message ?? e.error.toString();

      if (kDebugMode) {
        developer.log(
          '''
          🔴🔴🔴 API RESPONSE ERROR 🔴🔴🔴
          ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
          🌐 URL     : $fullUrl
          📌 Method  : ${method.name.toUpperCase()}
          📟 Status  : ${e.response?.statusCode}
          💬 Message : ${errorMessage ?? 'Unknown error'}
          ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
          ''',
          name: 'DioService',
          error: e,
          stackTrace: e.stackTrace,
        );
      }

      // Ném lỗi để nơi gọi có thể bắt (try-catch)
      throw Exception('API thất bại: $errorMessage');
    } catch (e) {
      if (kDebugMode) {
        developer.log('Lỗi không xác định: $e', name: 'DioService', error: e);
      }
      throw Exception('Lỗi không xác định: $e');
    }
  }
}
