import 'dart:developer' as developer;
import 'dart:math';

import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../../models/tarot_card.dart';
import '../../../models/card_draw_history.dart';
import '../../../services/storage_service.dart';
import '../../../widget/custom_snackbar.dart';
import '../../models/tarot_card_entity.dart';
import '../../providers/api_client.dart';
import '../card_draw_history/card_draw_history_controller.dart';
import '../main_screen/main_controller.dart';

class CardDrawController extends GetxController {
  final ApiClient apiClient;
  final isLoading = false.obs;
  final errorMessage = "".obs;

  final Rx<TarotCardEntity> selectedCard =
      Rx<TarotCardEntity>(TarotCardEntity());

  CardDrawController(this.apiClient);

  final isFlipping = true.obs;

  // Quản lý lượt rút bài
  static const String _drawCountKey = 'card_draw_count';
  static const String _drawHistoryKey = 'card_draw_history';
  static const int _maxDraws = 3; // Số lượt rút tối đa

  final _remainingDraws = _maxDraws.obs;

  int get remainingDraws => _remainingDraws.value;

  bool get canDraw => _remainingDraws.value > 0;

  // Lịch sử rút bài
  final _drawHistory = <CardDrawHistory>[].obs;

  List<CardDrawHistory> get drawHistory => _drawHistory;

  // 5 lá bài để hiển thị: 1 lá ở giữa (hero từ home) + 2 trái + 2 phải (4 lá giả)
  final _displayCards = <TarotCardEntity>[].obs;

  List<TarotCardEntity> get displayCards => _displayCards;

  // Video controller cho background
  VideoPlayerController? _videoController;

  VideoPlayerController? get videoController => _videoController;

  final _hasVideoError = false.obs;

  bool get hasVideoError => _hasVideoError.value;

  // Lá bài nào đã được chọn
  final _selectedIndex = Rx<int?>(null);

  int? get selectedIndex => _selectedIndex.value;

  // Đã chọn lá bài chưa
  final _hasSelected = false.obs;

  bool get hasSelected => _hasSelected.value;

  // Animation state để trigger fade in cho text
  final _showCardDetail = false.obs;

  bool get showCardDetail => _showCardDetail.value;

  @override
  void onInit() async {
    super.onInit();
    // Random một lá bài khi khởi tạo
    await fetchRandomCard();

    _loadDrawCount();

    // Load lịch sử rút bài
    _loadDrawHistory();

    // Pause MainController video khi vào card draw page
    _pauseMainVideo();

    // Initialize video background
    _initializeVideo();

    // Tạo 5 lá bài để hiển thị: 1 lá ở giữa (hero) + 2 trái + 2 phải
    _generateDisplayCards();
  }

