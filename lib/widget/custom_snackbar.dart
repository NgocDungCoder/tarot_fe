import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../configs/styles/theme_config.dart';
import 'custom_text.dart';

/// Snackbar type enum
/// 
/// Defines different types of snackbars with corresponding colors
enum SnackbarType {
  success, // Green - Thành công
  warning, // Yellow - Cảnh báo
  error, // Red - Lỗi
  information, // Blue - Thông tin
}

/// Custom snackbar utility class
/// 
/// Provides methods to show snackbars with different types and colors
class CustomSnackbar {
  // Private constructor to prevent instantiation
  CustomSnackbar._();

  /// Show custom snackbar với type và màu tương ứng
  /// 
  /// [title] - Tiêu đề snackbar
  /// [message] - Nội dung snackbar
  /// [type] - Loại snackbar (success, warning, error, information)
  /// [duration] - Thời gian hiển thị (mặc định 3 giây)
  /// [snackPosition] - Vị trí hiển thị (mặc định BOTTOM)
  static void show({
    required String title,
    required String message,
    required SnackbarType type,
    Duration? duration,
    SnackPosition snackPosition = SnackPosition.BOTTOM,
  }) {
    // Get colors và icon dựa trên type
    final colors = _getColorsForType(type);
    final icon = _getIconForType(type);

    Get.snackbar(
      title,
      message,
      snackPosition: snackPosition,
      duration: duration ?? const Duration(seconds: 3),
      backgroundColor: colors['background'] as Color,
      colorText: colors['text'] as Color,
      icon: Icon(
        icon,
        color: colors['text'] as Color,
        size: 28,
      ),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      boxShadows: [
        BoxShadow(
          color: colors['background']!.withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
      titleText: CustomText(
        title,
        fontSize: 18,
        color: colors['text'] as Color,
        fontWeight: FontWeight.bold,
      ),
      messageText: CustomText(
        message,
        fontSize: 14,
        color: colors['text'] as Color,
      ),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
    );
  }

  /// Show success snackbar (màu xanh lá)
  static void success({
    required String title,
    required String message,
    Duration? duration,
    SnackPosition snackPosition = SnackPosition.BOTTOM,
  }) {
    show(
      title: title,
      message: message,
      type: SnackbarType.success,
      duration: duration,
      snackPosition: snackPosition,
    );
  }

  /// Show warning snackbar (màu vàng)
  static void warning({
    required String title,
    required String message,
    Duration? duration,
    SnackPosition snackPosition = SnackPosition.BOTTOM,
  }) {
    show(
      title: title,
      message: message,
      type: SnackbarType.warning,
      duration: duration,
      snackPosition: snackPosition,
    );
  }

  /// Show error snackbar (màu đỏ)
  static void error({
    required String title,
    required String message,
    Duration? duration,
    SnackPosition snackPosition = SnackPosition.BOTTOM,
  }) {
    show(
      title: title,
      message: message,
      type: SnackbarType.error,
      duration: duration,
      snackPosition: snackPosition,
    );
  }

  /// Show information snackbar (màu xanh lam)
  static void information({
    required String title,
    required String message,
    Duration? duration,
    SnackPosition snackPosition = SnackPosition.BOTTOM,
  }) {
    show(
      title: title,
      message: message,
      type: SnackbarType.information,
      duration: duration,
      snackPosition: snackPosition,
    );
  }

  /// Get colors cho từng type
  /// 
  /// Returns map với 'background' và 'text' colors
  static Map<String, Color> _getColorsForType(SnackbarType type) {
    switch (type) {
      case SnackbarType.success:
        // Xanh lá - Success
        return {
          'background': ThemeConfig.success,
          'text': Colors.white,
        };
      case SnackbarType.warning:
        // Vàng - Warning
        return {
          'background': ThemeConfig.warning,
          'text': Colors.white,
        };
      case SnackbarType.error:
        // Đỏ - Error
        return {
          'background': ThemeConfig.error,
          'text': Colors.white,
        };
      case SnackbarType.information:
        // Xanh lam - Information
        return {
          'background': ThemeConfig.info,
          'text': Colors.white,
        };
    }
  }

  /// Get icon cho từng type
  static IconData _getIconForType(SnackbarType type) {
    switch (type) {
      case SnackbarType.success:
        return Icons.check_circle;
      case SnackbarType.warning:
        return Icons.warning;
      case SnackbarType.error:
        return Icons.error;
      case SnackbarType.information:
        return Icons.info;
    }
  }
}

