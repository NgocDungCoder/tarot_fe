import 'package:get/get.dart';
import '../../../models/tarot_card.dart';
import 'explore_controller.dart';
import 'explore_page.dart';

/// Controller for View All Cards page
/// 
/// Manages the list of cards for a specific card type (Major, Cup, Wand, Sword)
class ViewAllCardsController extends GetxController {
  // Card type và danh sách lá bài
  late final String cardType;
  late final String title;
  final List<TarotCard> _cards = [];

  // Getters
  List<TarotCard> get cards => _cards;

  @override
  void onInit() {
    super.onInit();
    // Get card type và title từ arguments
    final arguments = Get.arguments;
    if (arguments is Map<String, dynamic>) {
      cardType = arguments['cardType'] as String? ?? '';
      title = arguments['title'] as String? ?? cardType;
    } else if (arguments is String) {
      cardType = arguments;
      title = cardType;
    } else {
      cardType = '';
      title = 'All Cards';
    }

    // Load cards từ ExploreController
    _loadCards();
  }

  /// Load cards từ ExploreController dựa trên cardType
  void _loadCards() {
    // Get ExploreController instance
    // Nếu chưa có thì tạo mới
    if (!Get.isRegistered<ExploreController>()) {
      ExploreBinding().dependencies();
    }
    final exploreController = Get.find<ExploreController>();

    // Lấy danh sách lá bài theo loại
    switch (cardType) {
      case 'Major':
        _cards.addAll(exploreController.majorCards);
        break;
      case 'Cup':
        _cards.addAll(exploreController.cupCards);
        break;
      case 'Wand':
        _cards.addAll(exploreController.wandCards);
        break;
      case 'Sword':
        _cards.addAll(exploreController.swordCards);
        break;
      default:
        // Nếu không match, lấy tất cả
        _cards.addAll(exploreController.majorCards);
        _cards.addAll(exploreController.cupCards);
        _cards.addAll(exploreController.wandCards);
        _cards.addAll(exploreController.swordCards);
        break;
    }
  }

  /// Navigate to card detail page
  void navigateToCardDetail(TarotCard card) {
    Get.toNamed(
      '/card-detail',
      arguments: card,
    );
  }
}

