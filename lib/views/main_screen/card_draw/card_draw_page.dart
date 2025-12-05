import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../../configs/styles/theme_config.dart';
import '../../../models/tarot_card.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/flip_card.dart';
import '../../../widget/floating_card.dart';
import '../../../widget/typewriter_text.dart';
import 'card_draw_controller.dart';

class CardDrawBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CardDrawController>(CardDrawController(), permanent: false);
  }
}

class CardDrawPage extends GetView<CardDrawController> {
  const CardDrawPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background video
          _buildBackground(),

          // Content
          SafeArea(
            child: Obx(() {
              final hasSelected = controller.hasSelected;
              final selectedCard = controller.selectedCard;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Cards display
                    if (!hasSelected) _buildCardsSpread(),
                    if (hasSelected && !controller.isZooming)
                      ...[
                        SizedBox(
                          height: 20,
                        ),
                        _buildSelectedCard(),
                      ],

                    // Card details (chỉ hiển thị sau khi chọn)
                    if (hasSelected) ...[
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
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  /// Build background video
  Widget _buildBackground() {
    return Obx(() {
      final videoController = controller.videoController;
      final hasError = controller.hasVideoError;

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

  /// Build cards spread (5 cards: 1 giữa hero + 2 trái + 2 phải)
  /// Layout: [0: trái trên, 1: trái dưới, 2: giữa (hero), 3: phải trên, 4: phải dưới]
  /// Z-index: trái thấp nhất (0) -> phải cao nhất (4)
  Widget _buildCardsSpread() {
    return Obx(() {
      final cards = controller.displayCards;
      final selectedIndex = controller.selectedIndex;
      final isZooming = controller.isZooming;
      final isFlipping = controller.isFlipping.value;
      final isZoomCompleted = controller.isZoomCompleted;
      final zoomedCardIndex = controller.zoomedCardIndex;

      // Tạo list children với z-index đúng (trái thấp nhất -> phải cao nhất)
      // Trong Stack, widget add sau sẽ ở trên, nên add từ trái sang phải (0->4)
      final children = <Widget>[];
      for (int index = 0; index < 5; index++) {
        final isSelected = selectedIndex == index;
        final isHidden = selectedIndex != null && selectedIndex != index;
        final isZoomed = zoomedCardIndex == index;

        final cardWidth = 120.0;
        final cardHeight = 200.0;
        final centerX = MediaQuery.of(Get.context!).size.width / 2;
        final zoomedWidth = 200.0;
        final zoomedHeight = 350.0;

        // Tính toán vị trí dựa trên index - layout đẹp hơn, đều hơn
        double offsetX = 0;
        double offsetY = 0;
        double angle = 0;

        switch (index) {
          case 0: // Trái trên
            offsetX = -160.0;
            offsetY = -20.0;
            angle = -0.35;
            break;
          case 1: // Trái dưới
            offsetX = -80.0;
            offsetY = -40.0;
            angle = -0.25;
            break;
          case 2: // Giữa (hero)
            offsetX = 0;
            offsetY = -55;
            angle = 0;
            break;
          case 3: // Phải trên
            offsetX = 80.0;
            offsetY = -40.0;
            angle = 0.25;
            break;
          case 4: // Phải dưới
            offsetX = 160.0;
            offsetY = -20.0;
            angle = 0.35;
            break;
        }

        // Tính toán vị trí ban đầu (initial position) của lá bài
        final initialLeft = centerX - cardWidth / 2 + offsetX;
        final initialTop = 200.0 + offsetY;
        
        // Tính toán vị trí zoomed (final position) khi được chọn
        final zoomedLeft = centerX - zoomedWidth / 2;
        final zoomedTop = 20.0;
        
        // Vị trí hiện tại: nếu đang zoom thì dùng zoomed position, nếu không thì dùng initial position
        final currentLeft = isZoomed ? zoomedLeft : initialLeft;
        final currentTop = isZoomed ? zoomedTop : initialTop;

        children.add(
          AnimatedPositioned(
            // Z-index: trái thấp nhất (0) -> phải cao nhất (4)
            // Index càng cao thì càng ở trên
            duration: Duration(milliseconds: isZoomed ? 1200 : 500),
            curve: Curves.easeInOutCubic,
            left: currentLeft,
            top: currentTop,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: isZoomed ? 1000 : 500),
              opacity: isHidden ? 0.0 : 1.0,
              child: AnimatedContainer(
                duration: Duration(milliseconds: isZoomed ? 1200 : 500),
                curve: Curves.easeInOutCubic,
                width: isZoomed ? zoomedWidth : cardWidth,
                height: isZoomed ? zoomedHeight : cardHeight,
                child: TweenAnimationBuilder<double>(
                  key: ValueKey('rotation_$index $isZoomed'),
                  duration: Duration(milliseconds: isZoomed ? 1200 : 500),
                  curve: Curves.easeInOutCubic,
                  tween: Tween<double>(
                    begin: isZoomed ? angle : angle,
                    end: isZoomed ? 0.0 : angle,
                  ),
                  builder: (context, rotationAngle, child) {
                    return Transform.rotate(
                      angle: rotationAngle,
                      child: GestureDetector(
                        onTap: () => controller.selectCard(index),
                        child: _buildCardWidget(
                          index,
                          cards[index],
                          isSelected,
                          isZoomed,
                          isFlipping && isSelected && isZoomCompleted,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      }

      return SizedBox(
        height: 450,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: children,
        ),
      );
    });
  }

  /// Build card widget với hero và flip animation
  /// Index 2 là card ở giữa (hero từ home)
  Widget _buildCardWidget(
    int index,
    TarotCard card,
    bool isSelected,
    bool isZoomed,
    bool isFlipping,
  ) {
    final selectedIndex = controller.selectedIndex;
    final hasSelected = controller.hasSelected;
    final isZooming = controller.isZooming;
    final isZoomCompleted = controller.isZoomCompleted;

    // Card ở giữa (index 2) có hero tag để match với home
    final heroTag = index == 2 && selectedIndex == null
        ? 'home_card_${card.id}'
        : 'card_${card.id}_$index';

    Widget cardContent;

    // Chỉ hiển thị FlipCard khi đã zoom hoàn thành VÀ đang flip
    // Đảm bảo không bị ngắt giữa chừng
    if (isZoomed && isZoomCompleted && isFlipping && isSelected && !isZooming) {
      cardContent = FlipCard(
        key: ValueKey('flipCard_${card.id}_${isSelected}_${isFlipping}'),
        backImage: 'assets/images/back_card.png',
        frontImage: card.imagePath,
        width: 210,
        height: 350,
        initialFlipped: false,
        autoFlip: true, // Tự động flip sau khi widget được tạo
      );
    } else {
      // Card bình thường hoặc đang zoom (chưa flip)
      // Vẫn hiển thị mặt sau khi đang zoom để không bị ngắt
      cardContent = FloatingCard(
        floatingHeight: (isSelected || isZoomed) ? 0 : 8.0,
        duration: const Duration(milliseconds: 2500),
        curve: Curves.easeInOut,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: (isSelected || isZoomed)
                  ? ThemeConfig.textGold
                  : ThemeConfig.textGold.withOpacity(0.3),
              width: (isSelected || isZoomed) ? 3 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: (isSelected || isZoomed)
                    ? ThemeConfig.textGold.withOpacity(0.6)
                    : Colors.black.withOpacity(0.5),
                blurRadius: (isSelected || isZoomed) ? 25 : 10,
                offset: const Offset(0, 5),
                spreadRadius: (isSelected || isZoomed) ? 3 : 0,
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
                  color: ThemeConfig.deepPurple,
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      color: ThemeConfig.textGold,
                      size: 40,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    }

    // Wrap với Hero nếu là card ở giữa (index 2) và chưa select
    if (index == 2 && selectedIndex == null) {
      return Hero(
        tag: heroTag,
        child: cardContent,
      );
    }

    return cardContent;
  }

  /// Build selected card display
  Widget _buildSelectedCard() {
    final card = controller.selectedCard;

    return Center(
      child: FloatingCard(
        floatingHeight: 8.0,
        duration: const Duration(milliseconds: 2500),
        curve: Curves.easeInOut,
        child: Container(
          width: 210,
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
              card.imagePath,
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
    );
  }

  /// Build card name
  Widget _buildCardName(card) {
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

  /// Build description container
  Widget _buildDescriptionContainer(card) {
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
  Widget _buildMeaningContainer(card) {
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
  Widget _buildReversedMeaningContainer(card) {
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
