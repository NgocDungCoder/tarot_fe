import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../configs/routes/route.dart';
import '../../../models/user.dart';
import '../../../widget/custom_snackbar.dart';

class UserController extends GetxController {
  // User data
  final _user = Rx<User?>(null);

  User? get user => _user.value;

  // Loading state
  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  /// Load user data (tạm thời dùng dữ liệu mẫu)
  void _loadUserData() {
    _isLoading.value = true;

    // Simulate API call delay
    Future.delayed(const Duration(milliseconds: 500), () {
      // Dữ liệu mẫu với 100000 điểm mặc định
      _user.value = const User(
        id: '1',
        name: 'Nguyễn Văn A',
        email: 'nguyenvana@example.com',
        phone: '+84 123 456 789',
        magicPoints: 100000.0, // Magic Points - điểm ma thuật (mặc định 100000)
        rewardPoints: 100000, // Reward Points - điểm tích lũy/thưởng (mặc định 100000)
        zodiacSign: 'Bạch Dương',
        avatarPath: 'assets/icons/tarot_logo.jpg',
        createdAt: null,
        updatedAt: null,
      );
      _isLoading.value = false;
    });
  }

  /// Navigate to profile page
  void navigateToProfile() {
    Get.toNamed(Routes.profile.sp);
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

  /// View card history
  void viewCardHistory() {
    Get.toNamed('/card-draw-history');
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
  void updateUser(User updatedUser) {
    _user.value = updatedUser;
  }

  /// Add magic points (nạp tiền)
  void addMagicPoints(double amount) {
    if (_user.value != null) {
      _user.value = _user.value!.copyWith(
        magicPoints: _user.value!.magicPoints + amount,
      );
    }
  }

  /// Subtract magic points (trừ điểm)
  void subtractMagicPoints(double amount) {
    if (_user.value != null) {
      final newAmount = (_user.value!.magicPoints - amount).clamp(0.0, double.infinity);
      _user.value = _user.value!.copyWith(
        magicPoints: newAmount,
      );
    }
  }

  /// Check if user has enough magic points
  bool hasEnoughMagicPoints(double amount) {
    return _user.value != null && _user.value!.magicPoints >= amount;
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
