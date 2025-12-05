import 'package:flutter/material.dart';

/// Floating card widget với hiệu ứng bay bổng nhẹ nhàng
/// 
/// Wraps child widget với animation lên xuống liên tục
class FloatingCard extends StatefulWidget {
  /// Widget con cần được wrap
  final Widget child;
  
  /// Độ cao tối đa của hiệu ứng bay bổng (default: 15.0)
  final double floatingHeight;
  
  /// Thời gian một chu kỳ animation (default: 2 giây)
  final Duration duration;
  
  /// Curve cho animation (default: Curves.easeInOut)
  final Curve curve;

  const FloatingCard({
    super.key,
    required this.child,
    this.floatingHeight = 15.0,
    this.duration = const Duration(seconds: 2),
    this.curve = Curves.easeInOut,
  });

  @override
  State<FloatingCard> createState() => _FloatingCardState();
}

class _FloatingCardState extends State<FloatingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    
    // Tạo animation controller với duration và repeat
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    // Tạo animation từ -1 đến 1 để tạo hiệu ứng lên xuống
    _animation = Tween<double>(
      begin: -widget.floatingHeight,
      end: widget.floatingHeight,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ),
    );

    // Bắt đầu animation và lặp lại vô hạn
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: widget.child,
        );
      },
    );
  }
}