  Future<void> fetchRandomCard() async {
    developer.log(
      'Fetching card detail',
      name: 'cardDetailController',
    );

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await apiClient.getRandomCard();

      if (response == null) {
        throw Exception('card detail response is null');
      }

      selectedCard.value = response;

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

  final _storage = StorageService();

  /// Load số lượt rút còn lại từ storage
  void _loadDrawCount() {
    // final count = _storage.read<int>(_drawCountKey) ?? _maxDraws;
    // _remainingDraws.value = count;
  }

  /// Save số lượt rút còn lại vào storage
  void _saveDrawCount() {
    // _storage.write(_drawCountKey, _remainingDraws.value);
  }

  /// Load lịch sử rút bài từ storage
  void _loadDrawHistory() {
    try {
      // final historyJson = _storage.read<List<dynamic>>(_drawHistoryKey) ?? [];
      // _drawHistory.value = historyJson
      //     .map((json) => CardDrawHistory.fromJson(json as Map<String, dynamic>))
      //     .toList();
    } catch (e) {
      _drawHistory.value = [];
    }
  }

  /// Save lịch sử rút bài vào storage
  void _saveDrawHistory() {
    try {
      final historyJson = _drawHistory.map((h) => h.toJson()).toList();
      // _storage.write(_drawHistoryKey, historyJson);
    } catch (e) {
      print('Error saving draw history: $e');
    }
  }

  /// Thêm vào lịch sử rút bài
  void _addToHistory(TarotCardEntity card) {
    // final history = CardDrawHistory(
    //   id: DateTime.now().millisecondsSinceEpoch.toString(),
    //   cardId: card.id,
    //   cardName: card.name,
    //   cardNameVi: card.nameVi,
    //   cardImagePath: card.imagePath,
    //   drawnAt: DateTime.now(),
    //   isReversed: card.isReversed,
    // );
    // _drawHistory.insert(0, history); // Thêm vào đầu danh sách
    // // Giới hạn lịch sử tối đa 50 lá bài
    // if (_drawHistory.length > 50) {
    //   _drawHistory.removeRange(50, _drawHistory.length);
    // }
    // _saveDrawHistory();
    //
    // // Also save to CardDrawHistoryController if registered
    // if (Get.isRegistered<CardDrawHistoryController>()) {
    //   Get.find<CardDrawHistoryController>().addHistory(history);
    // }
  }

  /// Mua thêm lượt rút bài
  /// TODO: Implement logic mua lượt rút (có thể dùng magicPoints)
  void buyDraws({int count = 1}) {
    // Tạm thời chỉ tăng lượt rút
    _remainingDraws.value += count;
    _saveDrawCount();

    CustomSnackbar.success(
      title: 'Thành công',
      message: 'Đã mua $count lượt rút bài',
      duration: const Duration(seconds: 1),
    );
  }

  /// Pause MainController video để tránh conflict
  void _pauseMainVideo() {
    try {
      if (Get.isRegistered<MainController>()) {
        final mainController = Get.find<MainController>();
        mainController.pauseVideo();
      }
    } catch (e) {
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
      print('MainController not found: $e');
    }
  }

  /// Initialize video background
  Future<void> _initializeVideo() async {
    try {
      _videoController =
          VideoPlayerController.asset('assets/videos/video_bg2.mp4');

      await _videoController!.setLooping(true);
      await _videoController!.setVolume(0);

      await _videoController!.initialize();

      _videoController!.play();

      _hasVideoError.value = false;

      _videoController!.addListener(() {
        if (_videoController!.value.hasError) {
          _hasVideoError.value = true;
        }
      });
    } catch (error) {
      print('CardDrawController: Video initialization FAILED: $error');
      await _videoController?.dispose();
      _videoController = null;
      _hasVideoError.value = true;
    }
  }

  // State để track zoom animation
  final _isZooming = false.obs;

  bool get isZooming => _isZooming.value;

  final _zoomedCardIndex = Rx<int?>(null);

  int? get zoomedCardIndex => _zoomedCardIndex.value;
  
  void _generateDisplayCards() {
    _displayCards.addAll(List.filled(5, selectedCard.value));
  }

  // State để track zoom completed
  final _isZoomCompleted = false.obs;

  bool get isZoomCompleted => _isZoomCompleted.value;

  /// Select a card với zoom animation trước, sau đó thay bằng FlipCard để user tự lật
  /// Index: 0=trái trên, 1=trái dưới, 2=giữa, 3=phải trên, 4=phải dưới
  void selectCard(int index) {
    // Check lượt rút còn lại
    if (!canDraw) {
      CustomSnackbar.warning(
        title: 'Hết lượt rút',
        message: 'Bạn đã hết lượt rút bài. Vui lòng mua thêm lượt rút.',
        duration: const Duration(seconds: 2),
      );
      return;
    }

    if (_hasSelected.value || _isZooming.value) return;

    // Giảm số lượt rút và lưu vào storage
    _remainingDraws.value--;
    _saveDrawCount();

    // Thêm vào lịch sử rút bài
    _addToHistory(selectedCard.value);

    _selectedIndex.value = index;
    _zoomedCardIndex.value = index;
    _isZooming.value = true;
    _isZoomCompleted.value = false;

    // Bước 1: Zoom animation (bay lên) - 1200ms để đảm bảo mượt
    Future.delayed(const Duration(milliseconds: 1200), () {
      _isZooming.value = false;

      _isZoomCompleted.value = true;
      Future.delayed(const Duration(milliseconds: 1200), () {
        _hasSelected.value = true;
        Future.delayed(const Duration(milliseconds: 300), () {
          _showCardDetail.value = true;
        });
      });
    });
  }

  /// Navigate to draw history page
  void navigateToHistory() {
    Get.toNamed('/card-draw-history');
  }

  /// User flip card manually

  @override
  void onClose() {
    _resumeMainVideo();
    _videoController?.dispose();
    super.onClose();
  }
}
