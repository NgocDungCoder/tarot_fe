import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tarot_fe/models/category_entity.dart';
import 'package:tarot_fe/providers/api_client.dart';
import '../../../configs/styles/theme_config.dart';

import '../../../widget/custom_text.dart';
import '../../models/gift_entity.dart';
import '../main_screen/user/user_controller.dart';

class RedeemGiftController extends GetxController {
  // Loading state
  final isLoading = false.obs;
  final ApiClient apiClient;
  final errorMessage = "".obs;
  final gifts = <GiftEntity>[].obs;
  final categories = <CategoryEntity>[].obs;

  // User's current reward points
  int get currentRewardPoints {
    // if (Get.isRegistered<UserController>()) {
    //   return Get.find<UserController>().user?.rewardPoints ?? 0;
    // }
    return 30;
  }

  // Filter by category
  final _selectedCategory = 'All'.obs;
  String get selectedCategory => _selectedCategory.value;

  // Search query
  final _searchQuery = ''.obs;
  String get searchQuery => _searchQuery.value;

  RedeemGiftController(this.apiClient) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchCategories();
      await fetchGifts();
    });
}

  Future<void> fetchCategories () async {
    developer.log(
      'Fetching gifts',
      name: 'ShopController',
    );

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await apiClient.getCategories();

      if (response == null) {
        throw Exception('gift detail response is null');
      }

      categories.value = response.docs ?? [];

      categories.insert(0, CategoryEntity(name: "All"));

      developer.log(
        'Fetch gifts success',
        name: 'ShopController',
      );
    } catch (e, stackTrace) {
      errorMessage.value = 'Không thể tải list sản phẩm';

      developer.log(
        'Fetch gifts failed',
        name: 'Shop Controller',
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchGifts () async {
    developer.log(
      'Fetching gifts',
      name: 'ShopController',
    );

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await apiClient.getGifts();

      if (response == null) {
        throw Exception('gift detail response is null');
      }

      gifts.value = response.docs ?? [];

      developer.log(
        'Fetch gifts success',
        name: 'ShopController',
      );
    } catch (e, stackTrace) {
      errorMessage.value = 'Không thể tải list sản phẩm';

      developer.log(
        'Fetch gifts failed',
        name: 'Shop Controller',
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Get filtered gifts based on category and search query
  List<GiftEntity> get filteredGifts {
    var filtered = gifts.where((gift) {
      // Filter by category
      if (_selectedCategory.value != 'All' &&
          gift.categoryId!.name != _selectedCategory.value) {
        return false;
      }

      // Filter by search query
      if (_searchQuery.value.isNotEmpty) {
        final query = _searchQuery.value.toLowerCase();
        return gift.name!.toLowerCase().contains(query) ||
            gift.description!.toLowerCase().contains(query);
      }

      return true;
    }).toList();

    return filtered;
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
  bool canRedeem(GiftEntity gift) {
    return currentRewardPoints >= (gift.price ?? 0) &&
        (gift.stock ?? 0) > 0;
  }

  /// Redeem a gift
  // Future<void> redeemGift(GiftEntity gift) async {
  //   // Check if user has enough points
  //   if (!canRedeem(gift)) {
  //     CustomSnackbar.error(
  //       title: 'Không đủ điểm',
  //       message: 'Bạn cần ${gift.price} điểm thưởng để đổi quà này. Bạn hiện có $currentRewardPoints điểm.',
  //     );
  //     return;
  //   }
  //
  //   // Show confirmation dialog
  //   final confirmed = await Get.dialog<bool>(
  //     AlertDialog(
  //       backgroundColor: Colors.black87,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(16),
  //       ),
  //       title: const CustomText(
  //         'Xác nhận đổi quà',
  //         fontSize: 20,
  //         color: ThemeConfig.textGold,
  //         fontWeight: FontWeight.bold,
  //       ),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           const CustomText(
  //             'Bạn có chắc chắn muốn đổi quà này?',
  //             fontSize: 16,
  //             color: Colors.white,
  //           ),
  //           const SizedBox(height: 16),
  //           _buildInfoRow(
  //             label: 'Quà tặng',
  //             value: gift.name,
  //           ),
  //           const SizedBox(height: 8),
  //           _buildInfoRow(
  //             label: 'Điểm cần dùng',
  //             value: '${gift.price} RP',
  //           ),
  //           const SizedBox(height: 8),
  //           _buildInfoRow(
  //             label: 'Điểm còn lại',
  //             value: '${currentRewardPoints - (gift.price ?? 0)} RP',
  //           ),
  //         ],
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Get.back(result: false),
  //           child: const Text(
  //             'Hủy',
  //             style: TextStyle(color: Colors.grey),
  //           ),
  //         ),
  //         ElevatedButton(
  //           onPressed: () => Get.back(result: true),
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: Colors.amber,
  //             foregroundColor: Colors.black,
  //           ),
  //           child: const Text(
  //             'Xác nhận',
  //             style: TextStyle(fontWeight: FontWeight.bold),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  //
  //   if (confirmed != true) return;
  //
  //   // Simulate API call
  //   isLoading.value = true;
  //   try {
  //     await Future.delayed(const Duration(seconds: 1));
  //
  //     // Update user's reward points
  //     if (Get.isRegistered<UserController>()) {
  //       final userController = Get.find<UserController>();
  //       final currentUser = userController.user;
  //       if (currentUser != null) {
  //         final updatedUser = currentUser.copyWith(
  //           rewardPoints: currentUser.rewardPoints - gift.rewardPointsRequired,
  //         );
  //         userController.updateUser(updatedUser);
  //       }
  //     }
  //
  //     // Create redeem history
  //     final redeemHistory = RedeemHistory(
  //       id: 'redeem-${DateTime.now().millisecondsSinceEpoch}',
  //       gift: gift,
  //       rewardPointsUsed: gift.rewardPointsRequired,
  //       status: 'pending',
  //       redeemedAt: DateTime.now(),
  //     );
  //
  //     // Save redeem history
  //     if (Get.isRegistered<RedeemHistoryController>()) {
  //       Get.find<RedeemHistoryController>().addRedeemHistory(redeemHistory);
  //     } else {
  //       // Initialize RedeemHistoryController if not registered
  //       RedeemHistoryBinding().dependencies();
  //       Get.find<RedeemHistoryController>().addRedeemHistory(redeemHistory);
  //     }
  //
  //     // Save transaction to history - Đổi quà bằng Reward Points
  //     final rpSpendTransaction = Transaction(
  //       id: 'tx-rp-spend-${DateTime.now().millisecondsSinceEpoch}',
  //       type: TransactionType.rewardPointSpend,
  //       amount: gift.rewardPointsRequired.toDouble(),
  //       description: 'Đổi quà: ${gift.nameVi}',
  //       createdAt: DateTime.now(),
  //       metadata: {
  //         'giftId': gift.id,
  //         'giftName': gift.nameVi,
  //       },
  //     );
  //
  //     if (Get.isRegistered<TransactionHistoryController>()) {
  //       Get.find<TransactionHistoryController>().addTransaction(rpSpendTransaction);
  //     } else {
  //       // Initialize TransactionHistoryController if not registered
  //       TransactionHistoryBinding().dependencies();
  //       Get.find<TransactionHistoryController>().addTransaction(rpSpendTransaction);
  //     }
  //
  //     CustomSnackbar.success(
  //       title: 'Đổi quà thành công!',
  //       message: 'Bạn đã đổi "${gift.nameVi}" thành công. Quà sẽ được gửi đến địa chỉ của bạn trong vòng 3-5 ngày.',
  //     );
  //
  //     // Refresh gifts list
  //     _loadGifts();
  //   } catch (e) {
  //     CustomSnackbar.error(
  //       title: 'Lỗi',
  //       message: 'Không thể đổi quà. Vui lòng thử lại.',
  //     );
  //   } finally {
  //     _isLoading.value = false;
  //   }
  // }
}

