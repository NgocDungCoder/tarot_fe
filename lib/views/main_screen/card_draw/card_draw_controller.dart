import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../../models/tarot_card.dart';
import '../home/home_controller.dart';
import '../main_controller.dart';

class CardDrawController extends GetxController {
  // Card đã được random từ home controller
  late final TarotCard selectedCard;
final isFlipping = true.obs;
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

  @override
  void onInit() {
    super.onInit();
    // Get card từ arguments (card đã được random từ home)
    final arguments = Get.arguments;
    if (arguments is TarotCard) {
      selectedCard = arguments;
    } else if (arguments is Map<String, dynamic> && arguments['card'] != null) {
      selectedCard = arguments['card'] as TarotCard;
    } else {
      // Fallback: lấy từ HomeController nếu không có arguments
      if (Get.isRegistered<HomeController>()) {
        final homeController = Get.find<HomeController>();
        selectedCard = homeController.randomCard ?? _getDefaultCard();
      } else {
        selectedCard = _getDefaultCard();
      }
    }

    // Pause MainController video khi vào card draw page
    _pauseMainVideo();
    
    // Initialize video background
    _initializeVideo();
    
    // Tạo 5 lá bài để hiển thị: 1 lá ở giữa (hero) + 2 trái + 2 phải
    _generateDisplayCards();
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

  /// Generate 5 display cards: 1 lá ở giữa (hero từ home) + 2 trái + 2 phải
  /// Layout: [0: trái trên, 1: trái dưới, 2: giữa (hero), 3: phải trên, 4: phải dưới]
  void _generateDisplayCards() {
    // Lấy danh sách cards từ HomeController hoặc tạo default
    List<TarotCard> allCards = [];
    if (Get.isRegistered<HomeController>()) {
      final homeController = Get.find<HomeController>();
      allCards = homeController.cards;
    }

    // Nếu không có cards từ HomeController, tạo default cards
    if (allCards.isEmpty) {
      allCards = _getDefaultCards();
    }

    // Tạo danh sách lá bài giả (khác với selectedCard)
    final fakeCards = <TarotCard>[];
    final availableCards = allCards.where((card) => card.id != selectedCard.id).toList();
    
    // Tạo 4 lá giả cho 2 trái + 2 phải
    if (availableCards.isNotEmpty) {
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
      selectedCard, // Giữa (hero từ home)
      fakeCards[2], // Phải trên
      fakeCards[3], // Phải dưới
    ];
  }

  // State để track zoom completed
  final _isZoomCompleted = false.obs;
  bool get isZoomCompleted => _isZoomCompleted.value;
  
  // State để track card đã được flip bởi user chưa
  final _isCardFlipped = false.obs;
  bool get isCardFlipped => _isCardFlipped.value;

  /// Select a card với zoom animation trước, sau đó thay bằng FlipCard để user tự lật
  /// Index: 0=trái trên, 1=trái dưới, 2=giữa, 3=phải trên, 4=phải dưới
  void selectCard(int index) {
    if (_hasSelected.value || _isZooming.value) return;

    _selectedIndex.value = index;
    _zoomedCardIndex.value = index;
    _isZooming.value = true;
    _isZoomCompleted.value = false;
    _isCardFlipped.value = false;

    // Bước 1: Zoom animation (bay lên) - 1200ms để đảm bảo mượt
    Future.delayed(const Duration(milliseconds: 1200), () {
      // Đánh dấu zoom đã hoàn thành - lúc này sẽ thay bằng FlipCard
      _isZooming.value = false;
      _isZoomCompleted.value = true;
      // Không tự động flip, để user tự lật
    });
  }

  /// User flip card manually
  void flipCard() {
    _isCardFlipped.value = !_isCardFlipped.value;
    
    // Sau khi flip xong, hiển thị card details
    if (_isCardFlipped.value) {
      Future.delayed(const Duration(milliseconds: 3000), () {
        _hasSelected.value = true;
        Future.delayed(const Duration(milliseconds: 300), () {
          _showCardDetail.value = true;
        });
      });
    }
  }

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

  /// Get default cards list
  List<TarotCard> _getDefaultCards() {
    return const [
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
    ];
  }
}

