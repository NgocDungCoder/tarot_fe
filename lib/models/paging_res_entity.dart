import 'dart:convert';

PagingResEntity<T> pagingResEntityFromJson<T>(
    String str,
    T Function(Map<String, dynamic>) fromJsonT,
    ) =>
    PagingResEntity<T>.fromJson(json.decode(str), fromJsonT);

String pagingResEntityToJson<T>(
    PagingResEntity<T> data,
    Map<String, dynamic> Function(T) toJsonT,
    ) =>
    json.encode(data.toJson(toJsonT));

class PagingResEntity<T> {
  PagingResEntity({
    List<T>? docs,
    num? totalDocs,
    num? limit,
    num? totalPages,
    num? page,
    num? pagingCounter,
    bool? hasPrevPage,
    bool? hasNextPage,
    dynamic prevPage,
    num? nextPage,
  })  : _docs = docs,
        _totalDocs = totalDocs,
        _limit = limit,
        _totalPages = totalPages,
        _page = page,
        _pagingCounter = pagingCounter,
        _hasPrevPage = hasPrevPage,
        _hasNextPage = hasNextPage,
        _prevPage = prevPage,
        _nextPage = nextPage;

  List<T>? _docs;
  num? _totalDocs;
  num? _limit;
  num? _totalPages;
  num? _page;
  num? _pagingCounter;
  bool? _hasPrevPage;
  bool? _hasNextPage;
  dynamic _prevPage;
  num? _nextPage;

  factory PagingResEntity.fromJson(
      Map<String, dynamic> json,
      T Function(Map<String, dynamic>) fromJsonT,
      ) {
    return PagingResEntity<T>(
      docs: json['docs'] != null
          ? List<T>.from(json['docs'].map((x) => fromJsonT(x)))
          : null,
      totalDocs: _parseToNum(json['totalDocs']),
      limit: _parseToNum(json['limit']),
      totalPages: _parseToNum(json['totalPages']),
      page: _parseToNum(json['page']),
      pagingCounter: _parseToNum(json['pagingCounter']),
      hasPrevPage: json['hasPrevPage'],
      hasNextPage: json['hasNextPage'],
      prevPage: json['prevPage'],
      nextPage: _parseToNum(json['nextPage']),
    );
  }

  // Helper method để parse String hoặc num thành num
  static num? _parseToNum(dynamic value) {
    if (value == null) return null;
    if (value is num) return value;
    if (value is String) {
      return num.tryParse(value);
    }
    return null;
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    final map = <String, dynamic>{};
    if (_docs != null) {
      map['docs'] = _docs?.map((x) => toJsonT(x)).toList();
    }
    map['totalDocs'] = _totalDocs;
    map['limit'] = _limit;
    map['totalPages'] = _totalPages;
    map['page'] = _page;
    map['pagingCounter'] = _pagingCounter;
    map['hasPrevPage'] = _hasPrevPage;
    map['hasNextPage'] = _hasNextPage;
    map['prevPage'] = _prevPage;
    map['nextPage'] = _nextPage;
    return map;
  }

  List<T>? get docs => _docs;
  num? get totalDocs => _totalDocs;
  num? get limit => _limit;
  num? get totalPages => _totalPages;
  num? get page => _page;
  num? get pagingCounter => _pagingCounter;
  bool? get hasPrevPage => _hasPrevPage;
  bool? get hasNextPage => _hasNextPage;
  dynamic get prevPage => _prevPage;
  num? get nextPage => _nextPage;

  PagingResEntity<T> copyWith({
    List<T>? docs,
    num? totalDocs,
    num? limit,
    num? totalPages,
    num? page,
    num? pagingCounter,
    bool? hasPrevPage,
    bool? hasNextPage,
    dynamic prevPage,
    num? nextPage,
  }) =>
      PagingResEntity<T>(
        docs: docs ?? _docs,
        totalDocs: totalDocs ?? _totalDocs,
        limit: limit ?? _limit,
        totalPages: totalPages ?? _totalPages,
        page: page ?? _page,
        pagingCounter: pagingCounter ?? _pagingCounter,
        hasPrevPage: hasPrevPage ?? _hasPrevPage,
        hasNextPage: hasNextPage ?? _hasNextPage,
        prevPage: prevPage ?? _prevPage,
        nextPage: nextPage ?? _nextPage,
      );
}
