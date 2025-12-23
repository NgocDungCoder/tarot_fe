import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tarot_fe/models/address_entity.dart';
import 'package:tarot_fe/models/discount_entity.dart';
import 'package:tarot_fe/providers/api_client.dart';
import '../../../configs/styles/theme_config.dart';
import '../../../configs/routes/route.dart';
import '../../../widget/custom_snackbar.dart';
import '../../../widget/custom_text.dart';
import '../../models/cart_entity.dart';
import '../../models/cart_item_entity.dart';
import '../cart/cart_controller.dart';
import '../main_screen/user/user_controller.dart';
import '../order_history/order_history_controller.dart';
import '../order_history/order_history_page.dart';
import '../transaction_history/transaction_history_controller.dart';
import '../transaction_history/transaction_history_page.dart';
import '../../../models/transaction.dart';

class CheckoutConfirmationController extends GetxController {
  final ApiClient apiClient;
  final isLoading = false.obs;
  final errorMessage = "".obs;
  final userIdTest = "6943d3e9905d10bd4b078aad";

  final cart = Rxn<CartEntity>();
  final cartItems = <CartItemEntity>[].obs;
  final discounts = <DiscountEntity>[].obs;
  final address = Rx<AddressEntity?>(null);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // Processing payment state
  final _isProcessing = false.obs;

  bool get isProcessing => _isProcessing.value;

  // Selected voucher
  final selectedVoucher = Rx<DiscountEntity?>(null);

  CheckoutConfirmationController(this.apiClient);

  @override
  void onInit() async {
    super.onInit();
    await fetchCartOfUser();
    await fetchItemsInCart(cartId: cart.value?.id ?? "");
    await fetchAddressOfUser();
    await fetchDiscount();
    getTotalPrice();
  }

  Future<void> fetchCartOfUser() async {
    developer.log(
      'Fetching products',
      name: 'CartController',
    );

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await apiClient.getCartOfUser(userId: userIdTest);

      if (response == null) {
        throw Exception('Product detail response is null');
      }

      cart.value = response.docs?.first;

      developer.log(
        'Fetch products success',
        name: 'CartController',
      );
    } catch (e, stackTrace) {
      errorMessage.value = 'Không thể tải list sản phẩm';

      developer.log(
        'Fetch products failed',
        name: 'CartController',
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchItemsInCart({required String cartId}) async {
    developer.log(
      'Fetching cart items',
      name: 'CartController',
    );

    try {
      isLoading.value = true;
      errorMessage.value = '';
      final response = await apiClient.getCartItems(cartId: cartId);

      if (response == null) {
        throw Exception('cart items response is null');
      }

      cartItems.value = response.docs ?? [];

      developer.log(
        'Fetch cart items success',
        name: 'CartController',
      );
    } catch (e, stackTrace) {
      errorMessage.value = 'Không thể tải list cart items';

      developer.log(
        'Fetch cart items failed',
        name: 'CartController',
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAddressOfUser() async {
    developer.log(
      'Fetching address',
      name: 'CartController',
    );

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await apiClient.getAddressOfUser(userId: userIdTest);

      if (response == null) {
        throw Exception('address detail response is null');
      }

      address.value = response;

      if (address.value != null) {
        setTextController();
      }

      developer.log(
        'Fetch address success',
        name: 'CartController',
      );
    } catch (e, stackTrace) {
      errorMessage.value = 'Không thể tải list sản phẩm';

      developer.log(
        'Fetch address failed',
        name: 'CartController',
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void setTextController() {
    nameController.text = address.value?.fullName ?? '';
    phoneController.text = address.value?.phone ?? "";
    addressController.text = address.value?.detail ?? "";
  }

  Future<void> fetchDiscount() async {
    developer.log(
      'Fetching discounts',
      name: 'checkoutController',
    );

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await apiClient.getDiscounts();

      if (response == null) {
        throw Exception('discounts detail response is null');
      }

      discounts.value = response.docs ?? [];

      developer.log(
        'Fetch discounts success',
        name: 'checkoutController',
      );
    } catch (e, stackTrace) {
      errorMessage.value = 'Không thể tải list discount';

      developer.log(
        'Fetch discounts failed',
        name: 'checkoutController',
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void getTotalPrice() {}

  /// Calculate subtotal (tổng tiền trước khi giảm giá)
  double get subtotal {
    // return cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
    return 0.0;
  }

  /// Calculate voucher discount (giảm giá từ voucher)
  double get voucherDiscount {
    final discountPercent = selectedVoucher.value?.value ?? 0;
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

  /// Remove voucher
  void removeVoucher() {
    selectedVoucher.value = DiscountEntity();
    CustomSnackbar.information(
      title: 'Đã xóa voucher',
      message: 'Voucher đã được gỡ bỏ',
    );
  }

  /// Edit shipping info
  void editShippingInfo() {
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
        final shortage =
            totalAmount - (userController.user.value.magicPoints ?? 0);
        CustomSnackbar.warning(
          title: 'Không đủ Magic Points',
          message:
              'Bạn cần nạp thêm ${shortage.toStringAsFixed(0)} MP để thanh toán đơn hàng này.',
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
      //   voucher: selectedVoucher.value,
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
        final currentUser = userController.user.value;
        userController.updateUser(
          currentUser.copyWith(
            rewardPoints: currentUser.rewardPoints! + rewardPoints.toInt(),
          ),
        );
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
          'voucher': selectedVoucher.value,
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
