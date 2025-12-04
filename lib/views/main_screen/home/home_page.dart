import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../configs/styles/theme_config.dart';
import '../../../models/tarot_card.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/flip_card.dart';
import '../../../widget/typewriter_text.dart';
import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Obx(() {
        final selectedCard = controller.selectedCard;
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: CustomText(
                  'Chọn lá bài của bạn',
                  fontSize: 32,
                  color: ThemeConfig.textWhite,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 20),

              _buildFlipCard(),

              const SizedBox(height: 30),

              _buildCardName(selectedCard),

              const SizedBox(height: 30),

              _buildDescriptionContainer(selectedCard),

              const SizedBox(height: 20),

              _buildMeaningContainer(selectedCard),

              const SizedBox(height: 20),

              _buildReversedMeaningContainer(selectedCard),

              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }

  /// Build flip card - luôn hiển thị
  Widget _buildFlipCard() {
    final card = controller.cards.isNotEmpty ? controller.cards[0] : null;
    final selectedCard = controller.selectedCard;
    
    if (card == null) {
      return const Center(
        child: CustomText(
          'Không có lá bài nào',
          fontSize: 20,
          color: Colors.white,
        ),
      );
    }

    return Center(
      child: Column(
        children: [
          FlipCard(
            key: ValueKey('flipCard_${selectedCard?.id ?? 'none'}'),
            backImage: 'assets/images/back_card.png',
            frontImage: selectedCard?.imagePath ?? card.imagePath,
            width: 200,
            height: 350,
            initialFlipped: selectedCard != null, // Nếu đã chọn thì hiển thị mặt trước
            onFlipComplete: () {
              if (selectedCard == null) {
                controller.selectCard(card);
              }
            },
          ),
          if (selectedCard == null) ...[
            const SizedBox(height: 20),
            const CustomText(
              'Chạm vào lá bài để lật',
              fontSize: 18,
              color: ThemeConfig.textWhite,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  /// Build card name - hiển thị tên hoặc câu hỏi
  Widget _buildCardName(TarotCard? card) {
    if (card == null) {
      return const CustomText(
        'Lá bài của bạn là gì?',
        fontSize: 28,
        color: ThemeConfig.textGold,
        fontWeight: FontWeight.bold,
        textAlign: TextAlign.center,
      );
    }

    return Column(
      children: [
        TypewriterText(
          card.nameVi,
          key: ValueKey('nameVi_${card.id}_${controller.showCardDetail}'),
          fontSize: 32,
          color: ThemeConfig.textGold,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
          delay: const Duration(milliseconds: 200),
          autoStart: controller.showCardDetail,
        ),
        const SizedBox(height: 10),
        TypewriterText(
          card.name,
          key: ValueKey('name_${card.id}_${controller.showCardDetail}'),
          fontSize: 20,
          color: ThemeConfig.textWhite,
          textAlign: TextAlign.center,
          delay: const Duration(milliseconds: 300),
          autoStart: controller.showCardDetail,
        ),
      ],
    );
  }

  /// Build description container - luôn hiển thị
  Widget _buildDescriptionContainer(TarotCard? card) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: ThemeConfig.textGold.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TypewriterText(
            card == null ? 'Mô tả lá bài của bạn?' : 'Mô tả',
            key: ValueKey('desc_title_${card?.id ?? 'none'}_${controller.showCardDetail}'),
            fontSize: 22,
            color: ThemeConfig.textGold,
            fontWeight: FontWeight.bold,
            delay: card == null ? Duration.zero : const Duration(milliseconds: 400),
            autoStart: card == null ? true : controller.showCardDetail,
          ),
          const SizedBox(height: 10),
          TypewriterText(
            card?.description ?? 'Hãy lật lá bài để xem mô tả chi tiết...',
            key: ValueKey('desc_${card?.id ?? 'none'}_${controller.showCardDetail}'),
            fontSize: 16,
            color: ThemeConfig.textWhite,
            delay: card == null ? Duration.zero : const Duration(milliseconds: 500),
            autoStart: card == null ? true : controller.showCardDetail,
          ),
        ],
      ),
    );
  }

  /// Build meaning container - luôn hiển thị
  Widget _buildMeaningContainer(TarotCard? card) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: ThemeConfig.textGold.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TypewriterText(
            card == null ? 'Ý nghĩa lá bài của bạn?' : 'Ý nghĩa',
            key: ValueKey('meaning_title_${card?.id ?? 'none'}_${controller.showCardDetail}'),
            fontSize: 22,
            color: ThemeConfig.textGold,
            fontWeight: FontWeight.bold,
            delay: card == null ? Duration.zero : const Duration(milliseconds: 600),
            autoStart: card == null ? true : controller.showCardDetail,
          ),
          const SizedBox(height: 10),
          TypewriterText(
            card?.meaning ?? 'Hãy lật lá bài để xem ý nghĩa...',
            key: ValueKey('meaning_${card?.id ?? 'none'}_${controller.showCardDetail}'),
            fontSize: 16,
            color: ThemeConfig.textWhite,
            delay: card == null ? Duration.zero : const Duration(milliseconds: 700),
            autoStart: card == null ? true : controller.showCardDetail,
          ),
        ],
      ),
    );
  }

  /// Build reversed meaning container - luôn hiển thị
  Widget _buildReversedMeaningContainer(TarotCard? card) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: ThemeConfig.textGold.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TypewriterText(
            card == null ? 'Ý nghĩa ngược lá bài của bạn?' : 'Ý nghĩa ngược',
            key: ValueKey('reversed_title_${card?.id ?? 'none'}_${controller.showCardDetail}'),
            fontSize: 22,
            color: ThemeConfig.textGold,
            fontWeight: FontWeight.bold,
            delay: card == null ? Duration.zero : const Duration(milliseconds: 800),
            autoStart: card == null ? true : controller.showCardDetail,
          ),
          const SizedBox(height: 10),
          TypewriterText(
            card?.reversedMeaning ?? 'Hãy lật lá bài để xem ý nghĩa ngược...',
            key: ValueKey('reversed_${card?.id ?? 'none'}_${controller.showCardDetail}'),
            fontSize: 16,
            color: ThemeConfig.textWhite,
            delay: card == null ? Duration.zero : const Duration(milliseconds: 900),
            autoStart: card == null ? true : controller.showCardDetail,
          ),
        ],
      ),
    );
  }
}

