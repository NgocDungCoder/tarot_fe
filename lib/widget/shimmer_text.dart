import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tarot_fe/configs/styles/theme_config.dart';

/// Shimmer text widget with animated sparkle effect
/// 
/// Usage: ShimmerText('Hello World', fontSize: 32, baseColor: Colors.white)
class ShimmerText extends StatefulWidget {
  /// The text to display
  final String text;
  
  /// Font size (default: 16)
  final double? fontSize;
  
  /// Base text color (default: Colors.white)
  final Color? baseColor;
  
  /// Shimmer color (default: ThemeConfig.textGold)
  final Color? shimmerColor;
  
  /// Font weight (default: FontWeight.normal)
  final FontWeight? fontWeight;
  
  /// Text alignment (default: TextAlign.start)
  final TextAlign? textAlign;
  
  /// Animation duration in milliseconds (default: 1500)
  final int duration;
  
  /// Shimmer angle in degrees (default: 0)
  final double angle;

  const ShimmerText(
    this.text, {
    super.key,
    this.fontSize,
    this.baseColor,
    this.shimmerColor,
    this.fontWeight,
    this.textAlign,
    this.duration = 1500,
    this.angle = 0,
  });

  @override
  State<ShimmerText> createState() => _ShimmerTextState();
}

class _ShimmerTextState extends State<ShimmerText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.duration),
      vsync: this,
    )..repeat(reverse: true); // Repeat với reverse để chạy qua rồi chạy về lại

    // Animation từ -1.5 đến 1.5 để shimmer chạy từ đầu đến cuối text đầy đủ
    _animation = Tween<double>(begin: -1.5, end: 1.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut, // Smooth ease in out
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.baseColor ?? Colors.white;
    final shimmerColor = widget.shimmerColor ?? ThemeConfig.textGold;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // Normalize animation value từ -1.5..1.5 về 0.0..1.0 để shimmer chạy từ đầu đến cuối
        final normalizedValue = ((_animation.value + 1.5) / 3.0).clamp(0.0, 1.0);
        
        // Độ rộng của shimmer band (0.3 = 30% chiều rộng)
        const shimmerWidth = 0.1;
        
        // Tính toán vị trí shimmer để đảm bảo chạy từ đầu đến cuối
        final shimmerStart = (normalizedValue - shimmerWidth).clamp(0.0, 1.0);
        final shimmerCenter = normalizedValue.clamp(0.0, 1.0);
        final shimmerEnd = (normalizedValue + shimmerWidth).clamp(0.0, 1.0);
        
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                baseColor,
                baseColor,
                shimmerColor,
                shimmerColor,
                shimmerColor,
                baseColor,
                baseColor,
              ],
              stops: [
                0.0,
                shimmerStart,
                shimmerStart + 0.05, // Edge mềm
                shimmerCenter, // Center sáng nhất
                shimmerEnd - 0.05, // Edge mềm
                shimmerEnd,
                1.0,
              ],
            ).createShader(bounds);
          },
          child: Text(
            widget.text,
            style: GoogleFonts.dancingScript(
              fontSize: widget.fontSize ?? 16,
              color: Colors.white, // Must be white for ShaderMask to work
              fontWeight: widget.fontWeight ?? FontWeight.normal,
            ),
            textAlign: widget.textAlign ?? TextAlign.start,
          ),
        );
      },
    );
  }
}

/// Sparkle text widget with twinkling effect
/// 
/// Usage: SparkleText('Hello World', fontSize: 32)
class SparkleText extends StatefulWidget {
  /// The text to display
  final String text;
  
  /// Font size (default: 16)
  final double? fontSize;
  
  /// Base text color (default: Colors.white)
  final Color? baseColor;
  
  /// Sparkle color (default: ThemeConfig.textGold)
  final Color? sparkleColor;
  
  /// Font weight (default: FontWeight.normal)
  final FontWeight? fontWeight;
  
  /// Text alignment (default: TextAlign.start)
  final TextAlign? textAlign;
  
  /// Number of sparkles (default: 5)
  final int sparkleCount;

  const SparkleText(
    this.text, {
    super.key,
    this.fontSize,
    this.baseColor,
    this.sparkleColor,
    this.fontWeight,
    this.textAlign,
    this.sparkleCount = 5,
  });

  @override
  State<SparkleText> createState() => _SparkleTextState();
}

class _SparkleTextState extends State<SparkleText>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.sparkleCount,
      (index) => AnimationController(
        duration: Duration(milliseconds: 1000 + (index * 200)),
        vsync: this,
      )..repeat(reverse: true),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOut,
        ),
      );
    }).toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.baseColor ?? Colors.white;
    final sparkleColor = widget.sparkleColor ?? ThemeConfig.textGold;

    return Stack(
      children: [
        // Base text
        Text(
          widget.text,
          style: GoogleFonts.dancingScript(
            fontSize: widget.fontSize ?? 16,
            color: baseColor,
            fontWeight: widget.fontWeight ?? FontWeight.normal,
          ),
          textAlign: widget.textAlign ?? TextAlign.start,
        ),
        // Sparkle overlay
        ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: List.generate(
                widget.sparkleCount,
                (index) {
                  final opacity = _animations[index].value;
                  return sparkleColor.withOpacity(opacity);
                },
              ),
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: Text(
            widget.text,
            style: GoogleFonts.dancingScript(
              fontSize: widget.fontSize ?? 16,
              color: Colors.white,
              fontWeight: widget.fontWeight ?? FontWeight.normal,
            ),
            textAlign: widget.textAlign ?? TextAlign.start,
          ),
        ),
      ],
    );
  }
}

/// Glow text widget with pulsing glow effect
/// 
/// Usage: GlowText('Hello World', fontSize: 32, glowColor: ThemeConfig.textGold)
class GlowText extends StatefulWidget {
  /// The text to display
  final String text;
  
  /// Font size (default: 16)
  final double? fontSize;
  
  /// Text color (default: Colors.white)
  final Color? color;
  
  /// Glow color (default: ThemeConfig.textGold)
  final Color? glowColor;
  
  /// Font weight (default: FontWeight.normal)
  final FontWeight? fontWeight;
  
  /// Text alignment (default: TextAlign.start)
  final TextAlign? textAlign;
  
  /// Glow radius (default: 10.0)
  final double glowRadius;
  
  /// Animation duration in milliseconds (default: 2000)
  final int duration;

  const GlowText(
    this.text, {
    super.key,
    this.fontSize,
    this.color,
    this.glowColor,
    this.fontWeight,
    this.textAlign,
    this.glowRadius = 10.0,
    this.duration = 2000,
  });

  @override
  State<GlowText> createState() => _GlowTextState();
}

class _GlowTextState extends State<GlowText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.duration),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = widget.color ?? Colors.white;
    final glowColor = widget.glowColor ?? ThemeConfig.textGold;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text(
          widget.text,
          style: GoogleFonts.dancingScript(
            fontSize: widget.fontSize ?? 16,
            color: textColor,
            fontWeight: widget.fontWeight ?? FontWeight.normal,
            shadows: [
              Shadow(
                color: glowColor.withOpacity(_animation.value),
                blurRadius: widget.glowRadius * _animation.value,
              ),
              Shadow(
                color: glowColor.withOpacity(_animation.value * 0.5),
                blurRadius: widget.glowRadius * 1.5 * _animation.value,
              ),
            ],
          ),
          textAlign: widget.textAlign ?? TextAlign.start,
        );
      },
    );
  }
}

