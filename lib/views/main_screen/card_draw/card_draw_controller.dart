import 'dart:math';

import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../../models/tarot_card.dart';
import '../../../models/card_draw_history.dart';
import '../../../services/storage_service.dart';
import '../../../widget/custom_snackbar.dart';
import '../home/home_controller.dart';
import '../main_controller.dart';
import '../card_draw_history/card_draw_history_controller.dart';

class CardDrawController extends GetxController {
  // Card đã được random từ home controller
  late final TarotCard selectedCard;
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
  final _displayCards = <TarotCard>[].obs;
  List<TarotCard> get displayCards => _displayCards;


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

  // Random instance để tạo số ngẫu nhiên
  final _random = Random();

  // Danh sách tarot cards
  final List<TarotCard> _cards = const [
    TarotCard(
      id: '1',
      name: 'The Moon',
      nameVi: 'Mặt Trăng',
      imagePath: 'assets/images/m18.jpg',
      description: 'Lá bài đại diện cho trực giác, giấc mơ và tiềm thức.',
      meaning: 'Trực giác, giấc mơ, tiềm thức, sự bí ẩn, cảm xúc sâu thẳm.',
      reversedMeaning: 'Nhầm lẫn, sợ hãi, thiếu trực giác, bị che giấu sự thật.',
    ),
    TarotCard(
      id: '2',
      name: 'The Star',
      nameVi: 'Ngôi Sao',
      imagePath: 'assets/images/m14.jpg',
      description: 'Lá bài đại diện cho hy vọng, hướng dẫn và sự khai sáng.',
      meaning: 'Hy vọng, hướng dẫn, khai sáng, cảm hứng, hòa bình nội tâm.',
      reversedMeaning: 'Thất vọng, thiếu hy vọng, mất phương hướng, bi quan.',
    ),
    TarotCard(
      id: '3',
      name: 'The Lovers',
      nameVi: 'Người Tình',
      imagePath: 'assets/images/m6.jpg',
      description: 'Lá bài đại diện cho tình yêu, sự lựa chọn và sự kết hợp.',
      meaning: 'Tình yêu, sự lựa chọn, kết hợp, hài hòa, quyết định quan trọng.',
      reversedMeaning: 'Xung đột, thiếu hài hòa, lựa chọn sai, mất cân bằng.',
    ),
    TarotCard(
      id: '4',
      name: 'The Magician',
      nameVi: 'Phù Thủy',
      imagePath: 'assets/images/m1.jpg',
      description: 'Lá bài đại diện cho ý chí, khả năng và sự tập trung.',
      meaning: 'Ý chí mạnh mẽ, khả năng, tập trung, quyết tâm, hành động.',
      reversedMeaning: 'Thiếu ý chí, lãng phí năng lượng, không tập trung, yếu đuối.',
    ),
    TarotCard(
      id: '5',
      name: 'The High Priestess',
      nameVi: 'Nữ Tư Tế',
      imagePath: 'assets/images/m2.jpg',
      description: 'Lá bài đại diện cho trực giác, bí mật và sự khôn ngoan.',
      meaning: 'Trực giác, bí mật, khôn ngoan, nội tâm, tiềm thức.',
      reversedMeaning: 'Thiếu trực giác, bí mật bị tiết lộ, thiếu hiểu biết.',
    ),
    TarotCard(
      id: '6',
      name: 'The Empress',
      nameVi: 'Hoàng Hậu',
      imagePath: 'assets/images/m3.jpg',
      description: 'Lá bài đại diện cho sự sinh sôi, phong phú và sáng tạo.',
      meaning: 'Sinh sôi, phong phú, sáng tạo, nuôi dưỡng, thịnh vượng.',
      reversedMeaning: 'Thiếu sáng tạo, nghèo nàn, thiếu nuôi dưỡng, trì trệ.',
    ),
    TarotCard(
      id: '7',
      name: 'The Emperor',
      nameVi: 'Hoàng Đế',
      imagePath: 'assets/images/m4.jpg',
      description: 'Lá bài đại diện cho quyền lực, cấu trúc và sự kiểm soát.',
      meaning: 'Quyền lực, cấu trúc, kiểm soát, ổn định, lãnh đạo.',
      reversedMeaning: 'Lạm dụng quyền lực, thiếu cấu trúc, độc đoán, cứng nhắc.',
    ),
    TarotCard(
      id: '8',
      name: 'Ace of Cups',
      nameVi: 'Át Cốc',
      imagePath: 'assets/images/c1.jpg',
      description: 'Lá bài đại diện cho tình yêu mới, cảm xúc và sự khởi đầu.',
      meaning: 'Tình yêu mới, cảm xúc, khởi đầu, niềm vui, hạnh phúc.',
      reversedMeaning: 'Cảm xúc bị chặn, thiếu tình yêu, đau khổ, thất vọng.',
    ),
    TarotCard(
      id: '9',
      name: 'Two of Cups',
      nameVi: 'Hai Cốc',
      imagePath: 'assets/images/c2.jpg',
      description: 'Lá bài đại diện cho sự kết hợp, hợp tác và tình bạn.',
      meaning: 'Kết hợp, hợp tác, tình bạn, hòa hợp, đối tác.',
      reversedMeaning: 'Xung đột, chia ly, thiếu hòa hợp, mất kết nối.',
    ),
    TarotCard(
      id: '10',
      name: 'Three of Cups',
      nameVi: 'Ba Cốc',
      imagePath: 'assets/images/c3.jpg',
      description: 'Lá bài đại diện cho niềm vui, lễ kỷ niệm và tình bạn.',
      meaning: 'Niềm vui, lễ kỷ niệm, tình bạn, hạnh phúc, đoàn kết.',
      reversedMeaning: 'Cô đơn, thiếu niềm vui, xung đột bạn bè, cô lập.',
    ),
    TarotCard(
      id: '11',
      name: 'Four of Cups',
      nameVi: 'Bốn Cốc',
      imagePath: 'assets/images/c4.jpg',
      description: 'Lá bài đại diện cho sự thờ ơ, bỏ lỡ cơ hội và tự suy ngẫm.',
      meaning: 'Thờ ơ, bỏ lỡ cơ hội, tự suy ngẫm, thiếu động lực.',
      reversedMeaning: 'Nhận ra cơ hội, hành động, tham gia, nhiệt tình.',
    ),
    TarotCard(
      id: '12',
      name: 'Ace of Wands',
      nameVi: 'Át Gậy',
      imagePath: 'assets/images/w1.jpg',
      description: 'Lá bài đại diện cho khởi đầu mới, cảm hứng và năng lượng.',
      meaning: 'Khởi đầu mới, cảm hứng, năng lượng, đam mê, sáng tạo.',
      reversedMeaning: 'Thiếu cảm hứng, mất năng lượng, trì hoãn, thất bại.',
    ),
    TarotCard(
      id: '13',
      name: 'Two of Wands',
      nameVi: 'Hai Gậy',
      imagePath: 'assets/images/w2.jpg',
      description: 'Lá bài đại diện cho lập kế hoạch, quyết định và tầm nhìn.',
      meaning: 'Lập kế hoạch, quyết định, tầm nhìn, chuẩn bị, khám phá.',
      reversedMeaning: 'Thiếu kế hoạch, không quyết định, thiếu tầm nhìn, sợ hãi.',
    ),
  ];

