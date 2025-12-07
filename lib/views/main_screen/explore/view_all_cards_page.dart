import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../configs/styles/theme_config.dart';
import '../../../models/tarot_card.dart';
import '../../../widget/custom_text.dart';
import 'view_all_cards_controller.dart';

/// Binding for View All Cards page
class ViewAllCardsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ViewAllCardsController>(() => ViewAllCardsController());
  }
}

/// Page to display all cards of a specific type
/// 
/// Shows a grid view of all tarot cards for the selected category
class ViewAllCardsPage extends GetView<ViewAllCardsController> {
  const ViewAllCardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back,
            color: ThemeConfig.textGold,
            size: 28,
          ),
        ),
        title: CustomText(
          controller.title,
          fontSize: 24,
          color: ThemeConfig.textGold,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: GetBuilder<ViewAllCardsController>(
          builder: (controller) {
            if (controller.cards.isEmpty) {
              return Center(
                child: CustomText(
                  'Không có lá bài nào',
                  fontSize: 18,
                  color: ThemeConfig.textGold,
                ),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.58, // Width/Height ratio - giống explore page
              ),
              itemCount: controller.cards.length,
              itemBuilder: (context, index) {
                final card = controller.cards[index];
                return _buildCardItem(card);
              },
            );
          },
        ),
      ),
    );
  }

  /// Build card item widget
  /// 
  /// Displays a single tarot card with image and name overlay
  Widget _buildCardItem(TarotCard card) {
    return GestureDetector(
      onTap: () => controller.navigateToCardDetail(card),
      child: Hero(
        tag: 'card_${card.id}',
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: ThemeConfig.textGold.withOpacity(0.5),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Card image
                Image.asset(
                  card.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.deepPurple.withOpacity(0.3),
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
                // Gradient overlay để text dễ đọc
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.8),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          card.nameVi,
                          fontSize: 14,
                          color: ThemeConfig.textGold,
                          fontWeight: FontWeight.bold,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        CustomText(
                          card.name,
                          fontSize: 12,
                          color: ThemeConfig.textGold.withOpacity(0.8),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

