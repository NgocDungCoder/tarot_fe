/// Transaction model - lịch sử giao dịch
class Transaction {
  final String id;
  final TransactionType type; // Loại giao dịch
  final double amount; // Số lượng điểm
  final String description; // Mô tả giao dịch
  final DateTime createdAt; // Thời gian giao dịch
  final Map<String, dynamic>? metadata; // Dữ liệu bổ sung (orderId, giftId, etc.)

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.createdAt,
    this.metadata,
  });

  /// Create transaction from JSON
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id']?.toString() ?? '',
      type: TransactionTypeExtension.fromString(json['type']?.toString() ?? ''),
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      description: json['description']?.toString() ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Convert transaction to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toValueString(),
      'amount': amount,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  /// Get display name for transaction type
  String get typeDisplayName {
    switch (type) {
      case TransactionType.magicPointDeposit:
        return 'Nạp Magic Points';
      case TransactionType.magicPointWithdraw:
        return 'Chi tiêu Magic Points';
      case TransactionType.rewardPointEarn:
        return 'Nhận Reward Points';
      case TransactionType.rewardPointSpend:
        return 'Đổi quà bằng Reward Points';
    }
  }

  /// Get icon for transaction type
  String get typeIcon {
    switch (type) {
      case TransactionType.magicPointDeposit:
        return '💰';
      case TransactionType.magicPointWithdraw:
        return '💸';
      case TransactionType.rewardPointEarn:
        return '🎁';
      case TransactionType.rewardPointSpend:
        return '🎫';
    }
  }

  /// Check if transaction is positive (income)
  bool get isPositive {
    return type == TransactionType.magicPointDeposit ||
        type == TransactionType.rewardPointEarn;
  }
}

/// Transaction type enum
enum TransactionType {
  magicPointDeposit, // Nạp Magic Points
  magicPointWithdraw, // Chi tiêu Magic Points
  rewardPointEarn, // Nhận Reward Points
  rewardPointSpend, // Đổi quà bằng Reward Points
}

/// Extension for TransactionType to add helper methods
extension TransactionTypeExtension on TransactionType {
  /// Convert from string
  static TransactionType fromString(String value) {
    switch (value) {
      case 'magicPointDeposit':
        return TransactionType.magicPointDeposit;
      case 'magicPointWithdraw':
        return TransactionType.magicPointWithdraw;
      case 'rewardPointEarn':
        return TransactionType.rewardPointEarn;
      case 'rewardPointSpend':
        return TransactionType.rewardPointSpend;
      default:
        return TransactionType.magicPointDeposit;
    }
  }

  /// Convert to string
  String toValueString() {
    switch (this) {
      case TransactionType.magicPointDeposit:
        return 'magicPointDeposit';
      case TransactionType.magicPointWithdraw:
        return 'magicPointWithdraw';
      case TransactionType.rewardPointEarn:
        return 'rewardPointEarn';
      case TransactionType.rewardPointSpend:
        return 'rewardPointSpend';
    }
  }
}

