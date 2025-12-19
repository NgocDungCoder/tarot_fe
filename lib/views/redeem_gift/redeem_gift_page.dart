import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tarot_fe/models/gift_entity.dart';
import '../../../configs/styles/theme_config.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/video_background.dart';
import 'redeem_gift_controller.dart';

class RedeemGiftBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RedeemGiftController>(() => RedeemGiftController(Get.find()));
  }
}

class RedeemGiftPage extends GetView<RedeemGiftController> {
  const RedeemGiftPage({super.key});

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
          'Đổi quà tặng',
          fontSize: 24,
          color: ThemeConfig.textGold,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // User reward points info
            _buildRewardPointsHeader(),

            // Search and filter section
            _buildSearchAndFilter(),

            // Gifts list
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: ThemeConfig.textGold,
                    ),
                  );
                }

                final gifts = controller.filteredGifts;
                if (gifts.isEmpty) {
                  return Center(
                    child: CustomText(
                      'Không tìm thấy quà tặng nào',
                      fontSize: 16,
                      color: ThemeConfig.textWhite.withOpacity(0.7),
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: gifts.length,
                  itemBuilder: (context, index) {
                    return _buildGiftCard(gifts[index]);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    ),);
  }

  /// Build reward points header
  Widget _buildRewardPointsHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
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
            child: Image.asset(
              "assets/icons/gift.png",
              height: 32,
              width: 32,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  'Điểm thưởng của bạn',
                  fontSize: 14,
                  color: ThemeConfig.textWhite,
                ),
                const SizedBox(height: 4),
                CustomText(
                  '${controller.currentRewardPoints} RP',
                  fontSize: 28,
                  color: ThemeConfig.textGold,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build search and filter section
  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Search bar
          TextField(
            onChanged: controller.setSearchQuery,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Tìm kiếm quà tặng...',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              prefixIcon: const Icon(
                Icons.search,
                color: ThemeConfig.textGold,
              ),
              filled: true,
              fillColor: Colors.black.withOpacity(0.6),
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
            ),
          ),
          const SizedBox(height: 12),
          // Category filter
          Obx(() => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: controller.categories.map((category) {
                    final isSelected = controller.selectedCategory == category.name;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: CustomText(
                          category.name ?? "",
                          fontSize: 14,
                          color:
                              isSelected ? Colors.black : ThemeConfig.textWhite,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        selected: isSelected,
                        onSelected: (_) {
                          controller.setCategory(category.name ?? "");
                        },
                        selectedColor: ThemeConfig.textGold,
                        backgroundColor: Colors.black.withOpacity(0.6),
                        side: BorderSide(
                          color: isSelected
                              ? ThemeConfig.textGold
                              : ThemeConfig.textGold.withOpacity(0.3),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              )),
        ],
      ),
    );
  }


  /// Build gift card
  Widget _buildGiftCard(GiftEntity gift) {
    final canRedeem = controller.canRedeem(gift);

    return GestureDetector(
      onTap: () => _showGiftDetail(gift),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: canRedeem
                ? ThemeConfig.textGold.withOpacity(0.5)
                : Colors.grey.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gift image
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(gift.thumbnail ?? ""),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) {
                      // Handle error
                    },
                  ),
                ),
                child: Stack(
                  children: [
                    // Overlay if not available
                    if (gift.stock! <= 0)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        child: const Center(
                          child: CustomText(
                            'Hết hàng',
                            fontSize: 16,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Gift info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    gift.name ?? "",
                    fontSize: 16,
                    color: ThemeConfig.textWhite,
                    fontWeight: FontWeight.bold,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.card_giftcard,
                            color: ThemeConfig.textGold,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          CustomText(
                            '${gift.price} RP',
                            fontSize: 14,
                            color: ThemeConfig.textGold,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      if (!canRedeem)
                        const Icon(
                          Icons.lock,
                          color: Colors.grey,
                          size: 16,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show gift detail dialog
  void _showGiftDetail(GiftEntity gift) {
    final canRedeem = controller.canRedeem(gift);

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: ThemeConfig.textGold.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Gift image
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(gift.thumbnail ?? ""),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Gift info
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        gift.name ?? "",
                        fontSize: 24,
                        color: ThemeConfig.textGold,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 16),
                      CustomText(
                        gift.description ?? "",
                        fontSize: 14,
                        color: ThemeConfig.textWhite,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CustomText(
                                'Điểm cần dùng',
                                fontSize: 14,
                                color: ThemeConfig.textWhite,
                              ),
                              const SizedBox(height: 4),
                              CustomText(
                                '${gift.price} RP',
                                fontSize: 20,
                                color: ThemeConfig.textGold,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const CustomText(
                                'Điểm của bạn',
                                fontSize: 14,
                                color: ThemeConfig.textWhite,
                              ),
                              const SizedBox(height: 4),
                              CustomText(
                                '${controller.currentRewardPoints} RP',
                                fontSize: 20,
                                color: controller.currentRewardPoints >=
                                    (gift.price ?? 0)
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: canRedeem && (gift.stock! > 0)
                              ? () {
                                  Get.back();
                                  _showConfirmDialog(gift);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ThemeConfig.textGold,
                            foregroundColor: Colors.black,
                            disabledBackgroundColor: Colors.grey.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: CustomText(
                            canRedeem && (gift.stock! > 0)
                                ? 'Đổi quà ngay'
                                : (gift.stock! > 0)
                                    ? 'Không đủ điểm'
                                    : 'Hết hàng',
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Show confirm redeem dialog
  void _showConfirmDialog(GiftEntity gift) {
    final canRedeem = controller.canRedeem(gift);
    final currentPoints = controller.currentRewardPoints;

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const CustomText(
          'Xác nhận đổi quà',
          fontSize: 20,
          color: ThemeConfig.textGold,
          fontWeight: FontWeight.bold,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              'Bạn có chắc chắn muốn đổi quà này?',
              fontSize: 16,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              label: 'Quà tặng',
              value: gift.name ?? "",
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              label: 'Điểm cần dùng',
              value: '${gift.price} RP',
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              label: 'Điểm còn lại',
              value: '${currentPoints - (gift.price ?? 0)} RP',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Hủy',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              // await controller.redeemGift(gift);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
            ),
            child: const Text(
              'Xác nhận',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  /// Build info row for dialog
  Widget _buildInfoRow({required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          label,
          fontSize: 14,
          color: ThemeConfig.textWhite.withOpacity(0.8),
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
}
