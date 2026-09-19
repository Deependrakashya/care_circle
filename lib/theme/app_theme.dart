import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color background = Color(0xFFF7F8F4);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color primary = Color(0xFF2F6F68);
  static const Color primarySoft = Color(0xFFE2F0EC);
  static const Color secondarySage = Color(0xFF7E9B76);
  static const Color warmAccent = Color(0xFFE8A87C);

  static const Color textPrimary = Color(0xFF24302E);
  static const Color textSecondary = Color(0xFF6E7C79);
  static const Color border = Color(0xFFE4E9E5);

  // Semantic Colors
  static const Color semanticPositive = Color(0xFF4F8A68);
  static const Color semanticCaution = Color(0xFFD99A4E);
  static const Color semanticError = Color(0xFFC95D5D);

  // Privacy Colors
  static const Color privacyShared = Color(0xFFE2F0EC); // soft teal/green
  static const Color privacySharedText = Color(0xFF2F6F68);

  static const Color privacyLimited = Color(0xFFFDF0DF); // soft amber
  static const Color privacyLimitedText = Color(0xFFD99A4E);

  static const Color privacyPrivate = Color(0xFFF0F1F4); // soft gray
  static const Color privacyPrivateText = Color(0xFF6E7C79);

  static ThemeData get themeData {
    // We use the existing system font but preserve the hierarchy.
    const TextTheme textTheme = TextTheme(
      headlineLarge: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ), // Page title
      headlineMedium: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ), // Hero
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ), // Section
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ), // Card
      bodyLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: textPrimary,
      ), // Body
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ), // Body
      bodySmall: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: textSecondary,
      ), // Metadata
      labelSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: textSecondary,
      ), // Chip
    );

    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: secondarySage,
        background: background,
        surface: surface,
        onPrimary: Colors.white,
        onBackground: textPrimary,
        onSurface: textPrimary,
        error: semanticError,
      ),
      scaffoldBackgroundColor: background,
      textTheme: textTheme,
      useMaterial3: true,

      // Card Theme
      cardTheme: CardThemeData(
        color: surface,
        elevation:
            0, // Avoid heavy shadows, use border for separation if needed or subtle shadow
        shadowColor: Colors.black.withOpacity(0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Normal cards 16-20
          side: const BorderSide(color: border, width: 1), // subtle border
        ),
        margin: EdgeInsets.zero,
      ),

      // Button Theme
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: border, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.headlineLarge,
        iconTheme: const IconThemeData(color: primary),
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: border,
        space: 1,
        thickness: 1,
      ),
    );
  }
}
