import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

/// Controller to manage video background for all screens
class VideoBackgroundController extends GetxController {
  VideoPlayerController? _videoController;
  VideoPlayerController? get videoController => _videoController;

  // Reactive error state
  final _hasVideoError = false.obs;
  bool get hasVideoError => _hasVideoError.value;

  // Video path
  final String videoPath = 'assets/videos/video_bg1.mp4';

  @override
  void onInit() {
    super.onInit();
    _initializeVideo();
  }

  /// Initialize video background
  Future<void> _initializeVideo() async {
    try {
      _videoController = VideoPlayerController.asset(videoPath);

      // Set video properties
      await _videoController!.setLooping(true);
      await _videoController!.setVolume(0); // Mute

      // Initialize video player
      await _videoController!.initialize();

      // Start playing
      _videoController!.play();

      _hasVideoError.value = false;

      // Add listener to detect errors during playback
      _videoController!.addListener(() {
        if (_videoController!.value.hasError) {
          _hasVideoError.value = true;
        }
      });
    } catch (error) {
      debugPrint("VideoBackgroundController: Video initialization FAILED: $error");
      await _videoController?.dispose();
      _videoController = null;
      _hasVideoError.value = true;
    }
  }

  /// Pause video
  void pauseVideo() {
    if (_videoController != null && _videoController!.value.isInitialized) {
      _videoController!.pause();
    }
  }

  /// Resume video
  void resumeVideo() {
    if (_videoController != null && _videoController!.value.isInitialized) {
      _videoController!.play();
    }
  }

  @override
  void onClose() {
    _videoController?.dispose();
    super.onClose();
  }
}

/// Video background widget - reusable for all screens
class VideoBackground extends StatelessWidget {
  final Widget child;

  const VideoBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize controller if not registered
    if (!Get.isRegistered<VideoBackgroundController>()) {
      Get.put(VideoBackgroundController(), permanent: true);
    }

    final controller = Get.find<VideoBackgroundController>();

    return Obx(() {
      final videoController = controller.videoController;
      final hasError = controller.hasVideoError;

      return Stack(
        children: [
          // Background video or fallback image
          Positioned.fill(
            child: _buildBackground(videoController, hasError),
          ),
          // Content
          child,
        ],
      );
    });
  }

  /// Build background - video or fallback image
  Widget _buildBackground(VideoPlayerController? videoController, bool hasError) {
    // If video has error, show fallback image
    if (hasError) {
      return SizedBox.expand(
        child: Image.asset(
          'assets/images/bg_fallback.jpg',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // If fallback image also fails, show black background
            return Container(color: Colors.black);
          },
        ),
      );
    }

    // If video controller is initialized, show video
    if (videoController != null && videoController.value.isInitialized) {
      return SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: videoController.value.size.width > 0
                ? videoController.value.size.width
                : 1920,
            height: videoController.value.size.height > 0
                ? videoController.value.size.height
                : 1080,
            child: VideoPlayer(videoController),
          ),
        ),
      );
    }

    // If video controller is not ready yet, show fallback image
    return SizedBox.expand(
      child: Image.asset(
        'assets/images/bg_fallback.jpg',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // If fallback image also fails, show black background
          return Container(color: Colors.black);
        },
      ),
    );
  }
}

