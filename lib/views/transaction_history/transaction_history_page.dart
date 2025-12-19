import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../configs/styles/theme_config.dart';
import '../../../models/transaction.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/video_background.dart';
import 'transaction_history_controller.dart';

class TransactionHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransactionHistoryController>(() => TransactionHistoryController());
  }
}

class TransactionHistoryPage extends GetView<TransactionHistoryController> {
  const TransactionHistoryPage({super.key});

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
          'Lịch sử giao dịch',
          fontSize: 24,
          color: ThemeConfig.textGold,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search and filter section
            _buildSearchAndFilter(),

            // Transactions list
            Expanded(
              child: Obx(() {
                if (controller.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: ThemeConfig.textGold,
                    ),
                  );
                }

                final transactions = controller.filteredTransactions;
                if (transactions.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          size: 64,
                          color: ThemeConfig.textWhite.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        CustomText(
                          controller.searchQuery.isEmpty
                              ? 'Chưa có giao dịch nào'
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
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    return _buildTransactionCard(transactions[index]);
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
              hintText: 'Tìm kiếm giao dịch...',
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
          Obx(() => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: controller.filterOptions.map((option) {
                    final isSelected = controller.selectedFilter == option['value'];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: CustomText(
                          option['label'] ?? '',
                          fontSize: 14,
                          color: isSelected ? Colors.black : ThemeConfig.textWhite,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          controller.setFilter(option['value'] ?? 'all');
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

  /// Build transaction card
  Widget _buildTransactionCard(Transaction transaction) {
    final isPositive = transaction.isPositive;
    final color = isPositive ? Colors.green : Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          // Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.2),
              border: Border.all(
                color: color,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                transaction.typeIcon,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Transaction info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  transaction.typeDisplayName,
                  fontSize: 16,
                  color: ThemeConfig.textWhite,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 4),
                CustomText(
                  transaction.description,
                  fontSize: 14,
                  color: ThemeConfig.textWhite.withOpacity(0.7),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 12,
                      color: ThemeConfig.textWhite.withOpacity(0.5),
                    ),
                    const SizedBox(width: 4),
                    CustomText(
                      _formatDate(transaction.createdAt),
                      fontSize: 12,
                      color: ThemeConfig.textWhite.withOpacity(0.5),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(
                '${isPositive ? '+' : '-'}${transaction.amount.toStringAsFixed(0)}',
                fontSize: 18,
                color: color,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 4),
              CustomText(
                _getAmountUnit(transaction.type),
                fontSize: 12,
                color: ThemeConfig.textWhite.withOpacity(0.7),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Get amount unit based on transaction type
  String _getAmountUnit(TransactionType type) {
    switch (type) {
      case TransactionType.magicPointDeposit:
      case TransactionType.magicPointWithdraw:
        return 'MP';
      case TransactionType.rewardPointEarn:
      case TransactionType.rewardPointSpend:
        return 'RP';
    }
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
}

