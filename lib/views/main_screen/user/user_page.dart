import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../configs/styles/theme_config.dart';
import '../../../widget/custom_text.dart';
import 'user_controller.dart';

class UserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserController>(() => UserController());
  }
}

class UserPage extends GetView<UserController> {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: CustomText(
          'User',
          fontSize: 32,
          color: ThemeConfig.textWhite,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

