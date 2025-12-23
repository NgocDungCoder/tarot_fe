import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:tarot_fe/models/tarot_card_entity.dart';

import '../../../../configs/routes/route.dart';
import '../../../../configs/styles/theme_config.dart';

class CardItemWidget extends StatelessWidget {
  final TarotCardEntity card;

  const CardItemWidget({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to card detail page với Hero animation
        Get.toNamed(Routes.cardDetail.p, arguments: {"cardId": card.id});
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
                Image.network(
                  card.imageUrl ?? "",
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
