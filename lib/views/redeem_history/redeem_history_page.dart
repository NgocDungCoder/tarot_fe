import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../configs/styles/theme_config.dart';
import '../../../models/redeem_history.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/video_background.dart';
import 'redeem_history_controller.dart';

class RedeemHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RedeemHistoryController>(() => RedeemHistoryController());
  }
}

class RedeemHistoryPage extends GetView<RedeemHistoryController> {
  const RedeemHistoryPage({super.key});

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
          'Lịch sử đổi quà',
          fontSize: 24,
          color: ThemeConfig.textGold,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter chips
            _buildFilterChips(),

            // Redeem histories list
            Expanded(
              child: Obx(() {
                if (controller.isLoading) {
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

                final histories = controller.filteredRedeemHistories;
                if (histories.isEmpty) {
                  return Center(
                    child: CustomText(
                      'Chưa có lịch sử đổi quà nào',
                      fontSize: 16,
                      color: ThemeConfig.textWhite.withOpacity(0.7),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: histories.length,
                  itemBuilder: (context, index) {
                    return _buildRedeemHistoryCard(histories[index]);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    ),);
  }

  /// Build filter chips
  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Obx(() => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: controller.statuses.map((status) {
                final isSelected = controller.selectedStatus == status;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: CustomText(
                      controller.getStatusDisplayName(status),
                      fontSize: 14,
                      color: isSelected ? Colors.black : ThemeConfig.textWhite,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      controller.setStatus(status);
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
    );
  }

  /// Build redeem history card
  Widget _buildRedeemHistoryCard(RedeemHistory history) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ThemeConfig.textGold.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Gift image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: ThemeConfig.textGold.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: Image.asset(
                // history.gift.imagePath,
                "",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: ThemeConfig.deepPurple.withOpacity(0.5),
                    child: const Icon(
                      Icons.card_giftcard,
                      color: ThemeConfig.textGold,
                      size: 32,
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Gift info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  history.gift.name ?? "",
                  fontSize: 16,
                  color: ThemeConfig.textWhite,
                  fontWeight: FontWeight.bold,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.card_giftcard,
                      color: ThemeConfig.textGold,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    CustomText(
                      '${history.rewardPointsUsed} RP',
                      fontSize: 14,
                      color: ThemeConfig.textGold,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                CustomText(
                  _formatDate(history.redeemedAt),
                  fontSize: 12,
                  color: ThemeConfig.textWhite.withOpacity(0.7),
                ),
              ],
            ),
          ),

          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getStatusColor(history.status).withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _getStatusColor(history.status),
                width: 1,
              ),
            ),
            child: CustomText(
              history.statusDisplayName,
              fontSize: 12,
              color: _getStatusColor(history.status),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Get status color
  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return ThemeConfig.textGold;
    }
  }

  /// Format date
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} phút trước';
      }
      return '${difference.inHours} giờ trước';
    } else if (difference.inDays == 1) {
      return 'Hôm qua';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày trước';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

