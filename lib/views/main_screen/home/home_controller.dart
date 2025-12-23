import 'dart:developer' as developer;
import 'package:get/get.dart';
import 'package:tarot_fe/models/tarot_card_entity.dart';
import '../../../providers/api_client.dart';

class HomeController extends GetxController {
  final ApiClient apiClient;
  final isLoading = false.obs;
  final errorMessage = "".obs;

  final Rx<TarotCardEntity> randomCard = Rx<TarotCardEntity>(TarotCardEntity());

  HomeController(this.apiClient);

  // Flag để biết lá bài đã được lật (revealed) hay chưa
  final _isCardRevealed = false.obs;

  bool get isCardRevealed => _isCardRevealed.value;

  // Animation state để trigger fade in cho text
  final _showCardDetail = false.obs;

  bool get showCardDetail => _showCardDetail.value;


}