  List<TarotCard> get cards => _cards;

  @override
  void onInit() {
    super.onInit();
    
    // Load số lượt rút còn lại từ storage
    _loadDrawCount();
    
    // Load lịch sử rút bài
    _loadDrawHistory();
    
    // Random một lá bài khi vào màn hình và gán vào selectedCard
    _generateRandomCard();

    // Pause MainController video khi vào card draw page
    _pauseMainVideo();
    
    // Initialize video background
    _initializeVideo();
    
    // Tạo 5 lá bài để hiển thị: 1 lá ở giữa (hero) + 2 trái + 2 phải
    _generateDisplayCards();
  }

  final _storage = StorageService();

  /// Load số lượt rút còn lại từ storage
  void _loadDrawCount() {
    final count = _storage.read<int>(_drawCountKey) ?? _maxDraws;
    _remainingDraws.value = count;
  }

  /// Save số lượt rút còn lại vào storage
  void _saveDrawCount() {
    _storage.write(_drawCountKey, _remainingDraws.value);
  }

  /// Load lịch sử rút bài từ storage
  void _loadDrawHistory() {
    try {
      final historyJson = _storage.read<List<dynamic>>(_drawHistoryKey) ?? [];
      _drawHistory.value = historyJson
          .map((json) => CardDrawHistory.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _drawHistory.value = [];
    }
  }

  /// Save lịch sử rút bài vào storage
  void _saveDrawHistory() {
    try {
      final historyJson = _drawHistory.map((h) => h.toJson()).toList();
      _storage.write(_drawHistoryKey, historyJson);
    } catch (e) {
      print('Error saving draw history: $e');
    }
  }

  /// Thêm vào lịch sử rút bài
  void _addToHistory(TarotCard card) {
    final history = CardDrawHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      cardId: card.id,
      cardName: card.name,
      cardNameVi: card.nameVi,
      cardImagePath: card.imagePath,
      drawnAt: DateTime.now(),
      isReversed: card.isReversed,
    );
    _drawHistory.insert(0, history); // Thêm vào đầu danh sách
    // Giới hạn lịch sử tối đa 50 lá bài
    if (_drawHistory.length > 50) {
      _drawHistory.removeRange(50, _drawHistory.length);
    }
    _saveDrawHistory();

    // Also save to CardDrawHistoryController if registered
    if (Get.isRegistered<CardDrawHistoryController>()) {
      Get.find<CardDrawHistoryController>().addHistory(history);
    }
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
      duration: const Duration(seconds: 2),
    );
  }

  /// Generate random card - chọn 1 lá ngẫu nhiên từ danh sách cards
  void _generateRandomCard() {
    if (_cards.isNotEmpty) {
      // Sử dụng Random class để tạo số ngẫu nhiên thực sự
      final randomIndex = _random.nextInt(_cards.length);
      selectedCard = _cards[randomIndex];
    } else {
      selectedCard = _getDefaultCard();
    }
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
      _videoController = VideoPlayerController.asset('assets/videos/video_bg2.mp4');
      
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

  /// Generate 5 display cards: 1 lá ở giữa (hero - selectedCard) + 2 trái + 2 phải
  /// Layout: [0: trái trên, 1: trái dưới, 2: giữa (hero), 3: phải trên, 4: phải dưới]
  void _generateDisplayCards() {
    // Tạo danh sách lá bài giả (khác với selectedCard)
    final fakeCards = <TarotCard>[];
    final availableCards = List<TarotCard>.from(
      _cards.where((card) => card.id != selectedCard.id),
    );
    
    // Tạo 4 lá giả cho 2 trái + 2 phải
    if (availableCards.isNotEmpty) {
      // Shuffle để random
      availableCards.shuffle(_random);
      // Lấy 4 lá đầu tiên
      fakeCards.addAll(availableCards.take(4));
      // Nếu không đủ 4 lá, lặp lại cho đủ
      while (fakeCards.length < 4) {
        fakeCards.addAll(availableCards);
      }
      fakeCards.removeRange(4, fakeCards.length);
    } else {
      fakeCards.addAll(List.filled(4, selectedCard));
    }

    // Layout: [0: trái trên, 1: trái dưới, 2: giữa (hero), 3: phải trên, 4: phải dưới]
    _displayCards.value = [
      fakeCards[0], // Trái trên
      fakeCards[1], // Trái dưới
      selectedCard, // Giữa (hero - selectedCard đã được random)
      fakeCards[2], // Phải trên
      fakeCards[3], // Phải dưới
    ];
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
        duration: const Duration(seconds: 3),
      );
      return;
    }

    if (_hasSelected.value || _isZooming.value) return;

    // Giảm số lượt rút và lưu vào storage
    _remainingDraws.value--;
    _saveDrawCount();

    // Thêm vào lịch sử rút bài
    _addToHistory(selectedCard);

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

  /// Get default card
  TarotCard _getDefaultCard() {
    return const TarotCard(
      id: '1',
      name: 'The Moon',
      nameVi: 'Mặt Trăng',
      imagePath: 'assets/images/m18.jpg',
      description: 'Lá bài đại diện cho trực giác, giấc mơ và tiềm thức.',
      meaning: 'Trực giác, giấc mơ, tiềm thức, sự bí ẩn, cảm xúc sâu thẳm.',
      reversedMeaning: 'Nhầm lẫn, sợ hãi, thiếu trực giác, bị che giấu sự thật.',
    );
  }

}

