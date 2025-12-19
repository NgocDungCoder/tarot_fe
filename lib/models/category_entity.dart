import 'dart:convert';
/// name : "Cầu"
/// thumbnail : "https://abcde.jpg"
/// _id : "69451570fad3a6a150003778"
/// createdAt : "2025-12-19T09:05:52.433Z"
/// updatedAt : "2025-12-19T09:05:52.433Z"

CategoryEntity categoryEntityFromJson(String str) => CategoryEntity.fromJson(json.decode(str));
String categoryEntityToJson(CategoryEntity data) => json.encode(data.toJson());
class CategoryEntity {
  CategoryEntity({
      String? name, 
      String? thumbnail, 
      String? id, 
      String? createdAt, 
      String? updatedAt,}){
    _name = name;
    _thumbnail = thumbnail;
    _id = id;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  CategoryEntity.fromJson(dynamic json) {
    _name = json['name'];
    _thumbnail = json['thumbnail'];
    _id = json['_id'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  String? _name;
  String? _thumbnail;
  String? _id;
  String? _createdAt;
  String? _updatedAt;
CategoryEntity copyWith({  String? name,
  String? thumbnail,
  String? id,
  String? createdAt,
  String? updatedAt,
}) => CategoryEntity(  name: name ?? _name,
  thumbnail: thumbnail ?? _thumbnail,
  id: id ?? _id,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  String? get name => _name;
  String? get thumbnail => _thumbnail;
  String? get id => _id;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['thumbnail'] = _thumbnail;
    map['_id'] = _id;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }

}