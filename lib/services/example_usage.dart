// Example: Cách sử dụng API service trong GetX Controller
// 
// File này chỉ là example, không được import vào code chính

import 'package:get/get.dart';
import '../models/tarot_card.dart';
import 'tarot_api_service.dart';
import 'api_service.dart';

/// Example: HomeController với API integration
class ExampleHomeController extends GetxController {
  // API service instance
  final TarotApiService _tarotApi = TarotApiService();

  // Reactive state
  final _cards = <TarotCard>[].obs;
  final _isLoading = false.obs;
  final _error = RxString('');

  // Getters
  List<TarotCard> get cards => _cards;
  bool get isLoading => _isLoading.value;
  String? get error => _error.value.isEmpty ? null : _error.value;

  @override
  void onInit() {
    super.onInit();
    // Load cards khi khởi tạo
    loadCards();
  }

  /// Load all cards từ API
  Future<void> loadCards() async {
    try {
      _isLoading.value = true;
      _error.value = '';

      final cards = await _tarotApi.getAllCards();
      _cards.assignAll(cards);
    } on ApiException catch (e) {
      _error.value = e.message;
      Get.snackbar(
        'Lỗi',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      _error.value = 'Đã xảy ra lỗi không xác định: ${e.toString()}';
      Get.snackbar(
        'Lỗi',
        'Không thể tải danh sách lá bài',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// Load random card từ API
  Future<void> loadRandomCard() async {
    try {
      _isLoading.value = true;
      _error.value = '';

      final randomCard = await _tarotApi.getRandomCard();
      // Xử lý random card...
      print('Random card: ${randomCard.nameVi}');
    } on ApiException catch (e) {
      _error.value = e.message;
      Get.snackbar('Lỗi', e.message);
    } finally {
      _isLoading.value = false;
    }
  }

  /// Create new card
  Future<void> createCard(TarotCard card) async {
    try {
      _isLoading.value = true;
      final createdCard = await _tarotApi.createCard(card);
      _cards.add(createdCard);
      Get.snackbar('Thành công', 'Tạo lá bài thành công');
    } on ApiException catch (e) {
      Get.snackbar('Lỗi', e.message);
    } finally {
      _isLoading.value = false;
    }
  }

  /// Update card
  Future<void> updateCard(String cardId, TarotCard card) async {
    try {
      _isLoading.value = true;
      final updatedCard = await _tarotApi.updateCard(cardId, card);
      final index = _cards.indexWhere((c) => c.id == cardId);
      if (index != -1) {
        _cards[index] = updatedCard;
      }
      Get.snackbar('Thành công', 'Cập nhật lá bài thành công');
    } on ApiException catch (e) {
      Get.snackbar('Lỗi', e.message);
    } finally {
      _isLoading.value = false;
    }
  }

  /// Delete card
  Future<void> deleteCard(String cardId) async {
    try {
      _isLoading.value = true;
      await _tarotApi.deleteCard(cardId);
      _cards.removeWhere((c) => c.id == cardId);
      Get.snackbar('Thành công', 'Xóa lá bài thành công');
    } on ApiException catch (e) {
      Get.snackbar('Lỗi', e.message);
    } finally {
      _isLoading.value = false;
    }
  }
}

