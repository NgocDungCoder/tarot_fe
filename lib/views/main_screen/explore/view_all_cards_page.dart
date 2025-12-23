import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tarot_fe/models/tarot_card_entity.dart';
import '../../../configs/routes/route.dart';
import '../../../configs/styles/theme_config.dart';
import '../../../models/tarot_card.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/video_background.dart';
import 'components/card_item_widget.dart';
import 'view_all_cards_controller.dart';

/// Binding for View All Cards page
class ViewAllCardsBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments;
    final cardType = args["cardType"].toString() ?? "";
    Get.lazyPut<ViewAllCardsController>(
        () => ViewAllCardsController(cardType, Get.find()));
  }
}

/// Page to display all cards of a specific type
///
/// Shows a grid view of all tarot cards for the selected category
class ViewAllCardsPage extends GetView<ViewAllCardsController> {
  const ViewAllCardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return VideoBackground(
      child: Scaffold(
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
          title: Obx(() {
            return CustomText(
              controller.title.value,
              fontSize: 24,
              color: ThemeConfig.textGold,
              fontWeight: FontWeight.bold,
            );
          }),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Obx(() {
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
                childAspectRatio:
                    0.58, // Width/Height ratio - giống explore page
              ),
              itemCount: controller.cards.length,
              itemBuilder: (context, index) {
                final card = controller.cards[index];
                return CardItemWidget(card: card);
              },
            );
          }),
        ),
      ),
    );
  }
}
