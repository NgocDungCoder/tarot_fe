import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../configs/styles/theme_config.dart';
import '../../../models/tarot_card.dart';
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child:
        SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const CustomText(
                  'Explore',
                  fontSize: 32,
                  color: ThemeConfig.textGold,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // Major Arcana Section
                _buildCardSection(
                  title: 'Major Arcana',
                  cards: controller.majorCards,
                  cardType: 'Major',
                ),

                const SizedBox(height: 30),

                // Cup Section
                _buildCardSection(
                  title: 'Cup',
                  cards: controller.cupCards,
                  cardType: 'Cup',
                ),

                const SizedBox(height: 30),

                // Wand Section
                _buildCardSection(
                  title: 'Wand',
                  cards: controller.wandCards,
                  cardType: 'Wand',
                ),

                const SizedBox(height: 30),

                // Sword Section
                _buildCardSection(
                  title: 'Sword',
                  cards: controller.swordCards,
                  cardType: 'Sword',
                ),

                const SizedBox(height: 30),
              ],
            ),
          )
        ),

    );
  }

  /// Build card section với GridView 2x2 và nút "Xem thêm tất cả"
  Widget _buildCardSection({
    required String title,
    required List<TarotCard> cards,
    required String cardType,
  }) {
    if (cards.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header với nút "Xem thêm tất cả"
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              title,
              fontSize: 24,
              color: ThemeConfig.textGold,
              fontWeight: FontWeight.bold,
            ),
            TextButton(
              onPressed: () => controller.viewAllCards(cardType),
              child: const CustomText(
                'View All',
                fontSize: 14,
                color: ThemeConfig.textGold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),

        // GridView 2x2
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 0.58, // Width/Height ratio
          ),
          itemCount: cards.length > 4 ? 4 : cards.length, // Chỉ hiển thị 4 lá đầu
          itemBuilder: (context, index) {
            final card = cards[index];
            return _buildCardItem(card);
          },
        ),
      ],
    );
  }

  /// Build card item widget
  Widget _buildCardItem(TarotCard card) {
    return GestureDetector(
      onTap: () {
        // Navigate to card detail page với Hero animation
        Get.toNamed(
          '/card-detail',
          arguments: card,
        );
      },
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
