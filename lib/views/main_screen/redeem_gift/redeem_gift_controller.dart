import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../configs/styles/theme_config.dart';
import '../../../models/gift.dart';
import '../../../models/redeem_history.dart';
import '../../../widget/custom_snackbar.dart';
import '../../../widget/custom_text.dart';
import '../redeem_history/redeem_history_page.dart';
import '../user/user_controller.dart';
import '../redeem_history/redeem_history_controller.dart';
import '../transaction_history/transaction_history_controller.dart';
import '../transaction_history/transaction_history_page.dart';
import '../../../models/transaction.dart';

class RedeemGiftController extends GetxController {
  // Loading state
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  // List of available gifts
  final _gifts = <Gift>[].obs;
  List<Gift> get gifts => _gifts;

  // User's current reward points
  int get currentRewardPoints {
    if (Get.isRegistered<UserController>()) {
      return Get.find<UserController>().user?.rewardPoints ?? 0;
    }
    return 0;
  }

  // Filter by category
  final _selectedCategory = 'all'.obs;
  String get selectedCategory => _selectedCategory.value;

  // Search query
  final _searchQuery = ''.obs;
  String get searchQuery => _searchQuery.value;

  @override
  void onInit() {
    super.onInit();
    _loadGifts();
  }

  /// Load gifts from assets/images/gift*.jpg
  void _loadGifts() {
    _isLoading.value = true;

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 500), () {
      // Create sample gifts với hình ảnh từ assets/images/gift1.jpg đến gift6.jpg
      final sampleGifts = [
        Gift(
          id: 'gift1',
          name: 'Mystic Crystal Ball',
          nameVi: 'Quả cầu pha lê thần bí',
          description: 'Quả cầu pha lê cổ điển với khả năng nhìn thấy tương lai. Hoàn hảo cho các buổi tiên tri.',
          rewardPointsRequired: 500,
          imagePath: 'assets/images/gift1.jpg',
          category: 'decoration',
          isAvailable: true,
        ),
        Gift(
          id: 'gift2',
          name: 'Tarot Card Set Premium',
          nameVi: 'Bộ bài Tarot cao cấp',
          description: 'Bộ bài Tarot được làm thủ công với thiết kế độc đáo và chất lượng cao.',
          rewardPointsRequired: 800,
          imagePath: 'assets/images/gift2.jpg',
          category: 'cards',
          isAvailable: true,
        ),
        Gift(
          id: 'gift3',
          name: 'Crystal Pendant',
          nameVi: 'Mặt dây chuyền pha lê',
          description: 'Mặt dây chuyền pha lê tự nhiên với năng lượng tích cực, giúp cân bằng cảm xúc.',
          rewardPointsRequired: 300,
          imagePath: 'assets/images/gift3.jpg',
          category: 'jewelry',
          isAvailable: true,
        ),
        Gift(
          id: 'gift4',
          name: 'Incense Set',
          nameVi: 'Bộ nhang thơm',
          description: 'Bộ nhang thơm với nhiều mùi hương khác nhau, tạo không gian thiền định hoàn hảo.',
          rewardPointsRequired: 200,
          imagePath: 'assets/images/gift4.jpg',
          category: 'wellness',
          isAvailable: true,
        ),
        Gift(
          id: 'gift5',
          name: 'Moon Phase Calendar',
          nameVi: 'Lịch chu kỳ mặt trăng',
          description: 'Lịch theo dõi chu kỳ mặt trăng với thiết kế đẹp mắt, giúp bạn kết nối với tự nhiên.',
          rewardPointsRequired: 400,
          imagePath: 'assets/images/gift5.jpg',
          category: 'decoration',
          isAvailable: true,
        ),
        Gift(
          id: 'gift6',
          name: 'Mystic Book Collection',
          nameVi: 'Bộ sưu tập sách huyền bí',
          description: 'Bộ sưu tập các cuốn sách về tarot, chiêm tinh và huyền học từ các tác giả nổi tiếng.',
          rewardPointsRequired: 1000,
          imagePath: 'assets/images/gift6.jpg',
          category: 'books',
          isAvailable: true,
        ),
      ];

      _gifts.assignAll(sampleGifts);
      _isLoading.value = false;
    });
  }

  /// Get filtered gifts based on category and search query
  List<Gift> get filteredGifts {
    var filtered = _gifts.where((gift) {
      // Filter by category
      if (_selectedCategory.value != 'all' &&
          gift.category != _selectedCategory.value) {
        return false;
      }

      // Filter by search query
      if (_searchQuery.value.isNotEmpty) {
        final query = _searchQuery.value.toLowerCase();
        return gift.nameVi.toLowerCase().contains(query) ||
            gift.name.toLowerCase().contains(query) ||
            gift.description.toLowerCase().contains(query);
      }

      return true;
    }).toList();

    return filtered;
  }

  /// Get unique categories
  List<String> get categories {
    final cats = _gifts.map((g) => g.category).toSet().toList();
    cats.insert(0, 'all');
    return cats;
  }

  /// Set selected category
  void setCategory(String category) {
    _selectedCategory.value = category;
  }

  /// Set search query
  void setSearchQuery(String query) {
    _searchQuery.value = query;
  }

  /// Check if user can redeem a gift
  bool canRedeem(Gift gift) {
    return currentRewardPoints >= gift.rewardPointsRequired &&
        gift.isAvailable;
  }

  /// Redeem a gift
  Future<void> redeemGift(Gift gift) async {
    // Check if user has enough points
    if (!canRedeem(gift)) {
      CustomSnackbar.error(
        title: 'Không đủ điểm',
        message: 'Bạn cần ${gift.rewardPointsRequired} điểm thưởng để đổi quà này. Bạn hiện có $currentRewardPoints điểm.',
      );
      return;
    }

    // Show confirmation dialog
    final confirmed = await Get.dialog<bool>(
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
              value: gift.nameVi,
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              label: 'Điểm cần dùng',
              value: '${gift.rewardPointsRequired} RP',
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              label: 'Điểm còn lại',
              value: '${currentRewardPoints - gift.rewardPointsRequired} RP',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text(
              'Hủy',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
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

    if (confirmed != true) return;

    // Simulate API call
    _isLoading.value = true;
    try {
      await Future.delayed(const Duration(seconds: 1));

      // Update user's reward points
      if (Get.isRegistered<UserController>()) {
        final userController = Get.find<UserController>();
        final currentUser = userController.user;
        if (currentUser != null) {
          final updatedUser = currentUser.copyWith(
            rewardPoints: currentUser.rewardPoints - gift.rewardPointsRequired,
          );
          userController.updateUser(updatedUser);
        }
      }

      // Create redeem history
      final redeemHistory = RedeemHistory(
        id: 'redeem-${DateTime.now().millisecondsSinceEpoch}',
        gift: gift,
        rewardPointsUsed: gift.rewardPointsRequired,
        status: 'pending',
        redeemedAt: DateTime.now(),
      );

      // Save redeem history
      if (Get.isRegistered<RedeemHistoryController>()) {
        Get.find<RedeemHistoryController>().addRedeemHistory(redeemHistory);
      } else {
        // Initialize RedeemHistoryController if not registered
        RedeemHistoryBinding().dependencies();
        Get.find<RedeemHistoryController>().addRedeemHistory(redeemHistory);
      }

      // Save transaction to history - Đổi quà bằng Reward Points
      final rpSpendTransaction = Transaction(
        id: 'tx-rp-spend-${DateTime.now().millisecondsSinceEpoch}',
        type: TransactionType.rewardPointSpend,
        amount: gift.rewardPointsRequired.toDouble(),
        description: 'Đổi quà: ${gift.nameVi}',
        createdAt: DateTime.now(),
        metadata: {
          'giftId': gift.id,
          'giftName': gift.nameVi,
        },
      );

      if (Get.isRegistered<TransactionHistoryController>()) {
        Get.find<TransactionHistoryController>().addTransaction(rpSpendTransaction);
      } else {
        // Initialize TransactionHistoryController if not registered
        TransactionHistoryBinding().dependencies();
        Get.find<TransactionHistoryController>().addTransaction(rpSpendTransaction);
      }

      CustomSnackbar.success(
        title: 'Đổi quà thành công!',
        message: 'Bạn đã đổi "${gift.nameVi}" thành công. Quà sẽ được gửi đến địa chỉ của bạn trong vòng 3-5 ngày.',
      );

      // Refresh gifts list
      _loadGifts();
    } catch (e) {
      CustomSnackbar.error(
        title: 'Lỗi',
        message: 'Không thể đổi quà. Vui lòng thử lại.',
      );
    } finally {
      _isLoading.value = false;
    }
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

