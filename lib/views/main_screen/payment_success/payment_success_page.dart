import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../configs/styles/theme_config.dart';
import '../../../widget/custom_text.dart';
import 'payment_success_controller.dart';

class PaymentSuccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentSuccessController>(() => PaymentSuccessController());
  }
}

class PaymentSuccessPage extends GetView<PaymentSuccessController> {
  const PaymentSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Obx(() {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                // Success icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ThemeConfig.success.withOpacity(0.2),
                    border: Border.all(
                      color: ThemeConfig.success,
                      width: 4,
                    ),
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: ThemeConfig.success,
                    size: 80,
                  ),
                ),

                const SizedBox(height: 30),

                // Success title
                const CustomText(
                  'Thanh toán thành công!',
                  fontSize: 32,
                  color: ThemeConfig.textGold,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                // Success message
                CustomText(
                  'Cảm ơn bạn đã mua hàng.\nĐơn hàng của bạn đang được xử lý.',
                  fontSize: 16,
                  color: ThemeConfig.textWhite.withOpacity(0.8),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // Order summary
                _buildOrderSummary(),

                const SizedBox(height: 40),

                // Reward points info
                _buildRewardPointsInfo(),

                const SizedBox(height: 40),

                // Action buttons
                _buildActionButtons(),

                const SizedBox(height: 20),
              ],
            ),
          );
        }),
      ),
    );
  }

  /// Build order summary
  Widget _buildOrderSummary() {
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
            'Thông tin đơn hàng',
            fontSize: 20,
            color: ThemeConfig.textGold,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 20),
          Obx(() {
            return Column(
              children: [
                _buildInfoRow(
                  icon: Icons.receipt_long,
                  label: 'Mã đơn hàng',
                  value: controller.orderId,
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  icon: Icons.payment,
                  label: 'Tổng thanh toán',
                  value: '${controller.totalAmount.toStringAsFixed(0)} MP',
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  icon: Icons.card_giftcard,
                  label: 'Điểm thưởng nhận được',
                  value: '+${controller.rewardPoints.toStringAsFixed(0)} RP',
                ),
                if (controller.selectedVoucher != null) ...[
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    icon: Icons.local_offer,
                    label: 'Voucher đã dùng',
                    value: controller.selectedVoucher!['code'] ?? '',
                  ),
                ],
              ],
            );
          }),
        ],
      ),
    );
  }

  /// Build info row
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: ThemeConfig.textGold,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: CustomText(
            label,
            fontSize: 14,
            color: ThemeConfig.textWhite.withOpacity(0.8),
          ),
        ),
        CustomText(
          value,
          fontSize: 16,
          color: ThemeConfig.textGold,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }

  /// Build reward points info
  Widget _buildRewardPointsInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ThemeConfig.textGold.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ThemeConfig.textGold.withOpacity(0.2),
              border: Border.all(
                color: ThemeConfig.textGold,
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.card_giftcard,
              color: ThemeConfig.textGold,
              size: 32,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  'Điểm thưởng',
                  fontSize: 14,
                  color: ThemeConfig.textWhite,
                ),
                const SizedBox(height: 4),
                Obx(() => CustomText(
                      '+${controller.rewardPoints.toStringAsFixed(0)} RP',
                      fontSize: 24,
                      color: ThemeConfig.textGold,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 4),
                const CustomText(
                  'Đã được cộng vào tài khoản',
                  fontSize: 12,
                  color: ThemeConfig.textWhite,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build action buttons
  Widget _buildActionButtons() {
    return Column(
      children: [
        // Back to home button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: controller.backToHome,
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeConfig.textGold,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
            ),
            child: const CustomText(
              'Về trang chủ',
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // View orders button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: controller.viewOrders,
            style: OutlinedButton.styleFrom(
              foregroundColor: ThemeConfig.textGold,
              side: BorderSide(
                color: ThemeConfig.textGold,
                width: 2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const CustomText(
              'Xem đơn hàng',
              fontSize: 18,
              color: ThemeConfig.textGold,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

