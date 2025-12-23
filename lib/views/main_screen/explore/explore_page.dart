import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:tarot_fe/configs/routes/route.dart';
import 'package:tarot_fe/models/blog_entity.dart';
import 'package:tarot_fe/models/tarot_card_entity.dart';
import 'package:tarot_fe/views/main_screen/explore/components/blog_item_widget.dart';
import 'package:tarot_fe/views/main_screen/explore/components/card_item_widget.dart';
import '../../../configs/styles/theme_config.dart';
import '../../../models/tarot_card.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/video_background.dart';
import 'explore_controller.dart';

class ExploreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExploreController>(() => ExploreController(Get.find()));
  }
}

class ExplorePage extends GetView<ExploreController> {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
          child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Obx(() {
          return Column(
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

              // Blog Section
              _buildBlogSection(),

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
                cardType: 'Cups',
              ),

              const SizedBox(height: 30),

              // Wand Section
              _buildCardSection(
                title: 'Wand',
                cards: controller.wandCards,
                cardType: 'Wands',
              ),

              const SizedBox(height: 30),

              // Sword Section
              _buildCardSection(
                title: 'Sword',
                cards: controller.swordCards,
                cardType: 'Swords',
              ),

              const SizedBox(height: 30),

              _buildCardSection(
                title: 'Pentacle',
                cards: controller.pentacleCards,
                cardType: 'Pentacles',
              ),
              const SizedBox(height: 30),
            ],
          );
        }),
      )),
    );
  }

  /// Build card section với GridView 2x2 và nút "Xem thêm tất cả"
  Widget _buildCardSection({
    required String title,
    required List<TarotCardEntity> cards,
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
              onPressed: () => Get.toNamed(Routes.viewAllCards.p, arguments: {
                "cardType": cardType,
              }),
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
          itemCount: cards.length > 4 ? 4 : cards.length,
          // Chỉ hiển thị 4 lá đầu
          itemBuilder: (context, index) {
            final card = cards[index];
            return CardItemWidget(card: card);
          },
        ),
      ],
    );
  }

  Widget _buildBlogSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: controller.fetchBlogs,
              child: const CustomText(
                'Blog',
                fontSize: 24,
                color: ThemeConfig.textGold,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => Get.toNamed(Routes.viewAllBlogs.p),
              child: const CustomText(
                'View All',
                fontSize: 14,
                color: ThemeConfig.textGold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),

        // Blog list - horizontal scroll
        SizedBox(
          height: 200,
          child: Obx(() {
            final blogs = controller.blogs;
            if (blogs.isEmpty) {
              return const SizedBox.shrink();
            }

            return ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: blogs.length,
              itemBuilder: (context, index) {
                final blog = blogs[index];
                return BlogItemWidget(blog: blog);
              },
              separatorBuilder: (_, __) => SizedBox(width: 15),
            );
          }),
        ),
      ],
    );
  }
}
