import 'dart:convert';
/// _id : "6943d423905d10bd4b078aaf"
/// userId : {"_id":"6943d3e9905d10bd4b078aad","name":"Nguyễn Văn Tefo","email":"nguyenvanteo@example.com","phone":"0123457798","magicPoints":4000,"rewardPoints":1500,"zodiacSign":"Bò cạp","avatarPath":"fdafdfdafs df a","age":25,"createdAt":"2025-12-18T10:14:01.270Z","updatedAt":"2025-12-18T10:14:01.270Z","__v":0}
/// createdAt : "2025-12-18T10:14:59.953Z"
/// updatedAt : "2025-12-18T10:14:59.953Z"

CartEntity cartEntityFromJson(String str) => CartEntity.fromJson(json.decode(str));
String cartEntityToJson(CartEntity data) => json.encode(data.toJson());
class CartEntity {
  CartEntity({
      String? id, 
      UserId? userId, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _userId = userId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  CartEntity.fromJson(dynamic json) {
    _id = json['_id'];
    _userId = json['userId'] != null ? UserId.fromJson(json['userId']) : null;
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  String? _id;
  UserId? _userId;
  String? _createdAt;
  String? _updatedAt;
CartEntity copyWith({  String? id,
  UserId? userId,
  String? createdAt,
  String? updatedAt,
}) => CartEntity(  id: id ?? _id,
  userId: userId ?? _userId,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  String? get id => _id;
  UserId? get userId => _userId;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    if (_userId != null) {
      map['userId'] = _userId?.toJson();
    }
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }

}

/// _id : "6943d3e9905d10bd4b078aad"
/// name : "Nguyễn Văn Tefo"
/// email : "nguyenvanteo@example.com"
/// phone : "0123457798"
/// magicPoints : 4000
/// rewardPoints : 1500
/// zodiacSign : "Bò cạp"
/// avatarPath : "fdafdfdafs df a"
/// age : 25
/// createdAt : "2025-12-18T10:14:01.270Z"
/// updatedAt : "2025-12-18T10:14:01.270Z"
/// __v : 0

UserId userIdFromJson(String str) => UserId.fromJson(json.decode(str));
String userIdToJson(UserId data) => json.encode(data.toJson());
class UserId {
  UserId({
      String? id, 
      String? name, 
      String? email, 
      String? phone, 
      num? magicPoints, 
      num? rewardPoints, 
      String? zodiacSign, 
      String? avatarPath, 
      num? age, 
      String? createdAt, 
      String? updatedAt, 
      num? v,}){
    _id = id;
    _name = name;
    _email = email;
    _phone = phone;
    _magicPoints = magicPoints;
    _rewardPoints = rewardPoints;
    _zodiacSign = zodiacSign;
    _avatarPath = avatarPath;
    _age = age;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
}

  UserId.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
    _email = json['email'];
    _phone = json['phone'];
    _magicPoints = json['magicPoints'];
    _rewardPoints = json['rewardPoints'];
    _zodiacSign = json['zodiacSign'];
    _avatarPath = json['avatarPath'];
    _age = json['age'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
  }
  String? _id;
  String? _name;
  String? _email;
  String? _phone;
  num? _magicPoints;
  num? _rewardPoints;
  String? _zodiacSign;
  String? _avatarPath;
  num? _age;
  String? _createdAt;
  String? _updatedAt;
  num? _v;
UserId copyWith({  String? id,
  String? name,
  String? email,
  String? phone,
  num? magicPoints,
  num? rewardPoints,
  String? zodiacSign,
  String? avatarPath,
  num? age,
  String? createdAt,
  String? updatedAt,
  num? v,
}) => UserId(  id: id ?? _id,
  name: name ?? _name,
  email: email ?? _email,
  phone: phone ?? _phone,
  magicPoints: magicPoints ?? _magicPoints,
  rewardPoints: rewardPoints ?? _rewardPoints,
  zodiacSign: zodiacSign ?? _zodiacSign,
  avatarPath: avatarPath ?? _avatarPath,
  age: age ?? _age,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  v: v ?? _v,
);
  String? get id => _id;
  String? get name => _name;
  String? get email => _email;
  String? get phone => _phone;
  num? get magicPoints => _magicPoints;
  num? get rewardPoints => _rewardPoints;
  String? get zodiacSign => _zodiacSign;
  String? get avatarPath => _avatarPath;
  num? get age => _age;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    map['email'] = _email;
    map['phone'] = _phone;
    map['magicPoints'] = _magicPoints;
    map['rewardPoints'] = _rewardPoints;
    map['zodiacSign'] = _zodiacSign;
    map['avatarPath'] = _avatarPath;
    map['age'] = _age;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    return map;
  }

}