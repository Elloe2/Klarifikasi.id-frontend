/// ============================================================================
/// MAIN APPLICATION WIDGET - KLARIFIKASI.ID
/// ============================================================================
/// File ini berisi jantung konfigurasi Flutter app.
/// Di sinilah seluruh dependency global, tema, dan routing diikat menjadi satu.
///
/// Struktur utama file:
/// - Import dependency lintas modul (providers, theme, pages)
/// - Definisi `MainApp` sebagai root widget
/// - Konfigurasi `MultiProvider` untuk state management
/// - Pengaturan `MaterialApp` (tema, routes, initial route, error handling)
/// ============================================================================
library;

import 'package:flutter/material.dart'; // Flutter core widgets untuk UI dasar
import 'package:provider/provider.dart'; // Paket Provider untuk state management

// === PROVIDERS ===
// Import AuthProvider untuk state management autentikasi
import '../providers/auth_provider.dart'; // Menyediakan status login ke seluruh app

// === THEME ===
// Import custom theme dengan dark mode dan gradient design
import '../theme/app_theme.dart'; // Menyediakan skema warna dan typography custom

// === PAGES ===
// Import semua halaman utama aplikasi
import '../splash/splash_gate.dart'; // Splash screen yang memeriksa status auth
import '../pages/login_page.dart'; // Halaman autentikasi login user
import '../pages/register_page.dart'; // Halaman pendaftaran user baru
import '../app/home_shell.dart'; // Shell utama berisi tab navigasi (search/settings)

/// === MAIN APP WIDGET ===
/// Root widget aplikasi yang mengatur semua konfigurasi global.
/// Menggunakan `MultiProvider` agar state (seperti autentikasi) bisa
/// diakses oleh seluruh widget tree, lalu membungkusnya dengan `MaterialApp`
/// untuk mendefinisikan tema, routing, dan konfigurasi UI lainnya.
///
/// Fitur kunci:
/// - Injeksi `AuthProvider` sehingga halaman bisa memantau status login.
/// - Tema gelap custom (`AppTheme.light`) yang konsisten di seluruh app.
/// - Definisi route menggunakan map untuk navigasi terpusat.
/// - Override `builder` untuk mengunci text scale (mencegah layout shifting).
class MainApp extends StatelessWidget {
  /// Constructor dengan key untuk widget identification
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // ===== PROVIDER SETUP =====
      // Semua provider global dideklarasikan di daftar ini sehingga dapat diakses
      // melalui `context.read()` atau `context.watch()` di seluruh widget.
      providers: [
        // AuthProvider untuk development dengan local Laravel backend
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(), // Menyediakan state autentikasi
        ),
        // Tambahkan provider lain di sini jika diperlukan (mis. SearchProvider)
      ],

      // ===== MATERIAL APP CONFIGURATION =====
      // Setelah provider siap, bungkus aplikasi dengan `MaterialApp` untuk
      // mendefinisikan tema, routing, dan konfigurasi global lainnya.
      child: MaterialApp(
        // Judul aplikasi yang muncul di window/browser tab
        title: 'Klarifikasi.id',
        // Sembunyikan banner debug untuk tampilan yang bersih
        debugShowCheckedModeBanner: false,
        // Terapkan tema gelap custom dari `AppTheme`
        theme: AppTheme.light,

        // ===== ROUTE CONFIGURATION =====
        // Semua halaman utama didaftarkan di sini untuk navigasi berbasis nama.
        routes: {
          // Route definitions dengan named routes untuk type safety
          '/': (context) => const SplashGate(), // Entry point → cek autentikasi
          '/login': (context) => const LoginPage(), // Form login pengguna
          '/register': (context) => const RegisterPage(), // Form registrasi
          '/home': (context) => const HomeShell(), // Shell utama setelah login
        },

        // Tentukan route awal yang ditampilkan saat aplikasi dibuka
        initialRoute: '/',

        // ===== ERROR & MEDIA CONFIG =====
        // Override `builder` untuk memastikan text scale tetap 1.0 (stabil di web)
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.0)),
            child: child!,
          );
        },

        // Konfigurasi tambahan (lokalisasi, dsb) bisa diaktifkan bila diperlukan
        // locale: const Locale('id', 'ID'),
        // localizationsDelegates: [...],
        // supportedLocales: [Locale('id', 'ID')],
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
