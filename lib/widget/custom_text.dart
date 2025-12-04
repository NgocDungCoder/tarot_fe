import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom Text widget with Dancing Script font from Google Fonts
/// 
/// This widget automatically applies Dancing Script font to all text
/// Usage: CustomText('Hello World', fontSize: 16, color: Colors.white)
class CustomText extends StatelessWidget {
  /// The text to display
  final String text;
  
  /// Font size (default: 16)
  final double? fontSize;
  
  /// Text color (default: Colors.black)
  final Color? color;
  
  /// Font weight (default: FontWeight.normal)
  final FontWeight? fontWeight;
  
  /// Text alignment (default: TextAlign.start)
  final TextAlign? textAlign;
  
  /// Maximum number of lines
  final int? maxLines;
  
  /// Text overflow behavior
  final TextOverflow? overflow;
  
  /// Text style (optional, will merge with Dancing Script style)
  final TextStyle? style;

  const CustomText(
    this.text, {
    super.key,
    this.fontSize,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    // Base Dancing Script style
    final baseStyle = GoogleFonts.dancingScript(
      fontSize: fontSize ?? 16,
      color: color ?? Colors.black,
      fontWeight: fontWeight ?? FontWeight.normal,
    );

    // Merge with custom style if provided
    final textStyle = style != null ? baseStyle.merge(style) : baseStyle;

    return Text(
      text,
      style: textStyle,
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

