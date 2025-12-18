import 'dart:convert';
/// _id : "6943b800a5036544b046999f"
/// image : "https://drive.usercontent.google.com/download?id=1T_udHG7wG1G1Wh6IZjn02V72LiOQChJU&export=view&authuser=0"
/// title : "hehehe"
/// description : "hehhe"
/// link : "https://drive.usercontent.google.com/download?id=1T_udHG7wG1G1Wh6IZjn02V72LiOQChJU&export=view&authuser=0"
/// order : 1
/// status : "active"
/// createdAt : "2025-12-18T08:14:56.667Z"
/// updatedAt : "2025-12-18T08:14:56.667Z"

BannerEntity bannerEntityFromJson(String str) => BannerEntity.fromJson(json.decode(str));
String bannerEntityToJson(BannerEntity data) => json.encode(data.toJson());
class BannerEntity {
  BannerEntity({
      String? id, 
      String? image, 
      String? title, 
      String? description, 
      String? link, 
      num? order, 
      String? status, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _image = image;
    _title = title;
    _description = description;
    _link = link;
    _order = order;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  BannerEntity.fromJson(dynamic json) {
    _id = json['_id'];
    _image = json['image'];
    _title = json['title'];
    _description = json['description'];
    _link = json['link'];
    _order = json['order'];
    _status = json['status'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  String? _id;
  String? _image;
  String? _title;
  String? _description;
  String? _link;
  num? _order;
  String? _status;
  String? _createdAt;
  String? _updatedAt;
BannerEntity copyWith({  String? id,
  String? image,
  String? title,
  String? description,
  String? link,
  num? order,
  String? status,
  String? createdAt,
  String? updatedAt,
}) => BannerEntity(  id: id ?? _id,
  image: image ?? _image,
  title: title ?? _title,
  description: description ?? _description,
  link: link ?? _link,
  order: order ?? _order,
  status: status ?? _status,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  String? get id => _id;
  String? get image => _image;
  String? get title => _title;
  String? get description => _description;
  String? get link => _link;
  num? get order => _order;
  String? get status => _status;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['image'] = _image;
    map['title'] = _title;
    map['description'] = _description;
    map['link'] = _link;
    map['order'] = _order;
    map['status'] = _status;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }

}