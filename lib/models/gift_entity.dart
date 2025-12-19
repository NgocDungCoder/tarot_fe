import 'dart:convert';
/// _id : "6945086c34454170daefade1"
/// categoryId : {"_id":"69451538fad3a6a150003773","name":"Thảm","thumbnail":"https://abcde.jpg","createdAt":"2025-12-19T09:04:56.372Z","updatedAt":"2025-12-19T09:04:56.372Z"}
/// name : "Mũ ảo thuật"
/// description : "Áo thun nam chất liệu cotton 100%, thoáng mát, dễ giặt"
/// thumbnail : "https://drive.usercontent.google.com/download?id=1IEDrwlvP_UTLK9-LRa0ykiBjL8O3rFom&export=view&authuser=0"
/// images : ["https://drive.usercontent.google.com/download?id=1IEDrwlvP_UTLK9-LRa0ykiBjL8O3rFom&export=view&authuser=0","https://drive.usercontent.google.com/download?id=1IEDrwlvP_UTLK9-LRa0ykiBjL8O3rFom&export=view&authuser=0"]
/// price : 30
/// originalPrice : 399000
/// stock : 100
/// createdAt : "2025-12-19T08:10:20.007Z"
/// updatedAt : "2025-12-19T08:10:20.007Z"

GiftEntity giftEntityFromJson(String str) => GiftEntity.fromJson(json.decode(str));
String giftEntityToJson(GiftEntity data) => json.encode(data.toJson());
class GiftEntity {
  GiftEntity({
      String? id, 
      CategoryId? categoryId, 
      String? name, 
      String? description, 
      String? thumbnail, 
      List<String>? images, 
      num? price, 
      num? originalPrice, 
      num? stock, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _categoryId = categoryId;
    _name = name;
    _description = description;
    _thumbnail = thumbnail;
    _images = images;
    _price = price;
    _originalPrice = originalPrice;
    _stock = stock;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  GiftEntity.fromJson(dynamic json) {
    _id = json['_id'];
    _categoryId = json['categoryId'] != null ? CategoryId.fromJson(json['categoryId']) : null;
    _name = json['name'];
    _description = json['description'];
    _thumbnail = json['thumbnail'];
    _images = json['images'] != null ? json['images'].cast<String>() : [];
    _price = json['price'];
    _originalPrice = json['originalPrice'];
    _stock = json['stock'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  String? _id;
  CategoryId? _categoryId;
  String? _name;
  String? _description;
  String? _thumbnail;
  List<String>? _images;
  num? _price;
  num? _originalPrice;
  num? _stock;
  String? _createdAt;
  String? _updatedAt;
GiftEntity copyWith({  String? id,
  CategoryId? categoryId,
  String? name,
  String? description,
  String? thumbnail,
  List<String>? images,
  num? price,
  num? originalPrice,
  num? stock,
  String? createdAt,
  String? updatedAt,
}) => GiftEntity(  id: id ?? _id,
  categoryId: categoryId ?? _categoryId,
  name: name ?? _name,
  description: description ?? _description,
  thumbnail: thumbnail ?? _thumbnail,
  images: images ?? _images,
  price: price ?? _price,
  originalPrice: originalPrice ?? _originalPrice,
  stock: stock ?? _stock,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  String? get id => _id;
  CategoryId? get categoryId => _categoryId;
  String? get name => _name;
  String? get description => _description;
  String? get thumbnail => _thumbnail;
  List<String>? get images => _images;
  num? get price => _price;
  num? get originalPrice => _originalPrice;
  num? get stock => _stock;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    if (_categoryId != null) {
      map['categoryId'] = _categoryId?.toJson();
    }
    map['name'] = _name;
    map['description'] = _description;
    map['thumbnail'] = _thumbnail;
    map['images'] = _images;
    map['price'] = _price;
    map['originalPrice'] = _originalPrice;
    map['stock'] = _stock;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }

}

/// _id : "69451538fad3a6a150003773"
/// name : "Thảm"
/// thumbnail : "https://abcde.jpg"
/// createdAt : "2025-12-19T09:04:56.372Z"
/// updatedAt : "2025-12-19T09:04:56.372Z"

CategoryId categoryIdFromJson(String str) => CategoryId.fromJson(json.decode(str));
String categoryIdToJson(CategoryId data) => json.encode(data.toJson());
class CategoryId {
  CategoryId({
      String? id, 
      String? name, 
      String? thumbnail, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _name = name;
    _thumbnail = thumbnail;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  CategoryId.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
    _thumbnail = json['thumbnail'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  String? _id;
  String? _name;
  String? _thumbnail;
  String? _createdAt;
  String? _updatedAt;
CategoryId copyWith({  String? id,
  String? name,
  String? thumbnail,
  String? createdAt,
  String? updatedAt,
}) => CategoryId(  id: id ?? _id,
  name: name ?? _name,
  thumbnail: thumbnail ?? _thumbnail,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  String? get id => _id;
  String? get name => _name;
  String? get thumbnail => _thumbnail;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    map['thumbnail'] = _thumbnail;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }

}