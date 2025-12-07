/// Model cho lịch sử rút bài tarot
class CardDrawHistory {
  final String id;
  final String cardId;
  final String cardName;
  final String cardNameVi;
  final String cardImagePath;
  final DateTime drawnAt; // Thời gian rút bài
  final bool isReversed; // Lá bài có bị ngược không

  const CardDrawHistory({
    required this.id,
    required this.cardId,
    required this.cardName,
    required this.cardNameVi,
    required this.cardImagePath,
    required this.drawnAt,
    this.isReversed = false,
  });

  /// Create from JSON
  factory CardDrawHistory.fromJson(Map<String, dynamic> json) {
    return CardDrawHistory(
      id: json['id']?.toString() ?? '',
      cardId: json['cardId']?.toString() ?? '',
      cardName: json['cardName']?.toString() ?? '',
      cardNameVi: json['cardNameVi']?.toString() ?? '',
      cardImagePath: json['cardImagePath']?.toString() ?? '',
      drawnAt: json['drawnAt'] != null
          ? DateTime.parse(json['drawnAt'] as String)
          : DateTime.now(),
      isReversed: json['isReversed'] as bool? ?? false,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cardId': cardId,
      'cardName': cardName,
      'cardNameVi': cardNameVi,
      'cardImagePath': cardImagePath,
      'drawnAt': drawnAt.toIso8601String(),
      'isReversed': isReversed,
    };
  }

  /// Create copy with updated fields
  CardDrawHistory copyWith({
    String? id,
    String? cardId,
    String? cardName,
    String? cardNameVi,
    String? cardImagePath,
    DateTime? drawnAt,
    bool? isReversed,
  }) {
    return CardDrawHistory(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      cardName: cardName ?? this.cardName,
      cardNameVi: cardNameVi ?? this.cardNameVi,
      cardImagePath: cardImagePath ?? this.cardImagePath,
      drawnAt: drawnAt ?? this.drawnAt,
      isReversed: isReversed ?? this.isReversed,
    );
  }
}

