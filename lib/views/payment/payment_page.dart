import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../configs/styles/theme_config.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/video_background.dart';
import 'payment_controller.dart';

class PaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentController>(() => PaymentController());
  }
}

class PaymentPage extends GetView<PaymentController> {
  const PaymentPage({super.key});

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
            'Deposit',
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
              const SizedBox(height: 20),

              // Required amount warning (if from checkout)
              if (controller.requiredAmount != null) _buildRequiredAmountWarning(),

              const SizedBox(height: 20),

              // Amount input section
              Obx(() => _buildAmountInput()),

              const SizedBox(height: 30),

              // Show different content based on confirmation state
              Obx(() {
                if (!controller.isAmountConfirmed) {
                  // Show preview and confirm button
                  return _buildPreviewAndConfirm();
                } else {
                  // Show payment info and edit button
                  return _buildPaymentInfo();
                }
              }),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      ),
    );
  }

  /// Build required amount warning
  Widget _buildRequiredAmountWarning() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.orange,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            color: Colors.orange,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  'Additional deposit required',
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 4),
                CustomText(
                  '${controller.requiredAmount!.toStringAsFixed(0)} MP',
                  fontSize: 18,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build amount input section
  Widget _buildAmountInput() {
    final isEditing = !controller.isAmountConfirmed;
    return Container(
      padding: const EdgeInsets.all(24),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(
                'Enter amount to deposit (USD)',
                fontSize: 16,
                color: ThemeConfig.textWhite,
              ),
              if (!isEditing)
                IconButton(
                  onPressed: controller.editAmount,
                  icon: const Icon(
                    Icons.edit,
                    color: ThemeConfig.textGold,
                    size: 20,
                  ),
                  tooltip: 'Edit',
                ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controller.amountController,
            keyboardType: TextInputType.number,
            enabled: isEditing,
            style: TextStyle(
              color: isEditing ? ThemeConfig.textGold : ThemeConfig.textGold.withOpacity(0.7),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              hintText: '0',
              hintStyle: TextStyle(
                color: ThemeConfig.textGold.withOpacity(0.5),
                fontSize: 24,
              ),
              prefixIcon: const Icon(
                Icons.attach_money,
                color: ThemeConfig.textGold,
                size: 28,
              ),
              filled: true,
              fillColor: Colors.black.withOpacity(0.3),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: ThemeConfig.textGold.withOpacity(0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: ThemeConfig.textGold.withOpacity(0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: ThemeConfig.textGold,
                  width: 2,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: ThemeConfig.textGold.withOpacity(0.3),
                ),
              ),
            ),
            onChanged: controller.setDepositAmount,
          ),
          const SizedBox(height: 12),
          const CustomText(
            'Exchange rate: 1 USD = 10 MP',
            fontSize: 12,
            color: ThemeConfig.textWhite,
          ),
        ],
      ),
    );
  }

  /// Build preview and confirm button (when amount not confirmed)
  Widget _buildPreviewAndConfirm() {
    if (controller.depositAmount == null || controller.depositAmount! <= 0) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        // Magic Points preview
        _buildMagicPointsInfo(),
        const SizedBox(height: 30),
        // Confirm button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: controller.confirmAmount,
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeConfig.textGold,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
            ),
            child: const CustomText(
              'Confirm',
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  /// Build payment info section (when amount confirmed)
  Widget _buildPaymentInfo() {
    return Column(
      children: [
        // Magic Points info
        _buildMagicPointsInfo(),
        const SizedBox(height: 30),

        // Expiry time warning
        _buildExpiryWarning(),

        const SizedBox(height: 30),

        // QR Code section
        _buildQRCodeSection(),

        const SizedBox(height: 30),

        // Bank account info
        _buildBankAccountInfo(),

        const SizedBox(height: 30),

        // Payment reference code
        _buildPaymentReferenceCode(),

        const SizedBox(height: 40),

        // Action buttons
        _buildActionButtons(),
      ],
    );
  }

  /// Build magic points info
  Widget _buildMagicPointsInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.purple.withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          // Sparkling star icon
          _SparklingStarIcon(),
          const SizedBox(width: 16),
          // Amount and MP info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  '\$${(controller.confirmedAmount ?? controller.depositAmount ?? 0).toStringAsFixed(2)}',
                  fontSize: 20,
                  color: ThemeConfig.textGold,
                  fontWeight: FontWeight.bold,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                CustomText(
                  '${controller.magicPointsToReceive.toStringAsFixed(0)} MP',
                  fontSize: 18,
                  color: Colors.purple.shade300,
                  fontWeight: FontWeight.bold,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build expiry warning
  Widget _buildExpiryWarning() {
    return Obx(() {
      final isExpired = controller.isExpired;
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isExpired
              ? Colors.red.withOpacity(0.2)
              : Colors.orange.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isExpired ? Colors.red : Colors.orange,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isExpired ? Icons.error_outline : Icons.access_time,
              color: isExpired ? Colors.red : Colors.orange,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    isExpired ? 'Payment Expired' : 'Time Remaining',
                    fontSize: 14,
                    color: ThemeConfig.textWhite,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 4),
                  CustomText(
                    isExpired
                        ? 'Please create a new transaction'
                        : controller.formattedRemainingTime,
                    fontSize: 18,
                    color: isExpired ? Colors.red : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  /// Build QR code section
  Widget _buildQRCodeSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ThemeConfig.textGold.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          const CustomText(
            'Scan QR Code to Pay',
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 20),
          // QR Code placeholder - sẽ thay bằng package qr_flutter sau
          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.qr_code,
                  size: 80,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 12),
                const CustomText(
                  'QR Code',
                  fontSize: 16,
                  color: Colors.black,
                ),
                const SizedBox(height: 8),
                CustomText(
                  controller.qrCodeData,
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const CustomText(
            'Open your banking app and scan the QR code to pay',
            fontSize: 14,
            color: Colors.black,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build bank account info
  Widget _buildBankAccountInfo() {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(
                'Bank Information',
                fontSize: 18,
                color: ThemeConfig.textGold,
                fontWeight: FontWeight.bold,
              ),
              IconButton(
                onPressed: controller.copyBankAccount,
                icon: const Icon(
                  Icons.copy,
                  color: ThemeConfig.textGold,
                  size: 20,
                ),
                tooltip: 'Copy',
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoRow(
            icon: Icons.account_balance,
            label: 'Bank',
            value: controller.bankAccountInfo['bankName'] ?? '',
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.credit_card,
            label: 'Account Number',
            value: controller.bankAccountInfo['accountNumber'] ?? '',
            isHighlight: true,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.person,
            label: 'Account Holder',
            value: controller.bankAccountInfo['accountHolder'] ?? '',
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.location_on,
            label: 'Branch',
            value: controller.bankAccountInfo['branch'] ?? '',
          ),
        ],
      ),
    );
  }

  /// Build payment reference code
  Widget _buildPaymentReferenceCode() {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(
                'Transfer Reference Code',
                fontSize: 18,
                color: ThemeConfig.textGold,
                fontWeight: FontWeight.bold,
              ),
              IconButton(
                onPressed: controller.copyReferenceCode,
                icon: const Icon(
                  Icons.copy,
                  color: ThemeConfig.textGold,
                  size: 20,
                ),
                tooltip: 'Copy',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ThemeConfig.textGold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: ThemeConfig.textGold,
                width: 2,
              ),
            ),
            child: Obx(() => CustomText(
                  controller.paymentReferenceCode,
                  fontSize: 24,
                  color: ThemeConfig.textGold,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center,
                )),
          ),
          const SizedBox(height: 12),
          const CustomText(
            '⚠️ Important: Please enter this code correctly in the transfer content for automatic payment confirmation.',
            fontSize: 12,
            color: Colors.orange,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build info row
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool isHighlight = false,
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
                fontSize: isHighlight ? 18 : 16,
                color: isHighlight ? ThemeConfig.textGold : ThemeConfig.textWhite,
                fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build action buttons
  Widget _buildActionButtons() {
    return Column(
      children: [
        // Confirm payment button
        Obx(() => SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: (controller.depositAmount == null || controller.isExpired)
                    ? null
                    : controller.confirmPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeConfig.textGold,
                  foregroundColor: Colors.black,
                  disabledBackgroundColor: Colors.grey.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: CustomText(
                  controller.isExpired
                      ? 'Expired'
                      : 'Payment Completed',
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
        const SizedBox(height: 16),
        // Back button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: () => Get.back(),
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
              'Back',
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

/// Sparkling star icon widget with animation
class _SparklingStarIcon extends StatefulWidget {
  const _SparklingStarIcon();

  @override
  State<_SparklingStarIcon> createState() => _SparklingStarIconState();
}

class _SparklingStarIconState extends State<_SparklingStarIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Icon(
            Icons.star,
            color: Colors.purple.shade300,
            size: 40,
          ),
        );
      },
    );
  }
}
