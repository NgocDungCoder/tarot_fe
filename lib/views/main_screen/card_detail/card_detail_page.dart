import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../../configs/styles/theme_config.dart';
import '../../../models/tarot_card.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/flip_card.dart';
import '../../../widget/floating_card.dart';
import '../../../widget/typewriter_text.dart';
import 'card_detail_controller.dart';

class CardDetailBinding extends Bindings {
  @override
  void dependencies() {
    // Sử dụng put thay vì lazyPut để đảm bảo controller được tạo ngay
    // Controller sẽ được dispose tự động khi pop page
    Get.put<CardDetailController>(CardDetailController(), permanent: false);
  }
}

class CardDetailPage extends GetView<CardDetailController> {
  const CardDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Obx(() {
        return Stack(
          children: [
            // Background video - reactive với video controller state
            Positioned.fill(
              child: _buildBackground(),
            ),
            // Content
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button
                    _buildBackButton(),
                    const SizedBox(height: 20),

                    // Card image với Hero animation và floating effect
                    _buildCardImage(),

                    const SizedBox(height: 30),

                    // Card name - reactive với showCardDetail
                    _buildCardName(),

                    const SizedBox(height: 30),

                    // Description - reactive với showCardDetail
                    _buildDescriptionContainer(),

                    const SizedBox(height: 20),

                    // Meaning - reactive với showCardDetail
                    _buildMeaningContainer(),

                    const SizedBox(height: 20),

                    // Reversed meaning - reactive với showCardDetail
                    _buildReversedMeaningContainer(),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  /// Build background video - reactive với video controller state
  Widget _buildBackground() {
    return Obx(() {
      final videoController = controller.videoController;
      final hasError = controller.hasVideoError;

      // Nếu có lỗi video, hiển thị gradient màu tím
      if (hasError) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.deepPurple.shade900,
                Colors.deepPurple.shade700,
                Colors.purple.shade900,
              ],
            ),
          ),
        );
      }

      if (videoController != null && videoController.value.isInitialized) {
        return SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: videoController.value.size.width > 0
                  ? videoController.value.size.width
                  : 1920,
              height: videoController.value.size.height > 0
                  ? videoController.value.size.height
                  : 1080,
              child: VideoPlayer(videoController),
            ),
          ),
        );
      }

      // Nếu chưa có controller hoặc chưa initialized, hiển thị gradient màu tím
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.black,
              Colors.black,
            ],
          ),
        ),
      );
    });
  }

  /// Build back button
  Widget _buildBackButton() {
    return Row(
      children: [
        IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back,
            color: ThemeConfig.textGold,
            size: 28,
          ),
        ),
      ],
    );
  }

  /// Build card image với Hero animation, floating effect và flip functionality
  Widget _buildCardImage() {
    final card = controller.card;

    return Obx(() {
      // Delay floating effect sau khi Hero animation hoàn thành
      final shouldFloat = controller.showCardDetail;
      final isFlipped = controller.isCardFlipped;

      final flipCardWidget = Hero(
        tag: 'card_${card.id}',
        child: FlipCard(
          key: ValueKey('flipCard_${card.id}'), // Key cố định để widget không bị recreate
          backImage: 'assets/images/back_card.png',
          frontImage: card.imagePath,
          width: 250,
          height: 420,
          initialFlipped: isFlipped,
          onTap: () {
            // Update controller state khi card được flip
            controller.flipCard();
          },
          onFlipComplete: () {
            // Có thể thêm logic khi flip hoàn thành nếu cần
          },
        ),
      );

      return Center(
        child: shouldFloat
            ? FloatingCard(
                floatingHeight: 8.0,
                duration: const Duration(milliseconds: 2500),
                curve: Curves.easeInOut,
                child: flipCardWidget,
              )
            : flipCardWidget,
      );
    });
  }

  /// Build card name
  Widget _buildCardName() {
    final card = controller.card;

    return Column(
      children: [
        TypewriterText(
          card.nameVi,
          key: ValueKey('nameVi_${card.id}_${controller.showCardDetail}'),
          fontSize: 36,
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
          fontSize: 24,
          color: ThemeConfig.textWhite,
          textAlign: TextAlign.center,
          delay: const Duration(milliseconds: 300),
          autoStart: controller.showCardDetail,
        ),
      ],
    );
  }

  /// Build description container
  Widget _buildDescriptionContainer() {
    final card = controller.card;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.9),
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
            'Mô tả',
            key: ValueKey('desc_title_${card.id}_${controller.showCardDetail}'),
            fontSize: 22,
            color: ThemeConfig.textGold,
            fontWeight: FontWeight.bold,
            delay: const Duration(milliseconds: 400),
            autoStart: controller.showCardDetail,
          ),
          const SizedBox(height: 10),
          TypewriterText(
            card.description,
            key: ValueKey('desc_${card.id}_${controller.showCardDetail}'),
            fontSize: 16,
            color: ThemeConfig.textWhite,
            delay: const Duration(milliseconds: 500),
            autoStart: controller.showCardDetail,
          ),
        ],
      ),
    );
  }

  /// Build meaning container
  Widget _buildMeaningContainer() {
    final card = controller.card;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.9),
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
            'Ý nghĩa',
            key: ValueKey(
                'meaning_title_${card.id}_${controller.showCardDetail}'),
            fontSize: 22,
            color: ThemeConfig.textGold,
            fontWeight: FontWeight.bold,
            delay: const Duration(milliseconds: 600),
            autoStart: controller.showCardDetail,
          ),
          const SizedBox(height: 10),
          TypewriterText(
            card.meaning,
            key: ValueKey('meaning_${card.id}_${controller.showCardDetail}'),
            fontSize: 16,
            color: ThemeConfig.textWhite,
            delay: const Duration(milliseconds: 700),
            autoStart: controller.showCardDetail,
          ),
        ],
      ),
    );
  }

  /// Build reversed meaning container
  Widget _buildReversedMeaningContainer() {
    final card = controller.card;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.9),
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
            'Ý nghĩa ngược',
            key: ValueKey(
                'reversed_title_${card.id}_${controller.showCardDetail}'),
            fontSize: 22,
            color: ThemeConfig.textGold,
            fontWeight: FontWeight.bold,
            delay: const Duration(milliseconds: 800),
            autoStart: controller.showCardDetail,
          ),
          const SizedBox(height: 10),
          TypewriterText(
            card.reversedMeaning,
            key: ValueKey('reversed_${card.id}_${controller.showCardDetail}'),
            fontSize: 16,
            color: ThemeConfig.textWhite,
            delay: const Duration(milliseconds: 900),
            autoStart: controller.showCardDetail,
          ),
        ],
      ),
    );
  }
}
