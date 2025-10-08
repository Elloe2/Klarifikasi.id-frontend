/// ============================================================================
/// APP THEME - KLARIFIKASI.ID FRONTEND
/// ============================================================================
/// File konfigurasi tema aplikasi dengan desain dark mode dan gradient.
/// Mengatur color scheme, typography, dan component styling untuk konsistensi UI.
///
/// Fitur Utama:
/// - Dark theme dengan gradient backgrounds
/// - Custom color palette untuk brand identity
/// - Responsive component styling
/// - Material 3 design system integration
/// - Cross-platform consistency (Web & Android)
///
/// Color Philosophy:
/// - Primary Green (#92D332): Brand utama, trust, dan growth
/// - Dark Blues: Professional, calm, dan trustworthy
/// - Gradients: Modern, depth, dan visual appeal
/// ============================================================================

import 'package:flutter/material.dart'; // Flutter Material Design framework

/// === APP THEME CLASS ===
/// Singleton class untuk mengelola tema aplikasi.
/// Menggunakan private constructor untuk mencegah instantiation.
///
/// Responsibilities:
/// - Color palette definition
/// - Gradient configurations
/// - ThemeData construction
/// - Component styling consistency
///
/// Design Principles:
/// - Dark-first approach untuk modern look
/// - High contrast untuk readability
/// - Consistent spacing dan typography
/// - Accessible color combinations
class AppTheme {
  // Private constructor untuk singleton pattern
  AppTheme._();

  // === CORE COLOR PALETTE ===
  // Warna dasar yang digunakan sebagai foundation tema
  static const Color backgroundDark = Color(0xFF141E24); // Background utama
  static const Color surfaceDark = Color(0xFF1D2A31); // Surface untuk cards
  static const Color outlineDark = Color(0xFF23323A); // Border dan outline
  static const Color subduedGray = Color(0xFF37464E); // Text dan icon subtle

  // === BRAND COLOR PALETTE ===
  // Warna brand dan aksen untuk identitas visual
  static const Color primarySeedColor = Color(0xFF92D332); // Primary brand green
  static const Color secondaryAccentColor = Color(0xFF467F9D); // Secondary blue
  static const Color tertiaryAccentColor = Color(0xFF1B96D4); // Tertiary cyan

  // === GRADIENT DEFINITIONS ===
  // Pre-defined gradients untuk konsistensi visual di seluruh aplikasi

