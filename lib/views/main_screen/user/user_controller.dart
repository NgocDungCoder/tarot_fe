import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tarot_fe/models/user_entity.dart';
import '../../../configs/routes/route.dart';
import '../../../models/user.dart';
import '../../../providers/api_client.dart';
import '../../../widget/custom_snackbar.dart';

class UserController extends GetxController {

  final ApiClient apiClient;
  final isLoading = false.obs;
  final errorMessage = "".obs;
  final userId = "6943d3e9905d10bd4b078aad";
  // User data
  final Rx<UserEntity >user = Rx<UserEntity>(UserEntity());

  UserController(this.apiClient);

  @override
  void onInit() async {
    super.onInit();
    await fetchUserDetail();
  }

  Future<void> fetchUserDetail() async {
    developer.log(
      'Fetching user detail',
      name: 'userDetailController',
      error: {'userId': userId},
    );

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await apiClient.getUserById(userId);

      if (response == null) {
        throw Exception('user detail response is null');
      }

      user.value = response;

      developer.log(
        'Fetch user detail success',
        name: 'userDetailController',
      );
    } catch (e, stackTrace) {
      errorMessage.value = 'Không thể tải chi tiết sản phẩm';

      developer.log(
        'Fetch user detail failed',
        name: 'userDetailController',
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Navigate to profile page
  void navigateToProfile() {
    Get.toNamed(Routes.profile.sp);
  }

  void viewCardHistory(){

  }

  /// Logout user
  void logout() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.black87,
        title: const Text(
          'Đăng xuất',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Bạn có chắc chắn muốn đăng xuất?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Hủy',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              // TODO: Implement logout logic
              CustomSnackbar.success(
                title: 'Đăng xuất',
                message: 'Đã đăng xuất thành công',
              );
            },
            child: const Text(
              'Đăng xuất',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  /// Navigate to policy page
  void goToPolicy() {
    CustomSnackbar.information(
      title: 'Chính sách',
      message: 'Trang chính sách đang được phát triển',
    );
  }

  /// Navigate to terms page
  void goToTerms() {
    CustomSnackbar.information(
      title: 'Điều khoản',
      message: 'Trang điều khoản đang được phát triển',
    );
  }

  /// Navigate to privacy page
  void goToPrivacy() {
    CustomSnackbar.information(
      title: 'Quyền riêng tư',
      message: 'Trang quyền riêng tư đang được phát triển',
    );
  }

  /// Navigate to help page
  void goToHelp() {
    CustomSnackbar.information(
      title: 'Trợ giúp',
      message: 'Trang trợ giúp đang được phát triển',
    );
  }

  /// Navigate to about page
  void goToAbout() {
    CustomSnackbar.information(
      title: 'Về chúng tôi',
      message: 'Trang về chúng tôi đang được phát triển',
    );
  }

  /// View user history
  void viewuserHistory() {
    Get.toNamed('/user-draw-history');
  }

  /// View transaction history
  void viewTransactionHistory() {
    Get.toNamed('/transaction-history');
  }

  /// View orders
  void viewOrders() {
    Get.toNamed('/order-history');
  }
  
  /// View redeem history
  void viewRedeemHistory() {
    Get.toNamed('/redeem-history');
  }

  /// Update user data
  void updateUser(UserEntity updatedUser) {
    user.value = updatedUser;
  }

  /// Add magic points (nạp tiền)
  void addMagicPoints(double amount) {
    user.value = user.value.copyWith(
      magicPoints: user.value.magicPoints! + amount,
    );
    }

  /// Subtract magic points (trừ điểm)
  void subtractMagicPoints(double amount) {
    final newAmount = (user.value.magicPoints! - amount).clamp(0.0, double.infinity);
    user.value = user.value.copyWith(
      magicPoints: newAmount,
    );
    }

  /// Check if user has enough magic points
  bool hasEnoughMagicPoints(double amount) {
    return user.value.magicPoints! >= amount;
  }

  /// Navigate to deposit page
  void navigateToDeposit({double? requiredAmount}) {
    Get.toNamed(
      Routes.payment.sp,
      arguments: {
        'requiredAmount': requiredAmount,
      },
    );
  }
}
