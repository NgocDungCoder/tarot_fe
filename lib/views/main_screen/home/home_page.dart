import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../configs/routes/route.dart';
import '../../../configs/styles/theme_config.dart';
import '../../../models/tarot_card.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/floating_card.dart';
import '../../../widget/video_background.dart';
import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController(Get.find()));
  }
}

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: CustomText(
                'Chose your destiny card',
                fontSize: 32,
                color: ThemeConfig.textGold,
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 20),

            _buildFlipCard(),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// Build card - tap để chuyển sang trang rút bài
  Widget _buildFlipCard() {
    return Center(
      child: Column(
        children: [
          // Card với FloatingCard và Hero animation
          GestureDetector(
            onTap: () {
              Get.toNamed(
                Routes.cardDraw.p,
              );
            },
            child: FloatingCard(
              floatingHeight: 6.0, // Độ cao bay bổng nhẹ nhàng
              duration: const Duration(milliseconds: 3000), // Chu kỳ 3 giây
              curve: Curves.easeInOut,
              child: Container(
                width: 200,
                height: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: ThemeConfig.textGold.withOpacity(0.5),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(
                    'assets/images/back_card.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.deepPurple.withOpacity(0.3),
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: ThemeConfig.textGold,
                            size: 60,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const CustomText(
            'Tap the card to draw',
            fontSize: 18,
            color: ThemeConfig.textWhite,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
