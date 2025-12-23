import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tarot_fe/models/banner_entity.dart';
import 'package:tarot_fe/models/cart_item_entity.dart';
import 'package:tarot_fe/models/product_entity.dart';
import 'package:tarot_fe/providers/api_client.dart';
import '../../../widget/custom_snackbar.dart';
import '../../cart/cart_controller.dart';

class ShopController extends GetxController {
  final ApiClient apiClient;
  final isLoading = false.obs;
  final errorMessage = "".obs;

  final RxList<ProductId> products = <ProductId>[].obs;
  final RxList<BannerEntity> banners = <BannerEntity>[].obs;

  final cartController = Get.find<CartController>();

  ShopController(this.apiClient) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchBanners();
      await fetchProducts();
      ;
    });
  }

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
    _initBannerSlider();
  }

  /// Initialize banner slider
  void _initBannerSlider() {
    bannerPageController = PageController(initialPage: 0);
    _startBannerTimer();
  }

  int get totalItems {
    return cartController.totalItems;
  }

  /// Start auto slide timer
  void _startBannerTimer() {
    _bannerTimer?.cancel();
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (bannerPageController.hasClients) {
        final nextIndex = (_currentBannerIndex.value + 1) % banners.length;
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
    _startBannerTimer();
  }

  Future<void> fetchBanners () async {
    developer.log(
      'Fetching banner',
      name: 'ShopController',
    );

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await apiClient.getBanners();

      if(response.success) {
        banners.value = response.data ?? [];
      } else {
        CustomSnackbar.error(
          title: 'Thất bại',
          message: 'Lấy danh sách banner thất bại',
          duration: const Duration(seconds: 2),
        );
      }

      developer.log(
        'Fetch banners success',
        name: 'ShopController',
      );
    } catch (e, stackTrace) {
      errorMessage.value = 'Không thể tải list banner';

      developer.log(
        'Fetch banners failed',
        name: 'Shop Controller',
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchProducts () async {
    developer.log(
      'Fetching products',
      name: 'ShopController',
    );

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await apiClient.getProducts();

      if (response == null) {
        throw Exception('Product detail response is null');
      }

      products.value = response.docs ?? [];

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



  /// Add product to cart
  void addToCart(ProductId product) {
    cartController.addToCart(product);
  }

  @override
  void onClose() {
    _stopBannerTimer();
    bannerPageController.dispose();
    super.onClose();
  }
}
