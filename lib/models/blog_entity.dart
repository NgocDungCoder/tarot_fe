import 'dart:convert';
/// _id : "6948eb11568592414c1717da"
/// authorId : {"_id":"6943d3e9905d10bd4b078aad","name":"Nguyễn Văn Tefo","email":"nguyenvanteo@example.com"}
/// title : "Tarot khởi nguyên của huyền bí"
/// slug : "tarot-ki-nguyen-cua-huyen-bi"
/// excerpt : "Bài viết hướng dẫn chi tiết cách đọc bài Tarot..."
/// content : "<p>Nội dung bài viết...</p>"
/// featuredImage : "https://drive.usercontent.google.com/download?id=1efS5FqUBPLFrqujxWmhMWIuvlKNV4Z_R&export=view&authuser=0"
/// images : ["https://drive.usercontent.google.com/download?id=1efS5FqUBPLFrqujxWmhMWIuvlKNV4Z_R&export=view&authuser=0"]
/// status : "draft"
/// tags : ["tarot","hướng dẫn"]
/// categories : ["tarot","spirituality"]
/// viewCount : 0
/// likeCount : 0
/// isFeatured : true
/// allowComments : true
/// createdAt : "2025-12-22T06:54:09.116Z"
/// updatedAt : "2025-12-22T06:54:09.116Z"

BlogEntity blogEntityFromJson(String str) => BlogEntity.fromJson(json.decode(str));
String blogEntityToJson(BlogEntity data) => json.encode(data.toJson());
class BlogEntity {
  BlogEntity({
      String? id, 
      AuthorId? authorId, 
      String? title, 
      String? slug, 
      String? excerpt, 
      String? content, 
      String? featuredImage, 
      List<String>? images, 
      String? status, 
      List<String>? tags, 
      List<String>? categories, 
      num? viewCount, 
      num? likeCount, 
      bool? isFeatured, 
      bool? allowComments, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _authorId = authorId;
    _title = title;
    _slug = slug;
    _excerpt = excerpt;
    _content = content;
    _featuredImage = featuredImage;
    _images = images;
    _status = status;
    _tags = tags;
    _categories = categories;
    _viewCount = viewCount;
    _likeCount = likeCount;
    _isFeatured = isFeatured;
    _allowComments = allowComments;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  BlogEntity.fromJson(dynamic json) {
    _id = json['_id'];
    _authorId = json['authorId'] != null ? AuthorId.fromJson(json['authorId']) : null;
    _title = json['title'];
    _slug = json['slug'];
    _excerpt = json['excerpt'];
    _content = json['content'];
    _featuredImage = json['featuredImage'];
    _images = json['images'] != null ? json['images'].cast<String>() : [];
    _status = json['status'];
    _tags = json['tags'] != null ? json['tags'].cast<String>() : [];
    _categories = json['categories'] != null ? json['categories'].cast<String>() : [];
    _viewCount = json['viewCount'];
    _likeCount = json['likeCount'];
    _isFeatured = json['isFeatured'];
    _allowComments = json['allowComments'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  String? _id;
  AuthorId? _authorId;
  String? _title;
  String? _slug;
  String? _excerpt;
  String? _content;
  String? _featuredImage;
  List<String>? _images;
  String? _status;
  List<String>? _tags;
  List<String>? _categories;
  num? _viewCount;
  num? _likeCount;
  bool? _isFeatured;
  bool? _allowComments;
  String? _createdAt;
  String? _updatedAt;
BlogEntity copyWith({  String? id,
  AuthorId? authorId,
  String? title,
  String? slug,
  String? excerpt,
  String? content,
  String? featuredImage,
  List<String>? images,
  String? status,
  List<String>? tags,
  List<String>? categories,
  num? viewCount,
  num? likeCount,
  bool? isFeatured,
  bool? allowComments,
  String? createdAt,
  String? updatedAt,
}) => BlogEntity(  id: id ?? _id,
  authorId: authorId ?? _authorId,
  title: title ?? _title,
  slug: slug ?? _slug,
  excerpt: excerpt ?? _excerpt,
  content: content ?? _content,
  featuredImage: featuredImage ?? _featuredImage,
  images: images ?? _images,
  status: status ?? _status,
  tags: tags ?? _tags,
  categories: categories ?? _categories,
  viewCount: viewCount ?? _viewCount,
  likeCount: likeCount ?? _likeCount,
  isFeatured: isFeatured ?? _isFeatured,
  allowComments: allowComments ?? _allowComments,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  String? get id => _id;
  AuthorId? get authorId => _authorId;
  String? get title => _title;
  String? get slug => _slug;
  String? get excerpt => _excerpt;
  String? get content => _content;
  String? get featuredImage => _featuredImage;
  List<String>? get images => _images;
  String? get status => _status;
  List<String>? get tags => _tags;
  List<String>? get categories => _categories;
  num? get viewCount => _viewCount;
  num? get likeCount => _likeCount;
  bool? get isFeatured => _isFeatured;
  bool? get allowComments => _allowComments;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    if (_authorId != null) {
      map['authorId'] = _authorId?.toJson();
    }
    map['title'] = _title;
    map['slug'] = _slug;
    map['excerpt'] = _excerpt;
    map['content'] = _content;
    map['featuredImage'] = _featuredImage;
    map['images'] = _images;
    map['status'] = _status;
    map['tags'] = _tags;
    map['categories'] = _categories;
    map['viewCount'] = _viewCount;
    map['likeCount'] = _likeCount;
    map['isFeatured'] = _isFeatured;
    map['allowComments'] = _allowComments;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }

}

/// _id : "6943d3e9905d10bd4b078aad"
/// name : "Nguyễn Văn Tefo"
/// email : "nguyenvanteo@example.com"

AuthorId authorIdFromJson(String str) => AuthorId.fromJson(json.decode(str));
String authorIdToJson(AuthorId data) => json.encode(data.toJson());
class AuthorId {
  AuthorId({
      String? id, 
      String? name, 
      String? email,}){
    _id = id;
    _name = name;
    _email = email;
}

  AuthorId.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
    _email = json['email'];
  }
  String? _id;
  String? _name;
  String? _email;
AuthorId copyWith({  String? id,
  String? name,
  String? email,
}) => AuthorId(  id: id ?? _id,
  name: name ?? _name,
  email: email ?? _email,
);
  String? get id => _id;
  String? get name => _name;
  String? get email => _email;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    map['email'] = _email;
    return map;
  }

}