import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tarot_fe/models/tarot_card_entity.dart';
import 'package:tarot_fe/providers/api_client.dart';
import 'package:video_player/video_player.dart';
import '../../../models/tarot_card.dart';
import '../main_screen/main_controller.dart';

class CardDetailController extends GetxController {
  // Card data được truyền từ explore page
  final Rx<TarotCardEntity> card = Rx<TarotCardEntity>(TarotCardEntity());
  final ApiClient apiClient;
  final isLoading = false.obs;
  final errorMessage = "".obs;
  final String cardId;

  // Video controller cho background
  VideoPlayerController? _videoController;

  VideoPlayerController? get videoController => _videoController;

  final _hasVideoError = false.obs;

  bool get hasVideoError => _hasVideoError.value;

  // Animation state
  final _showCardDetail = false.obs;

  bool get showCardDetail => _showCardDetail.value;

  // Flip state - để track lá bài đã được lật hay chưa
  // Mặc định là true (mặt trước) để card hiển thị ngửa trước
  final _isCardFlipped = true.obs;

  bool get isCardFlipped => _isCardFlipped.value;

  CardDetailController(this.cardId, this.apiClient) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchCardDetail();
    });
  }

  /// Flip card
  void flipCard() {
    _isCardFlipped.value = !_isCardFlipped.value;
  }



  @override
  void onInit() {
    super.onInit();

    // Pause MainController video khi vào detail page
    _pauseMainVideo();

    // Initialize video background ngay lập tức
    _initializeVideo();

    // Trigger animation sau khi Hero animation hoàn thành
    // Delay một chút để Hero animation mượt mà hơn
    Future.delayed(const Duration(milliseconds: 500), () {
      _showCardDetail.value = true;
    });
  }

  Future<void> fetchCardDetail() async {
    developer.log(
      'Fetching card detail',
      name: 'cardDetailController',
      error: {'cardId': cardId},
    );

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await apiClient.getCardDetailById(cardId);

      if (response == null) {
        throw Exception('card detail response is null');
      }

      card.value = response;

      developer.log(
        'Fetch card detail success',
        name: 'cardDetailController',
      );
    } catch (e, stackTrace) {
      errorMessage.value = 'Không thể tải chi tiết sản phẩm';

      developer.log(
        'Fetch card detail failed',
        name: 'cardDetailController',
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Pause MainController video để tránh conflict
  void _pauseMainVideo() {
    try {
      // Tìm MainController và pause video nếu có
      if (Get.isRegistered<MainController>()) {
        final mainController = Get.find<MainController>();
        mainController.pauseVideo();
      }
    } catch (e) {
      // Ignore nếu MainController chưa được register
      print('MainController not found: $e');
    }
  }

  /// Resume MainController video khi quay lại
  void _resumeMainVideo() {
    try {
      if (Get.isRegistered<MainController>()) {
        final mainController = Get.find<MainController>();
        mainController.resumeVideo();
      }
    } catch (e) {
      // Ignore nếu MainController chưa được register
      print('MainController not found: $e');
    }
  }

  /// Initialize video background
  Future<void> _initializeVideo() async {
    try {
      _videoController =
          VideoPlayerController.asset('assets/videos/video_bg2.mp4');

      // Set video properties trước khi initialize
      await _videoController!.setLooping(true);
      await _videoController!.setVolume(0); // Tắt âm

      // Initialize video player
      await _videoController!.initialize();

      // Start playing
      _videoController!.play();

      // Update reactive state để UI rebuild
      _hasVideoError.value = false;

      // Add listener để UI tự động rebuild khi video state thay đổi
      _videoController!.addListener(() {
        if (_videoController!.value.hasError) {
          _hasVideoError.value = true;
        }
      });
    } catch (error) {
      print('CardDetailController: Video initialization FAILED: $error');
      await _videoController?.dispose();
      _videoController = null;
      _hasVideoError.value = true;
    }
  }

  @override
  void onClose() {
    // Resume MainController video khi đóng detail page
    _resumeMainVideo();

    // Dispose video controller của detail page
    _videoController?.dispose();
    super.onClose();
  }
}
