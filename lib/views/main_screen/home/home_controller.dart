import 'package:get/get.dart';
import '../../../models/tarot_card.dart';

class HomeController extends GetxController {
  // Selected tarot card
  final _selectedCard = Rx<TarotCard?>(null);
  TarotCard? get selectedCard => _selectedCard.value;

  // Animation state để trigger fade in cho text
  final _showCardDetail = false.obs;
  bool get showCardDetail => _showCardDetail.value;

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

  /// Select a tarot card
  void selectCard(TarotCard card) {
    _selectedCard.value = card;
    // Trigger animation sau một chút để đợi flip animation hoàn thành
    Future.delayed(const Duration(milliseconds: 100), () {
      _showCardDetail.value = true;
    });
  }

  /// Deselect card - reset về trạng thái ban đầu
  void deselectCard() {
    _showCardDetail.value = false;
    _selectedCard.value = null;
  }

  /// Get random card
  void getRandomCard() {
    if (_cards.isNotEmpty) {
      final random = _cards[DateTime.now().millisecond % _cards.length];
      selectCard(random);
    }
  }
}

