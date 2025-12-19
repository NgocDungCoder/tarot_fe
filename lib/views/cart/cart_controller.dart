import 'dart:async';
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
  final userIdTest = "6943d3e9905d10bd4b078aad";
  Timer? _debounceTimer;

  CartController(this.apiClient) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchCartOfUser();
      await fetchItemsInCart(cartId: cart.value?.id ?? "");
    });
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
      print("===================> $cartId");
      final response = await apiClient.getCartItems(cartId: cartId);

      if (response == null) {
        throw Exception('cart items response is null');
      }

      _cartItems.value = response.docs ?? [];

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
        0.0,
        (sum, item) =>
            sum +
            ((item.productId?.price?.toInt() ?? 0.0) * (item.quantity ?? 0)));
  }

  // Check if cart is empty
  bool get isEmpty => _cartItems.isEmpty;

  /// Add product to cart (thêm 1 vào giỏ hàng)
  void addToCart(ProductId product) {
    // Tìm xem sản phẩm đã có trong giỏ hàng chưa
    final existingIndex = _cartItems.indexWhere(
      (item) => item.productId?.id == product.id,
    );

    if (existingIndex >= 0) {
      // Nếu đã có, tăng số lượng lên 1
      _cartItems[existingIndex] = _cartItems[existingIndex].copyWith(
        quantity: (_cartItems[existingIndex].quantity!) + 1,
      );

      _cartItems.refresh();

      _cartItems.refresh();
    } else {
      // Nếu chưa có, thêm mới với quantity = 1
      _cartItems.add(CartItemEntity(productId: product, quantity: 1));
    }

    // Hiển thị thông báo
    CustomSnackbar.success(
      title: 'Đã thêm vào giỏ',
      message: '${product.name} đã được thêm vào giỏ hàng',
      duration: const Duration(seconds: 1),
    );
  }

  /// Remove item from cart
  Future<void> removeFromCart(String cartItemId) async {
    _cartItems.removeWhere((item) => item.id == cartItemId);
    try {
      await apiClient.removeCartItem(
        cartItemId: cartItemId,
      );
      CustomSnackbar.success(
        title: 'Xóa sản phẩm',
        message: 'Đã xóa sản phẩm thành công',
      );
    } catch (e) {
      errorMessage.value = "Không thể xóa cart item";
    }
  }

  void updateQuantity(String productId, int delta) {
    final index = _cartItems.indexWhere(
      (item) => item.productId?.id == productId,
    );

    if (index >= 0) {
      final currentItem = _cartItems[index];
      final int oldQuantity = currentItem.quantity?.toInt() ?? 0;
      final int newQuantity = oldQuantity + delta;

      if (newQuantity > 0) {
        // 1. Cập nhật ngay trên giao diện
        _cartItems[index] = currentItem.copyWith(quantity: newQuantity);
        _cartItems.refresh();

        // 2. Reset timer nếu người dùng bấm liên tục
        _debounceTimer?.cancel();
        _debounceTimer = Timer(const Duration(seconds: 3), () async {
          try {
            await apiClient.updateQuantityCartItem(
              cartItemId: currentItem.id ?? "",
              quantity: _cartItems[index].quantity?.toInt() ?? newQuantity,
            );
          } catch (e) {
            // rollback nếu API lỗi
            _cartItems[index] = currentItem.copyWith(quantity: oldQuantity);
            _cartItems.refresh();
            errorMessage.value = "Không thể cập nhật số lượng";
          }
        });
      } else {
        removeFromCart(productId);
      }
    }
  }

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
