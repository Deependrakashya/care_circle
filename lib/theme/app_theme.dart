import 'package:flutter/material.dart';

class AppTheme {
  // ─── Color palette ────────────────────────────────────────────────────────
  static const Color background = Color(0xFFF5F6F2); // warm off-white
  static const Color surfaceElevated = Color(0xFFFFFFFF); // card white
  static const Color surface = Color(0xFFFFFFFF);

  // Hero / tinted surfaces
  static const Color heroSurface = Color(0xFFDFF0E9); // soft sage-teal tint
  static const Color heroSurface2 = Color(0xFFE8F4EE); // slightly lighter

  static const Color primary = Color(0xFF2B6B63); // muted teal
  static const Color primarySoft = Color(0xFFDFF0E9);
  static const Color primaryMid = Color(0xFF3D7D74); // slightly lighter teal

  static const Color secondarySage = Color(0xFF7A9870);
  static const Color warmAccent = Color(0xFFE8A87C);

  static const Color textPrimary = Color(0xFF1E2D2A);
  static const Color textSecondary = Color(0xFF6B7876);
  static const Color textTertiary = Color(0xFF9AADAA);

  static const Color border = Color(0xFFE3E8E4);
  static const Color borderSubtle = Color(0xFFEDF0EC);

  // ─── Semantic colors ──────────────────────────────────────────────────────
  static const Color semanticPositive = Color(0xFF4A8766);
  static const Color semanticCaution = Color(0xFFCE9244);
  static const Color semanticError = Color(0xFFC45A5A);

  // ─── Privacy chip colors ──────────────────────────────────────────────────
  static const Color privacyShared = Color(0xFFDFF0E9);
  static const Color privacySharedText = Color(0xFF2B6B63);

  static const Color privacyLimited = Color(0xFFFAEED8);
  static const Color privacyLimitedText = Color(0xFFCE9244);

  static const Color privacyPrivate = Color(0xFFEEEFF2);
  static const Color privacyPrivateText = Color(0xFF6B7876);

  // ─── Spacing ──────────────────────────────────────────────────────────────
  static const double pagePadding = 20.0;
  static const double sectionGap = 24.0;
  static const double cardPadding = 20.0;
  static const double cardRadius = 20.0;
  static const double heroRadius = 24.0;
  static const double buttonHeight = 54.0;
  static const double buttonRadius = 16.0;

  // ─── ThemeData ────────────────────────────────────────────────────────────
  static ThemeData get themeData {
    const TextTheme textTheme = TextTheme(
      // Page / screen titles
      headlineLarge: TextStyle(
        fontSize: 27,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        letterSpacing: -0.5,
      ),
      // Hero headline (reassurance card)
      headlineMedium: TextStyle(
        fontSize: 23,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        height: 1.25,
        letterSpacing: -0.3,
      ),
      // Resident name / large label
      headlineSmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        letterSpacing: -0.2,
      ),
      // Section heading
      titleLarge: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      // Card title / event title
      titleMedium: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      // Supporting body
      bodyLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        height: 1.55,
      ),
      // Body text
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        height: 1.5,
      ),
      // Metadata / timestamps
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textTertiary,
        letterSpacing: 0.1,
      ),
      // Chips
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
    );

    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: secondarySage,
        surface: surface,
        onPrimary: Colors.white,
        onSurface: textPrimary,
        error: semanticError,
      ),
      scaffoldBackgroundColor: background,
      textTheme: textTheme,
      useMaterial3: true,

      // Card theme — subtle lift, no heavy shadows
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shadowColor: Colors.black.withValues(alpha: 0.04),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
          side: const BorderSide(color: borderSubtle, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // Primary filled button — tall and visually strong
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
          elevation: 0,
        ),
      ),

      // Outlined button — secondary; restrained
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          minimumSize: const Size(double.infinity, 48),
          side: const BorderSide(color: border, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      // AppBar — frameless, content-level
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.headlineLarge,
        iconTheme: const IconThemeData(color: primary, size: 22),
      ),

      // Bottom sheet — smooth top corners
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        elevation: 0,
        shadowColor: Colors.transparent,
      ),

      // Divider — very subtle
      dividerTheme: const DividerThemeData(
        color: borderSubtle,
        space: 1,
        thickness: 1,
      ),
    );
  }
}
