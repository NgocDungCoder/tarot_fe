import 'dart:async';
import 'package:get/get.dart';
import '../../configs/routes/route.dart';

class SplashController extends GetxController {
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    // Start timer để chuyển sang home sau 5 giây
    _startTimer();
  }

  /// Start timer 5 seconds to navigate to home
  void _startTimer() {
    _timer = Timer(const Duration(seconds: 5), () {
      // Navigate to home page
      Get.offAllNamed(Routes.main.p);
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}