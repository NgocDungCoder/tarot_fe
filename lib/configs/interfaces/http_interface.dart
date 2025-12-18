enum ApiMethod { get, post, put, delete }

abstract class IHttpClient {
  Future<dynamic> request(ApiMethod method, String url,
      [dynamic data, Map<String, String>? headers]);
}
