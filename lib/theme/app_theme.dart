import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color backgroundDark = Color(0xFF141E24);
  static const Color surfaceDark = Color(0xFF1D2A31);
  static const Color outlineDark = Color(0xFF23323A);
  static const Color subduedGray = Color(0xFF37464E);

  static const Color primarySeedColor = Color(0xFF92D332);
  static const Color secondaryAccentColor = Color(0xFF467F9D);
  static const Color tertiaryAccentColor = Color(0xFF1B96D4);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF92D332), Color(0xFF92D332)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF467F9D), Color(0xFF467F9D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF1B96D4), Color(0xFF1B96D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF141E24), Color(0xFF1D2A31)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [surfaceDark, surfaceDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient historyCardGradient = LinearGradient(
    colors: [surfaceDark, surfaceDark],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient historyAccentGradient = LinearGradient(
    colors: [primarySeedColor, primarySeedColor],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient errorGradient = LinearGradient(
    colors: [Color(0xFFDC2626), Color(0xFFD32F2F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const List<BoxShadow> cardShadows = [];

  static final ThemeData light = _buildLightTheme();

  static ThemeData _buildLightTheme() {
    final lightScheme = ColorScheme.fromSeed(
      seedColor: primarySeedColor,
      secondary: secondaryAccentColor,
      tertiary: tertiaryAccentColor,
      surface: backgroundDark,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: lightScheme,
      scaffoldBackgroundColor: surfaceDark,
      textTheme: ThemeData.dark().textTheme.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.transparent,
        indicatorColor: const Color(0x3358CC02),
        elevation: 0,
        height: 72,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final baseColor = Colors.white;
          return IconThemeData(
            color: states.contains(WidgetState.selected)
                ? baseColor
                : baseColor.withValues(alpha: 0.65),
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final baseStyle = const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          );
          return states.contains(WidgetState.selected)
              ? baseStyle
              : baseStyle.copyWith(
                  color: Colors.white.withValues(alpha: 0.65),
                );
        }),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFF1CB0F6)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: subduedGray,
        selectedColor: const Color(0xFF22313A),
        disabledColor: const Color(0xFF10191E),
        labelStyle: const TextStyle(color: Colors.white),
        secondaryLabelStyle: const TextStyle(color: Colors.white),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Color(0xFF92D332),
        contentTextStyle: TextStyle(color: Color(0xFF10241A)),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }
}
