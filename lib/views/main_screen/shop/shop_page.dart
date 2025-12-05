import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../configs/styles/theme_config.dart';
import '../../../models/product.dart';
import '../../../widget/custom_text.dart';
import 'shop_controller.dart';

class ShopBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShopController>(() => ShopController());
  }
}

class ShopPage extends GetView<ShopController> {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Banner
            SliverToBoxAdapter(
              child: _buildBanner(),
            ),

            // Sticky Action buttons
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyActionButtonsDelegate(
                child: _buildActionButtons(),
              ),
            ),

            // Products section title
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    CustomText(
                      'Products',
                      fontSize: 24,
                      color: ThemeConfig.textGold,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
            ),

            // Products grid
            _buildProductsGrid(),
          ],
        ),
      ),
    );
  }

  /// Build banner slider
  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      height: 200,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // PageView for banner slider
            PageView.builder(
              controller: controller.bannerPageController,
              onPageChanged: controller.updateBannerIndex,
              itemCount: controller.bannerImages.length,
              itemBuilder: (context, index) {
                return _buildBannerItem(controller.bannerImages[index]);
              },
            ),
            // Indicator dots
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      controller.bannerImages.length,
                      (index) => _buildIndicatorDot(
                        index == controller.currentBannerIndex,
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  /// Build individual banner item
  Widget _buildBannerItem(String imagePath) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    ThemeConfig.deepPurple,
                    ThemeConfig.primaryColor,
                    ThemeConfig.secondaryColor,
                  ],
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.image_not_supported,
                  color: ThemeConfig.textGold,
                  size: 60,
                ),
              ),
            );
          },
        ),
        // Dark overlay for mystical effect
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.6),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Build indicator dot
  Widget _buildIndicatorDot(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive
            ? ThemeConfig.textGold
            : ThemeConfig.textGold.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  /// Build action buttons (Cart and Redeem Gift)
  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              label: 'Cart',
              icon: "assets/icons/shopping-cart.png",
              onTap: controller.goToCart,
              gradient: [
                ThemeConfig.deepPurple,
                ThemeConfig.primaryColor,
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildActionButton(
              label: 'Redeem Gift',
              icon: "assets/icons/gift.png",
              onTap: controller.goToRedeemGift,
              gradient: [
                ThemeConfig.deepPurple,
                ThemeConfig.primaryColor,
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build individual action button
  Widget _buildActionButton({
    required String label,
    required String icon,
    required VoidCallback onTap,
    required List<Color> gradient,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: gradient.first.withOpacity(0.5),
              blurRadius: 15,
              offset: const Offset(0, 5),
              spreadRadius: 1,
            ),
          ],
          border: Border.all(
            color: ThemeConfig.textGold.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              icon,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            CustomText(
              label,
              fontSize: 18,
              color: ThemeConfig.textGold,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }

  /// Build products grid
  Widget _buildProductsGrid() {
    return Obx(() {
      if (controller.products.isEmpty) {
        return SliverToBoxAdapter(
          child: Container(
            height: 200,
            alignment: Alignment.center,
            child: const CustomText(
              'No products available',
              fontSize: 16,
              color: ThemeConfig.textHint,
            ),
          ),
        );
      }

      return SliverPadding(
        padding: const EdgeInsets.all(16),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return _buildProductCard(controller.products[index]);
            },
            childCount: controller.products.length,
          ),
        ),
      );
    });
  }

  /// Build individual product card
  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to product detail
        Get.snackbar(
          product.nameVi,
          'Product detail coming soon',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: ThemeConfig.textGold.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: ThemeConfig.primaryColor.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      ThemeConfig.deepPurple.withOpacity(0.5),
                      ThemeConfig.primaryColor.withOpacity(0.3),
                    ],
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        product.imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: ThemeConfig.deepPurple.withOpacity(0.5),
                            child: const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                color: ThemeConfig.textGold,
                                size: 40,
                              ),
                            ),
                          );
                        },
                      ),
                      // Mystical overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Product info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Product name
                    CustomText(
                      product.nameVi,
                      fontSize: 14,
                      color: ThemeConfig.textGold,
                      fontWeight: FontWeight.bold,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          '\$${product.price.toStringAsFixed(2)}',
                          fontSize: 16,
                          color: ThemeConfig.textGoldLight,
                          fontWeight: FontWeight.bold,
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: ThemeConfig.primaryColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: ThemeConfig.textGold.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Image.asset(
                            "assets/icons/add-to-cart.png",
                            fit: BoxFit.contain,
                            height: 16,
                            width: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom delegate for sticky action buttons header
class _StickyActionButtonsDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyActionButtonsDelegate({required this.child});

  @override
  double get minExtent => 86.0; // Height of buttons (70) + padding (16)

  @override
  double get maxExtent => 86.0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  bool shouldRebuild(_StickyActionButtonsDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}
