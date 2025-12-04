import 'package:flutter/material.dart';

/// Theme configuration class for app-wide color and style constants
/// 
/// Usage: ThemeConfig.textGold, ThemeConfig.primaryColor, etc.
class ThemeConfig {
  // Private constructor to prevent instantiation
  ThemeConfig._();

  // ==================== Primary Colors ====================
  
  /// Primary purple color for the app
  static const Color primaryColor = Color(0xFF6B46C1);
  
  /// Secondary purple color
  static const Color secondaryColor = Color(0xFF9333EA);
  
  /// Deep purple color
  static const Color deepPurple = Color(0xFF4C1D95);

  // ==================== Text Colors ====================
  
  /// Gold color for text (commonly used in tarot apps)
  static const Color textGold = Color(0xFFD4AF37);
  
  /// Light gold color
  static const Color textGoldLight = Color(0xFFF4D03F);
  
  /// Dark gold color
  static const Color textGoldDark = Color(0xFFB8941F);
  
  /// Black text color
  static const Color textBlack = Color(0xFF000000);
  
  /// White text color
  static const Color textWhite = Color(0xFFFFFFFF);
  
  /// Gray text color for hints/secondary text
  static const Color textHint = Color(0xFF9CA3AF);
  
  /// Dark gray text color
  static const Color textDarkGray = Color(0xFF4B5563);
  
  /// Light gray text color
  static const Color textLightGray = Color(0xFFD1D5DB);

  // ==================== Background Colors ====================
  
  /// Primary background color
  static const Color backgroundColor = Color(0xFFFFFFFF);
  
  /// Secondary background color
  static const Color backgroundSecondary = Color(0xFFF9FAFB);
  
  /// Dark background color
  static const Color backgroundDark = Color(0xFF1F2937);
  
  /// Purple gradient background start
  static const Color backgroundPurpleStart = Color(0xFF4C1D95);
  
  /// Purple gradient background end
  static const Color backgroundPurpleEnd = Color(0xFF9333EA);

  // ==================== Card Colors ====================
  
  /// Card background color
  static const Color cardBackground = Color(0xFFFFFFFF);
  
  /// Card shadow color
  static const Color cardShadow = Color(0x1A000000);
  
  /// Card border color
  static const Color cardBorder = Color(0xFFE5E7EB);

  // ==================== Accent Colors ====================
  
  /// Success/Green color
  static const Color success = Color(0xFF10B981);
  
  /// Error/Red color
  static const Color error = Color(0xFFEF4444);
  
  /// Warning/Orange color
  static const Color warning = Color(0xFFF59E0B);
  
  /// Info/Blue color
  static const Color info = Color(0xFF3B82F6);

  // ==================== Gradient Colors ====================
  
  /// Purple gradient colors list
  static const List<Color> purpleGradient = [
    Color(0xFF4C1D95),
    Color(0xFF6B46C1),
    Color(0xFF9333EA),
  ];
  
  /// Gold gradient colors list
  static const List<Color> goldGradient = [
    Color(0xFFB8941F),
    Color(0xFFD4AF37),
    Color(0xFFF4D03F),
  ];

  // ==================== Helper Methods ====================
  
  /// Get gradient for purple theme
  static const LinearGradient purpleGradientLinear = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: purpleGradient,
      );
  
  /// Get gradient for gold theme
  static const LinearGradient goldGradientLinear = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: goldGradient,
      );
  
  /// Get box shadow for cards
  static const List<BoxShadow> cardBoxShadow = [
        BoxShadow(
          color: cardShadow,
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ];
}

