import 'gift.dart';

/// RedeemHistory model - lịch sử đổi quà
class RedeemHistory {
  final String id;
  final Gift gift; // Quà đã đổi
  final int rewardPointsUsed; // Số điểm đã dùng
  final String status; // Trạng thái: pending, processing, shipped, delivered, cancelled
  final DateTime redeemedAt; // Thời gian đổi quà
  final Map<String, String>? shippingInfo; // Thông tin giao hàng (nếu có)

  RedeemHistory({
    required this.id,
    required this.gift,
    required this.rewardPointsUsed,
    this.status = 'pending',
    required this.redeemedAt,
    this.shippingInfo,
  });

  /// Create redeem history from JSON
  factory RedeemHistory.fromJson(Map<String, dynamic> json) {
    return RedeemHistory(
      id: json['id']?.toString() ?? '',
      gift: Gift.fromJson(json['gift'] as Map<String, dynamic>),
      rewardPointsUsed: (json['rewardPointsUsed'] as num?)?.toInt() ?? 0,
      status: json['status']?.toString() ?? 'pending',
      redeemedAt: json['redeemedAt'] != null
          ? DateTime.parse(json['redeemedAt'] as String)
          : DateTime.now(),
      shippingInfo: json['shippingInfo'] != null
          ? Map<String, String>.from(
              json['shippingInfo'] as Map,
            )
          : null,
    );
  }

  /// Convert redeem history to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gift': gift.toJson(),
      'rewardPointsUsed': rewardPointsUsed,
      'status': status,
      'redeemedAt': redeemedAt.toIso8601String(),
      'shippingInfo': shippingInfo,
    };
  }

  /// Get status display name in Vietnamese
  String get statusDisplayName {
    switch (status) {
      case 'pending':
        return 'Chờ xử lý';
      case 'processing':
        return 'Đang xử lý';
      case 'shipped':
        return 'Đã giao hàng';
      case 'delivered':
        return 'Đã nhận quà';
      case 'cancelled':
        return 'Đã hủy';
      default:
        return status;
    }
  }

  /// Create copy with updated fields
  RedeemHistory copyWith({
    String? id,
    Gift? gift,
    int? rewardPointsUsed,
    String? status,
    DateTime? redeemedAt,
    Map<String, String>? shippingInfo,
  }) {
    return RedeemHistory(
      id: id ?? this.id,
      gift: gift ?? this.gift,
      rewardPointsUsed: rewardPointsUsed ?? this.rewardPointsUsed,
      status: status ?? this.status,
      redeemedAt: redeemedAt ?? this.redeemedAt,
      shippingInfo: shippingInfo ?? this.shippingInfo,
    );
  }
}

