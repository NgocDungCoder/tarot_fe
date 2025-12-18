import 'dart:convert';

import 'package:tarot_fe/models/product_entity.dart';
/// _id : "69437cc558c4cebc175a4857"
/// cartId : "69437c5f58c4cebc175a4851"
/// productEntity : {"_id":"69412ac47f0d80c1105ad594","categoryId":"507f1f77bcf86cd799439011","name":"Áo hoddie cổ lọ","description":"Áo hoddienam chất liệu cotton 100%, thoáng mát, dễ giặt","thumbnail":"https://drive.usercontent.google.com/download?id=1OKD-sepVLYmb_KPSMESWP1TG_gH_kEbO&export=view&authuser=0","images":["https://drive.usercontent.google.com/download?id=17qoVJVXWz2L0POq4mMyL3bWXiPQV4HuX&export=view&authuser=0","https://drive.usercontent.google.com/download?id=1OKD-sepVLYmb_KPSMESWP1TG_gH_kEbO&export=view&authuser=0"],"price":230000,"originalPrice":299000,"stock":160,"sold":0,"rating":4.9,"createdAt":"2025-12-16T09:47:48.917Z","updatedAt":"2025-12-16T09:47:48.917Z"}
/// quantity : 3
/// price : 300000
/// createdAt : "2025-12-18T04:02:13.117Z"
/// updatedAt : "2025-12-18T04:02:13.117Z"

CartItemEntity cartItemEntityFromJson(String str) => CartItemEntity.fromJson(json.decode(str));
String cartItemEntityToJson(CartItemEntity data) => json.encode(data.toJson());
class CartItemEntity {
  CartItemEntity({
      String? id, 
      String? cartId, 
      ProductEntity? productEntity, 
      num? quantity, 
      num? price, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _cartId = cartId;
    _productEntity = productEntity;
    _quantity = quantity;
    _price = price;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  CartItemEntity.fromJson(dynamic json) {
    _id = json['_id'];
    _cartId = json['cartId'];
    _productEntity = json['productEntity'] != null ? ProductEntity.fromJson(json['productEntity']) : null;
    _quantity = json['quantity'];
    _price = json['price'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  String? _id;
  String? _cartId;
  ProductEntity? _productEntity;
  num? _quantity;
  num? _price;
  String? _createdAt;
  String? _updatedAt;
CartItemEntity copyWith({  String? id,
  String? cartId,
  ProductEntity? productEntity,
  num? quantity,
  num? price,
  String? createdAt,
  String? updatedAt,
}) => CartItemEntity(  id: id ?? _id,
  cartId: cartId ?? _cartId,
  productEntity: productEntity ?? _productEntity,
  quantity: quantity ?? _quantity,
  price: price ?? _price,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  String? get id => _id;
  String? get cartId => _cartId;
  ProductEntity? get productEntity => _productEntity;
  num? get quantity => _quantity;
  num? get price => _price;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['cartId'] = _cartId;
    if (_productEntity != null) {
      map['productEntity'] = _productEntity?.toJson();
    }
    map['quantity'] = _quantity;
    map['price'] = _price;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }

}
