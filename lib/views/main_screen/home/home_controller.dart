import 'dart:math';
import 'package:get/get.dart';
import '../../../models/tarot_card.dart';

class HomeController extends GetxController {
  // Random card được chọn - lưu lại để không bị thay đổi mỗi lần rebuild
  final _randomCard = Rx<TarotCard?>(null);
  TarotCard? get randomCard => _randomCard.value;

  // Flag để biết lá bài đã được lật (revealed) hay chưa
  final _isCardRevealed = false.obs;
  bool get isCardRevealed => _isCardRevealed.value;

  // Animation state để trigger fade in cho text
  final _showCardDetail = false.obs;
  bool get showCardDetail => _showCardDetail.value;

  // Random instance để tạo số ngẫu nhiên thực sự
  final _random = Random();

  @override
  void onInit() {
    super.onInit();
    // Random một lá bài khi khởi tạo
    _generateRandomCard();
  }

  // Sample tarot cards data - sử dụng hình ảnh có sẵn trong assets
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
  ];

  List<TarotCard> get cards => _cards;

  /// Reveal card - khi user lật lá bài
  void revealCard() {
    if (_randomCard.value != null) {
      _isCardRevealed.value = true;
      // Trigger animation sau một chút để đợi flip animation hoàn thành
      Future.delayed(const Duration(milliseconds: 100), () {
        _showCardDetail.value = true;
      });
    }
  }

  /// Reset card - reset về trạng thái ban đầu và random lá bài mới
  void resetCard() {
    _showCardDetail.value = false;
    _isCardRevealed.value = false;
    // Random lá bài mới khi reset
    _generateRandomCard();
  }

  /// Generate random card - sử dụng Random class thực sự
  void _generateRandomCard() {
    if (_cards.isNotEmpty) {
      // Sử dụng Random class để tạo số ngẫu nhiên thực sự
      final randomIndex = _random.nextInt(_cards.length);
      _randomCard.value = _cards[randomIndex];
    } else {
      _randomCard.value = null;
    }
  }
}

