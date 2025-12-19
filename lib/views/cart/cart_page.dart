import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tarot_fe/models/cart_item_entity.dart';
import 'package:tarot_fe/models/product_entity.dart';
import 'package:tarot_fe/widget/custom_popup.dart';
import '../../../configs/styles/theme_config.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/video_background.dart';
import 'cart_controller.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CartController>(CartController(Get.find()), permanent: true);
  }
}

class CartPage extends GetView<CartController> {
  const CartPage({super.key});

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
          title: InkWell(
            onTap: () =>
                controller.fetchItemsInCart(cartId: "6943d423905d10bd4b078aaf"),
            child: const CustomText(
              'Cart',
              fontSize: 24,
              color: ThemeConfig.textGold,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Obx(() {
            if (controller.isEmpty) {
              return _buildEmptyCart();
            }

            return Column(
              children: [
                // Cart items list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.cartItems.length,
                    itemBuilder: (context, index) {
                      return _buildCartItem(controller.cartItems[index]);
                    },
                  ),
                ),

                // Total and checkout button
                _buildCheckoutSection(),
              ],
            );
          }),
        ),
      ),
    );
  }

  /// Build empty cart state
  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/icons/shopping-cart.png",
            height: 40,
            width: 40,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 20),
          const CustomText(
            'Your cart is empty',
            fontSize: 20,
            color: ThemeConfig.textWhite,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 10),
          CustomText(
            'Add some products to get started',
            fontSize: 14,
            color: ThemeConfig.textWhite.withOpacity(0.7),
          ),
        ],
      ),
    );
  }

  /// Build cart item card
  Widget _buildCartItem(CartItemEntity cartItem) {
    final item = cartItem.productId;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: ThemeConfig.textGold.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeConfig.textGold.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: ThemeConfig.textGold.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: Image.network(
                item?.thumbnail ?? "",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: ThemeConfig.deepPurple.withOpacity(0.5),
                    child: const Icon(
                      Icons.image_not_supported,
                      color: ThemeConfig.textGold,
                      size: 30,
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Product info and quantity controls
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product name
                CustomText(
                  item?.name ?? "",
                  fontSize: 16,
                  color: ThemeConfig.textWhite,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 8),

                // Price
                CustomText(
                  '${item?.price} MP',
                  fontSize: 16,
                  color: ThemeConfig.textGold,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 12),

                // Quantity controls
                Row(
                  children: [
                    // Decrease button
                    GestureDetector(
                      onTap: () =>
                          controller.updateQuantity(item?.id ?? "", -1),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.red.withValues(alpha: 0.5),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.remove,
                          color: Colors.red,
                          size: 18,
                        ),
                      ),
                    ),

                    // Quantity display
                    Container(
                      width: 60,
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      child: Center(
                        child: CustomText(
                          '${cartItem.quantity}',
                          fontSize: 18,
                          color: ThemeConfig.textWhite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Increase button
                    GestureDetector(
                      onTap: () => controller.updateQuantity(item?.id ?? "", 1),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: ThemeConfig.success.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: ThemeConfig.success.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: ThemeConfig.success,
                          size: 18,
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Remove button
                    GestureDetector(
                      onTap: () => ConfirmDialog.show(
                        title: "Xác nhận xóa",
                        message: "Bạn có muốn xóa sản phẩm này khỏi giỏ hàng ?",
                        onConfirm: () =>
                            controller.removeFromCart(cartItem.id ?? ""),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build checkout section với total và checkout button
  Widget _buildCheckoutSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        border: Border(
          top: BorderSide(
            color: ThemeConfig.textGold.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(
                'Total Items:',
                fontSize: 16,
                color: ThemeConfig.textWhite,
              ),
              CustomText(
                '${controller.totalItems}',
                fontSize: 16,
                color: ThemeConfig.textGold,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(
                'Total Price:',
                fontSize: 20,
                color: ThemeConfig.textWhite,
                fontWeight: FontWeight.bold,
              ),
              CustomText(
                '${controller.totalPrice.toInt()} MP',
                fontSize: 24,
                color: ThemeConfig.textGold,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Checkout button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: controller.checkout,
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeConfig.textGold,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
              child: const CustomText(
                'Checkout',
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
