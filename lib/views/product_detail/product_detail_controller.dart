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
  final ApiClient apiClient;
  final isLoading = false.obs;
  final errorMessage = "".obs;
  final String productId;
  final Rx<ProductId> product = Rx<ProductId>(ProductId());
  ProductDetailController(this.productId, this.apiClient) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchProductDetail();
    });
  }

  Future<void> fetchProductDetail() async {
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

      product.value = response;

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



  /// Add product to cart
  void addToCart() {
    final cartController = Get.find<CartController>();
    cartController.addToCart(product.value);
  }
}

