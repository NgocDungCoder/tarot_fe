import 'package:flutter/material.dart';
import 'custom_text.dart';

/// Text widget với hiệu ứng typewriter - chữ cái nhảy ra từng ký tự
/// 
/// Usage: TypewriterText('Hello World', speed: Duration(milliseconds: 50))
class TypewriterText extends StatefulWidget {
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
  
  /// Tốc độ hiện từng ký tự (default: 50ms)
  final Duration speed;
  
  /// Delay trước khi bắt đầu animation (default: 0)
  final Duration delay;
  
  /// Có nên trigger animation ngay khi widget được build không (default: true)
  final bool autoStart;

  const TypewriterText(
    this.text, {
    super.key,
    this.fontSize,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
    this.speed = const Duration(milliseconds: 50),
    this.delay = Duration.zero,
    this.autoStart = true,
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  String _displayText = '';
  int _currentIndex = 0;
  bool _hasStarted = false;

  @override
  void initState() {
    super.initState();
    if (widget.autoStart) {
      _startAnimation();
    }
  }

  @override
  void didUpdateWidget(TypewriterText oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Nếu text thay đổi hoặc autoStart thay đổi từ false sang true
    if (oldWidget.text != widget.text || (!oldWidget.autoStart && widget.autoStart)) {
      _resetAndStart();
    }
  }

  /// Reset và bắt đầu animation lại
  void _resetAndStart() {
    _displayText = '';
    _currentIndex = 0;
    _hasStarted = false;
    _startAnimation();
  }

  /// Start animation với delay
  void _startAnimation() {
    if (_hasStarted || widget.text.isEmpty) return;
    _hasStarted = true;

    Future.delayed(widget.delay, () {
      if (!mounted) return;
      _typeNext();
    });
  }

  /// Type next character
  void _typeNext() {
    if (_currentIndex < widget.text.length && mounted) {
      setState(() {
        _displayText = widget.text.substring(0, _currentIndex + 1);
        _currentIndex++;
      });
      Future.delayed(widget.speed, () {
        if (mounted) {
          _typeNext();
        }
      });
    }
  }

  /// Trigger animation manually
  void triggerAnimation() {
    _resetAndStart();
  }

  @override
  Widget build(BuildContext context) {
    return CustomText(
      _displayText,
      fontSize: widget.fontSize,
      color: widget.color,
      fontWeight: widget.fontWeight,
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      overflow: widget.overflow,
      style: widget.style,
    );
  }
}

