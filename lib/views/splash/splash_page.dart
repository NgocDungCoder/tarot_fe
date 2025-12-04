import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:tarot_fe/views/splash/splash_controller.dart';
import 'package:video_player/video_player.dart';

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

class _SplashPageState extends State<SplashPage> {
  VideoPlayerController? _controller;
  ChewieController? _chewieController;
  bool _hasVideoError = false; // Track video initialization error
  bool _isInitializing = true; // Track initialization state

  @override
  void initState() {
    debugPrint("SplashPage: initState called");
    super.initState();
    _initializeVideo();
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
                              SizedBox(
                                width: 160,
                                height: 160,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.asset(
                                      "assets/icons/tarot_logo.jpg"),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: Text(
                                  "Give your destiny card",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    : _chewieController != null &&
                            _controller != null &&
                            _controller!.value.isInitialized
                        ? SizedBox.expand(
                            // Fill toàn bộ màn hình
                            child: FittedBox(
                              fit: BoxFit
                                  .contain, // Cover toàn bộ màn hình, crop nếu cần
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: _controller!.value.size.width,
                                height: _controller!.value.size.height,
                                child: Chewie(controller: _chewieController!),
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

          /// Nội dung trên video
          Positioned(
            top: MediaQuery.of(context).size.height * 0.10,
            left: 0,
            right: 0,
            child: _hasVideoError
                ? SizedBox.shrink()
                : Center(
                    child: Text(
                    "Tarot reader",
                    style: TextStyle(color: Colors.white),
                  )),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.10,
            left: 0,
            right: 0,
            child: _hasVideoError
                ? SizedBox.shrink()
                : Center(
                    child: Text(
                    "Give your destiny card",
                    style: TextStyle(color: Colors.white),
                  )),
          ),
        ],
      ),
    );
  }
}
