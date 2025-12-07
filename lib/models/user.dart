/// User model để lưu thông tin người dùng
class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final double magicPoints; // Magic Points - điểm ma thuật (người dùng nạp tiền để mua)
  final int rewardPoints; // Reward Points - điểm tích lũy/thưởng
  final String zodiacSign; // Cung hoàng đạo
  final String? avatarPath; // Đường dẫn avatar
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.magicPoints,
    required this.rewardPoints,
    required this.zodiacSign,
    this.avatarPath,
    this.createdAt,
    this.updatedAt,
  });

  /// Create user from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      magicPoints: (json['magicPoints'] as num?)?.toDouble() ?? 0.0,
      rewardPoints: (json['rewardPoints'] as num?)?.toInt() ?? 0,
      zodiacSign: json['zodiacSign']?.toString() ?? '',
      avatarPath: json['avatarPath']?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  /// Convert user to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'magicPoints': magicPoints,
      'rewardPoints': rewardPoints,
      'zodiacSign': zodiacSign,
      'avatarPath': avatarPath,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Create copy with updated fields
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    double? magicPoints,
    int? rewardPoints,
    String? zodiacSign,
    String? avatarPath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      magicPoints: magicPoints ?? this.magicPoints,
      rewardPoints: rewardPoints ?? this.rewardPoints,
      zodiacSign: zodiacSign ?? this.zodiacSign,
      avatarPath: avatarPath ?? this.avatarPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

