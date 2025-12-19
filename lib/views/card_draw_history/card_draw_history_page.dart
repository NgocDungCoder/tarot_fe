import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../configs/routes/route.dart';
import '../../../configs/styles/theme_config.dart';
import '../../../models/card_draw_history.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/video_background.dart';
import '../card_detail/card_detail_page.dart';
import 'card_draw_history_controller.dart';

class CardDrawHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CardDrawHistoryController>(() => CardDrawHistoryController());
  }
}

class CardDrawHistoryPage extends GetView<CardDrawHistoryController> {
  const CardDrawHistoryPage({super.key});

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
          'Lịch sử rút bài',
          fontSize: 24,
          color: ThemeConfig.textGold,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _showClearDialog,
            icon: const Icon(
              Icons.delete_outline,
              color: ThemeConfig.textGold,
            ),
            tooltip: 'Xóa tất cả',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search and filter section
            _buildSearchAndFilter(),

            // Histories list
            Expanded(
              child: Obx(() {
                if (controller.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: ThemeConfig.textGold,
                    ),
                  );
                }

                final histories = controller.filteredHistories;
                if (histories.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.style_outlined,
                          size: 64,
                          color: ThemeConfig.textWhite.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        CustomText(
                          controller.searchQuery.isEmpty
                              ? 'Chưa có lịch sử rút bài nào'
                              : 'Không tìm thấy kết quả',
                          fontSize: 16,
                          color: ThemeConfig.textWhite.withOpacity(0.7),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: histories.length,
                  itemBuilder: (context, index) {
                    return _buildHistoryCard(histories[index]);
                  },
                );
              }),
            ),
          ],
        ),
      ),
      ),);
  }

  /// Build search and filter section
  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          // Search bar
          TextField(
            onChanged: controller.setSearchQuery,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Tìm kiếm lá bài...',
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
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('all', 'Tất cả'),
                const SizedBox(width: 8),
                _buildFilterChip('normal', 'Lá xuôi'),
                const SizedBox(width: 8),
                _buildFilterChip('reversed', 'Lá ngược'),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// Build filter chip
  Widget _buildFilterChip(String value, String label) {
    return Obx(() {
      final isSelected = controller.filterReversed == value;
      return FilterChip(
        label: CustomText(
          label,
          fontSize: 14,
          color: isSelected ? Colors.black : ThemeConfig.textWhite,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        selected: isSelected,
        onSelected: (selected) {
          controller.setFilterReversed(value);
        },
        selectedColor: ThemeConfig.textGold,
        backgroundColor: Colors.black.withOpacity(0.6),
        side: BorderSide(
          color: isSelected
              ? ThemeConfig.textGold
              : ThemeConfig.textGold.withOpacity(0.3),
        ),
      );
    });
  }

  /// Build history card
  Widget _buildHistoryCard(CardDrawHistory history) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ThemeConfig.textGold.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToCardDetail(history),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Card image
                Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 120,
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
                          history.cardImagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: ThemeConfig.deepPurple.withOpacity(0.5),
                              child: const Icon(
                                Icons.style,
                                color: ThemeConfig.textGold,
                                size: 40,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    // Reversed badge
                    if (history.isReversed)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const CustomText(
                            'NGƯỢC',
                            fontSize: 8,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(width: 16),

                // Card info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        history.cardNameVi,
                        fontSize: 18,
                        color: ThemeConfig.textGold,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 4),
                      CustomText(
                        history.cardName,
                        fontSize: 14,
                        color: ThemeConfig.textWhite.withOpacity(0.7),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: ThemeConfig.textWhite.withOpacity(0.7),
                          ),
                          const SizedBox(width: 4),
                          CustomText(
                            _formatDate(history.drawnAt),
                            fontSize: 12,
                            color: ThemeConfig.textWhite.withOpacity(0.7),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Arrow icon
                Icon(
                  Icons.chevron_right,
                  color: ThemeConfig.textGold.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Format date
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Vừa xong';
        }
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

  /// Navigate to card detail
  void _navigateToCardDetail(CardDrawHistory history) {
    Get.toNamed(
      Routes.cardDetail.sp,
      arguments: {
        'cardId': history.cardId,
        'isReversed': history.isReversed,
      },
    );
  }

  /// Show clear dialog
  void _showClearDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const CustomText(
          'Xóa tất cả lịch sử',
          fontSize: 20,
          color: ThemeConfig.textGold,
          fontWeight: FontWeight.bold,
        ),
        content: const CustomText(
          'Bạn có chắc chắn muốn xóa tất cả lịch sử rút bài? Hành động này không thể hoàn tác.',
          fontSize: 16,
          color: Colors.white,
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
            onPressed: () {
              controller.clearHistories();
              Get.back();
              Get.snackbar(
                'Thành công',
                'Đã xóa tất cả lịch sử rút bài',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text(
              'Xóa',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
