import 'dart:convert';
/// _id : "69412ac47f0d80c1105ad594"
/// categoryId : "507f1f77bcf86cd799439011"
/// name : "Áo hoddie cổ lọ"
/// description : "Áo hoddienam chất liệu cotton 100%, thoáng mát, dễ giặt"
/// thumbnail : "https://example.com/images/product-main.jpg"
/// images : ["https://example.com/images/product-1.jpg","https://example.com/images/product-2.jpg"]
/// price : 230000
/// originalPrice : 299000
/// stock : 160
/// sold : 0
/// rating : 4.9
/// createdAt : "2025-12-16T09:47:48.917Z"
/// updatedAt : "2025-12-16T09:47:48.917Z"

ProductEntity productEntityFromJson(String str) => ProductEntity.fromJson(json.decode(str));
String productEntityToJson(ProductEntity data) => json.encode(data.toJson());
class ProductEntity {
  ProductEntity({
      String? id, 
      String? categoryId, 
      String? name, 
      String? description, 
      String? thumbnail, 
      List<String>? images, 
      num? price, 
      num? originalPrice, 
      num? stock, 
      num? sold, 
      num? rating, 
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
    _sold = sold;
    _rating = rating;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  ProductEntity.fromJson(dynamic json) {
    _id = json['_id'];
    _categoryId = json['categoryId'];
    _name = json['name'];
    _description = json['description'];
    _thumbnail = json['thumbnail'];
    _images = json['images'] != null ? json['images'].cast<String>() : [];
    _price = json['price'];
    _originalPrice = json['originalPrice'];
    _stock = json['stock'];
    _sold = json['sold'];
    _rating = json['rating'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  String? _id;
  String? _categoryId;
  String? _name;
  String? _description;
  String? _thumbnail;
  List<String>? _images;
  num? _price;
  num? _originalPrice;
  num? _stock;
  num? _sold;
  num? _rating;
  String? _createdAt;
  String? _updatedAt;
ProductEntity copyWith({  String? id,
  String? categoryId,
  String? name,
  String? description,
  String? thumbnail,
  List<String>? images,
  num? price,
  num? originalPrice,
  num? stock,
  num? sold,
  num? rating,
  String? createdAt,
  String? updatedAt,
}) => ProductEntity(  id: id ?? _id,
  categoryId: categoryId ?? _categoryId,
  name: name ?? _name,
  description: description ?? _description,
  thumbnail: thumbnail ?? _thumbnail,
  images: images ?? _images,
  price: price ?? _price,
  originalPrice: originalPrice ?? _originalPrice,
  stock: stock ?? _stock,
  sold: sold ?? _sold,
  rating: rating ?? _rating,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  String? get id => _id;
  String? get categoryId => _categoryId;
  String? get name => _name;
  String? get description => _description;
  String? get thumbnail => _thumbnail;
  List<String>? get images => _images;
  num? get price => _price;
  num? get originalPrice => _originalPrice;
  num? get stock => _stock;
  num? get sold => _sold;
  num? get rating => _rating;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['categoryId'] = _categoryId;
    map['name'] = _name;
    map['description'] = _description;
    map['thumbnail'] = _thumbnail;
    map['images'] = _images;
    map['price'] = _price;
    map['originalPrice'] = _originalPrice;
    map['stock'] = _stock;
    map['sold'] = _sold;
    map['rating'] = _rating;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }

}