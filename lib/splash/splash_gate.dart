import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../app/home_shell.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';

/// Menampilkan layar splash selama beberapa detik sebelum ke `HomeShell`.
class SplashGate extends StatefulWidget {
  const SplashGate({super.key});

  @override
  State<SplashGate> createState() => _SplashGateState();
}

class _SplashGateState extends State<SplashGate> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Tunggu sebentar untuk splash screen
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      // AuthProvider sudah auto-initialize di constructor
      // Tidak perlu memanggil initialize() manual

      if (mounted) {
        setState(() {
          _ready = true;
        });
      }
    } catch (e) {
      // Jika ada error saat inisialisasi, tetap lanjutkan ke login
      if (mounted) {
        setState(() {
          _ready = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (!_ready) {
          return const _SplashScreen();
        }

        if (!authProvider.isAuthenticated) {
          // Redirect to login if not authenticated
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && context.mounted) {
              Navigator.of(context).pushReplacementNamed('/login');
            }
          });
          return const _SplashScreen();
        }

        // User is authenticated, go to home
        return const HomeShell();
      },
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/logo/FIX_white.svg',
                width: 200,
                height: 200,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
                placeholderBuilder: (context) => const Icon(
                  Icons.verified_user,
                  size: 200,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Klarifikasi.id',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Membantu memfilter fakta dari informasi.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 28),
              const SizedBox(
                width: 42,
                height: 42,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
