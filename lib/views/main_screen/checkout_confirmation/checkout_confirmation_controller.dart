import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../configs/styles/theme_config.dart';
import '../../../configs/routes/route.dart';
import '../../../widget/custom_snackbar.dart';
import '../../../widget/custom_text.dart';
import '../cart/cart_controller.dart';
import '../order_history/order_history_controller.dart';
import '../order_history/order_history_page.dart';
import '../transaction_history/transaction_history_controller.dart';
import '../transaction_history/transaction_history_page.dart';
import '../user/user_controller.dart';
import '../../../models/transaction.dart';

class CheckoutConfirmationController extends GetxController {
  // Cart items từ CartController
  // List<CartItem> get cartItems {
  //   if (Get.isRegistered<CartController>()) {
  //     return Get.find<CartController>().cartItems;
  //   }
  //   return [];
  // }

  // Loading state
  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  // Processing payment state
  final _isProcessing = false.obs;

  bool get isProcessing => _isProcessing.value;

  // Selected voucher
  final _selectedVoucher = Rx<Map<String, dynamic>?>(null);

  Map<String, dynamic>? get selectedVoucher => _selectedVoucher.value;

  // Shipping info
  final _shippingInfo = <String, String>{
    'name': 'Nguyễn Văn A',
    'phone': '+84 123 456 789',
    'address': '123 Đường ABC, Quận XYZ, TP.HCM',
  }.obs;

  Map<String, String> get shippingInfo => _shippingInfo;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  /// Load initial data
  void _loadData() {
    _isLoading.value = true;
    // Simulate loading
    Future.delayed(const Duration(milliseconds: 300), () {
      _isLoading.value = false;
    });
  }

  /// Calculate subtotal (tổng tiền trước khi giảm giá)
  double get subtotal {
    // return cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
    return 0.0;
  }

  /// Calculate voucher discount (giảm giá từ voucher)
  double get voucherDiscount {
    if (_selectedVoucher.value == null) return 0.0;
    final discountPercent = _selectedVoucher.value!['discount'] as num? ?? 0;
    return subtotal * (discountPercent / 100);
  }

  /// Calculate total amount (tổng tiền sau khi giảm giá)
  double get totalAmount {
    return subtotal - voucherDiscount;
  }

  /// Calculate reward points (10% của tổng tiền)
  double get rewardPoints {
    return totalAmount * 0.1;
  }

  /// Check if can confirm payment
  bool get canConfirm {
    // return cartItems.isNotEmpty &&
    //     _shippingInfo['name'] != null &&
    //     _shippingInfo['name']!.isNotEmpty &&
    //     _shippingInfo['phone'] != null &&
    //     _shippingInfo['phone']!.isNotEmpty &&
    //     _shippingInfo['address'] != null &&
    //     _shippingInfo['address']!.isNotEmpty;
    return true;
  }

