import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tarot_fe/models/tarot_card_entity.dart';
import '../../../models/tarot_card.dart';
import '../../../providers/api_client.dart';
import 'explore_controller.dart';
import 'explore_page.dart';

/// Controller for View All Cards page
/// 
/// Manages the list of cards for a specific card type (Major, Cup, Wand, Sword)
class ViewAllCardsController extends GetxController {

  final ApiClient apiClient;
  final isLoading = false.obs;
  final errorMessage = "".obs;


  // Card type và danh sách lá bài
  final String cardType;
  final title = "".obs;
  final RxList<TarotCardEntity> _cards = <TarotCardEntity>[].obs;
  late final String arcana;
  late final String suit;
  // Getters
  List<TarotCardEntity> get cards => _cards;

  ViewAllCardsController(this.cardType, this.apiClient) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {

      if(cardType == "Major") {
        title.value = 'Major';
        arcana = Arcana.majorArcana.label;
        suit = "";
      } else {
        title.value = cardType;
        arcana = Arcana.minorArcana.label;
        suit = cardType;
      }

      await fetchTarotCards();
    });
  }


  /// Load cards từ ExploreController dựa trên cardType

  Future<void> fetchTarotCards () async {
    developer.log(
      'Fetching cards',
      name: 'ExploreController',
    );

    try {
      isLoading.value = true;
      errorMessage.value = '';
      final response = await apiClient.getTarotCards(arcana: arcana, suit: suit);

      _cards.addAll(response);


      developer.log(
        'Fetch cards success',
        name: 'exploreController',
      );
    } catch (e, stackTrace) {
      errorMessage.value = 'Không thể tải list cards';

      developer.log(
        'Fetch cards failed',
        name: 'Explore Controller',
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      isLoading.value = false;
    }
  }

}

