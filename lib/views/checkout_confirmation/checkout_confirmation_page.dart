import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tarot_fe/models/cart_item_entity.dart';
import '../../../configs/styles/theme_config.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/video_background.dart';
import '../../widget/custom_snackbar.dart';
import 'checkout_confirmation_controller.dart';

class CheckoutConfirmationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CheckoutConfirmationController>(
        () => CheckoutConfirmationController(Get.find()));
  }
}

class CheckoutConfirmationPage extends GetView<CheckoutConfirmationController> {
  const CheckoutConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return VideoBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back,
              color: ThemeConfig.textGold,
              size: 28,
            ),
          ),
          title: const CustomText(
            'Xác nhận thanh toán',
            fontSize: 24,
            color: ThemeConfig.textGold,
            fontWeight: FontWeight.bold,
          ),
          centerTitle: true,
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: Lottie.asset(
                'assets/lottie/loading_ball.json',
                repeat: true,
                height: 70,
                width: 70,
                fit: BoxFit.contain,
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                // Danh sách sản phẩm sẽ mua
                _buildProductsSection(),

                const SizedBox(height: 30),

                // Chọn voucher
                _buildVoucherSection(),

                const SizedBox(height: 30),

                // Thông tin giao hàng
                _buildShippingSection(),

                const SizedBox(height: 30),

                // Tóm tắt thanh toán
                _buildSummarySection(),

                const SizedBox(height: 30),

                // Nút xác nhận thanh toán
                _buildConfirmButton(),

                const SizedBox(height: 20),
              ],
            ),
          );
        }),
      ),
    );
  }

  /// Build products section - danh sách sản phẩm sẽ mua
  Widget _buildProductsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          'Sản phẩm',
          fontSize: 20,
          color: ThemeConfig.textGold,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 15),
        Obx(() {
          if (controller.cartItems.isEmpty) {
            return const Center(
              child: CustomText(
                'Không có sản phẩm',
                fontSize: 16,
                color: ThemeConfig.textWhite,
              ),
            );
          }

          return Column(
            children: controller.cartItems.map((item) {
              return _buildProductItem(item);
            }).toList(),
          );
        }),
      ],
    );
  }

  /// Build product item card
  Widget _buildProductItem(CartItemEntity item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: ThemeConfig.textGold.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Product image
          Container(
            width: 70,
            height: 70,
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
                item.productId?.thumbnail ?? "",
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

          // Product info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  item.productId?.name ?? "",
                  fontSize: 16,
                  color: ThemeConfig.textWhite,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      'Số lượng: ${item.quantity}',
                      fontSize: 14,
                      color: ThemeConfig.textWhite.withOpacity(0.8),
                    ),
                    CustomText(
                      '${item.price} MP',
                      fontSize: 16,
                      color: ThemeConfig.textGold,
                      fontWeight: FontWeight.bold,
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

  /// Build voucher section - chọn voucher
  Widget _buildVoucherSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CustomText(
              'Voucher',
              fontSize: 20,
              color: ThemeConfig.textGold,
              fontWeight: FontWeight.bold,
            ),
            if (controller.selectedVoucher.value != null)
              GestureDetector(
                onTap: controller.removeVoucher,
                child: const CustomText(
                  'Xóa',
                  fontSize: 14,
                  color: Colors.red,
                ),
              ),
          ],
        ),
        const SizedBox(height: 15),
        GestureDetector(
          onTap: selectVoucher,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: ThemeConfig.textGold.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.local_offer,
                  color: ThemeConfig.textGold,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(() {
                    if (controller.selectedVoucher.value != null) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            controller.selectedVoucher.value?.code ?? '',
                            fontSize: 16,
                            color: ThemeConfig.textGold,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(height: 4),
                          CustomText(
                            'Giảm ${controller.selectedVoucher.value?.value}%',
                            fontSize: 12,
                            color: ThemeConfig.textWhite.withOpacity(0.7),
                          ),
                        ],
                      );
                    }
                    return const CustomText(
                      'Chọn voucher',
                      fontSize: 16,
                      color: ThemeConfig.textWhite,
                    );
                  }),
                ),
                Icon(
                  Icons.chevron_right,
                  color: ThemeConfig.textGold.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Build shipping section - thông tin giao hàng
  Widget _buildShippingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CustomText(
              'Thông tin giao hàng',
              fontSize: 20,
              color: ThemeConfig.textGold,
              fontWeight: FontWeight.bold,
            ),
            GestureDetector(
              onTap: controller.editShippingInfo,
              child: const CustomText(
                'Chỉnh sửa',
                fontSize: 14,
                color: ThemeConfig.textGold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: ThemeConfig.textGold.withOpacity(0.3),
              width: 1,
            ),
          ),
          child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildShippingInfoRow(
                  icon: Icons.person,
                  label: 'Người nhận',
                  value: controller.nameController.text,
                ),
                const SizedBox(height: 12),
                _buildShippingInfoRow(
                  icon: Icons.phone,
                  label: 'Số điện thoại',
                  value: controller.phoneController.text,
                ),
                const SizedBox(height: 12),
                _buildShippingInfoRow(
                  icon: Icons.location_on,
                  label: 'Địa chỉ',
                  value: controller.addressController.text,
                ),
              ],
            ),
        ),
      ],
    );
  }

  /// Build shipping info row
  Widget _buildShippingInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: ThemeConfig.textGold,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                label,
                fontSize: 12,
                color: ThemeConfig.textWhite.withOpacity(0.7),
              ),
              const SizedBox(height: 4),
              CustomText(
                value,
                fontSize: 14,
                color: ThemeConfig.textWhite,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build summary section - tóm tắt thanh toán
  Widget _buildSummarySection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ThemeConfig.deepPurple.withOpacity(0.8),
            ThemeConfig.secondaryColor.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ThemeConfig.textGold.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            'Tóm tắt thanh toán',
            fontSize: 20,
            color: ThemeConfig.textGold,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 20),
          Obx(() {
            // Truy cập trực tiếp selectedVoucher để Obx theo dõi được
            final selectedVoucher = controller.selectedVoucher;
            final subtotal = controller.subtotal;
            final voucherDiscount = controller.voucherDiscount;
            final totalAmount = controller.totalAmount;
            final rewardPoints = controller.rewardPoints;

            return Column(
              children: [
                _buildSummaryRow(
                  label: 'Tổng tiền',
                  value: '${subtotal.toStringAsFixed(0)} MP',
                ),
                if (voucherDiscount > 0) ...[
                  const SizedBox(height: 8),
                  _buildSummaryRow(
                    label: 'Giảm giá voucher',
                    value: '-${voucherDiscount.toStringAsFixed(0)} MP',
                    isDiscount: true,
                  ),
                ],
                const SizedBox(height: 8),
                _buildSummaryRow(
                  label: 'Điểm thưởng (10%)',
                  value: '+${rewardPoints.toStringAsFixed(0)} RP',
                  isReward: true,
                ),
                const Divider(
                  color: ThemeConfig.textGold,
                  thickness: 1,
                  height: 24,
                ),
                _buildSummaryRow(
                  label: 'Tổng thanh toán',
                  value: '${totalAmount.toStringAsFixed(0)} MP',
                  isTotal: true,
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  /// Build summary row
  Widget _buildSummaryRow({
    required String label,
    required String value,
    bool isDiscount = false,
    bool isReward = false,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          label,
          fontSize: isTotal ? 18 : 16,
          color: ThemeConfig.textWhite,
          fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
        ),
        CustomText(
          value,
          fontSize: isTotal ? 20 : 16,
          color: isDiscount
              ? Colors.green
              : isReward
                  ? ThemeConfig.textGold
                  : ThemeConfig.textGold,
          fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
        ),
      ],
    );
  }

  /// Build confirm button
  Widget _buildConfirmButton() {
    return Obx(() {
      return SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: controller.canConfirm ? controller.confirmPayment : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: ThemeConfig.textGold,
            foregroundColor: Colors.black,
            disabledBackgroundColor: Colors.grey.shade700,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5,
          ),
          child: controller.isProcessing
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: Lottie.asset(
                    'assets/lottie/loading_ball.json',
                    repeat: true,
                    height: 70,
                    width: 70,
                    fit: BoxFit.contain,
                  ),
                )
              : const CustomText(
                  'Xác nhận thanh toán',
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
        ),
      );
    });
  }

  void selectVoucher() {
    Get.bottomSheet(
      Container(
        height: 800,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border.all(
            color: ThemeConfig.textGold.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              'Chọn voucher',
              fontSize: 20,
              color: ThemeConfig.textGold,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  ...controller.discounts.map((voucher) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: controller.selectedVoucher.value?.code ==
                                  voucher.code
                              ? ThemeConfig.textGold
                              : Colors.grey.shade700,
                          width: 2,
                        ),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.local_offer,
                          color: ThemeConfig.textGold,
                        ),
                        title: CustomText(
                          voucher.code ?? "",
                          fontSize: 16,
                          color: ThemeConfig.textGold,
                          fontWeight: FontWeight.bold,
                        ),
                        subtitle: CustomText(
                          voucher.description ?? "",
                          fontSize: 12,
                          color: ThemeConfig.textWhite.withOpacity(0.7),
                        ),
                        trailing: controller.selectedVoucher.value?.code ==
                                voucher.code
                            ? Icon(
                                Icons.check_circle,
                                color: ThemeConfig.textGold,
                              )
                            : null,
                        onTap: () {
                          controller.selectedVoucher.value = voucher;
                          Get.back();
                          CustomSnackbar.success(
                            duration: Duration(seconds: 1),
                            title: 'Đã chọn voucher',
                            message: 'Voucher ${voucher.code} đã được áp dụng',
                          );
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
