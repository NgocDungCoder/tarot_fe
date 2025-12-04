import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../configs/styles/theme_config.dart';
import '../../../widget/custom_text.dart';
import 'explore_controller.dart';

class ExploreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExploreController>(() => ExploreController());
  }
}

class ExplorePage extends GetView<ExploreController> {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: CustomText(
          'Khám phá',
          fontSize: 32,
          color: ThemeConfig.textWhite,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

