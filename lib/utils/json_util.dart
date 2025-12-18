import 'dart:convert';

import 'package:flutter/foundation.dart';

Future<T> parseJsonUtil<T>(
    dynamic json,
    T Function(Map<String, Object?>) fromJson,
    ) async {
  if (json == null) {
    return fromJson({});
  }
  final res = await compute(
        (dynamic json) {
      return fromJson(json is String ? jsonDecode(json) : json);
    },
    json,
  );
  return res;
}
