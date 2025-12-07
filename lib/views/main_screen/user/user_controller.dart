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
      // Dữ liệu mẫu
      _user.value = const User(
        id: '1',
        name: 'Nguyễn Văn A',
        email: 'nguyenvana@example.com',
        phone: '+84 123 456 789',
        magicPoints: 1250.0, // Magic Points - điểm ma thuật
        rewardPoints: 3500, // Reward Points - điểm tích lũy/thưởng
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
    CustomSnackbar.information(
      title: 'Lịch sử rút bài',
      message: 'Tính năng xem lịch sử rút bài đang được phát triển',
    );
  }

  /// View transaction history
  void viewTransactionHistory() {
    CustomSnackbar.information(
      title: 'Lịch sử giao dịch',
      message: 'Tính năng xem lịch sử giao dịch đang được phát triển',
    );
  }

  /// View orders
  void viewOrders() {
    CustomSnackbar.information(
      title: 'Đơn hàng',
      message: 'Tính năng xem đơn hàng đang được phát triển',
    );
  }
}
