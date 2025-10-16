/// ============================================================================
/// MAIN APPLICATION WIDGET - KLARIFIKASI.ID
/// ============================================================================
/// File ini berisi konfigurasi utama aplikasi Flutter.
/// Mengatur theme, routing, providers, dan struktur aplikasi.
///
/// Struktur:
/// - MainApp: Root widget dengan semua konfigurasi aplikasi
/// - MultiProvider: Setup untuk state management (AuthProvider)
/// - MaterialApp: Konfigurasi tema, routes, dan navigasi
/// ============================================================================
library;

import 'package:flutter/material.dart'; // Flutter core widgets
import 'package:provider/provider.dart'; // State management provider

// === PROVIDERS ===
// Import AuthProvider untuk state management autentikasi
import '../providers/auth_provider.dart';

// === THEME ===
// Import custom theme dengan dark mode dan gradient design
import '../theme/app_theme.dart';

// === PAGES ===
// Import semua halaman utama aplikasi
import '../splash/splash_gate.dart'; // Splash screen dengan auth check
import '../pages/login_page.dart'; // Halaman login pengguna
import '../pages/register_page.dart'; // Halaman registrasi pengguna
import '../app/home_shell.dart'; // Main navigation shell

/// === MAIN APP WIDGET ===
/// Root widget aplikasi yang mengatur semua konfigurasi utama.
/// Menggunakan MultiProvider untuk state management dan MaterialApp
/// untuk konfigurasi tema dan navigasi.
///
/// Features:
/// - Provider setup untuk authentication state
/// - Custom dark theme dengan gradient backgrounds
/// - Route definitions untuk semua pages
/// - Debug banner disabled untuk clean look
///
/// Architecture:
/// - StatelessWidget untuk performa optimal
/// - MultiProvider untuk dependency injection
/// - Named routes untuk type-safe navigation
class MainApp extends StatelessWidget {
  /// Constructor dengan key untuk widget identification
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      /// === PROVIDER SETUP ===
      /// Konfigurasi provider untuk state management.
      /// AuthProvider mengelola state autentikasi seluruh aplikasi.
      providers: [
        // AuthProvider untuk production dengan Laravel Cloud backend
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(),
        ),
        //
        // ChangeNotifierProvider<SearchProvider>(create: (_) => SearchProvider()),
      ],

      /// === MATERIAL APP CONFIGURATION ===
      /// Konfigurasi utama aplikasi dengan Material Design.
      child: MaterialApp(
        // === BASIC CONFIGURATION ===
        title: 'Klarifikasi.id', // App title untuk window bar
        debugShowCheckedModeBanner: false, // Hide debug banner di development
        // === THEME CONFIGURATION ===
        // Menggunakan custom dark theme dengan gradient design
        theme: AppTheme.light, // Custom theme dari app_theme.dart
        // === ROUTE CONFIGURATION ===
        // Definisi semua routes (halaman) dalam aplikasi
        routes: {
          // Route definitions dengan named routes untuk type safety
          '/': (context) => const SplashGate(), // Root route -> splash screen
          '/login': (context) => const LoginPage(), // Login page
          '/register': (context) => const RegisterPage(), // Registration page
          '/home': (context) =>
              const HomeShell(), // Main app shell dengan navigation
        },

        // === INITIAL ROUTE ===
        // Halaman pertama yang ditampilkan saat app start
        initialRoute: '/', // Mulai dari splash screen
        // === ERROR HANDLING ===
        // Global error handling untuk uncaught exceptions
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(1.0)),
            child: child!,
          );
        },

        // === ADDITIONAL CONFIGURATION ===
        // locale: const Locale('id', 'ID'), // Indonesian localization
        // localizationsDelegates: [...], // Localization setup
        // supportedLocales: [Locale('id', 'ID')], // Supported locales
      ),
    );
  }
}

/// === NAVIGATION FLOW ===
/// Flow navigasi aplikasi:
///
/// 1. App Start -> SplashGate (/)
/// 2. Check Authentication:
///    - Jika belum login -> LoginPage (/login)
///    - Jika sudah login -> HomeShell (/home)
/// 3. Dari HomeShell bisa navigasi ke:
///    - SearchPage (tab pertama)
///    - HistoryPage (tab kedua)
///    - SettingsPage (tab ketiga)
///
/// === STATE MANAGEMENT FLOW ===
/// 1. AuthProvider diinisialisasi di MainApp
/// 2. AuthProvider check token dan user state
/// 3. Semua pages dapat mengakses AuthProvider via context.read() atau context.watch()
/// 4. Auth state changes akan trigger rebuild di semua listening widgets
///
/// === THEME CONSISTENCY ===
/// - Semua pages menggunakan AppTheme.light untuk konsistensi
/// - Gradient backgrounds dan dark colors untuk brand identity
/// - Responsive design untuk semua screen sizes
