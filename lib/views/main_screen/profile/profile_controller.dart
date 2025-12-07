import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/user.dart';
import '../../../widget/custom_snackbar.dart';

class ProfileController extends GetxController {
  // User data
  final _user = Rx<User?>(null);

  User? get user => _user.value;

  // Loading state
  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  // Edit mode
  final _isEditMode = false.obs;

  bool get isEditMode => _isEditMode.value;

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

  /// Edit profile
  void editProfile() {
    _isEditMode.value = !_isEditMode.value;
    if (_isEditMode.value) {
      CustomSnackbar.information(
        title: 'Chế độ chỉnh sửa',
        message: 'Nhấn vào các trường để chỉnh sửa',
      );
    }
  }

  /// Edit avatar
  void editAvatar() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.black87,
        title: const Text(
          'Đổi avatar',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Tính năng đổi avatar đang được phát triển',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Đóng',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  /// Edit field - mở dialog để chỉnh sửa từng trường
  void editField(String field) {
    final user = _user.value;
    if (user == null) return;

    final TextEditingController textController = TextEditingController();
    String currentValue = '';

    switch (field) {
      case 'name':
        currentValue = user.name;
        break;
      case 'email':
        currentValue = user.email;
        break;
      case 'phone':
        currentValue = user.phone ?? '';
        break;
      case 'zodiac':
        currentValue = user.zodiacSign;
        break;
    }

    textController.text = currentValue;

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              _getFieldIcon(field),
              color: Colors.amber,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Chỉnh sửa ${_getFieldLabel(field)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: TextField(
          controller: textController,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            labelText: _getFieldLabel(field),
            labelStyle: const TextStyle(color: Colors.grey),
            hintText: 'Nhập ${_getFieldLabel(field).toLowerCase()}',
            hintStyle: TextStyle(color: Colors.grey.shade600),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade700),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.amber, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.shade900,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          keyboardType: _getKeyboardType(field),
          maxLines: field == 'phone' ? 1 : 1,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Hủy',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final newValue = textController.text.trim();
              if (newValue.isEmpty) {
                CustomSnackbar.error(
                  title: 'Lỗi',
                  message: '${_getFieldLabel(field)} không được để trống',
                );
                return;
              }

              // Update user data
              _updateUserField(field, newValue);
              Get.back();
              CustomSnackbar.success(
                title: 'Thành công',
                message: 'Đã cập nhật ${_getFieldLabel(field)}',
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Lưu',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  /// Update user field
  void _updateUserField(String field, String value) {
    final currentUser = _user.value;
    if (currentUser == null) return;

    User updatedUser;
    switch (field) {
      case 'name':
        updatedUser = currentUser.copyWith(name: value);
        break;
      case 'email':
        updatedUser = currentUser.copyWith(email: value);
        break;
      case 'phone':
        updatedUser = currentUser.copyWith(phone: value);
        break;
      case 'zodiac':
        updatedUser = currentUser.copyWith(zodiacSign: value);
        break;
      default:
        return;
    }

    _user.value = updatedUser;
    // TODO: Call API to save user data
  }

  /// Get field icon
  IconData _getFieldIcon(String field) {
    switch (field) {
      case 'name':
        return Icons.person;
      case 'email':
        return Icons.email;
      case 'phone':
        return Icons.phone;
      case 'zodiac':
        return Icons.star;
      default:
        return Icons.edit;
    }
  }

  /// Get keyboard type for field
  TextInputType _getKeyboardType(String field) {
    switch (field) {
      case 'email':
        return TextInputType.emailAddress;
      case 'phone':
        return TextInputType.phone;
      case 'name':
      case 'zodiac':
      default:
        return TextInputType.text;
    }
  }

  /// Get field label
  String _getFieldLabel(String field) {
    switch (field) {
      case 'name':
        return 'Tên';
      case 'email':
        return 'Email';
      case 'phone':
        return 'Số điện thoại';
      case 'zodiac':
        return 'Cung hoàng đạo';
      default:
        return '';
    }
  }

}

