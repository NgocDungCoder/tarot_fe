import 'cart_item.dart';

/// Order model - đơn hàng đã đặt
class Order {
  final String id;
  final String orderId; // Mã đơn hàng hiển thị (VD: ORD-1234567890)
  final List<CartItem> items; // Danh sách sản phẩm trong đơn
  final double totalAmount; // Tổng tiền thanh toán (Magic Points)
  final double rewardPoints; // Điểm thưởng nhận được
  final Map<String, dynamic>? voucher; // Voucher đã sử dụng
  final Map<String, String> shippingInfo; // Thông tin giao hàng
  final String status; // Trạng thái đơn hàng: pending, processing, shipped, delivered, cancelled
  final DateTime createdAt; // Thời gian đặt hàng

  Order({
    required this.id,
    required this.orderId,
    required this.items,
    required this.totalAmount,
    required this.rewardPoints,
    this.voucher,
    required this.shippingInfo,
    this.status = 'pending',
    required this.createdAt,
  });

  /// Create order from JSON
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id']?.toString() ?? '',
      orderId: json['orderId']?.toString() ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => CartItem.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      rewardPoints: (json['rewardPoints'] as num?)?.toDouble() ?? 0.0,
      voucher: json['voucher'] as Map<String, dynamic>?,
      shippingInfo: Map<String, String>.from(
        json['shippingInfo'] as Map? ?? {},
      ),
      status: json['status']?.toString() ?? 'pending',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  /// Convert order to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'rewardPoints': rewardPoints,
      'voucher': voucher,
      'shippingInfo': shippingInfo,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
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
        return 'Đã nhận hàng';
      case 'cancelled':
        return 'Đã hủy';
      default:
        return status;
    }
  }

  /// Create copy with updated fields
  Order copyWith({
    String? id,
    String? orderId,
    List<CartItem>? items,
    double? totalAmount,
    double? rewardPoints,
    Map<String, dynamic>? voucher,
    Map<String, String>? shippingInfo,
    String? status,
    DateTime? createdAt,
  }) {
    return Order(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      rewardPoints: rewardPoints ?? this.rewardPoints,
      voucher: voucher ?? this.voucher,
      shippingInfo: shippingInfo ?? this.shippingInfo,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

