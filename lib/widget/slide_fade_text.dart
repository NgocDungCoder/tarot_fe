import 'package:flutter/material.dart';
import 'custom_text.dart';

/// Text widget với hiệu ứng slide và fade in từ trái qua phải
/// 
/// Usage: SlideFadeText('Hello', delay: Duration(milliseconds: 200))
class SlideFadeText extends StatefulWidget {
  /// Text content
  final String text;
  
  /// Font size
  final double? fontSize;
  
  /// Text color
  final Color? color;
  
  /// Font weight
  final FontWeight? fontWeight;
  
  /// Text align
  final TextAlign? textAlign;
  
  /// Max lines
  final int? maxLines;
  
  /// Text overflow
  final TextOverflow? overflow;
  
  /// Custom text style
  final TextStyle? style;
  
  /// Delay trước khi bắt đầu animation (default: 0)
  final Duration delay;
  
  /// Duration của animation (default: 600ms)
  final Duration duration;
  
  /// Offset để slide từ trái (default: 50)
  final double slideOffset;
  
  /// Có nên trigger animation ngay khi widget được build không (default: true)
  final bool autoStart;

  const SlideFadeText(
    this.text, {
    super.key,
    this.fontSize,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 600),
    this.slideOffset = 50.0,
    this.autoStart = true,
  });

  @override
  State<SlideFadeText> createState() => _SlideFadeTextState();
}

class _SlideFadeTextState extends State<SlideFadeText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  bool _hasStarted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    // Fade animation từ 0 đến 1
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    // Slide animation từ offset về 0
    _slideAnimation = Tween<double>(
      begin: widget.slideOffset,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    // Auto start nếu được yêu cầu
    if (widget.autoStart) {
      _startAnimation();
    }
  }

  @override
  void didUpdateWidget(SlideFadeText oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Nếu autoStart thay đổi từ false sang true, trigger animation
    if (!oldWidget.autoStart && widget.autoStart && !_hasStarted) {
      _startAnimation();
    }
  }

  /// Start animation với delay
  void _startAnimation() {
    if (_hasStarted) return;
    _hasStarted = true;

    // Reset controller về đầu
    _controller.reset();

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  /// Trigger animation manually
  void triggerAnimation() {
    _startAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset: Offset(_slideAnimation.value, 0),
            child: CustomText(
              widget.text,
              fontSize: widget.fontSize,
              color: widget.color,
              fontWeight: widget.fontWeight,
              textAlign: widget.textAlign,
              maxLines: widget.maxLines,
              overflow: widget.overflow,
              style: widget.style,
            ),
          ),
        );
      },
    );
  }
}

