import 'dart:convert';
/// _id : "69438001b52dc7716317cd41"
/// userId : "694225dc70c8d00c521f6e83"
/// shippingFullName : "Darwinnnnnnnnnnnnnnn"
/// shippingPhone : "0123456789"
/// shippingProvince : "Thành phố Hồ Chí Minh"
/// shippingDistrict : "Quận 12"
/// shippingWard : "Thạnh Lộc"
/// shippingDetail : "123/456 Đường ABC"
/// totalPrice : 1000000
/// shippingFee : 30000
/// discount : 50000
/// finalPrice : 980000
/// paymentStatus : "pending"
/// paymentMethod : "cod"
/// status : "pending"
/// note : "Giao hàng vào buổi sáng"
/// createdAt : "2025-12-18T04:16:01.452Z"
/// updatedAt : "2025-12-18T04:16:01.452Z"

OrderEntity orderEntityFromJson(String str) => OrderEntity.fromJson(json.decode(str));
String orderEntityToJson(OrderEntity data) => json.encode(data.toJson());
class OrderEntity {
  OrderEntity({
      String? id, 
      String? userId, 
      String? shippingFullName, 
      String? shippingPhone, 
      String? shippingProvince, 
      String? shippingDistrict, 
      String? shippingWard, 
      String? shippingDetail, 
      num? totalPrice, 
      num? shippingFee, 
      num? discount, 
      num? finalPrice, 
      String? paymentStatus, 
      String? paymentMethod, 
      String? status, 
      String? note, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _userId = userId;
    _shippingFullName = shippingFullName;
    _shippingPhone = shippingPhone;
    _shippingProvince = shippingProvince;
    _shippingDistrict = shippingDistrict;
    _shippingWard = shippingWard;
    _shippingDetail = shippingDetail;
    _totalPrice = totalPrice;
    _shippingFee = shippingFee;
    _discount = discount;
    _finalPrice = finalPrice;
    _paymentStatus = paymentStatus;
    _paymentMethod = paymentMethod;
    _status = status;
    _note = note;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  OrderEntity.fromJson(dynamic json) {
    _id = json['_id'];
    _userId = json['userId'];
    _shippingFullName = json['shippingFullName'];
    _shippingPhone = json['shippingPhone'];
    _shippingProvince = json['shippingProvince'];
    _shippingDistrict = json['shippingDistrict'];
    _shippingWard = json['shippingWard'];
    _shippingDetail = json['shippingDetail'];
    _totalPrice = json['totalPrice'];
    _shippingFee = json['shippingFee'];
    _discount = json['discount'];
    _finalPrice = json['finalPrice'];
    _paymentStatus = json['paymentStatus'];
    _paymentMethod = json['paymentMethod'];
    _status = json['status'];
    _note = json['note'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  String? _id;
  String? _userId;
  String? _shippingFullName;
  String? _shippingPhone;
  String? _shippingProvince;
  String? _shippingDistrict;
  String? _shippingWard;
  String? _shippingDetail;
  num? _totalPrice;
  num? _shippingFee;
  num? _discount;
  num? _finalPrice;
  String? _paymentStatus;
  String? _paymentMethod;
  String? _status;
  String? _note;
  String? _createdAt;
  String? _updatedAt;
OrderEntity copyWith({  String? id,
  String? userId,
  String? shippingFullName,
  String? shippingPhone,
  String? shippingProvince,
  String? shippingDistrict,
  String? shippingWard,
  String? shippingDetail,
  num? totalPrice,
  num? shippingFee,
  num? discount,
  num? finalPrice,
  String? paymentStatus,
  String? paymentMethod,
  String? status,
  String? note,
  String? createdAt,
  String? updatedAt,
}) => OrderEntity(  id: id ?? _id,
  userId: userId ?? _userId,
  shippingFullName: shippingFullName ?? _shippingFullName,
  shippingPhone: shippingPhone ?? _shippingPhone,
  shippingProvince: shippingProvince ?? _shippingProvince,
  shippingDistrict: shippingDistrict ?? _shippingDistrict,
  shippingWard: shippingWard ?? _shippingWard,
  shippingDetail: shippingDetail ?? _shippingDetail,
  totalPrice: totalPrice ?? _totalPrice,
  shippingFee: shippingFee ?? _shippingFee,
  discount: discount ?? _discount,
  finalPrice: finalPrice ?? _finalPrice,
  paymentStatus: paymentStatus ?? _paymentStatus,
  paymentMethod: paymentMethod ?? _paymentMethod,
  status: status ?? _status,
  note: note ?? _note,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  String? get id => _id;
  String? get userId => _userId;
  String? get shippingFullName => _shippingFullName;
  String? get shippingPhone => _shippingPhone;
  String? get shippingProvince => _shippingProvince;
  String? get shippingDistrict => _shippingDistrict;
  String? get shippingWard => _shippingWard;
  String? get shippingDetail => _shippingDetail;
  num? get totalPrice => _totalPrice;
  num? get shippingFee => _shippingFee;
  num? get discount => _discount;
  num? get finalPrice => _finalPrice;
  String? get paymentStatus => _paymentStatus;
  String? get paymentMethod => _paymentMethod;
  String? get status => _status;
  String? get note => _note;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['userId'] = _userId;
    map['shippingFullName'] = _shippingFullName;
    map['shippingPhone'] = _shippingPhone;
    map['shippingProvince'] = _shippingProvince;
    map['shippingDistrict'] = _shippingDistrict;
    map['shippingWard'] = _shippingWard;
    map['shippingDetail'] = _shippingDetail;
    map['totalPrice'] = _totalPrice;
    map['shippingFee'] = _shippingFee;
    map['discount'] = _discount;
    map['finalPrice'] = _finalPrice;
    map['paymentStatus'] = _paymentStatus;
    map['paymentMethod'] = _paymentMethod;
    map['status'] = _status;
    map['note'] = _note;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }

}