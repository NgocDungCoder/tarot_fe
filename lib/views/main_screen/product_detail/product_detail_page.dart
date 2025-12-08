import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../configs/styles/theme_config.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/video_background.dart';
import '../cart/cart_controller.dart';
import 'product_detail_controller.dart';

class ProductDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductDetailController>(() => ProductDetailController());
  }
}

class ProductDetailPage extends GetView<ProductDetailController> {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return VideoBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ThemeConfig.textGold),
          onPressed: () => Get.back(),
        ),
        title: const CustomText(
          'Product Detail',
          fontSize: 24,
          color: ThemeConfig.textGold,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image
              _buildProductImage(),
              
              const SizedBox(height: 24),
              
              // Product name
              _buildProductName(),
              
              const SizedBox(height: 16),
              
              // Price
              _buildPrice(),
              
              const SizedBox(height: 24),
              
              // Description
              _buildDescription(),
              
              const SizedBox(height: 24),
              
              // Add to cart button
              _buildAddToCartButton(),
              
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    ),);
  }

  /// Build product image
  Widget _buildProductImage() {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ThemeConfig.textGold.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeConfig.textGold.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Image.asset(
          controller.product.imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: ThemeConfig.deepPurple.withOpacity(0.5),
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
      ),
    );
  }

  /// Build product name
  Widget _buildProductName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          controller.product.nameVi,
          fontSize: 28,
          color: ThemeConfig.textGold,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 8),
        CustomText(
          controller.product.name,
          fontSize: 18,
          color: ThemeConfig.textWhite.withOpacity(0.8),
        ),
      ],
    );
  }

  /// Build price
  Widget _buildPrice() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ThemeConfig.textGold.withOpacity(0.2),
            ThemeConfig.textGoldLight.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ThemeConfig.textGold.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.auto_awesome,
            color: ThemeConfig.textGold,
            size: 24,
          ),
          const SizedBox(width: 12),
          CustomText(
            '${controller.product.price.toStringAsFixed(0)} Magic Points',
            fontSize: 24,
            color: ThemeConfig.textGold,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  /// Build description
  Widget _buildDescription() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: ThemeConfig.textGold.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            'Description',
            fontSize: 20,
            color: ThemeConfig.textGold,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 12),
          CustomText(
            controller.product.description,
            fontSize: 16,
            color: ThemeConfig.textWhite,
          ),
        ],
      ),
    );
  }

  /// Build add to cart button
  Widget _buildAddToCartButton() {
    return Container(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: controller.addToCart,
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeConfig.textGold,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_cart, size: 24),
            const SizedBox(width: 12),
            const CustomText(
              'Add to Cart',
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),

    );
  }
}

