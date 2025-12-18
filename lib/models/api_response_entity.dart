import 'dart:convert';

ApiResponseEntity<T> apiResponseEntityFromJson<T>(
    String str,
    T Function(dynamic json) fromJsonT,
    ) =>
    ApiResponseEntity<T>.fromJson(
      json.decode(str),
      fromJsonT,
    );

String apiResponseEntityToJson<T>(
    ApiResponseEntity<T> data, {
      Map<String, dynamic> Function(T data)? toJsonT,
    }) =>
    json.encode(data.toJson(toJsonT: toJsonT));

class ApiResponseEntity<T> {
  final bool success;
  final T? data;
  final String message;
  final String? errorCode;

  const ApiResponseEntity({
    required this.success,
    this.data,
    this.message = '',
    this.errorCode,
  });

  factory ApiResponseEntity.fromJson(
      dynamic json,
      T Function(dynamic json) fromJsonT,
      ) {
    return ApiResponseEntity<T>(
      success: json['success'] ?? false,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      message: _parseMessage(json['message']),
      errorCode: json['errorCode'],
    );
  }

  ApiResponseEntity<T> copyWith({
    bool? success,
    T? data,
    String? message,
    String? errorCode,
  }) {
    return ApiResponseEntity<T>(
      success: success ?? this.success,
      data: data ?? this.data,
      message: message ?? this.message,
      errorCode: errorCode ?? this.errorCode,
    );
  }

  Map<String, dynamic> toJson({
    Map<String, dynamic> Function(T data)? toJsonT,
  }) {
    return {
      'success': success,
      'message': message,
      if (errorCode != null) 'errorCode': errorCode,
      'data': data != null
          ? (toJsonT != null ? toJsonT(data as T) : data)
          : null,
    };
  }

  /// Xử lý message có thể là String | List | null | dynamic
  static String _parseMessage(dynamic value) {
    if (value == null) return '';

    if (value is List) {
      return value.map((e) => e.toString()).join(', ');
    }

    if (value is String) {
      var msg = value.trim();
      if (msg.startsWith('[') && msg.endsWith(']')) {
        msg = msg.substring(1, msg.length - 1);
      }
      return msg;
    }

    return value.toString();
  }
}