  /// Primary brand gradient menggunakan warna hijau utama
  /// Digunakan untuk: Primary buttons, highlights, success states
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF92D332), Color(0xFF92D332)], // Solid green untuk simplicity
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Secondary gradient dengan warna biru untuk aksen
  /// Digunakan untuk: Secondary buttons, accents, info states
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF467F9D), Color(0xFF467F9D)], // Solid blue untuk consistency
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Accent gradient dengan warna cyan untuk tertiary actions
  /// Digunakan untuk: Links, tertiary buttons, special highlights
  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF1B96D4), Color(0xFF1B96D4)], // Solid cyan untuk tertiary
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Background gradient untuk main app background
  /// Menggunakan kombinasi backgroundDark colors untuk depth
  /// Digunakan untuk: Scaffold background, main screens
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF141E24), Color(0xFF1D2A31)], // Dark to darker transition
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Card gradient untuk container dan card backgrounds
  /// Menggunakan surfaceDark untuk subtle depth
  /// Digunakan untuk: Cards, containers, elevated surfaces
  static const LinearGradient cardGradient = LinearGradient(
    colors: [surfaceDark, surfaceDark], // Solid surface color
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// History card gradient dengan orientasi vertikal
  /// Digunakan khusus untuk history list items
  /// Digunakan untuk: Search history cards, list items
  static const LinearGradient historyCardGradient = LinearGradient(
    colors: [surfaceDark, surfaceDark], // Solid untuk consistency
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// History accent gradient untuk highlight elements
  /// Menggunakan primary color untuk emphasis
  /// Digunakan untuk: History badges, accent elements
  static const LinearGradient historyAccentGradient = LinearGradient(
    colors: [primarySeedColor, primarySeedColor], // Primary green accent
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// Error gradient untuk error states dan warnings
  /// Menggunakan red colors untuk attention-grabbing
  /// Digunakan untuk: Error messages, warning states, destructive actions
  static const LinearGradient errorGradient = LinearGradient(
    colors: [Color(0xFFDC2626), Color(0xFFD32F2F)], // Red gradient untuk errors
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Card shadows untuk elevated surfaces
  /// Kosong untuk flat design approach
  static const List<BoxShadow> cardShadows = []; // Flat design tanpa shadows

  // === THEME DATA CONSTRUCTION ===

  /// Main theme getter yang mengembalikan fully configured ThemeData
  /// Menggunakan Material 3 dengan custom color scheme dan component styling
  static final ThemeData light = _buildLightTheme();

  /// === PRIVATE THEME BUILDER ===
  /// Method internal untuk constructing ThemeData dengan semua konfigurasi.
  /// Menggunakan Material 3 design system dengan customizations.
  ///
  /// Returns: Fully configured ThemeData untuk aplikasi
  ///
  /// Features:
  /// - Material 3 design system
  /// - Custom color scheme dari seed colors
  /// - Dark theme dengan white text
  /// - Custom component themes untuk consistency
  static ThemeData _buildLightTheme() {
    // Color scheme dari seed colors dengan dark brightness
    final lightScheme = ColorScheme.fromSeed(
      seedColor: primarySeedColor,
      secondary: secondaryAccentColor,
      tertiary: tertiaryAccentColor,
      surface: backgroundDark,
      brightness: Brightness.dark,
    );

    return ThemeData(
      // === MATERIAL 3 SETUP ===
      useMaterial3: true, // Enable Material 3 design system
      colorScheme: lightScheme, // Custom color scheme

      // === BASIC CONFIGURATION ===
      scaffoldBackgroundColor: surfaceDark, // Dark background untuk semua screens

      // === TYPOGRAPHY ===
      // White text untuk semua text elements di dark theme
      textTheme: ThemeData.dark().textTheme.apply(
        bodyColor: Colors.white, // Body text color
        displayColor: Colors.white, // Display text color
      ),

      // === APP BAR THEME ===
      // Transparent app bar dengan white text
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent, // Transparent background
        foregroundColor: Colors.white, // White text dan icons
        elevation: 0, // No shadow untuk flat design
      ),

      // === BOTTOM NAVIGATION THEME ===
      // Custom navigation bar dengan transparent background
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.transparent, // Transparent background
        indicatorColor: const Color(0x3358CC02), // Subtle green indicator
        elevation: 0, // No elevation untuk flat design
        height: 72, // Custom height untuk better UX
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow, // Always show labels

        // Dynamic icon theming berdasarkan selection state
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final baseColor = Colors.white;
          return IconThemeData(
            color: states.contains(WidgetState.selected)
                ? baseColor // Full white untuk selected
                : baseColor.withValues(alpha: 0.65), // 65% opacity untuk unselected
          );
        }),

        // Dynamic label theming berdasarkan selection state
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final baseStyle = const TextStyle(
            fontWeight: FontWeight.w600, // Semi-bold untuk readability
            color: Colors.white,
          );
          return states.contains(WidgetState.selected)
              ? baseStyle // Full white untuk selected
              : baseStyle.copyWith(
                  color: Colors.white.withValues(alpha: 0.65), // 65% opacity untuk unselected
                );
        }),
      ),

      // === BUTTON THEMES ===
      // Consistent button styling di seluruh aplikasi

      /// Filled button theme untuk primary actions
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14), // Vertical padding
          foregroundColor: Colors.white, // White text untuk contrast
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Rounded corners
          ),
        ),
      ),

      /// Outlined button theme untuk secondary actions
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white, // White text
          side: const BorderSide(color: Color(0xFF1CB0F6)), // Cyan border
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Consistent corner radius
          ),
        ),
      ),

      // === CHIP THEME ===
      // Styling untuk chip components
      chipTheme: ChipThemeData(
        backgroundColor: subduedGray, // Subtle gray background
        selectedColor: const Color(0xFF22313A), // Darker untuk selected state
        disabledColor: const Color(0xFF10191E), // Very dark untuk disabled
        labelStyle: const TextStyle(color: Colors.white), // White text
        secondaryLabelStyle: const TextStyle(color: Colors.white), // White secondary text
      ),

      // === SNACKBAR THEME ===
      // Notification styling dengan brand colors
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Color(0xFF92D332), // Primary green background
        contentTextStyle: TextStyle(color: Color(0xFF10241A)), // Dark green text untuk contrast
        behavior: SnackBarBehavior.floating, // Floating style
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)), // Rounded corners
        ),
      ),
    );
  }
}
