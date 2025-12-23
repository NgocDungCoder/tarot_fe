import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tarot_fe/models/blog_entity.dart';
import 'package:tarot_fe/models/tarot_card_entity.dart';
import 'package:tarot_fe/providers/api_client.dart';
import '../../../models/tarot_card.dart';

enum Arcana {
  majorArcana('Major Arcana'),
  minorArcana('Minor Arcana');

  final String label;

  const Arcana(this.label);
}

enum SuitCard { sword, cup, pentacle, wand }

class ExploreController extends GetxController {
  final ApiClient apiClient;
  final isLoading = false.obs;
  final errorMessage = "".obs;

  // Dữ liệu ảo cho các loại lá bài
  final List<TarotCard> _majorCards = [];
  final List<TarotCard> _cupCards = [];
  final List<TarotCard> _wandCards = [];
  final List<TarotCard> _swordCards = [];

  // Blog list - sử dụng RxList để reactive
  final _blogs = <Map<String, dynamic>>[].obs;
  final RxList<BlogEntity> blogs = <BlogEntity>[].obs;
  final RxList<TarotCardEntity> majorCards = <TarotCardEntity>[].obs;
  final RxList<TarotCardEntity> wandCards = <TarotCardEntity>[].obs;
  final RxList<TarotCardEntity> cupCards = <TarotCardEntity>[].obs;
  final RxList<TarotCardEntity> swordCards = <TarotCardEntity>[].obs;
  final RxList<TarotCardEntity> pentacleCards = <TarotCardEntity>[].obs;

  ExploreController(this.apiClient) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchBlogs();
      await fetchTarotCards();
    });
  }

  Future<void> fetchBlogs() async {
    developer.log(
      'Fetching blogs',
      name: 'ExploreController',
    );

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await apiClient.getBlogs();

      if (response == null) {
        throw Exception('Blog detail response is null');
      }

      blogs.value = response.docs ?? [];

      developer.log(
        'Fetch blogs success',
        name: 'ploreController',
      );
    } catch (e, stackTrace) {
      errorMessage.value = 'Không thể tải list sản phẩm';

      developer.log(
        'Fetch blogs failed',
        name: 'Explore Controller',
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTarotCards() async {
    developer.log('Fetching cards', name: 'ExploreController');

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // chạy song song tất cả request
      final results = await Future.wait([
        apiClient.getTarotCards(
          arcana: Arcana.majorArcana.label,
          limit: 4,
        ),
        apiClient.getTarotCards(
          arcana: Arcana.minorArcana.label,
          suit: "Cups",
          limit: 4,
        ),
        apiClient.getTarotCards(
          arcana: Arcana.minorArcana.label,
          suit: "Swords",
          limit: 4,
        ),
        apiClient.getTarotCards(
          arcana: Arcana.minorArcana.label,
          suit: "Wands",
          limit: 4,
        ),
        apiClient.getTarotCards(
          arcana: Arcana.minorArcana.label,
          suit: "Pentacles",
          limit: 4,
        ),
      ]);

      // gán kết quả
      majorCards.addAll(results[0]);
      cupCards.addAll(results[1]);
      swordCards.addAll(results[2]);
      wandCards.addAll(results[3]);
      pentacleCards.addAll(results[4]);

      developer.log('Fetch cards success', name: 'ExploreController');
    } catch (e, stackTrace) {
      errorMessage.value = 'Không thể tải list cards';
      developer.log(
        'Fetch cards failed',
        name: 'ExploreController',
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      isLoading.value = false;
    }
  }



}
