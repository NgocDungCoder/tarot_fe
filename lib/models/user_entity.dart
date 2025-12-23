import 'dart:convert';
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

UserEntity userEntityFromJson(String str) => UserEntity.fromJson(json.decode(str));
String userEntityToJson(UserEntity data) => json.encode(data.toJson());
class UserEntity {
  UserEntity({
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

  UserEntity.fromJson(dynamic json) {
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
UserEntity copyWith({  String? id,
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
}) => UserEntity(  id: id ?? _id,
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

  set value(UserEntity value) {}

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