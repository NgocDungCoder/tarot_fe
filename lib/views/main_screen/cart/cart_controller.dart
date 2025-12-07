import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/cart_item.dart';
import '../../../models/product.dart';
import '../../../widget/custom_snackbar.dart';

class CartController extends GetxController {
  // Cart items list
  final _cartItems = <CartItem>[].obs;
  List<CartItem> get cartItems => _cartItems;

  // Get total items count
  int get totalItems {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  // Get total price (Magic Points)
  double get totalPrice {
    return _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  // Check if cart is empty
  bool get isEmpty => _cartItems.isEmpty;

  /// Add product to cart (thêm 1 vào giỏ hàng)
  void addToCart(Product product) {
    // Tìm xem sản phẩm đã có trong giỏ hàng chưa
    final existingIndex = _cartItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      // Nếu đã có, tăng số lượng lên 1
      _cartItems[existingIndex].quantity++;
      _cartItems.refresh();
    } else {
      // Nếu chưa có, thêm mới với quantity = 1
      _cartItems.add(CartItem(product: product, quantity: 1));
    }

    // Hiển thị thông báo
    CustomSnackbar.success(
      title: 'Đã thêm vào giỏ',
      message: '${product.nameVi} đã được thêm vào giỏ hàng',
      duration: const Duration(seconds: 2),
    );
  }

  /// Update quantity của một item trong giỏ hàng
  void updateQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(productId);
      return;
    }

    final index = _cartItems.indexWhere(
      (item) => item.product.id == productId,
    );

    if (index >= 0) {
      _cartItems[index].quantity = newQuantity;
      _cartItems.refresh();
    }
  }

  /// Remove item from cart
  void removeFromCart(String productId) {
    _cartItems.removeWhere((item) => item.product.id == productId);
  }

  /// Increase quantity by 1
  void increaseQuantity(String productId) {
    final index = _cartItems.indexWhere(
      (item) => item.product.id == productId,
    );

    if (index >= 0) {
      _cartItems[index].quantity++;
      _cartItems.refresh();
    }
  }

  /// Decrease quantity by 1
  void decreaseQuantity(String productId) {
    final index = _cartItems.indexWhere(
      (item) => item.product.id == productId,
    );

    if (index >= 0) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
        _cartItems.refresh();
      } else {
        removeFromCart(productId);
      }
    }
  }

  /// Clear cart
  void clearCart() {
    _cartItems.clear();
  }

  /// Checkout (thanh toán)
  void checkout() {
    if (isEmpty) {
      CustomSnackbar.warning(
        title: 'Giỏ hàng trống',
        message: 'Giỏ hàng của bạn đang trống',
      );
      return;
    }

    // TODO: Implement checkout logic
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.black87,
        title: const Text(
          'Checkout',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Tổng cộng: ${totalPrice.toStringAsFixed(0)} Magic Points\n\nBạn có chắc chắn muốn thanh toán?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Hủy',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              clearCart();
              CustomSnackbar.success(
                title: 'Thành công',
                message: 'Thanh toán thành công!',
              );
            },
            child: const Text(
              'Thanh toán',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }
}

