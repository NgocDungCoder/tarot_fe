import 'package:flutter/material.dart';

/// Flip card widget với hiệu ứng xoay 3D mượt mà
/// 
/// Usage: FlipCard(backImage: 'assets/images/back_card.png', frontImage: 'assets/images/m18.jpg')
class FlipCard extends StatefulWidget {
  /// Đường dẫn hình ảnh mặt sau lá bài
  final String backImage;
  
  /// Đường dẫn hình ảnh mặt trước lá bài
  final String frontImage;
  
  /// Chiều rộng của lá bài
  final double width;
  
  /// Chiều cao của lá bài
  final double height;
  
  /// Callback khi lá bài được lật hoàn toàn
  final VoidCallback? onFlipComplete;
  
  /// Tự động lật khi widget được tạo (default: false)
  final bool autoFlip;
  
  /// Trạng thái flip ban đầu (default: false - mặt sau)
  final bool initialFlipped;

  const FlipCard({
    super.key,
    required this.backImage,
    required this.frontImage,
    this.width = 200,
    this.height = 350,
    this.onFlipComplete,
    this.autoFlip = false,
    this.initialFlipped = false,
  });

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFlipped = false;
  bool _hasCalledCallback = false; // Track để tránh gọi callback nhiều lần

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Animation từ 0.0 đến 1.0 (0 độ đến 180 độ)
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Set initial flipped state
    _isFlipped = widget.initialFlipped;
    if (widget.initialFlipped) {
      _controller.value = 1.0; // Set animation to completed state
    }

    // Listen to animation status
    _controller.addStatusListener(_handleAnimationStatus);

    // Auto flip nếu được yêu cầu
    if (widget.autoFlip) {
      Future.delayed(const Duration(milliseconds: 500), () {
        flip();
      });
    }
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_handleAnimationStatus);
    _controller.dispose();
    super.dispose();
  }

  /// Handle animation status changes
  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && _isFlipped && !_hasCalledCallback) {
      _hasCalledCallback = true;
      widget.onFlipComplete?.call();
    } else if (status == AnimationStatus.dismissed && !_isFlipped) {
      _hasCalledCallback = false; // Reset khi về trạng thái ban đầu
    }
  }

  /// Flip card animation
  void flip() {
    if (_controller.isAnimating) return;

    _hasCalledCallback = false; // Reset callback flag

    if (_isFlipped) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    _isFlipped = !_isFlipped;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: flip,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          // Tính toán góc xoay (0 độ đến 180 độ)
          final angle = _animation.value * 3.14159; // 0 đến π (180 độ)
          
          // Xác định mặt nào đang hiển thị dựa trên góc xoay
          // Nếu góc < 90 độ (π/2) thì hiển thị mặt sau
          // Nếu góc >= 90 độ thì hiển thị mặt trước
          final isShowingBack = angle < 1.5708; // π/2 = 90 độ

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Perspective
              ..rotateY(angle), // Xoay quanh trục Y
            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: isShowingBack
                    ? Image.asset(
                        widget.backImage,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.deepPurple,
                            child: const Center(
                              child: Icon(Icons.image, color: Colors.white),
                            ),
                          );
                        },
                      )
                    : Transform(
                        // Flip mặt trước để đảo ngược
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..rotateY(3.14159), // 180 độ
                        child: Image.asset(
                          widget.frontImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.deepPurple,
                              child: const Center(
                                child: Icon(Icons.image, color: Colors.white),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}

