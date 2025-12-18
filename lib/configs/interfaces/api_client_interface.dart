import 'package:flutter/foundation.dart';

import 'http_interface.dart';
import 'storage_interface.dart';

abstract class IApiClient {
  final IHttpClient _api;
  final IStorage _storage;

  IApiClient(this._api, this._storage);

  @protected
  Future<dynamic> request(ApiMethod method, String url,
      [dynamic data, Map<String, String>? headers]) async {
    print("chaạy vo trong interface");
    return _api.request(method, url, data, headers);
  }

}
