import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tarot_fe/views/splash/splash_controller.dart';
import 'package:video_player/video_player.dart';
import 'package:tarot_fe/widget/custom_text.dart';
import 'package:tarot_fe/widget/shimmer_text.dart';

import '../../configs/styles/theme_config.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
  }
}

class SplashPage extends StatefulWidget {
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  VideoPlayerController? _controller;
  ChewieController? _chewieController;
  bool _hasVideoError = false; // Track video initialization error
  bool _isInitializing = true; // Track initialization state
  bool _isVideoReady = false; // Track khi video đã sẵn sàng để fade in
  
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    debugPrint("SplashPage: initState called");
    super.initState();
    
    // Initialize fade animation controller
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800), // Fade in duration
    );
    
    // Create fade animation từ 0.0 đến 1.0
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));
    
    _initializeVideo();
    // Initialize controller để timer bắt đầu chạy
    Get.find<SplashController>();
  }

  // Initialize video with better error handling
  Future<void> _initializeVideo() async {
    try {
      debugPrint("SplashPage: Starting video initialization...");

      _controller = VideoPlayerController.asset(
        "assets/videos/video_splash.mp4",
      );

      // Set video properties before initialization
      await _controller!.setLooping(true);
      await _controller!.setVolume(0); // Tắt âm

      // Initialize video player
      await _controller!.initialize();

      debugPrint("SplashPage: Video initialized OK");
      debugPrint("SplashPage: Video size: ${_controller!.value.size}");
      debugPrint("SplashPage: Video duration: ${_controller!.value.duration}");

      _chewieController = ChewieController(
        videoPlayerController: _controller!,
        autoPlay: true,
        looping: true,
        showControls: false,
        allowFullScreen: false,
        allowMuting: false,
        allowPlaybackSpeedChanging: false,
      );

      setState(() {
        _hasVideoError = false;
        _isInitializing = false;
      });

      // Start playing
      _controller!.play();
      
      // Đợi một chút để video bắt đầu play, sau đó fade in
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          setState(() {
            _isVideoReady = true;
          });
          // Bắt đầu fade in animation
          _fadeController.forward();
        }
      });
    } catch (error, stackTrace) {
      // Handle initialization error - video codec not supported or other issues
      debugPrint("SplashPage: Video initialization FAILED: $error");
      debugPrint("SplashPage: Error type: ${error.runtimeType}");
      debugPrint("SplashPage: Error stack: $stackTrace");

      // Dispose controller if it was created
      await _controller?.dispose();
      _controller = null;
      _chewieController = null;

      setState(() {
        _hasVideoError = true;
        _isInitializing = false;
      });
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _chewieController?.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// Background video or fallback
          Positioned.fill(
            child: _isInitializing
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.green,
                    ),
                  )
                : _hasVideoError
                    ? Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.deepPurple.shade900,
                              Colors.deepPurple.shade700,
                              Colors.purple.shade900,
                            ],
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Logo image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.asset(
                                  "assets/icons/tarot_logo.jpg",
                                  width: 160,
                                  height: 160,
                                ),
                              ),
                              // Spacing
                              const SizedBox(height: 10),
                              // Text with Dancing Script font
                              const CustomText(
                                "Give your destiny card",
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      )
                    : _chewieController != null &&
                            _controller != null &&
                            _controller!.value.isInitialized
                        ? FadeTransition(
                            opacity: _fadeAnimation,
                            child: SizedBox(
                              width: 200,
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: 290,
                                  height: 300,
                                  child: Chewie(controller: _chewieController!),
                                ),
                              ),
                            ),
                          )
                        : // Fallback nếu video không khởi tạo được
                        Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.deepPurple.shade900,
                                  Colors.deepPurple.shade700,
                                  Colors.purple.shade900,
                                ],
                              ),
                            ),
                          ),
          ),

          /// Overlay texts on video
          if (!_hasVideoError) ...[
            // Top text - Tarot reader
            Positioned(
              top: MediaQuery.of(context).size.height * 0.15,
              left: 0,
              right: 0,
              child: const Center(
                child: SparkleText(
                  "TAROT READER",
                  fontSize: 40,
                  sparkleColor: ThemeConfig.deepPurple,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            // Bottom text - Give your destiny card
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.15,
              left: 0,
              right: 0,
              child: Center(
                child: ShimmerText(
                  "Give your destiny card !",
                  fontSize: 30,
                  baseColor: ThemeConfig.deepPurple,
                  shimmerColor: ThemeConfig.textWhite,
                  fontWeight: FontWeight.w800,
                  textAlign: TextAlign.center,
                  duration: 4000,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
