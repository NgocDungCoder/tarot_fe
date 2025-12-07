import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/product.dart';
import '../../../widget/custom_snackbar.dart';
import '../cart/cart_controller.dart';
import '../cart/cart_page.dart';

class ShopController extends GetxController {
  // Dummy products data
  final _products = <Product>[].obs;
  List<Product> get products => _products;

  // Banner images
  final List<String> bannerImages = [
    'assets/images/banner.jpg',
    'assets/images/banner2.jpg',
    'assets/images/banner3.jpg',
  ];

  // PageController cho banner slider
  late PageController bannerPageController;
  
  // Current banner index
  final _currentBannerIndex = 0.obs;
  int get currentBannerIndex => _currentBannerIndex.value;

  // Timer cho auto slide
  Timer? _bannerTimer;

  @override
  void onInit() {
    super.onInit();
    _loadProducts();
    _initBannerSlider();
  }

  /// Initialize banner slider
  void _initBannerSlider() {
    bannerPageController = PageController(initialPage: 0);
    _startBannerTimer();
  }

  /// Start auto slide timer
  void _startBannerTimer() {
    _bannerTimer?.cancel();
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (bannerPageController.hasClients) {
        final nextIndex = (_currentBannerIndex.value + 1) % bannerImages.length;
        bannerPageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  /// Stop banner timer
  void _stopBannerTimer() {
    _bannerTimer?.cancel();
    _bannerTimer = null;
  }

  /// Update current banner index
  void updateBannerIndex(int index) {
    _currentBannerIndex.value = index;
    // Restart timer khi user swipe manually
    _startBannerTimer();
  }

  /// Load dummy products
  void _loadProducts() {
    _products.value = [
      Product(
        id: '1',
        name: 'Tarot Card Deck',
        nameVi: 'Bộ Bài Tarot',
        description: 'Complete tarot card deck with guidebook',
        price: 29.99,
        imagePath: 'assets/images/blog1.jpg',
        category: 'Decks',
      ),
      Product(
        id: '2',
        name: 'Crystal Ball Set',
        nameVi: 'Bộ Cầu Pha Lê',
        description: 'Premium crystal ball for divination',
        price: 49.99,
        imagePath: 'assets/images/blog2.jpg',
        category: 'Tools',
      ),
      Product(
        id: '3',
        name: 'Tarot Reading Cloth',
        nameVi: 'Khăn Trải Tarot',
        description: 'Beautiful silk cloth for tarot readings',
        price: 19.99,
        imagePath: 'assets/images/blog3.jpg',
        category: 'Accessories',
      ),
      Product(
        id: '4',
        name: 'Oracle Cards',
        nameVi: 'Bài Oracle',
        description: 'Mystical oracle card deck',
        price: 24.99,
        imagePath: 'assets/images/blog4.jpg',
        category: 'Decks',
      ),
      Product(
        id: '5',
        name: 'Sage Bundle',
        nameVi: 'Bó Cỏ Xô Thơm',
        description: 'Purifying sage bundle for cleansing',
        price: 12.99,
        imagePath: 'assets/images/blog5.jpg',
        category: 'Tools',
      ),
      Product(
        id: '6',
        name: 'Tarot Guide Book',
        nameVi: 'Sách Hướng Dẫn Tarot',
        description: 'Complete guide to tarot reading',
        price: 15.99,
        imagePath: 'assets/images/blog6.jpg',
        category: 'Books',
      ),
    ];
  }

  /// Navigate to cart page
  void goToCart() {
    // Đảm bảo CartController đã được khởi tạo
    if (!Get.isRegistered<CartController>()) {
      CartBinding().dependencies();
    }
    Get.toNamed('/cart');
  }

  /// Add product to cart
  void addToCart(Product product) {
    // Đảm bảo CartController đã được khởi tạo
    if (!Get.isRegistered<CartController>()) {
      CartBinding().dependencies();
    }
    final cartController = Get.find<CartController>();
    cartController.addToCart(product);
  }

  /// Navigate to redeem gift
  void goToRedeemGift() {
    // TODO: Navigate to redeem gift page
    CustomSnackbar.information(
      title: 'Đổi quà',
      message: 'Tính năng đổi quà sắp ra mắt',
    );
  }

  @override
  void onClose() {
    _stopBannerTimer();
    bannerPageController.dispose();
    super.onClose();
  }
}
