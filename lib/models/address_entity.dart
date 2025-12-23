import 'dart:convert';
/// _id : "694a6e3e0e269d9ee941de7b"
/// userId : {"_id":"6943d3e9905d10bd4b078aad","name":"Nguyễn Văn Tèo","email":"nguyenvanteo@example.com","phone":"0123457798","magicPoints":4000,"rewardPoints":1500,"zodiacSign":"Bò cạp","avatarPath":"https://drive.usercontent.google.com/download?id=1Jxr8LkWl0jOUNxYskF_JsOYdNVDtUKWu&export=view&authuser=0","age":25,"createdAt":"2025-12-18T10:14:01.270Z","updatedAt":"2025-12-18T10:14:01.270Z"}
/// fullName : "Nguyễn Văn Tèo add"
/// phone : "0123456789"
/// province : "Thành phố Hồ Chí Minh"
/// district : "Quận 12"
/// ward : "Thạnh Lộc"
/// detail : "123/456 Đường ABC"
/// isDefault : true
/// createdAt : "2025-12-23T10:26:06.158Z"
/// updatedAt : "2025-12-23T10:26:06.158Z"

AddressEntity addressEntityFromJson(String str) => AddressEntity.fromJson(json.decode(str));
String addressEntityToJson(AddressEntity data) => json.encode(data.toJson());
class AddressEntity {
  AddressEntity({
      String? id, 
      UserId? userId, 
      String? fullName, 
      String? phone, 
      String? province, 
      String? district, 
      String? ward, 
      String? detail, 
      bool? isDefault, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _userId = userId;
    _fullName = fullName;
    _phone = phone;
    _province = province;
    _district = district;
    _ward = ward;
    _detail = detail;
    _isDefault = isDefault;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  AddressEntity.fromJson(dynamic json) {
    _id = json['_id'];
    _userId = json['userId'] != null ? UserId.fromJson(json['userId']) : null;
    _fullName = json['fullName'];
    _phone = json['phone'];
    _province = json['province'];
    _district = json['district'];
    _ward = json['ward'];
    _detail = json['detail'];
    _isDefault = json['isDefault'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  String? _id;
  UserId? _userId;
  String? _fullName;
  String? _phone;
  String? _province;
  String? _district;
  String? _ward;
  String? _detail;
  bool? _isDefault;
  String? _createdAt;
  String? _updatedAt;
AddressEntity copyWith({  String? id,
  UserId? userId,
  String? fullName,
  String? phone,
  String? province,
  String? district,
  String? ward,
  String? detail,
  bool? isDefault,
  String? createdAt,
  String? updatedAt,
}) => AddressEntity(  id: id ?? _id,
  userId: userId ?? _userId,
  fullName: fullName ?? _fullName,
  phone: phone ?? _phone,
  province: province ?? _province,
  district: district ?? _district,
  ward: ward ?? _ward,
  detail: detail ?? _detail,
  isDefault: isDefault ?? _isDefault,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  String? get id => _id;
  UserId? get userId => _userId;
  String? get fullName => _fullName;
  String? get phone => _phone;
  String? get province => _province;
  String? get district => _district;
  String? get ward => _ward;
  String? get detail => _detail;
  bool? get isDefault => _isDefault;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    if (_userId != null) {
      map['userId'] = _userId?.toJson();
    }
    map['fullName'] = _fullName;
    map['phone'] = _phone;
    map['province'] = _province;
    map['district'] = _district;
    map['ward'] = _ward;
    map['detail'] = _detail;
    map['isDefault'] = _isDefault;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }

}

/// _id : "6943d3e9905d10bd4b078aad"
/// name : "Nguyễn Văn Tèo"
/// email : "nguyenvanteo@example.com"
/// phone : "0123457798"
/// magicPoints : 4000
/// rewardPoints : 1500
/// zodiacSign : "Bò cạp"
/// avatarPath : "https://drive.usercontent.google.com/download?id=1Jxr8LkWl0jOUNxYskF_JsOYdNVDtUKWu&export=view&authuser=0"
/// age : 25
/// createdAt : "2025-12-18T10:14:01.270Z"
/// updatedAt : "2025-12-18T10:14:01.270Z"

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
      String? updatedAt,}){
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
    return map;
  }

}