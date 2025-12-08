import 'package:get/get.dart';
import '../../../widget/custom_snackbar.dart';
import '../main_controller.dart';
import '../main_tab_enum.dart';

class PaymentSuccessController extends GetxController {
  // Order data từ arguments
  String get orderId => Get.arguments?['orderId'] ?? 'ORD-${DateTime.now().millisecondsSinceEpoch}';
  double get totalAmount => Get.arguments?['totalAmount'] ?? 0.0;
  double get rewardPoints => Get.arguments?['rewardPoints'] ?? 0.0;
  Map<String, dynamic>? get selectedVoucher => Get.arguments?['voucher'];

  @override
  void onInit() {
    super.onInit();
  }

  /// Back to home
  void backToHome() {
    // Pop về main page và chuyển sang tab home
    Get.until((route) => route.settings.name == '/main');
    
    // Chuyển sang tab home nếu MainController đã được đăng ký
    if (Get.isRegistered<MainController>()) {
      final mainController = Get.find<MainController>();
      mainController.changeTab(MainTab.home);
    }
  }

  /// View orders
  void viewOrders() {
    Get.toNamed('/order-history');
  }
}