  /// Select voucher
  void selectVoucher() {
    // Danh sách voucher mẫu
    final vouchers = [
      {
        'code': 'GIAM10',
        'discount': 10,
        'description': 'Giảm 10% cho đơn hàng từ 1000 MP',
      },
      {
        'code': 'GIAM20',
        'discount': 20,
        'description': 'Giảm 20% cho đơn hàng từ 2000 MP',
      },
      {
        'code': 'FREESHIP',
        'discount': 5,
        'description': 'Giảm 5% + miễn phí vận chuyển',
      },
    ];

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border.all(
            color: ThemeConfig.textGold.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              'Chọn voucher',
              fontSize: 20,
              color: ThemeConfig.textGold,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 20),
            ...vouchers.map((voucher) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _selectedVoucher.value?['code'] == voucher['code']
                        ? ThemeConfig.textGold
                        : Colors.grey.shade700,
                    width: 2,
                  ),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.local_offer,
                    color: ThemeConfig.textGold,
                  ),
                  title: CustomText(
                    voucher['code'] as String,
                    fontSize: 16,
                    color: ThemeConfig.textGold,
                    fontWeight: FontWeight.bold,
                  ),
                  subtitle: CustomText(
                    voucher['description'] as String,
                    fontSize: 12,
                    color: ThemeConfig.textWhite.withOpacity(0.7),
                  ),
                  trailing: _selectedVoucher.value?['code'] == voucher['code']
                      ? Icon(
                          Icons.check_circle,
                          color: ThemeConfig.textGold,
                        )
                      : null,
                  onTap: () {
                    _selectedVoucher.value = voucher;
                    Get.back();
                    CustomSnackbar.success(
                      title: 'Đã chọn voucher',
                      message: 'Voucher ${voucher['code']} đã được áp dụng',
                    );
                  },
                ),
              );
            }),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Get.back(),
              child: const CustomText(
                'Đóng',
                fontSize: 16,
                color: ThemeConfig.textWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Remove voucher
  void removeVoucher() {
    _selectedVoucher.value = null;
    CustomSnackbar.information(
      title: 'Đã xóa voucher',
      message: 'Voucher đã được gỡ bỏ',
    );
  }

  /// Edit shipping info
  void editShippingInfo() {
    final nameController = TextEditingController(text: _shippingInfo['name']);
    final phoneController = TextEditingController(text: _shippingInfo['phone']);
    final addressController =
        TextEditingController(text: _shippingInfo['address']);

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const CustomText(
          'Thông tin giao hàng',
          fontSize: 20,
          color: ThemeConfig.textGold,
          fontWeight: FontWeight.bold,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Tên người nhận',
                  labelStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade700),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.amber, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade900,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Số điện thoại',
                  labelStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade700),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.amber, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade900,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: addressController,
                style: const TextStyle(color: Colors.white),
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Địa chỉ',
                  labelStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade700),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.amber, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade900,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Hủy',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty ||
                  phoneController.text.trim().isEmpty ||
                  addressController.text.trim().isEmpty) {
                CustomSnackbar.error(
                  title: 'Lỗi',
                  message: 'Vui lòng điền đầy đủ thông tin',
                );
                return;
              }

              _shippingInfo['name'] = nameController.text.trim();
              _shippingInfo['phone'] = phoneController.text.trim();
              _shippingInfo['address'] = addressController.text.trim();
              Get.back();
              CustomSnackbar.success(
                title: 'Thành công',
                message: 'Đã cập nhật thông tin giao hàng',
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
            ),
            child: const Text(
              'Lưu',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  /// Confirm payment
  Future<void> confirmPayment() async {
    if (!canConfirm) {
      CustomSnackbar.error(
        title: 'Lỗi',
        message: 'Vui lòng điền đầy đủ thông tin giao hàng',
      );
      return;
    }

    // Show confirmation dialog
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const CustomText(
          'Xác nhận thanh toán',
          fontSize: 20,
          color: ThemeConfig.textGold,
          fontWeight: FontWeight.bold,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              'Bạn có chắc chắn muốn thanh toán?',
              fontSize: 16,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            _buildSummaryRow(
              label: 'Tổng thanh toán',
              value: '${totalAmount.toStringAsFixed(0)} MP',
            ),
            const SizedBox(height: 8),
            _buildSummaryRow(
              label: 'Điểm thưởng nhận được',
              value: '+${rewardPoints.toStringAsFixed(0)} RP',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text(
              'Hủy',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
            ),
            child: const Text(
              'Xác nhận',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Check if user has enough Magic Points
    if (Get.isRegistered<UserController>()) {
      final userController = Get.find<UserController>();
      if (!userController.hasEnoughMagicPoints(totalAmount)) {
        final shortage = totalAmount - (userController.user?.magicPoints ?? 0);
        CustomSnackbar.warning(
          title: 'Không đủ Magic Points',
          message: 'Bạn cần nạp thêm ${shortage.toStringAsFixed(0)} MP để thanh toán đơn hàng này.',
        );
        // Navigate to deposit page
        Get.toNamed(
          Routes.payment.sp,
          arguments: {
            'requiredAmount': shortage,
          },
        );
        return;
      }
    }

    _isProcessing.value = true;

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Subtract Magic Points from user
      if (Get.isRegistered<UserController>()) {
        Get.find<UserController>().subtractMagicPoints(totalAmount);
      }

      // Create order
      final orderId = 'ORD-${DateTime.now().millisecondsSinceEpoch}';
      // final order = Order(
      //   id: orderId,
      //   orderId: orderId,
      //   items: cartItems,
      //   totalAmount: totalAmount,
      //   rewardPoints: rewardPoints,
      //   voucher: _selectedVoucher.value,
      //   shippingInfo: _shippingInfo,
      //   status: 'pending',
      //   createdAt: DateTime.now(),
      // );

      // Save order to history
      // if (Get.isRegistered<OrderHistoryController>()) {
      //   Get.find<OrderHistoryController>().addOrder(order);
      // } else {
      //   // Initialize OrderHistoryController if not registered
      //   OrderHistoryBinding().dependencies();
      //   Get.find<OrderHistoryController>().addOrder(order);
      // }

      // Save transactions to history
      // Transaction 1: Chi tiêu Magic Points
      final mpTransaction = Transaction(
        id: 'tx-mp-${DateTime.now().millisecondsSinceEpoch}',
        type: TransactionType.magicPointWithdraw,
        amount: totalAmount,
        description: 'Thanh toán đơn hàng $orderId',
        createdAt: DateTime.now(),
        metadata: {'orderId': orderId},
      );

      // Transaction 2: Nhận Reward Points
      final rpTransaction = Transaction(
        id: 'tx-rp-${DateTime.now().millisecondsSinceEpoch}',
        type: TransactionType.rewardPointEarn,
        amount: rewardPoints,
        description: 'Nhận điểm thưởng từ đơn hàng $orderId',
        createdAt: DateTime.now(),
        metadata: {'orderId': orderId},
      );

      if (Get.isRegistered<TransactionHistoryController>()) {
        Get.find<TransactionHistoryController>().addTransaction(mpTransaction);
        Get.find<TransactionHistoryController>().addTransaction(rpTransaction);
      } else {
        // Initialize TransactionHistoryController if not registered
        TransactionHistoryBinding().dependencies();
        Get.find<TransactionHistoryController>().addTransaction(mpTransaction);
        Get.find<TransactionHistoryController>().addTransaction(rpTransaction);
      }

      // Add Reward Points to user
      if (Get.isRegistered<UserController>()) {
        final userController = Get.find<UserController>();
        final currentUser = userController.user;
        if (currentUser != null) {
          userController.updateUser(
            currentUser.copyWith(
              rewardPoints: currentUser.rewardPoints + rewardPoints.toInt(),
            ),
          );
        }
      }

      // Clear cart
      if (Get.isRegistered<CartController>()) {
        Get.find<CartController>().clearCart();
      }

      // Navigate to payment success page
      Get.offNamed(
        Routes.paymentSuccess.sp,
        arguments: {
          'orderId': orderId,
          'totalAmount': totalAmount,
          'rewardPoints': rewardPoints,
          'voucher': _selectedVoucher.value,
        },
      );
    } catch (e) {
      CustomSnackbar.error(
        title: 'Lỗi',
        message: 'Thanh toán thất bại. Vui lòng thử lại.',
      );
    } finally {
      _isProcessing.value = false;
    }
  }

  /// Build summary row for dialog
  Widget _buildSummaryRow({required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          label,
          fontSize: 14,
          color: ThemeConfig.textWhite.withOpacity(0.8),
        ),
        CustomText(
          value,
          fontSize: 16,
          color: ThemeConfig.textGold,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }
}
