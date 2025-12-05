import 'package:get/get.dart';
import '../../../models/tarot_card.dart';

class ExploreController extends GetxController {
  // Dữ liệu ảo cho các loại lá bài
  final List<TarotCard> _majorCards = [];
  final List<TarotCard> _cupCards = [];
  final List<TarotCard> _wandCards = [];
  final List<TarotCard> _swordCards = [];

  // Getters
  List<TarotCard> get majorCards => _majorCards;
  List<TarotCard> get cupCards => _cupCards;
  List<TarotCard> get wandCards => _wandCards;
  List<TarotCard> get swordCards => _swordCards;

  @override
  void onInit() {
    super.onInit();
    // Khởi tạo dữ liệu ảo
    _initializeMockData();
  }

  /// Khởi tạo dữ liệu ảo cho 16 lá bài
  void _initializeMockData() {
    // Major Arcana (4 lá)
    _majorCards.addAll([
      TarotCard(
        id: 'major_1',
        name: 'The Fool',
        nameVi: 'Kẻ Ngốc',
        imagePath: 'assets/images/m1.jpg',
        description: 'Lá bài đại diện cho sự khởi đầu, niềm tin và sự ngây thơ.',
        meaning: 'Khởi đầu mới, niềm tin, sự ngây thơ, phiêu lưu, tự do.',
        reversedMeaning: 'Thiếu suy nghĩ, thiếu kế hoạch, rủi ro không cần thiết.',
      ),
      TarotCard(
        id: 'major_2',
        name: 'The Magician',
        nameVi: 'Pháp Sư',
        imagePath: 'assets/images/m2.jpg',
        description: 'Lá bài đại diện cho sức mạnh, ý chí và khả năng biến đổi.',
        meaning: 'Sức mạnh, ý chí, khả năng, hành động, tập trung.',
        reversedMeaning: 'Thiếu ý chí, lãng phí tài năng, thao túng.',
      ),
      TarotCard(
        id: 'major_3',
        name: 'The High Priestess',
        nameVi: 'Nữ Tư Tế',
        imagePath: 'assets/images/m3.jpg',
        description: 'Lá bài đại diện cho trực giác, bí mật và sự khôn ngoan.',
        meaning: 'Trực giác, bí mật, khôn ngoan, nội tâm, tiềm thức.',
        reversedMeaning: 'Thiếu trực giác, bí mật bị tiết lộ, thiếu kết nối nội tâm.',
      ),
      TarotCard(
        id: 'major_4',
        name: 'The Empress',
        nameVi: 'Hoàng Hậu',
        imagePath: 'assets/images/m4.jpg',
        description: 'Lá bài đại diện cho sự sinh sôi, phong phú và sáng tạo.',
        meaning: 'Sinh sôi, phong phú, sáng tạo, nuôi dưỡng, tự nhiên.',
        reversedMeaning: 'Thiếu sáng tạo, phụ thuộc, lãng phí.',
      ),
    ]);

    // Cup (4 lá)
    _cupCards.addAll([
      TarotCard(
        id: 'cup_1',
        name: 'Ace of Cups',
        nameVi: 'Át Cốc',
        imagePath: 'assets/images/c1.jpg',
        description: 'Lá bài đại diện cho tình yêu mới, cảm xúc và sự khởi đầu.',
        meaning: 'Tình yêu mới, cảm xúc, khởi đầu, niềm vui, hạnh phúc.',
        reversedMeaning: 'Cảm xúc bị đè nén, thiếu tình yêu, đau khổ.',
      ),
      TarotCard(
        id: 'cup_2',
        name: 'Two of Cups',
        nameVi: 'Hai Cốc',
        imagePath: 'assets/images/c2.jpg',
        description: 'Lá bài đại diện cho sự kết hợp, hợp tác và tình bạn.',
        meaning: 'Kết hợp, hợp tác, tình bạn, hôn nhân, cân bằng.',
        reversedMeaning: 'Xung đột, mất cân bằng, chia tay.',
      ),
      TarotCard(
        id: 'cup_3',
        name: 'Three of Cups',
        nameVi: 'Ba Cốc',
        imagePath: 'assets/images/c3.jpg',
        description: 'Lá bài đại diện cho niềm vui, tình bạn và sự ăn mừng.',
        meaning: 'Niềm vui, tình bạn, ăn mừng, hội họp, hạnh phúc.',
        reversedMeaning: 'Cô đơn, thiếu bạn bè, quá độ.',
      ),
      TarotCard(
        id: 'cup_4',
        name: 'Four of Cups',
        nameVi: 'Bốn Cốc',
        imagePath: 'assets/images/c4.jpg',
        description: 'Lá bài đại diện cho sự thờ ơ, thiếu hài lòng và cơ hội bị bỏ lỡ.',
        meaning: 'Thờ ơ, thiếu hài lòng, cơ hội bị bỏ lỡ, tự suy ngẫm.',
        reversedMeaning: 'Chấp nhận cơ hội, hành động, tham gia.',
      ),
    ]);

    // Wand (4 lá)
    _wandCards.addAll([
      TarotCard(
        id: 'wand_1',
        name: 'Ace of Wands',
        nameVi: 'Át Gậy',
        imagePath: 'assets/images/w1.jpg',
        description: 'Lá bài đại diện cho năng lượng, đam mê và khởi đầu mới.',
        meaning: 'Năng lượng, đam mê, khởi đầu, cảm hứng, sáng tạo.',
        reversedMeaning: 'Thiếu năng lượng, mất đam mê, trì hoãn.',
      ),
      TarotCard(
        id: 'wand_2',
        name: 'Two of Wands',
        nameVi: 'Hai Gậy',
        imagePath: 'assets/images/w2.jpg',
        description: 'Lá bài đại diện cho lập kế hoạch, quyết định và tương lai.',
        meaning: 'Lập kế hoạch, quyết định, tương lai, khám phá, tự tin.',
        reversedMeaning: 'Thiếu kế hoạch, sợ hãi, không quyết định.',
      ),
      TarotCard(
        id: 'wand_3',
        name: 'Three of Wands',
        nameVi: 'Ba Gậy',
        imagePath: 'assets/images/w3.jpg',
        description: 'Lá bài đại diện cho sự mở rộng, khám phá và tầm nhìn xa.',
        meaning: 'Mở rộng, khám phá, tầm nhìn xa, hợp tác, thành công.',
        reversedMeaning: 'Thiếu tầm nhìn, hạn chế, thất bại.',
      ),
      TarotCard(
        id: 'wand_4',
        name: 'Four of Wands',
        nameVi: 'Bốn Gậy',
        imagePath: 'assets/images/w4.jpg',
        description: 'Lá bài đại diện cho sự ổn định, hòa hợp và ăn mừng.',
        meaning: 'Ổn định, hòa hợp, ăn mừng, thành tựu, hạnh phúc.',
        reversedMeaning: 'Thiếu ổn định, xung đột, không hài lòng.',
      ),
    ]);

    // Sword (4 lá)
    _swordCards.addAll([
      TarotCard(
        id: 'sword_1',
        name: 'Ace of Swords',
        nameVi: 'Át Kiếm',
        imagePath: 'assets/images/s1.jpg',
        description: 'Lá bài đại diện cho sự rõ ràng, sự thật và quyết định.',
        meaning: 'Rõ ràng, sự thật, quyết định, chiến thắng, công lý.',
        reversedMeaning: 'Thiếu rõ ràng, dối trá, quyết định sai.',
      ),
      TarotCard(
        id: 'sword_2',
        name: 'Two of Swords',
        nameVi: 'Hai Kiếm',
        imagePath: 'assets/images/s2.jpg',
        description: 'Lá bài đại diện cho sự lựa chọn khó khăn và cân bằng.',
        meaning: 'Lựa chọn khó khăn, cân bằng, tránh né, quyết định.',
        reversedMeaning: 'Thiếu quyết định, mất cân bằng, xung đột.',
      ),
      TarotCard(
        id: 'sword_3',
        name: 'Three of Swords',
        nameVi: 'Ba Kiếm',
        imagePath: 'assets/images/s3.jpg',
        description: 'Lá bài đại diện cho đau khổ, mất mát và đau lòng.',
        meaning: 'Đau khổ, mất mát, đau lòng, chia tay, thất vọng.',
        reversedMeaning: 'Hồi phục, tha thứ, chữa lành.',
      ),
      TarotCard(
        id: 'sword_4',
        name: 'Four of Swords',
        nameVi: 'Bốn Kiếm',
        imagePath: 'assets/images/s4.jpg',
        description: 'Lá bài đại diện cho sự nghỉ ngơi, phục hồi và suy ngẫm.',
        meaning: 'Nghỉ ngơi, phục hồi, suy ngẫm, hòa bình, chữa lành.',
        reversedMeaning: 'Kiệt sức, thiếu nghỉ ngơi, căng thẳng.',
      ),
    ]);
  }

  /// Navigate to view all cards of a type
  void viewAllCards(String cardType) {
    // TODO: Navigate to detail page with all cards of that type
    Get.snackbar(
      'View All',
      'View all $cardType cards',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

