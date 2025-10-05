import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/history_page.dart';
import '../pages/search_page.dart';
import '../pages/settings_page.dart';
import '../providers/auth_provider.dart';
import '../services/search_api.dart';
import '../widgets/loading_widgets.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;
  final SearchApi _api = const SearchApi();
  bool _isDashboardLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeDashboard();
  }

  Future<void> _initializeDashboard() async {
    // Simulate dashboard loading for better UX
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
        // Pastikan provider sudah initialized
        if (!authProvider.isInitialized) {
          return const LoadingScreen(
            message: 'Memuat aplikasi...',
            showProgress: true,
          );
        }

        if (!authProvider.isAuthenticated) {
          // Redirect to login if not authenticated
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

        // Show loading screen when first entering dashboard
        if (_isDashboardLoading) {
          return const LoadingScreen(
            message: 'Memuat dashboard...',
            showProgress: true,
          );
        }

        final pages = [
          SearchPage(api: _api),
          HistoryPage(api: _api),
          const SettingsPage(),
        ];

        return Scaffold(
          body: SafeArea(
            child: IndexedStack(
              index: _currentIndex,
              children: pages,
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFF1F2C33),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(26),
                child: NavigationBar(
                  backgroundColor: Colors.transparent,
                  indicatorColor: Colors.white.withValues(alpha: 0.22),
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
                      selectedIcon: Icon(Icons.search, color: Colors.white),
                      label: 'Cari',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.history_outlined),
                      selectedIcon: Icon(Icons.history, color: Colors.white),
                      label: 'Riwayat',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.settings_outlined),
                      selectedIcon: Icon(Icons.settings, color: Colors.white),
                      label: 'Pengaturan',
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
