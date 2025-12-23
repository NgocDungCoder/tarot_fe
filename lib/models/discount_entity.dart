import 'dart:convert';
/// _id : "694a64d54f65df8029418e3f"
/// code : "SAVE60"
/// description : "Mã giảm giá 20% cho thành viên thân thiết"
/// type : "percent"
/// value : 60
/// minOrderValue : 10
/// maxUsage : 100
/// usedCount : 0
/// active : true
/// startDate : "2024-01-01T00:00:00.000Z"
/// endDate : "2024-12-31T23:59:59.999Z"
/// createdAt : "2025-12-23T09:45:57.247Z"
/// updatedAt : "2025-12-23T09:45:57.247Z"

DiscountEntity discountEntityFromJson(String str) => DiscountEntity.fromJson(json.decode(str));
String discountEntityToJson(DiscountEntity data) => json.encode(data.toJson());
class DiscountEntity {
  DiscountEntity({
      String? id, 
      String? code, 
      String? description, 
      String? type, 
      num? value, 
      num? minOrderValue, 
      num? maxUsage, 
      num? usedCount, 
      bool? active, 
      String? startDate, 
      String? endDate, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _code = code;
    _description = description;
    _type = type;
    _value = value;
    _minOrderValue = minOrderValue;
    _maxUsage = maxUsage;
    _usedCount = usedCount;
    _active = active;
    _startDate = startDate;
    _endDate = endDate;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  DiscountEntity.fromJson(dynamic json) {
    _id = json['_id'];
    _code = json['code'];
    _description = json['description'];
    _type = json['type'];
    _value = json['value'];
    _minOrderValue = json['minOrderValue'];
    _maxUsage = json['maxUsage'];
    _usedCount = json['usedCount'];
    _active = json['active'];
    _startDate = json['startDate'];
    _endDate = json['endDate'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  String? _id;
  String? _code;
  String? _description;
  String? _type;
  num? _value;
  num? _minOrderValue;
  num? _maxUsage;
  num? _usedCount;
  bool? _active;
  String? _startDate;
  String? _endDate;
  String? _createdAt;
  String? _updatedAt;
DiscountEntity copyWith({  String? id,
  String? code,
  String? description,
  String? type,
  num? value,
  num? minOrderValue,
  num? maxUsage,
  num? usedCount,
  bool? active,
  String? startDate,
  String? endDate,
  String? createdAt,
  String? updatedAt,
}) => DiscountEntity(  id: id ?? _id,
  code: code ?? _code,
  description: description ?? _description,
  type: type ?? _type,
  value: value ?? _value,
  minOrderValue: minOrderValue ?? _minOrderValue,
  maxUsage: maxUsage ?? _maxUsage,
  usedCount: usedCount ?? _usedCount,
  active: active ?? _active,
  startDate: startDate ?? _startDate,
  endDate: endDate ?? _endDate,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  String? get id => _id;
  String? get code => _code;
  String? get description => _description;
  String? get type => _type;
  num? get value => _value;
  num? get minOrderValue => _minOrderValue;
  num? get maxUsage => _maxUsage;
  num? get usedCount => _usedCount;
  bool? get active => _active;
  String? get startDate => _startDate;
  String? get endDate => _endDate;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['code'] = _code;
    map['description'] = _description;
    map['type'] = _type;
    map['value'] = _value;
    map['minOrderValue'] = _minOrderValue;
    map['maxUsage'] = _maxUsage;
    map['usedCount'] = _usedCount;
    map['active'] = _active;
    map['startDate'] = _startDate;
    map['endDate'] = _endDate;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }

}