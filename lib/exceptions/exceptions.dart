

class AppException implements Exception {
  final String? message;

  AppException(this.message);

  @override
  String toString() => message ?? 'App unknown error';
}

class ValidationException extends AppException {
  ValidationException(super.message);
}

class NoNetworkConnectionException implements Exception {
  @override
  String toString() => "No network connection";
}

class UnauthenticatedException implements Exception {
  @override
  String toString() => 'Unauthenticated. Please log in again.';
}

class UnknownException implements Exception {
  final String? message;
  final dynamic error;
  final String? code;

  UnknownException({this.code, this.message, this.error});

  @override
  String toString() {
    if (error is Map) {
      return error['message'] ?? message;
    } else if (error is String) {
      return error;
    } else {
      if (error is Exception) {
        return error.toString();
      }
      if (error is Error) {
        return error.toString();
      }
      if (error is Object) {
        return error.toString();
      }
      return message ??
          'Unknown error ${code?.isNotEmpty ?? false ? '($code)' : ''}';
    }
  }
}
