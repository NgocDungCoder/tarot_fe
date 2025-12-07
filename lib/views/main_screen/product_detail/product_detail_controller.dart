import 'package:get/get.dart';
import '../../../models/product.dart';
import '../cart/cart_controller.dart';
import '../cart/cart_page.dart';

class ProductDetailController extends GetxController {
  // Product data
  late final Product product;

  @override
  void onInit() {
    super.onInit();
    // Get product from arguments
    final arguments = Get.arguments;
    if (arguments is Product) {
      product = arguments;
    } else if (arguments is Map<String, dynamic> && arguments['product'] != null) {
      product = arguments['product'] as Product;
    } else {
      // Fallback: create default product
      product = _getDefaultProduct();
    }
  }

  /// Get default product
  Product _getDefaultProduct() {
    return Product(
      id: '1',
      name: 'Tarot Card Deck',
      nameVi: 'Bộ Bài Tarot',
      description: 'Complete tarot card deck with guidebook',
      price: 29.99,
      imagePath: 'assets/images/blog1.jpg',
      category: 'Decks',
    );
  }

  /// Add product to cart
  void addToCart() {
    // Get CartController
    if (!Get.isRegistered<CartController>()) {
      CartBinding().dependencies();
    }
    final cartController = Get.find<CartController>();
    cartController.addToCart(product);
  }
}

