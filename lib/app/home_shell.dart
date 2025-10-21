import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/search_page.dart'; // Tab utama untuk pencarian klaim
import '../pages/settings_page.dart'; // Tab pengaturan profil dan preferensi
import '../providers/auth_provider.dart'; // Menyediakan status autentikasi global
import '../theme/app_theme.dart'; // Warna dan gaya tema aplikasi
import '../services/search_api.dart'; // Service pencarian yang dioper ke SearchPage
import '../widgets/loading_widgets.dart'; // Widget loading reusable

/// Shell navigasi utama setelah user berhasil login.
/// Mengatur tab bottom navigation antara pencarian dan pengaturan,
/// sekaligus meng-handle loading state awal dashboard.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  // Index tab yang sedang aktif pada bottom navigation
  int _currentIndex = 0;

  // Instance `SearchApi` yang diteruskan ke `SearchPage`
  final SearchApi _api = const SearchApi();

  // Flag loading untuk menampilkan splash kecil sebelum dashboard siap
  bool _isDashboardLoading = true;

  @override
  void initState() {
    super.initState();
    // Trigger loading animasi singkat sebelum halaman utama muncul
    _initializeDashboard();
  }

  Future<void> _initializeDashboard() async {
    // Menunda 1.5 detik agar transisi terasa smooth saat memasuki dashboard
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      setState(() {
        _isDashboardLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Pastikan `AuthProvider` selesai melakukan inisialisasi awal
        if (!authProvider.isInitialized) {
          return const LoadingScreen(
            message: 'Memuat aplikasi...',
            showProgress: true,
          );
        }

        if (!authProvider.isAuthenticated) {
          // Jika token tidak valid, arahkan kembali ke halaman login
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && context.mounted) {
              Navigator.of(context).pushReplacementNamed('/login');
            }
          });
          return const LoadingScreen(
            message: 'Memverifikasi autentikasi...',
            showProgress: true,
          );
        }

        // Saat pertama kali masuk dashboard, tampilkan shimmer loading
        if (_isDashboardLoading) {
          return const LoadingScreen(
            message: 'Memuat dashboard...',
            showProgress: true,
          );
        }

        // Daftar halaman yang di-stack; `IndexedStack` menjaga state antar tab
        final pages = [SearchPage(api: _api), const SettingsPage()];

        return Scaffold(
          body: SafeArea(
            // IndexedStack menjaga state masing-masing tab agar tidak rebuild
            child: IndexedStack(index: _currentIndex, children: pages),
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              color: AppTheme.backgroundDark, // Spotify-style dark background
            ),
            child: NavigationBar(
              backgroundColor: Colors.transparent,
              indicatorColor:
                  Colors.transparent, // No indicator seperti Spotify
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) {
                if (mounted) {
                  setState(() {
                    _currentIndex = index;
                  });
                }
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.search_outlined),
                  selectedIcon: Icon(Icons.search),
                  label: 'Cari',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: 'Pengaturan',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
