/// Gift model for redeem gift items - quà tặng có thể đổi bằng điểm thưởng
class Gift {
  final String id;
  final String name;
  final String nameVi;
  final String description;
  final int rewardPointsRequired; // Số điểm thưởng cần để đổi
  final String imagePath;
  final String category;
  final bool isAvailable; // Còn hàng hay không

  Gift({
    required this.id,
    required this.name,
    required this.nameVi,
    required this.description,
    required this.rewardPointsRequired,
    required this.imagePath,
    required this.category,
    this.isAvailable = true,
  });

  /// Create gift from JSON
  factory Gift.fromJson(Map<String, dynamic> json) {
    return Gift(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      nameVi: json['nameVi']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      rewardPointsRequired: (json['rewardPointsRequired'] as num?)?.toInt() ?? 0,
      imagePath: json['imagePath']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      isAvailable: json['isAvailable'] as bool? ?? true,
    );
  }

  /// Convert gift to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameVi': nameVi,
      'description': description,
      'rewardPointsRequired': rewardPointsRequired,
      'imagePath': imagePath,
      'category': category,
      'isAvailable': isAvailable,
    };
  }

  /// Create copy with updated fields
  Gift copyWith({
    String? id,
    String? name,
    String? nameVi,
    String? description,
    int? rewardPointsRequired,
    String? imagePath,
    String? category,
    bool? isAvailable,
  }) {
    return Gift(
      id: id ?? this.id,
      name: name ?? this.name,
      nameVi: nameVi ?? this.nameVi,
      description: description ?? this.description,
      rewardPointsRequired: rewardPointsRequired ?? this.rewardPointsRequired,
      imagePath: imagePath ?? this.imagePath,
      category: category ?? this.category,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}

