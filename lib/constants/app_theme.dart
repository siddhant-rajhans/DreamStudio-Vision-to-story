import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Colors matched EXACTLY to web CSS variables
class AppColors {
  // Core backgrounds — from web :root
  static const Color bgPrimary = Color(0xFF0a0a0f);
  static const Color bgSecondary = Color(0xFF12121a);
  static const Color bgElevated = Color(0xFF1a1a28);
  static const Color bgOverlay = Color(0xD90a0a0f); // rgba(10,10,15,0.85)
  static const Color bgCard = Color(0xFF12121a); // Card background
  static const Color bgSurface = Color(0xFF1a1a28); // Surface background

  // Accent colors — from web :root
  static const Color accentWarm = Color(0xFFE8A87C); // --accent-warm (PRIMARY)
  static const Color accentPink = Color(0xFFD4789C); // --accent-pink
  static const Color accentBlue = Color(0xFF6C8EBF); // --accent-blue
  static const Color accentGreen = Color(0xFF7BC47F); // --accent-green
  static const Color accentRed = Color(0xFFE07070); // --accent-red
  static const Color accentGold = Color(0xFFD4A574); // Additional accent
  static const Color accentPurple = Color(0xFF9B7DB8); // Additional accent
  static const Color accentTeal = Color(0xFF5FA8A3); // Additional accent
  static const Color accentOrange = Color(0xFFE8956F); // Additional accent

  // Text colors — from web :root
  static const Color textPrimary = Color(0xFFe8e6e3); // --text-primary
  static const Color textSecondary = Color(0xFF9a97a0); // --text-secondary
  static const Color textMuted = Color(0xFF5a5760); // --text-muted

  // Borders — from web :root
  static const Color borderSubtle = Color(0x0FFFFFFF); // rgba(255,255,255,0.06)
  static const Color borderLight = Color(0x1AFFFFFF); // rgba(255,255,255,0.1)
  static const Color border = Color(0x1AFFFFFF); // Alias for borderLight

  // Gradient — from web --gradient-primary: linear-gradient(135deg, #E8A87C, #D4789C)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [accentWarm, accentPink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

/// Text styles matched to web CSS
class AppTextStyles {
  // Hero title — web: font-family: Playfair Display, 4.2rem on desktop, ~2.2rem on mobile
  static TextStyle heroTitle = GoogleFonts.playfairDisplay(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.15,
  );

  // Section title — web: Playfair Display, 2.5rem
  static TextStyle sectionTitle = GoogleFonts.playfairDisplay(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  // Section tag — web: 0.75rem uppercase, accent-warm
  static TextStyle sectionTag = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.accentWarm,
    letterSpacing: 1.6,
  );

  // Card title — web: 1.15rem, 600
  static TextStyle cardTitle = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Body text — web: Inter 0.9rem, secondary color
  static TextStyle bodyText = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.6,
  );

  // Subtitle — web: 1.15rem, 300 weight, secondary
  static TextStyle subtitle = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w300,
    color: AppColors.textSecondary,
    height: 1.7,
  );

  // Caption / muted — web: 0.75rem
  static TextStyle caption = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
    letterSpacing: 0.5,
  );

  // Model badge — web: 0.7rem, accent-warm
  static TextStyle modelBadge = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.accentWarm,
  );

  // Nav brand — web: Playfair Display, gradient text
  static TextStyle navBrand = GoogleFonts.playfairDisplay(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
}

ThemeData buildAppTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bgPrimary,
    primaryColor: AppColors.accentWarm,
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accentWarm,
      secondary: AppColors.accentPink,
      surface: AppColors.bgSecondary,
      onPrimary: AppColors.bgPrimary,
      onSecondary: AppColors.bgPrimary,
      onSurface: AppColors.textPrimary,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: AppTextStyles.navBrand,
    ),
    cardTheme: CardThemeData(
      color: AppColors.bgSecondary,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.borderSubtle, width: 1),
      ),
    ),
    // Buttons match web .btn-primary gradient style
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accentWarm,
        foregroundColor: AppColors.bgPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        side: const BorderSide(color: AppColors.borderLight),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500),
      ),
    ),
  );
}