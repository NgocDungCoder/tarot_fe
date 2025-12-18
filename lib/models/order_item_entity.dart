import 'dart:convert';
/// _id : "69438476ebd85befd717c02d"
/// orderId : "69438001b52dc7716317cd41"
/// productId : {"_id":"693bbd929a1689500d81194d","categoryId":"507f1f77bcf86cd799439011","name":"Áo thun nam cổ tròn","description":"Áo thun nam chất liệu cotton 100%, thoáng mát, dễ giặt","thumbnail":"https://example.com/images/product-main.jpg","images":["https://example.com/images/product-1.jpg","https://example.com/images/product-2.jpg"],"price":299000,"originalPrice":399000,"stock":100,"sold":0,"rating":4.5,"createdAt":"2025-12-12T07:00:34.842Z","updatedAt":"2025-12-12T07:00:34.842Z"}
/// quantity : 6
/// price : 900000
/// createdAt : "2025-12-18T04:35:02.646Z"
/// updatedAt : "2025-12-18T04:35:02.646Z"

OrderItemEntity orderItemEntityFromJson(String str) => OrderItemEntity.fromJson(json.decode(str));
String orderItemEntityToJson(OrderItemEntity data) => json.encode(data.toJson());
class OrderItemEntity {
  OrderItemEntity({
      String? id, 
      String? orderId, 
      ProductId? productId, 
      num? quantity, 
      num? price, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _orderId = orderId;
    _productId = productId;
    _quantity = quantity;
    _price = price;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  OrderItemEntity.fromJson(dynamic json) {
    _id = json['_id'];
    _orderId = json['orderId'];
    _productId = json['productId'] != null ? ProductId.fromJson(json['productId']) : null;
    _quantity = json['quantity'];
    _price = json['price'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  String? _id;
  String? _orderId;
  ProductId? _productId;
  num? _quantity;
  num? _price;
  String? _createdAt;
  String? _updatedAt;
OrderItemEntity copyWith({  String? id,
  String? orderId,
  ProductId? productId,
  num? quantity,
  num? price,
  String? createdAt,
  String? updatedAt,
}) => OrderItemEntity(  id: id ?? _id,
  orderId: orderId ?? _orderId,
  productId: productId ?? _productId,
  quantity: quantity ?? _quantity,
  price: price ?? _price,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  String? get id => _id;
  String? get orderId => _orderId;
  ProductId? get productId => _productId;
  num? get quantity => _quantity;
  num? get price => _price;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['orderId'] = _orderId;
    if (_productId != null) {
      map['productId'] = _productId?.toJson();
    }
    map['quantity'] = _quantity;
    map['price'] = _price;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }

}

/// _id : "693bbd929a1689500d81194d"
/// categoryId : "507f1f77bcf86cd799439011"
/// name : "Áo thun nam cổ tròn"
/// description : "Áo thun nam chất liệu cotton 100%, thoáng mát, dễ giặt"
/// thumbnail : "https://example.com/images/product-main.jpg"
/// images : ["https://example.com/images/product-1.jpg","https://example.com/images/product-2.jpg"]
/// price : 299000
/// originalPrice : 399000
/// stock : 100
/// sold : 0
/// rating : 4.5
/// createdAt : "2025-12-12T07:00:34.842Z"
/// updatedAt : "2025-12-12T07:00:34.842Z"

ProductId productIdFromJson(String str) => ProductId.fromJson(json.decode(str));
String productIdToJson(ProductId data) => json.encode(data.toJson());
class ProductId {
  ProductId({
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

  ProductId.fromJson(dynamic json) {
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
ProductId copyWith({  String? id,
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
}) => ProductId(  id: id ?? _id,
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