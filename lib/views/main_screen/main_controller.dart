import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'main_tab_enum.dart';

class MainController extends GetxController {
  // Current selected tab
  final _currentTab = MainTab.home.obs;
  MainTab get currentTab => _currentTab.value;

  // Video player controller cho background video
  VideoPlayerController? _videoController;
  VideoPlayerController? get videoController => _videoController;
  
  // Reactive error state để UI tự động cập nhật khi có lỗi
  final _hasVideoError = false.obs;
  bool get hasVideoError => _hasVideoError.value;

  @override
  void onInit() {
    super.onInit();
    _initializeVideo();
  }

  /// Initialize background video
  Future<void> _initializeVideo() async {
    try {
      _videoController = VideoPlayerController.asset(
        "assets/videos/video_bg1.mp4",
      );

      // Set video properties
      await _videoController!.setLooping(true);
      await _videoController!.setVolume(0); // Tắt âm

      // Initialize video player
      await _videoController!.initialize();

      // Start playing
      _videoController!.play();
      
      _hasVideoError.value = false;
    } catch (error) {
      debugPrint("MainController: Video initialization FAILED: $error");
      await _videoController?.dispose();
      _videoController = null;
      _hasVideoError.value = true;
    }
  }

  /// Change tab
  void changeTab(MainTab tab) {
    _currentTab.value = tab;
  }

  /// Pause video (khi navigate đến page khác)
  void pauseVideo() {
    if (_videoController != null && _videoController!.value.isInitialized) {
      _videoController!.pause();
    }
  }

  /// Resume video (khi quay lại main screen)
  void resumeVideo() {
    if (_videoController != null && 
        _videoController!.value.isInitialized && 
        !_videoController!.value.isPlaying) {
      _videoController!.play();
    }
  }

  @override
  void onClose() {
    // Chỉ dispose khi MainController thực sự bị đóng (khi app đóng)
    // Không dispose khi navigate đến page khác vì MainController là permanent
    _videoController?.dispose();
    super.onClose();
  }
}

