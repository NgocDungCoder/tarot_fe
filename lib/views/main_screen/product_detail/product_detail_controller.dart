import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tarot_fe/models/cart_item_entity.dart';
import 'package:tarot_fe/providers/api_client.dart';
import '../../../models/product_entity.dart';
import '../cart/cart_controller.dart';
import '../cart/cart_page.dart';

class ProductDetailController extends GetxController {
  // Product data
  late final ProductEntity product;
  final ApiClient apiClient;
  final isLoading = false.obs;
  final errorMessage = "".obs;
  final Rx<ProductEntity> product2 = Rx<ProductEntity>(ProductEntity());
  final productId = "693bbd929a1689500d81194d";
  ProductDetailController(this.apiClient) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {

      //id: 693bbd929a1689500d81194d
      fetchProductDetail();
      fetchProductDetail2();
    });
  }

  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments is ProductEntity) {
      product = arguments;
    } else if (arguments is Map<String, dynamic> && arguments['product'] != null) {
      product = arguments['product'] as ProductEntity;
    } else {
      // Fallback: create default product
      product = _getDefaultProduct();
    }  }

  Future<void> fetchProductDetail() async {
    print("gọi API trong product detail");
    try {
      isLoading.value = true;
      apiClient.getProductDetailById("693bbd929a1689500d81194d");
      // final response = await apiClient.getProductDetailById(productId);
      //
      // if (response != null) {
      //   product2.value = response;
      // } else {
      //   isLoading.value = false;
      //   print("Lỗi get detail với rỗng");
      // }
    } catch (e) {
      print("Lỗi get detail product: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchProductDetail2() async {
    developer.log(
      'Fetching product detail',
      name: 'ProductDetailController',
      error: {'productId': productId},
    );

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await apiClient.getProductDetailById(productId);

      if (response == null) {
        throw Exception('Product detail response is null');
      }

      product2.value = response;

      developer.log(
        'Fetch product detail success',
        name: 'ProductDetailController',
      );
    } catch (e, stackTrace) {
      errorMessage.value = 'Không thể tải chi tiết sản phẩm';

      developer.log(
        'Fetch product detail failed',
        name: 'ProductDetailController',
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Get default product
  ProductEntity _getDefaultProduct() {
    return ProductEntity(
      id: '1',
      name: 'Tarot Card Deck',
      description: 'Complete tarot card deck with guidebook',
      price: 29.99,
      thumbnail: 'assets/images/blog1.jpg',
      categoryId: 'Decks',
    );
  }

  /// Add product to cart
  void addToCart() {
    // Get CartController
    if (!Get.isRegistered<CartController>()) {
      CartBinding().dependencies();
    }
    final cartController = Get.find<CartController>();
    cartController.addToCart(product as ProductId);
  }
}

