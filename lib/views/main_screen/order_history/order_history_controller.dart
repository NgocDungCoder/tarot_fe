import 'package:get/get.dart';
import '../../../models/order.dart';
import '../../../models/cart_item.dart';
import '../../../models/product.dart';

class OrderHistoryController extends GetxController {
  // Loading state
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  // List of orders
  final _orders = <Order>[].obs;
  List<Order> get orders => _orders;

  // Filter by status
  final _selectedStatus = 'all'.obs;
  String get selectedStatus => _selectedStatus.value;

  @override
  void onInit() {
    super.onInit();
    _loadOrders();
  }

  /// Load orders (tạm thời dùng dữ liệu mẫu)
  void _loadOrders() {
    _isLoading.value = true;

    Future.delayed(const Duration(milliseconds: 500), () {
      // Dữ liệu mẫu - tạo một số đơn hàng giả
      final sampleOrders = [
        Order(
          id: 'order1',
          orderId: 'ORD-1703123456789',
          items: [
            CartItem(
              product: Product(
                id: 'prod1',
                name: 'Tarot Deck Classic',
                nameVi: 'Bộ bài Tarot cổ điển',
                description: 'Bộ bài tarot cổ điển với thiết kế đẹp mắt',
                price: 500.0,
                imagePath: 'assets/images/product1.jpg',
                category: 'cards',
              ),
              quantity: 2,
            ),
            CartItem(
              product: Product(
                id: 'prod2',
                name: 'Crystal Ball',
                nameVi: 'Quả cầu pha lê',
                description: 'Quả cầu pha lê để tiên tri',
                price: 800.0,
                imagePath: 'assets/images/product2.jpg',
                category: 'decoration',
              ),
              quantity: 1,
            ),
          ],
          totalAmount: 1800.0,
          rewardPoints: 180.0,
          voucher: {
            'code': 'GIAM10',
            'discount': 10,
          },
          shippingInfo: {
            'name': 'Nguyễn Văn A',
            'phone': '+84 123 456 789',
            'address': '123 Đường ABC, Quận XYZ, TP.HCM',
          },
          status: 'delivered',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
        Order(
          id: 'order2',
          orderId: 'ORD-1703123456790',
          items: [
            CartItem(
              product: Product(
                id: 'prod3',
                name: 'Mystic Book',
                nameVi: 'Sách huyền học',
                description: 'Sách về tarot và chiêm tinh',
                price: 300.0,
                imagePath: 'assets/images/product3.jpg',
                category: 'books',
              ),
              quantity: 1,
            ),
          ],
          totalAmount: 300.0,
          rewardPoints: 30.0,
          shippingInfo: {
            'name': 'Nguyễn Văn A',
            'phone': '+84 123 456 789',
            'address': '123 Đường ABC, Quận XYZ, TP.HCM',
          },
          status: 'shipped',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        Order(
          id: 'order3',
          orderId: 'ORD-1703123456791',
          items: [
            CartItem(
              product: Product(
                id: 'prod4',
                name: 'Incense Set',
                nameVi: 'Bộ nhang thơm',
                description: 'Bộ nhang với nhiều mùi hương',
                price: 200.0,
                imagePath: 'assets/images/product4.jpg',
                category: 'wellness',
              ),
              quantity: 3,
            ),
          ],
          totalAmount: 600.0,
          rewardPoints: 60.0,
          shippingInfo: {
            'name': 'Nguyễn Văn A',
            'phone': '+84 123 456 789',
            'address': '123 Đường ABC, Quận XYZ, TP.HCM',
          },
          status: 'processing',
          createdAt: DateTime.now().subtract(const Duration(hours: 12)),
        ),
      ];

      _orders.assignAll(sampleOrders);
      _isLoading.value = false;
    });
  }

  /// Get filtered orders based on status
  List<Order> get filteredOrders {
    if (_selectedStatus.value == 'all') {
      return _orders;
    }
    return _orders.where((order) => order.status == _selectedStatus.value).toList();
  }

  /// Set selected status filter
  void setStatus(String status) {
    _selectedStatus.value = status;
  }

  /// Get unique statuses
  List<String> get statuses => ['all', 'pending', 'processing', 'shipped', 'delivered', 'cancelled'];

  /// Get status display name
  String getStatusDisplayName(String status) {
    switch (status) {
      case 'all':
        return 'Tất cả';
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

  /// Add new order (called from checkout confirmation)
  void addOrder(Order order) {
    _orders.insert(0, order); // Add to beginning of list
  }
}

