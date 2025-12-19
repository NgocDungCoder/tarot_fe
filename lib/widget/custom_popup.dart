import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmDialog {
  static void show({
    required String title,
    required String message,
    required VoidCallback onConfirm,
    String cancelText = "Hủy",
    String confirmText = "Xác nhận",
    Color confirmColor = Colors.red,
  }) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.black87,
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          message,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              cancelText,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              onConfirm();
            },
            child: Text(
              confirmText,
              style: TextStyle(color: confirmColor),
            ),
          ),
        ],
      ),
    );
  }
}