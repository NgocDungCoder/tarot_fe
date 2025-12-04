/// Tarot card model
class TarotCard {
  final String id;
  final String name;
  final String nameVi; // Tên tiếng Việt
  final String imagePath; // Đường dẫn hình ảnh lá bài
  final String description; // Mô tả lá bài
  final String meaning; // Ý nghĩa lá bài
  final String reversedMeaning; // Ý nghĩa khi lá bài ngược
  final bool isReversed; // Lá bài có bị ngược không

  const TarotCard({
    required this.id,
    required this.name,
    required this.nameVi,
    required this.imagePath,
    required this.description,
    required this.meaning,
    required this.reversedMeaning,
    this.isReversed = false,
  });

  /// Create TarotCard from JSON
  factory TarotCard.fromJson(Map<String, dynamic> json) {
    return TarotCard(
      id: json['id'] as String,
      name: json['name'] as String,
      nameVi: json['nameVi'] as String,
      imagePath: json['imagePath'] as String,
      description: json['description'] as String,
      meaning: json['meaning'] as String,
      reversedMeaning: json['reversedMeaning'] as String,
      isReversed: json['isReversed'] as bool? ?? false,
    );
  }

  /// Convert TarotCard to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameVi': nameVi,
      'imagePath': imagePath,
      'description': description,
      'meaning': meaning,
      'reversedMeaning': reversedMeaning,
      'isReversed': isReversed,
    };
  }

  /// Copy with method để tạo bản sao với các thay đổi
  TarotCard copyWith({
    String? id,
    String? name,
    String? nameVi,
    String? imagePath,
    String? description,
    String? meaning,
    String? reversedMeaning,
    bool? isReversed,
  }) {
    return TarotCard(
      id: id ?? this.id,
      name: name ?? this.name,
      nameVi: nameVi ?? this.nameVi,
      imagePath: imagePath ?? this.imagePath,
      description: description ?? this.description,
      meaning: meaning ?? this.meaning,
      reversedMeaning: reversedMeaning ?? this.reversedMeaning,
      isReversed: isReversed ?? this.isReversed,
    );
  }
}

