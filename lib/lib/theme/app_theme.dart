import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color gold = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFEDD97A);
  static const Color goldDark = Color(0xFF9C7E1A);
  static const Color saffron = Color(0xFFFF9933);
  static const Color saffronLight = Color(0xFFFFB566);
  static const Color saffronDark = Color(0xFFCC7A00);
  static const Color darkBg = Color(0xFF0D0A05);
  static const Color darkSurface = Color(0xFF1A1508);
  static const Color darkCard = Color(0xFF231D0C);
  static const Color darkElevated = Color(0xFF2E2510);
  static const Color lightBg = Color(0xFFFFFBF0);
  static const Color lightSurface = Color(0xFFFFF8E7);
  static const Color lightCard = Color(0xFFFFF3CC);
  static const Color lightElevated = Color(0xFFFFEDAA);
  static const Color textGold = Color(0xFFD4AF37);
  static const Color textCream = Color(0xFFFFF8E7);
  static const Color textDark = Color(0xFF1A1508);
  static const Color textMuted = Color(0xFF8B7355);
  static const Color lotus = Color(0xFFE91E8C);
  static const Color rudraksha = Color(0xFF5D3A1A);
  static const Color chakra = Color(0xFF6B35C9);
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFD4AF37), Color(0xFFFF9933), Color(0xFFD4AF37)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient darkBgGradient = LinearGradient(
    colors: [Color(0xFF0D0A05), Color(0xFF1A1005), Color(0xFF0D0A05)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const LinearGradient saffronGradient = LinearGradient(
    colors: [Color(0xFFFF9933), Color(0xFFFFB566)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.gold,
      secondary: AppColors.saffron,
      surface: AppColors.darkSurface,
      background: AppColors.darkBg,
      onPrimary: AppColors.darkBg,
      onSecondary: AppColors.darkBg,
      onSurface: AppColors.textCream,
      onBackground: AppColors.textCream,
      tertiary: AppColors.chakra,
      error: AppColors.error,
    ),
    scaffoldBackgroundColor: AppColors.darkBg,
    cardTheme: CardTheme(
      color: AppColors.darkCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppColors.gold.withOpacity(0.2), width: 1),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.cinzel(
        color: AppColors.gold,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 2,
      ),
      iconTheme: const IconThemeData(color: AppColors.gold),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.darkBg,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.darkCard,
      indicatorColor: AppColors.gold.withOpacity(0.2),
    ),
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: AppColors.goldDark,
      secondary: AppColors.saffronDark,
      surface: AppColors.lightSurface,
      background: AppColors.lightBg,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.textDark,
      onBackground: AppColors.textDark,
      tertiary: AppColors.chakra,
      error: AppColors.error,
    ),
    scaffoldBackgroundColor: AppColors.lightBg,
  );
}
