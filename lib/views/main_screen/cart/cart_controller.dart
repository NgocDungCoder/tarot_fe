import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tarot_fe/models/cart_entity.dart';
import 'package:tarot_fe/models/cart_item_entity.dart';
import 'package:tarot_fe/models/product_entity.dart';
import 'package:tarot_fe/providers/api_client.dart';
import '../../../configs/routes/route.dart';
import '../../../widget/custom_snackbar.dart';

class CartController extends GetxController {
  // Cart items list
  final _cartItems = <CartItemEntity>[].obs;
  final errorMessage = "".obs;
  List<CartItemEntity> get cartItems => _cartItems;
  final cart = Rxn<CartEntity>();
  final ApiClient apiClient;
  final isLoading = false.obs;

  CartController(this.apiClient) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchCartOfUser();
      await fetchItemsInCart(cartId: cart.value?.id ?? "");
    });
  }

  Future<void> fetchCartOfUser() async {
    developer.log(
      'Fetching products',
      name: 'ShopController',
    );

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await apiClient.getCartOfUser();

      if (response == null) {
        throw Exception('Product detail response is null');
      }

      cart.value = response.docs?.first;

      developer.log(
        'Fetch products success',
        name: 'ShopController',
      );
    } catch (e, stackTrace) {
      errorMessage.value = 'Không thể tải list sản phẩm';

      developer.log(
        'Fetch products failed',
        name: 'Shop Controller',
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchItemsInCart({required String cartId}) async {
    developer.log(
      'Fetching products',
      name: 'ShopController',
    );

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await apiClient.getCartOfUser();

      if (response == null) {
        throw Exception('Product detail response is null');
      }

      cart.value = response.docs?.first;

      developer.log(
        'Fetch products success',
        name: 'ShopController',
      );
    } catch (e, stackTrace) {
      errorMessage.value = 'Không thể tải list sản phẩm';

      developer.log(
        'Fetch products failed',
        name: 'Shop Controller',
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      isLoading.value = false;
    }
  }
  // Get total items count
  int get totalItems {
    //- fold là một phương thức của Iterable (ví dụ List), dùng để gộp (reduce) toàn bộ phần tử của danh sách thành một giá trị duy nhất.
    //- initialValue: giá trị khởi tạo (ở đây là 0).
    // - (accumulator, element) => ...: hàm callback, nhận:
    // - accumulator (ở đây là sum): kết quả tích lũy từ các bước trước.
    // - element (ở đây là item): phần tử hiện tại trong danh sách
    //Hàm này sẽ trả về sum
    return _cartItems.fold(
        0, (sum, item) => sum + (item.quantity?.toInt() ?? 0));
  }

  // Get total price (Magic Points)
  double get totalPrice {
    return _cartItems.fold(
        0.0, (sum, item) => sum + (item.price?.toInt() ?? 0));
  }

  // Check if cart is empty
  bool get isEmpty => _cartItems.isEmpty;

  /// Add product to cart (thêm 1 vào giỏ hàng)
  void addToCart(ProductEntity product) {
    // Tìm xem sản phẩm đã có trong giỏ hàng chưa
    final existingIndex = _cartItems.indexWhere(
      (item) => item.productEntity?.id == product.id,
    );

    if (existingIndex >= 0) {
      // Nếu đã có, tăng số lượng lên 1
      _cartItems[existingIndex] = _cartItems[existingIndex].copyWith(
        quantity: _cartItems[existingIndex].quantity ?? 0 + 1,
      );

      _cartItems.refresh();

      _cartItems.refresh();
    } else {
      // Nếu chưa có, thêm mới với quantity = 1
      _cartItems.add(CartItemEntity(productEntity: product, quantity: 1));
    }

    // Hiển thị thông báo
    CustomSnackbar.success(
      title: 'Đã thêm vào giỏ',
      message: '${product.name} đã được thêm vào giỏ hàng',
      duration: const Duration(seconds: 2),
    );
  }

  /// Update quantity của một item trong giỏ hàng
  void updateQuantity(String productEntity, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(productEntity);
      return;
    }

    final index = _cartItems.indexWhere(
      (item) => item.productEntity?.id == productEntity,
    );

    if (index >= 0) {
      _cartItems[index] = _cartItems[index].copyWith(
        quantity: newQuantity,
      );

      _cartItems.refresh();
    }
  }

  /// Remove item from cart
  void removeFromCart(String productEntity) {
    _cartItems.removeWhere((item) => item.productEntity?.id == productEntity);
  }

  /// Increase quantity by 1
  void increaseQuantity(String productEntity) {
    final index = _cartItems.indexWhere(
      (item) => item.productEntity?.id == productEntity,
    );

    if (index >= 0) {
      _cartItems[index] = _cartItems[index].copyWith(
        quantity: _cartItems[index].quantity ?? 0 + 1,
      );
      _cartItems.refresh();
    }
  }

  /// Decrease quantity by 1
  void decreaseQuantity(String productEntity) {
    final index = _cartItems.indexWhere(
      (item) => item.productEntity?.id == productEntity,
    );

    if (index >= 0) {
      if (_cartItems[index].quantity! > 1) {
        _cartItems[index] = _cartItems[index].copyWith(
          quantity: _cartItems[index].quantity ?? 0 - 1,
        );
        _cartItems.refresh();
      } else {
        removeFromCart(productEntity);
      }
    }
  }

  /// Clear cart
  void clearCart() {
    _cartItems.clear();
  }

  /// Checkout (thanh toán) - navigate đến trang xác nhận thanh toán
  void checkout() {
    if (isEmpty) {
      CustomSnackbar.warning(
        title: 'Giỏ hàng trống',
        message: 'Giỏ hàng của bạn đang trống',
      );
      return;
    }
    Get.toNamed(Routes.checkoutConfirmation.p);
  }
}
