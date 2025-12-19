enum ApiMethod { get, post, put, delete, patch }

abstract class IHttpClient {
  Future<dynamic> request(ApiMethod method, String url,
      [dynamic data, Map<String, String>? headers]);
}
